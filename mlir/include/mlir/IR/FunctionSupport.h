//===- FunctionSupport.h - Utility types for function-like ops --*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines support types for Operations that represent function-like
// constructs to use.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_IR_FUNCTIONSUPPORT_H
#define MLIR_IR_FUNCTIONSUPPORT_H

#include "mlir/IR/BuiltinTypes.h"
#include "mlir/IR/OpDefinition.h"
#include "llvm/ADT/SmallString.h"

namespace mlir {

namespace impl {

/// Return the name of the attribute used for function types.
inline StringRef getTypeAttrName() { return "type"; }

/// Return the name of the attribute used for function arguments.
inline StringRef getArgAttrName(unsigned arg, SmallVectorImpl<char> &out) {
  out.clear();
  return ("arg" + Twine(arg)).toStringRef(out);
}

/// Returns true if the given name is a valid argument attribute name.
inline bool isArgAttrName(StringRef name) {
  APInt unused;
  return name.startswith("arg") &&
         !name.drop_front(3).getAsInteger(/*Radix=*/10, unused);
}

/// Return the name of the attribute used for function results.
inline StringRef getResultAttrName(unsigned arg, SmallVectorImpl<char> &out) {
  out.clear();
  return ("result" + Twine(arg)).toStringRef(out);
}

/// Returns the dictionary attribute corresponding to the argument at 'index'.
/// If there are no argument attributes at 'index', a null attribute is
/// returned.
inline DictionaryAttr getArgAttrDict(Operation *op, unsigned index) {
  SmallString<8> nameOut;
  return op->getAttrOfType<DictionaryAttr>(getArgAttrName(index, nameOut));
}

/// Returns the dictionary attribute corresponding to the result at 'index'.
/// If there are no result attributes at 'index', a null attribute is
/// returned.
inline DictionaryAttr getResultAttrDict(Operation *op, unsigned index) {
  SmallString<8> nameOut;
  return op->getAttrOfType<DictionaryAttr>(getResultAttrName(index, nameOut));
}

/// Return all of the attributes for the argument at 'index'.
inline ArrayRef<NamedAttribute> getArgAttrs(Operation *op, unsigned index) {
  auto argDict = getArgAttrDict(op, index);
  return argDict ? argDict.getValue() : llvm::None;
}

/// Return all of the attributes for the result at 'index'.
inline ArrayRef<NamedAttribute> getResultAttrs(Operation *op, unsigned index) {
  auto resultDict = getResultAttrDict(op, index);
  return resultDict ? resultDict.getValue() : llvm::None;
}

/// Erase the specified arguments and update the function type attribute.
void eraseFunctionArguments(Operation *op, ArrayRef<unsigned> argIndices,
                            unsigned originalNumArgs, Type newType);

/// Erase the specified results and update the function type attribute.
void eraseFunctionResults(Operation *op, ArrayRef<unsigned> resultIndices,
                          unsigned originalNumResults, Type newType);

} // namespace impl

namespace OpTrait {

/// This trait provides APIs for Ops that behave like functions.  In particular:
/// - Ops must be symbols, i.e. also have the `Symbol` trait;
/// - Ops have a single region with multiple blocks that corresponds to the body
///   of the function;
/// - An op with a single empty region corresponds to an external function;
/// - leading arguments of the first block of the region are treated as function
///   arguments;
/// - they can have argument attributes that are stored in a dictionary
///   attribute on the Op itself.
///
/// This trait provides limited type support for the declared or defined
/// functions. The convenience function `getTypeAttrName()` returns the name of
/// an attribute that can be used to store the function type. In addition, this
/// trait provides `getType` and `setType` helpers to store a `FunctionType` in
/// the attribute named by `getTypeAttrName()`.
///
/// In general, this trait assumes concrete ops use `FunctionType` under the
/// hood. If this is not the case, in order to use the function type support,
/// concrete ops must define the following methods, using the same name, to hide
/// the ones defined for `FunctionType`: `addBodyBlock`, `getType`,
/// `getTypeWithoutArgsAndResults` and `setType`.
///
/// Besides the requirements above, concrete ops must interact with this trait
/// using the following functions:
/// - Concrete ops *must* define a member function `getNumFuncArguments()` that
///   returns the number of function arguments based exclusively on type (so
///   that it can be called on function declarations).
/// - Concrete ops *must* define a member function `getNumFuncResults()` that
///   returns the number of function results based exclusively on type (so that
///   it can be called on function declarations).
/// - To verify that the type respects op-specific invariants, concrete ops may
///   redefine the `verifyType()` hook that will be called after verifying the
///   presence of the `type` attribute and before any call to
///   `getNumFuncArguments`/`getNumFuncResults` from the verifier.
/// - To verify that the body respects op-specific invariants, concrete ops may
///   redefine the `verifyBody()` hook that will be called after verifying the
///   function type and the presence of the (potentially empty) body region.
template <typename ConcreteType>
class FunctionLike : public OpTrait::TraitBase<ConcreteType, FunctionLike> {
public:
  /// Verify that all of the argument attributes are dialect attributes.
  static LogicalResult verifyTrait(Operation *op);

  //===--------------------------------------------------------------------===//
  // Body Handling
  //===--------------------------------------------------------------------===//

  /// Returns true if this function is external, i.e. it has no body.
  bool isExternal() { return empty(); }

  Region &getBody() { return this->getOperation()->getRegion(0); }

  /// Delete all blocks from this function.
  void eraseBody() {
    getBody().dropAllReferences();
    getBody().getBlocks().clear();
  }

  /// This is the list of blocks in the function.
  using BlockListType = Region::BlockListType;
  BlockListType &getBlocks() { return getBody().getBlocks(); }

  // Iteration over the block in the function.
  using iterator = BlockListType::iterator;
  using reverse_iterator = BlockListType::reverse_iterator;

  iterator begin() { return getBody().begin(); }
  iterator end() { return getBody().end(); }
  reverse_iterator rbegin() { return getBody().rbegin(); }
  reverse_iterator rend() { return getBody().rend(); }

  bool empty() { return getBody().empty(); }
  void push_back(Block *block) { getBody().push_back(block); }
  void push_front(Block *block) { getBody().push_front(block); }

  Block &back() { return getBody().back(); }
  Block &front() { return getBody().front(); }

  /// Add an entry block to an empty function, and set up the block arguments
  /// to match the signature of the function. The newly inserted entry block
  /// is returned.
  ///
  /// Note that the concrete class must define a method with the same name to
  /// hide this one if the concrete class does not use FunctionType for the
  /// function type under the hood.
  Block *addEntryBlock();

  /// Add a normal block to the end of the function's block list. The function
  /// should at least already have an entry block.
  Block *addBlock();

  /// Hook for concrete ops to verify the contents of the body. Called as a
  /// part of trait verification, after type verification and ensuring that a
  /// region exists.
  LogicalResult verifyBody();

  //===--------------------------------------------------------------------===//
  // Type Attribute Handling
  //===--------------------------------------------------------------------===//

  /// Return the name of the attribute used for function types.
  static StringRef getTypeAttrName() { return ::mlir::impl::getTypeAttrName(); }

  TypeAttr getTypeAttr() {
    return this->getOperation()->template getAttrOfType<TypeAttr>(
        getTypeAttrName());
  }

  /// Return the type of this function.
  ///
  /// Note that the concrete class must define a method with the same name to
  /// hide this one if the concrete class does not use FunctionType for the
  /// function type under the hood.
  FunctionType getType() {
    return getTypeAttr().getValue().template cast<FunctionType>();
  }

  /// Return the type of this function without the specified arguments and
  /// results. This is used to update the function's signature in the
  /// `eraseArguments` and `eraseResults` methods. The arrays of indices are
  /// allowed to have duplicates and can be in any order.
  ///
  /// Note that the concrete class must define a method with the same name to
  /// hide this one if the concrete class does not use FunctionType for the
  /// function type under the hood.
  FunctionType getTypeWithoutArgsAndResults(ArrayRef<unsigned> argIndices,
                                            ArrayRef<unsigned> resultIndices) {
    return getType().getWithoutArgsAndResults(argIndices, resultIndices);
  }

  bool isTypeAttrValid() {
    auto typeAttr = getTypeAttr();
    if (!typeAttr)
      return false;
    return typeAttr.getValue() != Type{};
  }

  /// Change the type of this function in place. This is an extremely dangerous
  /// operation and it is up to the caller to ensure that this is legal for this
  /// function, and to restore invariants:
  ///  - the entry block args must be updated to match the function params.
  ///  - the argument/result attributes may need an update: if the new type
  ///    has less parameters we drop the extra attributes, if there are more
  ///    parameters they won't have any attributes.
  ///
  /// Note that the concrete class must define a method with the same name to
  /// hide this one if the concrete class does not use FunctionType for the
  /// function type under the hood.
  void setType(FunctionType newType);

  //===--------------------------------------------------------------------===//
  // Argument and Result Handling
  //===--------------------------------------------------------------------===//
  using BlockArgListType = Region::BlockArgListType;

  unsigned getNumArguments() {
    return static_cast<ConcreteType *>(this)->getNumFuncArguments();
  }

  unsigned getNumResults() {
    return static_cast<ConcreteType *>(this)->getNumFuncResults();
  }

  /// Gets argument.
  BlockArgument getArgument(unsigned idx) { return getBody().getArgument(idx); }

  /// Support argument iteration.
  using args_iterator = Region::args_iterator;
  args_iterator args_begin() { return getBody().args_begin(); }
  args_iterator args_end() { return getBody().args_end(); }
  Block::BlockArgListType getArguments() { return getBody().getArguments(); }

  ValueTypeRange<BlockArgListType> getArgumentTypes() {
    return getBody().getArgumentTypes();
  }

  /// Erase a single argument at `argIndex`.
  void eraseArgument(unsigned argIndex) { eraseArguments({argIndex}); }

  /// Erases the arguments listed in `argIndices`.
  /// `argIndices` is allowed to have duplicates and can be in any order.
  void eraseArguments(ArrayRef<unsigned> argIndices) {
    unsigned originalNumArgs = getNumArguments();
    Type newType = getTypeWithoutArgsAndResults(argIndices, {});
    ::mlir::impl::eraseFunctionArguments(this->getOperation(), argIndices,
                                         originalNumArgs, newType);
  }

  /// Erase a single result at `resultIndex`.
  void eraseResult(unsigned resultIndex) { eraseResults({resultIndex}); }

  /// Erases the results listed in `resultIndices`.
  /// `resultIndices` is allowed to have duplicates and can be in any order.
  void eraseResults(ArrayRef<unsigned> resultIndices) {
    unsigned originalNumResults = getNumResults();
    Type newType = getTypeWithoutArgsAndResults({}, resultIndices);
    ::mlir::impl::eraseFunctionResults(this->getOperation(), resultIndices,
                                       originalNumResults, newType);
  }

  //===--------------------------------------------------------------------===//
  // Argument Attributes
  //===--------------------------------------------------------------------===//

  /// FunctionLike operations allow for attaching attributes to each of the
  /// respective function arguments. These argument attributes are stored as
  /// DictionaryAttrs in the main operation attribute dictionary. The name of
  /// these entries is `arg` followed by the index of the argument. These
  /// argument attribute dictionaries are optional, and will generally only
  /// exist if they are non-empty.

  /// Return all of the attributes for the argument at 'index'.
  ArrayRef<NamedAttribute> getArgAttrs(unsigned index) {
    return ::mlir::impl::getArgAttrs(this->getOperation(), index);
  }

  /// Return all argument attributes of this function. If an argument does not
  /// have any attributes, the corresponding entry in `result` is nullptr.
  void getAllArgAttrs(SmallVectorImpl<DictionaryAttr> &result) {
    for (unsigned i = 0, e = getNumArguments(); i != e; ++i)
      result.emplace_back(getArgAttrDict(i));
  }

  /// Return the specified attribute, if present, for the argument at 'index',
  /// null otherwise.
  Attribute getArgAttr(unsigned index, Identifier name) {
    auto argDict = getArgAttrDict(index);
    return argDict ? argDict.get(name) : nullptr;
  }
  Attribute getArgAttr(unsigned index, StringRef name) {
    auto argDict = getArgAttrDict(index);
    return argDict ? argDict.get(name) : nullptr;
  }

  template <typename AttrClass>
  AttrClass getArgAttrOfType(unsigned index, Identifier name) {
    return getArgAttr(index, name).template dyn_cast_or_null<AttrClass>();
  }
  template <typename AttrClass>
  AttrClass getArgAttrOfType(unsigned index, StringRef name) {
    return getArgAttr(index, name).template dyn_cast_or_null<AttrClass>();
  }

  /// Set the attributes held by the argument at 'index'.
  void setArgAttrs(unsigned index, ArrayRef<NamedAttribute> attributes);

  /// Set the attributes held by the argument at 'index'. `attributes` may be
  /// null, in which case any existing argument attributes are removed.
  void setArgAttrs(unsigned index, DictionaryAttr attributes);
  void setAllArgAttrs(ArrayRef<DictionaryAttr> attributes);

  /// If the an attribute exists with the specified name, change it to the new
  /// value. Otherwise, add a new attribute with the specified name/value.
  void setArgAttr(unsigned index, Identifier name, Attribute value);
  void setArgAttr(unsigned index, StringRef name, Attribute value) {
    setArgAttr(index, Identifier::get(name, this->getOperation()->getContext()),
               value);
  }

  /// Remove the attribute 'name' from the argument at 'index'. Return the
  /// attribute that was erased, or nullptr if there was no attribute with such
  /// name.
  Attribute removeArgAttr(unsigned index, Identifier name);

  //===--------------------------------------------------------------------===//
  // Result Attributes
  //===--------------------------------------------------------------------===//

  /// FunctionLike operations allow for attaching attributes to each of the
  /// respective function results. These result attributes are stored as
  /// DictionaryAttrs in the main operation attribute dictionary. The name of
  /// these entries is `result` followed by the index of the result. These
  /// result attribute dictionaries are optional, and will generally only
  /// exist if they are non-empty.

  /// Return all of the attributes for the result at 'index'.
  ArrayRef<NamedAttribute> getResultAttrs(unsigned index) {
    return ::mlir::impl::getResultAttrs(this->getOperation(), index);
  }

  /// Return all result attributes of this function. If a result does not have
  /// any attributes, the corresponding entry in `result` is nullptr.
  void getAllResultAttrs(SmallVectorImpl<DictionaryAttr> &result) {
    for (unsigned i = 0, e = getNumResults(); i != e; ++i)
      result.emplace_back(getResultAttrDict(i));
  }

  /// Return the specified attribute, if present, for the result at 'index',
  /// null otherwise.
  Attribute getResultAttr(unsigned index, Identifier name) {
    auto argDict = getResultAttrDict(index);
    return argDict ? argDict.get(name) : nullptr;
  }
  Attribute getResultAttr(unsigned index, StringRef name) {
    auto argDict = getResultAttrDict(index);
    return argDict ? argDict.get(name) : nullptr;
  }

  template <typename AttrClass>
  AttrClass getResultAttrOfType(unsigned index, Identifier name) {
    return getResultAttr(index, name).template dyn_cast_or_null<AttrClass>();
  }
  template <typename AttrClass>
  AttrClass getResultAttrOfType(unsigned index, StringRef name) {
    return getResultAttr(index, name).template dyn_cast_or_null<AttrClass>();
  }

  /// Set the attributes held by the result at 'index'.
  void setResultAttrs(unsigned index, ArrayRef<NamedAttribute> attributes);
  /// Set the attributes held by the result at 'index'. `attributes` may be
  /// null, in which case any existing argument attributes are removed.
  void setResultAttrs(unsigned index, DictionaryAttr attributes);
  void setAllResultAttrs(ArrayRef<DictionaryAttr> attributes);

  /// If the an attribute exists with the specified name, change it to the new
  /// value. Otherwise, add a new attribute with the specified name/value.
  void setResultAttr(unsigned index, Identifier name, Attribute value);
  void setResultAttr(unsigned index, StringRef name, Attribute value) {
    setResultAttr(index,
                  Identifier::get(name, this->getOperation()->getContext()),
                  value);
  }

  /// Remove the attribute 'name' from the result at 'index'. Return the
  /// attribute that was erased, or nullptr if there was no attribute with such
  /// name.
  Attribute removeResultAttr(unsigned index, Identifier name);

protected:
  /// Returns the attribute entry name for the set of argument attributes at
  /// 'index'.
  static StringRef getArgAttrName(unsigned index, SmallVectorImpl<char> &out) {
    return ::mlir::impl::getArgAttrName(index, out);
  }

  /// Returns the dictionary attribute corresponding to the argument at 'index'.
  /// If there are no argument attributes at 'index', a null attribute is
  /// returned.
  DictionaryAttr getArgAttrDict(unsigned index) {
    assert(index < getNumArguments() && "invalid argument number");
    return ::mlir::impl::getArgAttrDict(this->getOperation(), index);
  }

  /// Returns the attribute entry name for the set of result attributes at
  /// 'index'.
  static StringRef getResultAttrName(unsigned index,
                                     SmallVectorImpl<char> &out) {
    return ::mlir::impl::getResultAttrName(index, out);
  }

  /// Returns the dictionary attribute corresponding to the result at 'index'.
  /// If there are no result attributes at 'index', a null attribute is
  /// returned.
  DictionaryAttr getResultAttrDict(unsigned index) {
    assert(index < getNumResults() && "invalid result number");
    return ::mlir::impl::getResultAttrDict(this->getOperation(), index);
  }

  /// Hook for concrete classes to verify that the type attribute respects
  /// op-specific invariants.  Default implementation always succeeds.
  LogicalResult verifyType() { return success(); }
};

/// Default verifier checks that if the entry block exists, it has the same
/// number of arguments as the function-like operation.
template <typename ConcreteType>
LogicalResult FunctionLike<ConcreteType>::verifyBody() {
  auto funcOp = cast<ConcreteType>(this->getOperation());

  if (funcOp.isExternal())
    return success();

  unsigned numArguments = funcOp.getNumArguments();
  if (funcOp.front().getNumArguments() != numArguments)
    return funcOp.emitOpError("entry block must have ")
           << numArguments << " arguments to match function signature";

  return success();
}

template <typename ConcreteType>
LogicalResult FunctionLike<ConcreteType>::verifyTrait(Operation *op) {
  MLIRContext *ctx = op->getContext();
  auto funcOp = cast<ConcreteType>(op);

  if (!funcOp.isTypeAttrValid())
    return funcOp.emitOpError("requires a type attribute '")
           << getTypeAttrName() << '\'';

  if (failed(funcOp.verifyType()))
    return failure();

  for (unsigned i = 0, e = funcOp.getNumArguments(); i != e; ++i) {
    // Verify that all of the argument attributes are dialect attributes, i.e.
    // that they contain a dialect prefix in their name.  Call the dialect, if
    // registered, to verify the attributes themselves.
    for (auto attr : funcOp.getArgAttrs(i)) {
      if (!attr.first.strref().contains('.'))
        return funcOp.emitOpError("arguments may only have dialect attributes");
      auto dialectNamePair = attr.first.strref().split('.');
      if (auto *dialect = ctx->getLoadedDialect(dialectNamePair.first)) {
        if (failed(dialect->verifyRegionArgAttribute(op, /*regionIndex=*/0,
                                                     /*argIndex=*/i, attr)))
          return failure();
      }
    }
  }

  for (unsigned i = 0, e = funcOp.getNumResults(); i != e; ++i) {
    // Verify that all of the result attributes are dialect attributes, i.e.
    // that they contain a dialect prefix in their name.  Call the dialect, if
    // registered, to verify the attributes themselves.
    for (auto attr : funcOp.getResultAttrs(i)) {
      if (!attr.first.strref().contains('.'))
        return funcOp.emitOpError("results may only have dialect attributes");
      auto dialectNamePair = attr.first.strref().split('.');
      if (auto *dialect = ctx->getLoadedDialect(dialectNamePair.first)) {
        if (failed(dialect->verifyRegionResultAttribute(op, /*regionIndex=*/0,
                                                        /*resultIndex=*/i,
                                                        attr)))
          return failure();
      }
    }
  }

  // Check that the op has exactly one region for the body.
  if (op->getNumRegions() != 1)
    return funcOp.emitOpError("expects one region");

  return funcOp.verifyBody();
}

//===----------------------------------------------------------------------===//
// Function Body.
//===----------------------------------------------------------------------===//

template <typename ConcreteType>
Block *FunctionLike<ConcreteType>::addEntryBlock() {
  assert(empty() && "function already has an entry block");
  auto *entry = new Block();
  push_back(entry);
  entry->addArguments(getType().getInputs());
  return entry;
}

template <typename ConcreteType>
Block *FunctionLike<ConcreteType>::addBlock() {
  assert(!empty() && "function should at least have an entry block");
  push_back(new Block());
  return &back();
}

//===----------------------------------------------------------------------===//
// Function Type Attribute.
//===----------------------------------------------------------------------===//

template <typename ConcreteType>
void FunctionLike<ConcreteType>::setType(FunctionType newType) {
  SmallVector<char, 16> nameBuf;
  auto oldType = getType();
  auto *concreteOp = static_cast<ConcreteType *>(this);

  for (int i = newType.getNumInputs(), e = oldType.getNumInputs(); i < e; i++)
    concreteOp->removeAttr(getArgAttrName(i, nameBuf));
  for (int i = newType.getNumResults(), e = oldType.getNumResults(); i < e; i++)
    concreteOp->removeAttr(getResultAttrName(i, nameBuf));
  (*concreteOp)->setAttr(getTypeAttrName(), TypeAttr::get(newType));
}

//===----------------------------------------------------------------------===//
// Function Argument Attribute.
//===----------------------------------------------------------------------===//

/// Set the attributes held by the argument at 'index'.
template <typename ConcreteType>
void FunctionLike<ConcreteType>::setArgAttrs(
    unsigned index, ArrayRef<NamedAttribute> attributes) {
  assert(index < getNumArguments() && "invalid argument number");
  SmallString<8> nameOut;
  getArgAttrName(index, nameOut);

  if (attributes.empty())
    return (void)static_cast<ConcreteType *>(this)->removeAttr(nameOut);
  Operation *op = this->getOperation();
  op->setAttr(nameOut, DictionaryAttr::get(attributes, op->getContext()));
}

template <typename ConcreteType>
void FunctionLike<ConcreteType>::setArgAttrs(unsigned index,
                                             DictionaryAttr attributes) {
  assert(index < getNumArguments() && "invalid argument number");
  SmallString<8> nameOut;
  if (!attributes || attributes.empty())
    this->getOperation()->removeAttr(getArgAttrName(index, nameOut));
  else
    return this->getOperation()->setAttr(getArgAttrName(index, nameOut),
                                         attributes);
}

template <typename ConcreteType>
void FunctionLike<ConcreteType>::setAllArgAttrs(
    ArrayRef<DictionaryAttr> attributes) {
  assert(attributes.size() == getNumArguments());
  NamedAttrList attrs = this->getOperation()->getAttrs();

  // Instead of calling setArgAttrs() multiple times, which rebuild the
  // attribute dictionary every time, build a new list of attributes for the
  // operation so that we rebuild the attribute dictionary in one shot.
  SmallString<8> argAttrName;
  for (unsigned i = 0, e = attributes.size(); i != e; ++i) {
    StringRef attrName = getArgAttrName(i, argAttrName);
    if (!attributes[i] || attributes[i].empty())
      attrs.erase(attrName);
    else
      attrs.set(attrName, attributes[i]);
  }
  this->getOperation()->setAttrs(attrs);
}

/// If the an attribute exists with the specified name, change it to the new
/// value. Otherwise, add a new attribute with the specified name/value.
template <typename ConcreteType>
void FunctionLike<ConcreteType>::setArgAttr(unsigned index, Identifier name,
                                            Attribute value) {
  NamedAttrList attributes(getArgAttrDict(index));
  Attribute oldValue = attributes.set(name, value);

  // If the attribute changed, then set the new arg attribute list.
  if (value != oldValue)
    setArgAttrs(index, attributes.getDictionary(value.getContext()));
}

/// Remove the attribute 'name' from the argument at 'index'.
template <typename ConcreteType>
Attribute FunctionLike<ConcreteType>::removeArgAttr(unsigned index,
                                                    Identifier name) {
  // Build an attribute list and remove the attribute at 'name'.
  NamedAttrList attributes(getArgAttrDict(index));
  Attribute removedAttr = attributes.erase(name);

  // If the attribute was removed, then update the argument dictionary.
  if (removedAttr)
    setArgAttrs(index, attributes.getDictionary(removedAttr.getContext()));
  return removedAttr;
}

//===----------------------------------------------------------------------===//
// Function Result Attribute.
//===----------------------------------------------------------------------===//

/// Set the attributes held by the result at 'index'.
template <typename ConcreteType>
void FunctionLike<ConcreteType>::setResultAttrs(
    unsigned index, ArrayRef<NamedAttribute> attributes) {
  assert(index < getNumResults() && "invalid result number");
  SmallString<8> nameOut;
  getResultAttrName(index, nameOut);

  if (attributes.empty())
    return (void)this->getOperation()->removeAttr(nameOut);
  Operation *op = this->getOperation();
  op->setAttr(nameOut, DictionaryAttr::get(attributes, op->getContext()));
}

template <typename ConcreteType>
void FunctionLike<ConcreteType>::setResultAttrs(unsigned index,
                                                DictionaryAttr attributes) {
  assert(index < getNumResults() && "invalid result number");
  SmallString<8> nameOut;
  if (!attributes || attributes.empty())
    this->getOperation()->removeAttr(getResultAttrName(index, nameOut));
  else
    this->getOperation()->setAttr(getResultAttrName(index, nameOut),
                                  attributes);
}

template <typename ConcreteType>
void FunctionLike<ConcreteType>::setAllResultAttrs(
    ArrayRef<DictionaryAttr> attributes) {
  assert(attributes.size() == getNumResults());
  NamedAttrList attrs = this->getOperation()->getAttrs();

  // Instead of calling setResultAttrs() multiple times, which rebuild the
  // attribute dictionary every time, build a new list of attributes for the
  // operation so that we rebuild the attribute dictionary in one shot.
  SmallString<8> resultAttrName;
  for (unsigned i = 0, e = attributes.size(); i != e; ++i) {
    StringRef attrName = getResultAttrName(i, resultAttrName);
    if (!attributes[i] || attributes[i].empty())
      attrs.erase(attrName);
    else
      attrs.set(attrName, attributes[i]);
  }
  this->getOperation()->setAttrs(attrs);
}

/// If the an attribute exists with the specified name, change it to the new
/// value. Otherwise, add a new attribute with the specified name/value.
template <typename ConcreteType>
void FunctionLike<ConcreteType>::setResultAttr(unsigned index, Identifier name,
                                               Attribute value) {
  NamedAttrList attributes(getResultAttrDict(index));
  Attribute oldAttr = attributes.set(name, value);

  // If the attribute changed, then set the new arg attribute list.
  if (oldAttr != value)
    setResultAttrs(index, attributes.getDictionary(value.getContext()));
}

/// Remove the attribute 'name' from the result at 'index'.
template <typename ConcreteType>
Attribute FunctionLike<ConcreteType>::removeResultAttr(unsigned index,
                                                       Identifier name) {
  // Build an attribute list and remove the attribute at 'name'.
  NamedAttrList attributes(getResultAttrDict(index));
  Attribute removedAttr = attributes.erase(name);

  // If the attribute was removed, then update the result dictionary.
  if (removedAttr)
    setResultAttrs(index, attributes.getDictionary(removedAttr.getContext()));
  return removedAttr;
}

} // end namespace OpTrait

} // end namespace mlir

#endif // MLIR_IR_FUNCTIONSUPPORT_H
