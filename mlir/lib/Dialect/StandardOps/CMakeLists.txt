add_mlir_dialect_library(MLIRStandard
  IR/Ops.cpp
  EDSC/Builders.cpp
  EDSC/Intrinsics.cpp
  Utils/Utils.cpp

  ADDITIONAL_HEADER_DIRS
  ${MLIR_MAIN_INCLUDE_DIR}/mlir/Dialect/StandardOps

  DEPENDS
  MLIRStandardOpsIncGen

  LINK_LIBS PUBLIC
  MLIRCallInterfaces
  MLIRControlFlowInterfaces
  MLIREDSC
  MLIRIR
  MLIRSideEffectInterfaces
  MLIRTensor
  MLIRVectorInterfaces
  MLIRViewLikeInterface
  )

add_subdirectory(Transforms)
