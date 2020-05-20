; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s -mtriple=powerpc64le-unknown-linux -mcpu=pwr9 -enable-ppc-quad-precision=true | FileCheck %s

declare fp128 @llvm.experimental.constrained.fadd.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fsub.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fmul.f128(fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.fdiv.f128(fp128, fp128, metadata, metadata)

declare fp128 @llvm.experimental.constrained.fma.f128(fp128, fp128, fp128, metadata, metadata)
declare fp128 @llvm.experimental.constrained.sqrt.f128(fp128, metadata, metadata)

define fp128 @fadd_f128(fp128 %f1, fp128 %f2) {
; CHECK-LABEL: fadd_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsaddqp v2, v2, v3
; CHECK-NEXT:    blr
  %res = call fp128 @llvm.experimental.constrained.fadd.f128(
                        fp128 %f1, fp128 %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret fp128 %res
}

define fp128 @fsub_f128(fp128 %f1, fp128 %f2) {
; CHECK-LABEL: fsub_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xssubqp v2, v2, v3
; CHECK-NEXT:    blr
  %res = call fp128 @llvm.experimental.constrained.fsub.f128(
                        fp128 %f1, fp128 %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret fp128 %res
}

define fp128 @fmul_f128(fp128 %f1, fp128 %f2) {
; CHECK-LABEL: fmul_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsmulqp v2, v2, v3
; CHECK-NEXT:    blr
  %res = call fp128 @llvm.experimental.constrained.fmul.f128(
                        fp128 %f1, fp128 %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret fp128 %res
}

define fp128 @fdiv_f128(fp128 %f1, fp128 %f2) {
; CHECK-LABEL: fdiv_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsdivqp v2, v2, v3
; CHECK-NEXT:    blr
  %res = call fp128 @llvm.experimental.constrained.fdiv.f128(
                        fp128 %f1, fp128 %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret fp128 %res
}

define fp128 @fmadd_f128(fp128 %f0, fp128 %f1, fp128 %f2) {
; CHECK-LABEL: fmadd_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsmaddqp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
  %res = call fp128 @llvm.experimental.constrained.fma.f128(
                        fp128 %f0, fp128 %f1, fp128 %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret fp128 %res
}

define fp128 @fmsub_f128(fp128 %f0, fp128 %f1, fp128 %f2) {
; CHECK-LABEL: fmsub_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsmsubqp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
  %neg = fneg fp128 %f2
  %res = call fp128 @llvm.experimental.constrained.fma.f128(
                        fp128 %f0, fp128 %f1, fp128 %neg,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret fp128 %res
}

define fp128 @fnmadd_f128(fp128 %f0, fp128 %f1, fp128 %f2) {
; CHECK-LABEL: fnmadd_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsnmaddqp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
  %fma = call fp128 @llvm.experimental.constrained.fma.f128(
                        fp128 %f0, fp128 %f1, fp128 %f2,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %res = fneg fp128 %fma
  ret fp128 %res
}

define fp128 @fnmsub_f128(fp128 %f0, fp128 %f1, fp128 %f2) {
; CHECK-LABEL: fnmsub_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xsnmsubqp v4, v2, v3
; CHECK-NEXT:    vmr v2, v4
; CHECK-NEXT:    blr
  %neg = fneg fp128 %f2
  %fma = call fp128 @llvm.experimental.constrained.fma.f128(
                        fp128 %f0, fp128 %f1, fp128 %neg,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  %res = fneg fp128 %fma
  ret fp128 %res
}


define fp128 @fsqrt_f128(fp128 %f1) {
; CHECK-LABEL: fsqrt_f128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xssqrtqp v2, v2
; CHECK-NEXT:    blr
  %res = call fp128 @llvm.experimental.constrained.sqrt.f128(
                        fp128 %f1,
                        metadata !"round.dynamic",
                        metadata !"fpexcept.strict")
  ret fp128 %res
}
