//===- OpPythonBindingGen.cpp - Generator of Python API for MLIR Ops ------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// OpPythonBindingGen uses ODS specification of MLIR ops to generate Python
// binding classes wrapping a generic operation API.
//
//===----------------------------------------------------------------------===//

#include "mlir/TableGen/GenInfo.h"
#include "mlir/TableGen/Operator.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/FormatVariadic.h"
#include "llvm/TableGen/Error.h"
#include "llvm/TableGen/Record.h"

using namespace mlir;
using namespace mlir::tblgen;

/// File header and includes.
constexpr const char *fileHeader = R"Py(
# Autogenerated by mlir-tblgen; don't manually edit.

import array as _ods_array
from . import _cext as _ods_cext
from . import _segmented_accessor as _ods_segmented_accessor, _equally_sized_accessor as _ods_equally_sized_accessor, _get_default_loc_context as _ods_get_default_loc_context
_ods_ir = _ods_cext.ir
)Py";

/// Template for dialect class:
///   {0} is the dialect namespace.
constexpr const char *dialectClassTemplate = R"Py(
@_ods_cext.register_dialect
class _Dialect(_ods_ir.Dialect):
  DIALECT_NAMESPACE = "{0}"
  pass

)Py";

/// Template for operation class:
///   {0} is the Python class name;
///   {1} is the operation name.
constexpr const char *opClassTemplate = R"Py(
@_ods_cext.register_operation(_Dialect)
class {0}(_ods_ir.OpView):
  OPERATION_NAME = "{1}"
)Py";

/// Template for single-element accessor:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the position in the element list.
constexpr const char *opSingleTemplate = R"Py(
  @property
  def {0}(self):
    return self.operation.{1}s[{2}]
)Py";

/// Template for single-element accessor after a variable-length group:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the total number of element groups;
///   {3} is the position of the current group in the group list.
/// This works for both a single variadic group (non-negative length) and an
/// single optional element (zero length if the element is absent).
constexpr const char *opSingleAfterVariableTemplate = R"Py(
  @property
  def {0}(self):
    _ods_variadic_group_length = len(self.operation.{1}s) - {2} + 1
    return self.operation.{1}s[{3} + _ods_variadic_group_length - 1]
)Py";

/// Template for an optional element accessor:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the total number of element groups;
///   {3} is the position of the current group in the group list.
constexpr const char *opOneOptionalTemplate = R"Py(
  @property
  def {0}(self);
    return self.operation.{1}s[{3}] if len(self.operation.{1}s) > {2}
                                    else None
)Py";

/// Template for the variadic group accessor in the single variadic group case:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the total number of element groups;
///   {3} is the position of the current group in the group list.
constexpr const char *opOneVariadicTemplate = R"Py(
  @property
  def {0}(self):
    _ods_variadic_group_length = len(self.operation.{1}s) - {2} + 1
    return self.operation.{1}s[{3}:{3} + _ods_variadic_group_length]
)Py";

/// First part of the template for equally-sized variadic group accessor:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the total number of variadic groups;
///   {3} is the number of non-variadic groups preceding the current group;
///   {3} is the number of variadic groups preceding the current group.
constexpr const char *opVariadicEqualPrefixTemplate = R"Py(
  @property
  def {0}(self):
    start, pg = _ods_equally_sized_accessor(operation.{1}s, {2}, {3}, {4}))Py";

/// Second part of the template for equally-sized case, accessing a single
/// element:
///   {0} is either 'operand' or 'result'.
constexpr const char *opVariadicEqualSimpleTemplate = R"Py(
    return self.operation.{0}s[start]
)Py";

/// Second part of the template for equally-sized case, accessing a variadic
/// group:
///   {0} is either 'operand' or 'result'.
constexpr const char *opVariadicEqualVariadicTemplate = R"Py(
    return self.operation.{0}s[start:start + pg]
)Py";

/// Template for an attribute-sized group accessor:
///   {0} is the name of the accessor;
///   {1} is either 'operand' or 'result';
///   {2} is the position of the group in the group list;
///   {3} is a return suffix (expected [0] for single-element, empty for
///       variadic, and opVariadicSegmentOptionalTrailingTemplate for optional).
constexpr const char *opVariadicSegmentTemplate = R"Py(
  @property
  def {0}(self):
    {1}_range = _ods_segmented_accessor(
         self.operation.{1}s,
         self.operation.attributes["{1}_segment_sizes"], {2})
    return {1}_range{3}
)Py";

/// Template for a suffix when accessing an optional element in the
/// attribute-sized case:
///   {0} is either 'operand' or 'result';
constexpr const char *opVariadicSegmentOptionalTrailingTemplate =
    R"Py([0] if len({0}_range) > 0 else None)Py";

/// Template for an operation attribute getter:
///   {0} is the name of the attribute sanitized for Python;
///   {1} is the Python type of the attribute;
///   {2} os the original name of the attribute.
constexpr const char *attributeGetterTemplate = R"Py(
  @property
  def {0}(self):
    return {1}(self.operation.attributes["{2}"])
)Py";

/// Template for an optional operation attribute getter:
///   {0} is the name of the attribute sanitized for Python;
///   {1} is the Python type of the attribute;
///   {2} is the original name of the attribute.
constexpr const char *optionalAttributeGetterTemplate = R"Py(
  @property
  def {0}(self):
    if "{2}" not in self.operation.attributes:
      return None
    return {1}(self.operation.attributes["{2}"])
)Py";

/// Template for a getter of a unit operation attribute, returns True of the
/// unit attribute is present, False otherwise (unit attributes have meaning
/// by mere presence):
///    {0} is the name of the attribute sanitized for Python,
///    {1} is the original name of the attribute.
constexpr const char *unitAttributeGetterTemplate = R"Py(
  @property
  def {0}(self):
    return "{1}" in self.operation.attributes
)Py";

/// Template for an operation attribute setter:
///    {0} is the name of the attribute sanitized for Python;
///    {1} is the original name of the attribute.
constexpr const char *attributeSetterTemplate = R"Py(
  @{0}.setter
  def {0}(self, value):
    if value is None:
      raise ValueError("'None' not allowed as value for mandatory attributes")
    self.operation.attributes["{1}"] = value
)Py";

/// Template for a setter of an optional operation attribute, setting to None
/// removes the attribute:
///    {0} is the name of the attribute sanitized for Python;
///    {1} is the original name of the attribute.
constexpr const char *optionalAttributeSetterTemplate = R"Py(
  @{0}.setter
  def {0}(self, value):
    if value is not None:
      self.operation.attributes["{1}"] = value
    elif "{1}" in self.operation.attributes:
      del self.operation.attributes["{1}"]
)Py";

/// Template for a setter of a unit operation attribute, setting to None or
/// False removes the attribute:
///    {0} is the name of the attribute sanitized for Python;
///    {1} is the original name of the attribute.
constexpr const char *unitAttributeSetterTemplate = R"Py(
  @{0}.setter
  def {0}(self, value):
    if bool(value):
      self.operation.attributes["{1}"] = _ods_ir.UnitAttr.get()
    elif "{1}" in self.operation.attributes:
      del self.operation.attributes["{1}"]
)Py";

/// Template for a deleter of an optional or a unit operation attribute, removes
/// the attribute from the operation:
///    {0} is the name of the attribute sanitized for Python;
///    {1} is the original name of the attribute.
constexpr const char *attributeDeleterTemplate = R"Py(
  @{0}.deleter
  def {0}(self):
    del self.operation.attributes["{1}"]
)Py";

static llvm::cl::OptionCategory
    clOpPythonBindingCat("Options for -gen-python-op-bindings");

static llvm::cl::opt<std::string>
    clDialectName("bind-dialect",
                  llvm::cl::desc("The dialect to run the generator for"),
                  llvm::cl::init(""), llvm::cl::cat(clOpPythonBindingCat));

using AttributeClasses = DenseMap<StringRef, StringRef>;

/// Checks whether `str` is a Python keyword.
static bool isPythonKeyword(StringRef str) {
  static llvm::StringSet<> keywords(
      {"and",   "as",     "assert",   "break", "class",  "continue",
       "def",   "del",    "elif",     "else",  "except", "finally",
       "for",   "from",   "global",   "if",    "import", "in",
       "is",    "lambda", "nonlocal", "not",   "or",     "pass",
       "raise", "return", "try",      "while", "with",   "yield"});
  return keywords.contains(str);
};

/// Checks whether `str` would shadow a generated variable or attribute
/// part of the OpView API.
static bool isODSReserved(StringRef str) {
  static llvm::StringSet<> reserved(
      {"attributes", "create", "context", "ip", "operands", "print", "get_asm",
       "loc", "verify", "regions", "result", "results", "self", "operation",
       "DIALECT_NAMESPACE", "OPERATION_NAME"});
  return str.startswith("_ods_") || str.endswith("_ods") ||
         reserved.contains(str);
}

/// Modifies the `name` in a way that it becomes suitable for Python bindings
/// (does not change the `name` if it already is suitable) and returns the
/// modified version.
static std::string sanitizeName(StringRef name) {
  if (isPythonKeyword(name) || isODSReserved(name))
    return (name + "_").str();
  return name.str();
}

static std::string attrSizedTraitForKind(const char *kind) {
  return llvm::formatv("::mlir::OpTrait::AttrSized{0}{1}Segments",
                       llvm::StringRef(kind).take_front().upper(),
                       llvm::StringRef(kind).drop_front());
}

/// Emits accessors to "elements" of an Op definition. Currently, the supported
/// elements are operands and results, indicated by `kind`, which must be either
/// `operand` or `result` and is used verbatim in the emitted code.
static void emitElementAccessors(
    const Operator &op, raw_ostream &os, const char *kind,
    llvm::function_ref<unsigned(const Operator &)> getNumVariadic,
    llvm::function_ref<int(const Operator &)> getNumElements,
    llvm::function_ref<const NamedTypeConstraint &(const Operator &, int)>
        getElement) {
  assert(llvm::is_contained(
             llvm::SmallVector<StringRef, 2>{"operand", "result"}, kind) &&
         "unsupported kind");

  // Traits indicating how to process variadic elements.
  std::string sameSizeTrait =
      llvm::formatv("::mlir::OpTrait::SameVariadic{0}{1}Size",
                    llvm::StringRef(kind).take_front().upper(),
                    llvm::StringRef(kind).drop_front());
  std::string attrSizedTrait = attrSizedTraitForKind(kind);

  unsigned numVariadic = getNumVariadic(op);

  // If there is only one variadic element group, its size can be inferred from
  // the total number of elements. If there are none, the generation is
  // straightforward.
  if (numVariadic <= 1) {
    bool seenVariableLength = false;
    for (int i = 0, e = getNumElements(op); i < e; ++i) {
      const NamedTypeConstraint &element = getElement(op, i);
      if (element.isVariableLength())
        seenVariableLength = true;
      if (element.name.empty())
        continue;
      if (element.isVariableLength()) {
        os << llvm::formatv(element.isOptional() ? opOneOptionalTemplate
                                                 : opOneVariadicTemplate,
                            sanitizeName(element.name), kind,
                            getNumElements(op), i);
      } else if (seenVariableLength) {
        os << llvm::formatv(opSingleAfterVariableTemplate,
                            sanitizeName(element.name), kind,
                            getNumElements(op), i);
      } else {
        os << llvm::formatv(opSingleTemplate, sanitizeName(element.name), kind,
                            i);
      }
    }
    return;
  }

  // Handle the operations where variadic groups have the same size.
  if (op.getTrait(sameSizeTrait)) {
    int numPrecedingSimple = 0;
    int numPrecedingVariadic = 0;
    for (int i = 0, e = getNumElements(op); i < e; ++i) {
      const NamedTypeConstraint &element = getElement(op, i);
      if (!element.name.empty()) {
        os << llvm::formatv(opVariadicEqualPrefixTemplate,
                            sanitizeName(element.name), kind, numVariadic,
                            numPrecedingSimple, numPrecedingVariadic);
        os << llvm::formatv(element.isVariableLength()
                                ? opVariadicEqualVariadicTemplate
                                : opVariadicEqualSimpleTemplate,
                            kind);
      }
      if (element.isVariableLength())
        ++numPrecedingVariadic;
      else
        ++numPrecedingSimple;
    }
    return;
  }

  // Handle the operations where the size of groups (variadic or not) is
  // provided as an attribute. For non-variadic elements, make sure to return
  // an element rather than a singleton container.
  if (op.getTrait(attrSizedTrait)) {
    for (int i = 0, e = getNumElements(op); i < e; ++i) {
      const NamedTypeConstraint &element = getElement(op, i);
      if (element.name.empty())
        continue;
      std::string trailing;
      if (!element.isVariableLength())
        trailing = "[0]";
      else if (element.isOptional())
        trailing = std::string(
            llvm::formatv(opVariadicSegmentOptionalTrailingTemplate, kind));
      os << llvm::formatv(opVariadicSegmentTemplate, sanitizeName(element.name),
                          kind, i, trailing);
    }
    return;
  }

  llvm::PrintFatalError("unsupported " + llvm::Twine(kind) + " structure");
}

/// Free function helpers accessing Operator components.
static int getNumOperands(const Operator &op) { return op.getNumOperands(); }
static const NamedTypeConstraint &getOperand(const Operator &op, int i) {
  return op.getOperand(i);
}
static int getNumResults(const Operator &op) { return op.getNumResults(); }
static const NamedTypeConstraint &getResult(const Operator &op, int i) {
  return op.getResult(i);
}

/// Emits accessors to Op operands.
static void emitOperandAccessors(const Operator &op, raw_ostream &os) {
  auto getNumVariadic = [](const Operator &oper) {
    return oper.getNumVariableLengthOperands();
  };
  emitElementAccessors(op, os, "operand", getNumVariadic, getNumOperands,
                       getOperand);
}

/// Emits accessors Op results.
static void emitResultAccessors(const Operator &op, raw_ostream &os) {
  auto getNumVariadic = [](const Operator &oper) {
    return oper.getNumVariableLengthResults();
  };
  emitElementAccessors(op, os, "result", getNumVariadic, getNumResults,
                       getResult);
}

/// Emits accessors to Op attributes.
static void emitAttributeAccessors(const Operator &op,
                                   const AttributeClasses &attributeClasses,
                                   raw_ostream &os) {
  for (const auto &namedAttr : op.getAttributes()) {
    // Skip "derived" attributes because they are just C++ functions that we
    // don't currently expose.
    if (namedAttr.attr.isDerivedAttr())
      continue;

    if (namedAttr.name.empty())
      continue;

    std::string sanitizedName = sanitizeName(namedAttr.name);

    // Unit attributes are handled specially.
    if (namedAttr.attr.getStorageType().trim().equals("::mlir::UnitAttr")) {
      os << llvm::formatv(unitAttributeGetterTemplate, sanitizedName,
                          namedAttr.name);
      os << llvm::formatv(unitAttributeSetterTemplate, sanitizedName,
                          namedAttr.name);
      os << llvm::formatv(attributeDeleterTemplate, sanitizedName,
                          namedAttr.name);
      continue;
    }

    // Other kinds of attributes need a mapping to a Python type.
    if (!attributeClasses.count(namedAttr.attr.getStorageType().trim()))
      continue;

    StringRef pythonType =
        attributeClasses.lookup(namedAttr.attr.getStorageType());
    if (namedAttr.attr.isOptional()) {
      os << llvm::formatv(optionalAttributeGetterTemplate, sanitizedName,
                          pythonType, namedAttr.name);
      os << llvm::formatv(optionalAttributeSetterTemplate, sanitizedName,
                          namedAttr.name);
      os << llvm::formatv(attributeDeleterTemplate, sanitizedName,
                          namedAttr.name);
    } else {
      os << llvm::formatv(attributeGetterTemplate, sanitizedName, pythonType,
                          namedAttr.name);
      os << llvm::formatv(attributeSetterTemplate, sanitizedName,
                          namedAttr.name);
      // Non-optional attributes cannot be deleted.
    }
  }
}

/// Template for the default auto-generated builder.
///   {0} is the operation name;
///   {1} is a comma-separated list of builder arguments, including the trailing
///       `loc` and `ip`;
///   {2} is the code populating `operands`, `results` and `attributes` fields.
constexpr const char *initTemplate = R"Py(
  def __init__(self, {1}):
    operands = []
    results = []
    attributes = {{}
    {2}
    super().__init__(_ods_ir.Operation.create(
      "{0}", attributes=attributes, operands=operands, results=results,
      loc=loc, ip=ip))
)Py";

/// Template for appending a single element to the operand/result list.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *singleElementAppendTemplate = "{0}s.append({1})";

/// Template for appending an optional element to the operand/result list.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *optionalAppendTemplate =
    "if {1} is not None: {0}s.append({1})";

/// Template for appending a variadic element to the operand/result list.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *variadicAppendTemplate = "{0}s += [*{1}]";

/// Template for setting up the segment sizes buffer.
constexpr const char *segmentDeclarationTemplate =
    "{0}_segment_sizes_ods = _ods_array.array('L')";

/// Template for attaching segment sizes to the attribute list.
constexpr const char *segmentAttributeTemplate =
    R"Py(attributes["{0}_segment_sizes"] = _ods_ir.DenseElementsAttr.get({0}_segment_sizes_ods,
      context=_ods_get_default_loc_context(loc)))Py";

/// Template for appending the unit size to the segment sizes.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *singleElementSegmentTemplate =
    "{0}_segment_sizes_ods.append(1) # {1}";

/// Template for appending 0/1 for an optional element to the segment sizes.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *optionalSegmentTemplate =
    "{0}_segment_sizes_ods.append(0 if {1} is None else 1)";

/// Template for appending the length of a variadic group to the segment sizes.
///   {0} is either 'operand' or 'result';
///   {1} is the field name.
constexpr const char *variadicSegmentTemplate =
    "{0}_segment_sizes_ods.append(len({1}))";

/// Template for setting an attribute in the operation builder.
///   {0} is the attribute name;
///   {1} is the builder argument name.
constexpr const char *initAttributeTemplate = R"Py(attributes["{0}"] = {1})Py";

/// Template for setting an optional attribute in the operation builder.
///   {0} is the attribute name;
///   {1} is the builder argument name.
constexpr const char *initOptionalAttributeTemplate =
    R"Py(if {1} is not None: attributes["{0}"] = {1})Py";

constexpr const char *initUnitAttributeTemplate =
    R"Py(if bool({1}): attributes["{0}"] = _ods_ir.UnitAttr.get(
      _ods_get_default_loc_context(loc)))Py";

/// Populates `builderArgs` with the Python-compatible names of builder function
/// arguments, first the results, then the intermixed attributes and operands in
/// the same order as they appear in the `arguments` field of the op definition.
/// Additionally, `operandNames` is populated with names of operands in their
/// order of appearance.
static void
populateBuilderArgs(const Operator &op,
                    llvm::SmallVectorImpl<std::string> &builderArgs,
                    llvm::SmallVectorImpl<std::string> &operandNames) {
  for (int i = 0, e = op.getNumResults(); i < e; ++i) {
    std::string name = op.getResultName(i).str();
    if (name.empty())
      name = llvm::formatv("_gen_res_{0}", i);
    name = sanitizeName(name);
    builderArgs.push_back(name);
  }
  for (int i = 0, e = op.getNumArgs(); i < e; ++i) {
    std::string name = op.getArgName(i).str();
    if (name.empty())
      name = llvm::formatv("_gen_arg_{0}", i);
    name = sanitizeName(name);
    builderArgs.push_back(name);
    if (!op.getArg(i).is<NamedAttribute *>())
      operandNames.push_back(name);
  }
}

/// Populates `builderLines` with additional lines that are required in the
/// builder to set up operation attributes. `argNames` is expected to contain
/// the names of builder arguments that correspond to op arguments, i.e. to the
/// operands and attributes in the same order as they appear in the `arguments`
/// field.
static void
populateBuilderLinesAttr(const Operator &op,
                         llvm::ArrayRef<std::string> argNames,
                         llvm::SmallVectorImpl<std::string> &builderLines) {
  for (int i = 0, e = op.getNumArgs(); i < e; ++i) {
    Argument arg = op.getArg(i);
    auto *attribute = arg.dyn_cast<NamedAttribute *>();
    if (!attribute)
      continue;

    // Unit attributes are handled specially.
    if (attribute->attr.getStorageType().trim().equals("::mlir::UnitAttr")) {
      builderLines.push_back(llvm::formatv(initUnitAttributeTemplate,
                                           attribute->name, argNames[i]));
      continue;
    }

    builderLines.push_back(llvm::formatv(attribute->attr.isOptional()
                                             ? initOptionalAttributeTemplate
                                             : initAttributeTemplate,
                                         attribute->name, argNames[i]));
  }
}

/// Populates `builderLines` with additional lines that are required in the
/// builder. `kind` must be either "operand" or "result". `names` contains the
/// names of init arguments that correspond to the elements.
static void populateBuilderLines(
    const Operator &op, const char *kind, llvm::ArrayRef<std::string> names,
    llvm::SmallVectorImpl<std::string> &builderLines,
    llvm::function_ref<int(const Operator &)> getNumElements,
    llvm::function_ref<const NamedTypeConstraint &(const Operator &, int)>
        getElement) {
  // The segment sizes buffer only has to be populated if there attr-sized
  // segments trait is present.
  bool includeSegments = op.getTrait(attrSizedTraitForKind(kind)) != nullptr;
  if (includeSegments)
    builderLines.push_back(llvm::formatv(segmentDeclarationTemplate, kind));

  // For each element, find or generate a name.
  for (int i = 0, e = getNumElements(op); i < e; ++i) {
    const NamedTypeConstraint &element = getElement(op, i);
    std::string name = names[i];

    // Choose the formatting string based on the element kind.
    llvm::StringRef formatString, segmentFormatString;
    if (!element.isVariableLength()) {
      formatString = singleElementAppendTemplate;
      segmentFormatString = singleElementSegmentTemplate;
    } else if (element.isOptional()) {
      formatString = optionalAppendTemplate;
      segmentFormatString = optionalSegmentTemplate;
    } else {
      assert(element.isVariadic() && "unhandled element group type");
      formatString = variadicAppendTemplate;
      segmentFormatString = variadicSegmentTemplate;
    }

    // Add the lines.
    builderLines.push_back(llvm::formatv(formatString.data(), kind, name));
    if (includeSegments)
      builderLines.push_back(
          llvm::formatv(segmentFormatString.data(), kind, name));
  }

  if (includeSegments)
    builderLines.push_back(llvm::formatv(segmentAttributeTemplate, kind));
}

/// Emits a default builder constructing an operation from the list of its
/// result types, followed by a list of its operands.
static void emitDefaultOpBuilder(const Operator &op, raw_ostream &os) {
  // If we are asked to skip default builders, comply.
  if (op.skipDefaultBuilders())
    return;

  llvm::SmallVector<std::string, 8> builderArgs;
  llvm::SmallVector<std::string, 8> builderLines;
  llvm::SmallVector<std::string, 4> operandArgNames;
  builderArgs.reserve(op.getNumOperands() + op.getNumResults() +
                      op.getNumNativeAttributes());
  populateBuilderArgs(op, builderArgs, operandArgNames);
  populateBuilderLines(
      op, "result",
      llvm::makeArrayRef(builderArgs).take_front(op.getNumResults()),
      builderLines, getNumResults, getResult);
  populateBuilderLines(op, "operand", operandArgNames, builderLines,
                       getNumOperands, getOperand);
  populateBuilderLinesAttr(
      op, llvm::makeArrayRef(builderArgs).drop_front(op.getNumResults()),
      builderLines);

  builderArgs.push_back("loc=None");
  builderArgs.push_back("ip=None");
  os << llvm::formatv(initTemplate, op.getOperationName(),
                      llvm::join(builderArgs, ", "),
                      llvm::join(builderLines, "\n    "));
}

static void constructAttributeMapping(const llvm::RecordKeeper &records,
                                      AttributeClasses &attributeClasses) {
  for (const llvm::Record *rec :
       records.getAllDerivedDefinitions("PythonAttr")) {
    attributeClasses.try_emplace(rec->getValueAsString("cppStorageType").trim(),
                                 rec->getValueAsString("pythonType").trim());
  }
}

/// Emits bindings for a specific Op to the given output stream.
static void emitOpBindings(const Operator &op,
                           const AttributeClasses &attributeClasses,
                           raw_ostream &os) {
  os << llvm::formatv(opClassTemplate, op.getCppClassName(),
                      op.getOperationName());
  emitDefaultOpBuilder(op, os);
  emitOperandAccessors(op, os);
  emitAttributeAccessors(op, attributeClasses, os);
  emitResultAccessors(op, os);
}

/// Emits bindings for the dialect specified in the command line, including file
/// headers and utilities. Returns `false` on success to comply with Tablegen
/// registration requirements.
static bool emitAllOps(const llvm::RecordKeeper &records, raw_ostream &os) {
  if (clDialectName.empty())
    llvm::PrintFatalError("dialect name not provided");

  AttributeClasses attributeClasses;
  constructAttributeMapping(records, attributeClasses);

  os << fileHeader;
  os << llvm::formatv(dialectClassTemplate, clDialectName.getValue());
  for (const llvm::Record *rec : records.getAllDerivedDefinitions("Op")) {
    Operator op(rec);
    if (op.getDialectName() == clDialectName.getValue())
      emitOpBindings(op, attributeClasses, os);
  }
  return false;
}

static GenRegistration
    genPythonBindings("gen-python-op-bindings",
                      "Generate Python bindings for MLIR Ops", &emitAllOps);
