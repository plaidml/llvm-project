// RUN: mlir-translate  --mlir-to-llvmir %s | FileCheck %s

module {
  llvm.func @malloc(!llvm.i64) -> !llvm.ptr<i8>
  llvm.func @print_memref_f32(%arg0: !llvm.i64, %arg1: !llvm.ptr<i8>) {
    %0 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(i64, ptr<i8>)>
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(i64, ptr<i8>)>
    %3 = llvm.mlir.constant(1 : index) : !llvm.i64
    %4 = llvm.alloca %3 x !llvm.struct<(i64, ptr<i8>)> : (!llvm.i64) -> !llvm.ptr<struct<(i64, ptr<i8>)>>
    llvm.store %2, %4 : !llvm.ptr<struct<(i64, ptr<i8>)>>
    llvm.call @_mlir_ciface_print_memref_f32(%4) : (!llvm.ptr<struct<(i64, ptr<i8>)>>) -> ()
    llvm.return
  }
  llvm.func @_mlir_ciface_print_memref_f32(!llvm.ptr<struct<(i64, ptr<i8>)>>)
  llvm.func @plaidml_rt_thread_num() -> !llvm.i64 {
    %0 = llvm.call @_mlir_ciface_plaidml_rt_thread_num() : () -> !llvm.i64
    llvm.return %0 : !llvm.i64
  }
  llvm.func @_mlir_ciface_plaidml_rt_thread_num() -> !llvm.i64
  llvm.func @main() {
    %0 = llvm.mlir.constant(4 : index) : !llvm.i64
    %1 = llvm.mlir.constant(4 : index) : !llvm.i64
    %2 = llvm.mlir.null : !llvm.ptr<float>
    %3 = llvm.mlir.constant(1 : index) : !llvm.i64
    %4 = llvm.getelementptr %2[%3] : (!llvm.ptr<float>, !llvm.i64) -> !llvm.ptr<float>
    %5 = llvm.ptrtoint %4 : !llvm.ptr<float> to !llvm.i64
    %6 = llvm.mul %1, %5 : !llvm.i64
    %7 = llvm.call @malloc(%6) : (!llvm.i64) -> !llvm.ptr<i8>
    %8 = llvm.bitcast %7 : !llvm.ptr<i8> to !llvm.ptr<float>
    %9 = llvm.mlir.undef : !llvm.struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)>
    %10 = llvm.insertvalue %8, %9[0] : !llvm.struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)>
    %11 = llvm.insertvalue %8, %10[1] : !llvm.struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)>
    %12 = llvm.mlir.constant(0 : index) : !llvm.i64
    %13 = llvm.insertvalue %12, %11[2] : !llvm.struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)>
    %14 = llvm.mlir.constant(1 : index) : !llvm.i64
    %15 = llvm.insertvalue %1, %13[3, 0] : !llvm.struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)>
    %16 = llvm.insertvalue %14, %15[4, 0] : !llvm.struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)>
    %17 = llvm.mlir.constant(4.200000e+01 : f32) : !llvm.float
    // CHECK: %{{.*}} = alloca { {{.*}}, float }, i64 1
    // CHECK-NEXT %{{.*}} = insertvalue { {{.*}}, float } undef, {{.*}}, 0
    // CHECK-NEXT %{{.*}} = insertvalue { {{.*}}, float } %{{.*}}, float 4.200000e+01, 1
    // CHECK-NEXT store { {{.*}}, float } %{{.*}}, { {{.*}}, float }* %{{.*}}
    omp.parallel num_threads(%0 : !llvm.i64) {
      // CHECK: omp.par.region:
      // CHECK-NEXT br label %omp.par.region1
      // CHECK-NEXT omp.par.region1:
      // CHECK-NEXT %{{.*}} = load { {{.*}}, float }, { {{.*}}, float }* %{{.*}}
      // CHECK-NEXT %{{.*}} = extractvalue { {{.*}}, float } %{{.*}}, 0
      // CHECK-NEXT %{{.*}} = extractvalue { {{.*}}, float } %{{.*}}, 1
      %27 = llvm.call @plaidml_rt_thread_num() : () -> !llvm.i64
      %28 = llvm.extractvalue %16[1] : !llvm.struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)>
      %29 = llvm.mlir.constant(0 : index) : !llvm.i64
      %30 = llvm.mlir.constant(1 : index) : !llvm.i64
      %31 = llvm.mul %27, %30 : !llvm.i64
      %32 = llvm.add %29, %31 : !llvm.i64
      %33 = llvm.getelementptr %28[%32] : (!llvm.ptr<float>, !llvm.i64) -> !llvm.ptr<float>
      llvm.store %17, %33 : !llvm.ptr<float>
      omp.terminator
    }
    %18 = llvm.mlir.constant(1 : index) : !llvm.i64
    %19 = llvm.alloca %18 x !llvm.struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)> : (!llvm.i64) -> !llvm.ptr<struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)>>
    llvm.store %16, %19 : !llvm.ptr<struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)>>
    %20 = llvm.bitcast %19 : !llvm.ptr<struct<(ptr<float>, ptr<float>, i64, array<1 x i64>, array<1 x i64>)>> to !llvm.ptr<i8>
    %21 = llvm.mlir.constant(1 : i64) : !llvm.i64
    %22 = llvm.mlir.undef : !llvm.struct<(i64, ptr<i8>)>
    %23 = llvm.insertvalue %21, %22[0] : !llvm.struct<(i64, ptr<i8>)>
    %24 = llvm.insertvalue %20, %23[1] : !llvm.struct<(i64, ptr<i8>)>
    %25 = llvm.extractvalue %24[0] : !llvm.struct<(i64, ptr<i8>)>
    %26 = llvm.extractvalue %24[1] : !llvm.struct<(i64, ptr<i8>)>
    llvm.call @print_memref_f32(%25, %26) : (!llvm.i64, !llvm.ptr<i8>) -> ()
    llvm.return
  }
  llvm.func @_mlir_ciface_main() {
    llvm.call @main() : () -> ()
    llvm.return
  }
}

