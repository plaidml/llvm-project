; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -vector-combine -S -mtriple=amdgcn-amd-amdhsa | FileCheck %s --check-prefixes=CHECK

; ModuleID = 'load-as-transition.ll'
target datalayout = "e-p:64:64-p1:64:64-p2:32:32-p3:32:32-p4:64:64-p5:32:32-p6:32:32-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-v2048:2048-n32:64-S32-A5-ni:7"
target triple = "amdgcn-amd-amdhsa"

%struct.hoge = type { float }

define protected amdgpu_kernel void @load_from_other_as(<4 x float>* nocapture nonnull %resultptr) local_unnamed_addr #0 {
; CHECK-LABEL: @load_from_other_as(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    [[A:%.*]] = alloca [[STRUCT_HOGE:%.*]], align 4, addrspace(5)
; CHECK-NEXT:    [[B:%.*]] = addrspacecast [[STRUCT_HOGE]] addrspace(5)* [[A]] to %struct.hoge*
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[STRUCT_HOGE]], %struct.hoge* [[B]], i64 0, i32 0
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast float* [[C]] to <1 x float>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <1 x float>, <1 x float>* [[TMP0]], align 4
; CHECK-NEXT:    [[E:%.*]] = shufflevector <1 x float> [[TMP1]], <1 x float> poison, <4 x i32> <i32 0, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    store <4 x float> [[E]], <4 x float>* [[RESULTPTR:%.*]], align 16
; CHECK-NEXT:    ret void
;
bb:
  %a = alloca %struct.hoge, align 4, addrspace(5)
  %b = addrspacecast %struct.hoge addrspace(5)* %a to %struct.hoge*
  %c = getelementptr inbounds %struct.hoge, %struct.hoge* %b, i64 0, i32 0
  %d = load float, float* %c, align 4
  %e = insertelement <4 x float> undef, float %d, i32 0
  store <4 x float> %e, <4 x float>* %resultptr, align 16
  ret void
}

attributes #0 = { "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 12.0.0"}
