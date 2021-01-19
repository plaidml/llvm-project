; RUN: llc -mtriple=riscv64 -mattr=+experimental-v,+d -verify-machineinstrs \
; RUN:   --riscv-no-aliases < %s | FileCheck %s
declare <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i8(
  <vscale x 1 x i8>,
  <vscale x 1 x i8>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_vv_nxv1i8_nxv1i8(<vscale x 1 x i8> %0, <vscale x 1 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv1i8_nxv1i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i8(
    <vscale x 1 x i8> %0,
    <vscale x 1 x i8> %1,
    i64 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i8(
  <vscale x 1 x i1>,
  <vscale x 1 x i8>,
  <vscale x 1 x i8>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vv_nxv1i8_nxv1i8(<vscale x 1 x i1> %0, <vscale x 1 x i8> %1, <vscale x 1 x i8> %2, <vscale x 1 x i8> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv1i8_nxv1i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i8(
    <vscale x 1 x i8> %1,
    <vscale x 1 x i8> %2,
    i64 %4)
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i8(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i8> %2,
    <vscale x 1 x i8> %3,
    <vscale x 1 x i1> %mask,
    i64 %4)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i8(
  <vscale x 2 x i8>,
  <vscale x 2 x i8>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_vv_nxv2i8_nxv2i8(<vscale x 2 x i8> %0, <vscale x 2 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv2i8_nxv2i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i8(
    <vscale x 2 x i8> %0,
    <vscale x 2 x i8> %1,
    i64 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i8(
  <vscale x 2 x i1>,
  <vscale x 2 x i8>,
  <vscale x 2 x i8>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vv_nxv2i8_nxv2i8(<vscale x 2 x i1> %0, <vscale x 2 x i8> %1, <vscale x 2 x i8> %2, <vscale x 2 x i8> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv2i8_nxv2i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i8(
    <vscale x 2 x i8> %1,
    <vscale x 2 x i8> %2,
    i64 %4)
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i8(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i8> %2,
    <vscale x 2 x i8> %3,
    <vscale x 2 x i1> %mask,
    i64 %4)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i8(
  <vscale x 4 x i8>,
  <vscale x 4 x i8>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_vv_nxv4i8_nxv4i8(<vscale x 4 x i8> %0, <vscale x 4 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv4i8_nxv4i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i8(
    <vscale x 4 x i8> %0,
    <vscale x 4 x i8> %1,
    i64 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i8(
  <vscale x 4 x i1>,
  <vscale x 4 x i8>,
  <vscale x 4 x i8>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vv_nxv4i8_nxv4i8(<vscale x 4 x i1> %0, <vscale x 4 x i8> %1, <vscale x 4 x i8> %2, <vscale x 4 x i8> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv4i8_nxv4i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i8(
    <vscale x 4 x i8> %1,
    <vscale x 4 x i8> %2,
    i64 %4)
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i8(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i8> %2,
    <vscale x 4 x i8> %3,
    <vscale x 4 x i1> %mask,
    i64 %4)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i8(
  <vscale x 8 x i8>,
  <vscale x 8 x i8>,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_vv_nxv8i8_nxv8i8(<vscale x 8 x i8> %0, <vscale x 8 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv8i8_nxv8i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i8(
    <vscale x 8 x i8> %0,
    <vscale x 8 x i8> %1,
    i64 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i8(
  <vscale x 8 x i1>,
  <vscale x 8 x i8>,
  <vscale x 8 x i8>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_mask_vv_nxv8i8_nxv8i8(<vscale x 8 x i1> %0, <vscale x 8 x i8> %1, <vscale x 8 x i8> %2, <vscale x 8 x i8> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv8i8_nxv8i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i8(
    <vscale x 8 x i8> %1,
    <vscale x 8 x i8> %2,
    i64 %4)
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i8(
    <vscale x 8 x i1> %0,
    <vscale x 8 x i8> %2,
    <vscale x 8 x i8> %3,
    <vscale x 8 x i1> %mask,
    i64 %4)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i8(
  <vscale x 16 x i8>,
  <vscale x 16 x i8>,
  i64);

define <vscale x 16 x i1> @intrinsic_vmslt_vv_nxv16i8_nxv16i8(<vscale x 16 x i8> %0, <vscale x 16 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv16i8_nxv16i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i8(
    <vscale x 16 x i8> %0,
    <vscale x 16 x i8> %1,
    i64 %2)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmslt.mask.nxv16i8(
  <vscale x 16 x i1>,
  <vscale x 16 x i8>,
  <vscale x 16 x i8>,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i1> @intrinsic_vmslt_mask_vv_nxv16i8_nxv16i8(<vscale x 16 x i1> %0, <vscale x 16 x i8> %1, <vscale x 16 x i8> %2, <vscale x 16 x i8> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv16i8_nxv16i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i8(
    <vscale x 16 x i8> %1,
    <vscale x 16 x i8> %2,
    i64 %4)
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.mask.nxv16i8(
    <vscale x 16 x i1> %0,
    <vscale x 16 x i8> %2,
    <vscale x 16 x i8> %3,
    <vscale x 16 x i1> %mask,
    i64 %4)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 32 x i1> @llvm.riscv.vmslt.nxv32i8(
  <vscale x 32 x i8>,
  <vscale x 32 x i8>,
  i64);

define <vscale x 32 x i1> @intrinsic_vmslt_vv_nxv32i8_nxv32i8(<vscale x 32 x i8> %0, <vscale x 32 x i8> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv32i8_nxv32i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 32 x i1> @llvm.riscv.vmslt.nxv32i8(
    <vscale x 32 x i8> %0,
    <vscale x 32 x i8> %1,
    i64 %2)

  ret <vscale x 32 x i1> %a
}

declare <vscale x 32 x i1> @llvm.riscv.vmslt.mask.nxv32i8(
  <vscale x 32 x i1>,
  <vscale x 32 x i8>,
  <vscale x 32 x i8>,
  <vscale x 32 x i1>,
  i64);

define <vscale x 32 x i1> @intrinsic_vmslt_mask_vv_nxv32i8_nxv32i8(<vscale x 32 x i1> %0, <vscale x 32 x i8> %1, <vscale x 32 x i8> %2, <vscale x 32 x i8> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv32i8_nxv32i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 32 x i1> @llvm.riscv.vmslt.nxv32i8(
    <vscale x 32 x i8> %1,
    <vscale x 32 x i8> %2,
    i64 %4)
  %a = call <vscale x 32 x i1> @llvm.riscv.vmslt.mask.nxv32i8(
    <vscale x 32 x i1> %0,
    <vscale x 32 x i8> %2,
    <vscale x 32 x i8> %3,
    <vscale x 32 x i1> %mask,
    i64 %4)

  ret <vscale x 32 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i16(
  <vscale x 1 x i16>,
  <vscale x 1 x i16>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_vv_nxv1i16_nxv1i16(<vscale x 1 x i16> %0, <vscale x 1 x i16> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv1i16_nxv1i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i16(
    <vscale x 1 x i16> %0,
    <vscale x 1 x i16> %1,
    i64 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i16(
  <vscale x 1 x i1>,
  <vscale x 1 x i16>,
  <vscale x 1 x i16>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vv_nxv1i16_nxv1i16(<vscale x 1 x i1> %0, <vscale x 1 x i16> %1, <vscale x 1 x i16> %2, <vscale x 1 x i16> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv1i16_nxv1i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i16(
    <vscale x 1 x i16> %1,
    <vscale x 1 x i16> %2,
    i64 %4)
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i16(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i16> %2,
    <vscale x 1 x i16> %3,
    <vscale x 1 x i1> %mask,
    i64 %4)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i16(
  <vscale x 2 x i16>,
  <vscale x 2 x i16>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_vv_nxv2i16_nxv2i16(<vscale x 2 x i16> %0, <vscale x 2 x i16> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv2i16_nxv2i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i16(
    <vscale x 2 x i16> %0,
    <vscale x 2 x i16> %1,
    i64 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i16(
  <vscale x 2 x i1>,
  <vscale x 2 x i16>,
  <vscale x 2 x i16>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vv_nxv2i16_nxv2i16(<vscale x 2 x i1> %0, <vscale x 2 x i16> %1, <vscale x 2 x i16> %2, <vscale x 2 x i16> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv2i16_nxv2i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i16(
    <vscale x 2 x i16> %1,
    <vscale x 2 x i16> %2,
    i64 %4)
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i16(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i16> %2,
    <vscale x 2 x i16> %3,
    <vscale x 2 x i1> %mask,
    i64 %4)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i16(
  <vscale x 4 x i16>,
  <vscale x 4 x i16>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_vv_nxv4i16_nxv4i16(<vscale x 4 x i16> %0, <vscale x 4 x i16> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv4i16_nxv4i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i16(
    <vscale x 4 x i16> %0,
    <vscale x 4 x i16> %1,
    i64 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i16(
  <vscale x 4 x i1>,
  <vscale x 4 x i16>,
  <vscale x 4 x i16>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vv_nxv4i16_nxv4i16(<vscale x 4 x i1> %0, <vscale x 4 x i16> %1, <vscale x 4 x i16> %2, <vscale x 4 x i16> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv4i16_nxv4i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i16(
    <vscale x 4 x i16> %1,
    <vscale x 4 x i16> %2,
    i64 %4)
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i16(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i16> %2,
    <vscale x 4 x i16> %3,
    <vscale x 4 x i1> %mask,
    i64 %4)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i16(
  <vscale x 8 x i16>,
  <vscale x 8 x i16>,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_vv_nxv8i16_nxv8i16(<vscale x 8 x i16> %0, <vscale x 8 x i16> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv8i16_nxv8i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i16(
    <vscale x 8 x i16> %0,
    <vscale x 8 x i16> %1,
    i64 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i16(
  <vscale x 8 x i1>,
  <vscale x 8 x i16>,
  <vscale x 8 x i16>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_mask_vv_nxv8i16_nxv8i16(<vscale x 8 x i1> %0, <vscale x 8 x i16> %1, <vscale x 8 x i16> %2, <vscale x 8 x i16> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv8i16_nxv8i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i16(
    <vscale x 8 x i16> %1,
    <vscale x 8 x i16> %2,
    i64 %4)
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i16(
    <vscale x 8 x i1> %0,
    <vscale x 8 x i16> %2,
    <vscale x 8 x i16> %3,
    <vscale x 8 x i1> %mask,
    i64 %4)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i16(
  <vscale x 16 x i16>,
  <vscale x 16 x i16>,
  i64);

define <vscale x 16 x i1> @intrinsic_vmslt_vv_nxv16i16_nxv16i16(<vscale x 16 x i16> %0, <vscale x 16 x i16> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv16i16_nxv16i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i16(
    <vscale x 16 x i16> %0,
    <vscale x 16 x i16> %1,
    i64 %2)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmslt.mask.nxv16i16(
  <vscale x 16 x i1>,
  <vscale x 16 x i16>,
  <vscale x 16 x i16>,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i1> @intrinsic_vmslt_mask_vv_nxv16i16_nxv16i16(<vscale x 16 x i1> %0, <vscale x 16 x i16> %1, <vscale x 16 x i16> %2, <vscale x 16 x i16> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv16i16_nxv16i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i16(
    <vscale x 16 x i16> %1,
    <vscale x 16 x i16> %2,
    i64 %4)
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.mask.nxv16i16(
    <vscale x 16 x i1> %0,
    <vscale x 16 x i16> %2,
    <vscale x 16 x i16> %3,
    <vscale x 16 x i1> %mask,
    i64 %4)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i32(
  <vscale x 1 x i32>,
  <vscale x 1 x i32>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_vv_nxv1i32_nxv1i32(<vscale x 1 x i32> %0, <vscale x 1 x i32> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv1i32_nxv1i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i32(
    <vscale x 1 x i32> %0,
    <vscale x 1 x i32> %1,
    i64 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i32(
  <vscale x 1 x i1>,
  <vscale x 1 x i32>,
  <vscale x 1 x i32>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vv_nxv1i32_nxv1i32(<vscale x 1 x i1> %0, <vscale x 1 x i32> %1, <vscale x 1 x i32> %2, <vscale x 1 x i32> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv1i32_nxv1i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i32(
    <vscale x 1 x i32> %1,
    <vscale x 1 x i32> %2,
    i64 %4)
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i32(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i32> %2,
    <vscale x 1 x i32> %3,
    <vscale x 1 x i1> %mask,
    i64 %4)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i32(
  <vscale x 2 x i32>,
  <vscale x 2 x i32>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_vv_nxv2i32_nxv2i32(<vscale x 2 x i32> %0, <vscale x 2 x i32> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv2i32_nxv2i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i32(
    <vscale x 2 x i32> %0,
    <vscale x 2 x i32> %1,
    i64 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i32(
  <vscale x 2 x i1>,
  <vscale x 2 x i32>,
  <vscale x 2 x i32>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vv_nxv2i32_nxv2i32(<vscale x 2 x i1> %0, <vscale x 2 x i32> %1, <vscale x 2 x i32> %2, <vscale x 2 x i32> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv2i32_nxv2i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i32(
    <vscale x 2 x i32> %1,
    <vscale x 2 x i32> %2,
    i64 %4)
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i32(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i32> %2,
    <vscale x 2 x i32> %3,
    <vscale x 2 x i1> %mask,
    i64 %4)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i32(
  <vscale x 4 x i32>,
  <vscale x 4 x i32>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_vv_nxv4i32_nxv4i32(<vscale x 4 x i32> %0, <vscale x 4 x i32> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv4i32_nxv4i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i32(
    <vscale x 4 x i32> %0,
    <vscale x 4 x i32> %1,
    i64 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i32(
  <vscale x 4 x i1>,
  <vscale x 4 x i32>,
  <vscale x 4 x i32>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vv_nxv4i32_nxv4i32(<vscale x 4 x i1> %0, <vscale x 4 x i32> %1, <vscale x 4 x i32> %2, <vscale x 4 x i32> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv4i32_nxv4i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i32(
    <vscale x 4 x i32> %1,
    <vscale x 4 x i32> %2,
    i64 %4)
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i32(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i32> %2,
    <vscale x 4 x i32> %3,
    <vscale x 4 x i1> %mask,
    i64 %4)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i32(
  <vscale x 8 x i32>,
  <vscale x 8 x i32>,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_vv_nxv8i32_nxv8i32(<vscale x 8 x i32> %0, <vscale x 8 x i32> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv8i32_nxv8i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i32(
    <vscale x 8 x i32> %0,
    <vscale x 8 x i32> %1,
    i64 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i32(
  <vscale x 8 x i1>,
  <vscale x 8 x i32>,
  <vscale x 8 x i32>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_mask_vv_nxv8i32_nxv8i32(<vscale x 8 x i1> %0, <vscale x 8 x i32> %1, <vscale x 8 x i32> %2, <vscale x 8 x i32> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv8i32_nxv8i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i32(
    <vscale x 8 x i32> %1,
    <vscale x 8 x i32> %2,
    i64 %4)
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i32(
    <vscale x 8 x i1> %0,
    <vscale x 8 x i32> %2,
    <vscale x 8 x i32> %3,
    <vscale x 8 x i1> %mask,
    i64 %4)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i64(
  <vscale x 1 x i64>,
  <vscale x 1 x i64>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_vv_nxv1i64_nxv1i64(<vscale x 1 x i64> %0, <vscale x 1 x i64> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv1i64_nxv1i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i64(
    <vscale x 1 x i64> %0,
    <vscale x 1 x i64> %1,
    i64 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i64(
  <vscale x 1 x i1>,
  <vscale x 1 x i64>,
  <vscale x 1 x i64>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vv_nxv1i64_nxv1i64(<vscale x 1 x i1> %0, <vscale x 1 x i64> %1, <vscale x 1 x i64> %2, <vscale x 1 x i64> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv1i64_nxv1i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i64(
    <vscale x 1 x i64> %1,
    <vscale x 1 x i64> %2,
    i64 %4)
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i64(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i64> %2,
    <vscale x 1 x i64> %3,
    <vscale x 1 x i1> %mask,
    i64 %4)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i64(
  <vscale x 2 x i64>,
  <vscale x 2 x i64>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_vv_nxv2i64_nxv2i64(<vscale x 2 x i64> %0, <vscale x 2 x i64> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv2i64_nxv2i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i64(
    <vscale x 2 x i64> %0,
    <vscale x 2 x i64> %1,
    i64 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i64(
  <vscale x 2 x i1>,
  <vscale x 2 x i64>,
  <vscale x 2 x i64>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vv_nxv2i64_nxv2i64(<vscale x 2 x i1> %0, <vscale x 2 x i64> %1, <vscale x 2 x i64> %2, <vscale x 2 x i64> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv2i64_nxv2i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i64(
    <vscale x 2 x i64> %1,
    <vscale x 2 x i64> %2,
    i64 %4)
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i64(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i64> %2,
    <vscale x 2 x i64> %3,
    <vscale x 2 x i1> %mask,
    i64 %4)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i64(
  <vscale x 4 x i64>,
  <vscale x 4 x i64>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_vv_nxv4i64_nxv4i64(<vscale x 4 x i64> %0, <vscale x 4 x i64> %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vv_nxv4i64_nxv4i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,ta,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i64(
    <vscale x 4 x i64> %0,
    <vscale x 4 x i64> %1,
    i64 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i64(
  <vscale x 4 x i1>,
  <vscale x 4 x i64>,
  <vscale x 4 x i64>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vv_nxv4i64_nxv4i64(<vscale x 4 x i1> %0, <vscale x 4 x i64> %1, <vscale x 4 x i64> %2, <vscale x 4 x i64> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vv_nxv4i64_nxv4i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,tu,mu
; CHECK:       vmslt.vv {{v[0-9]+}}, {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %mask = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i64(
    <vscale x 4 x i64> %1,
    <vscale x 4 x i64> %2,
    i64 %4)
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i64(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i64> %2,
    <vscale x 4 x i64> %3,
    <vscale x 4 x i1> %mask,
    i64 %4)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i8.i8(
  <vscale x 1 x i8>,
  i8,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_vx_nxv1i8_i8(<vscale x 1 x i8> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv1i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i8.i8(
    <vscale x 1 x i8> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i8.i8(
  <vscale x 1 x i1>,
  <vscale x 1 x i8>,
  i8,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vx_nxv1i8_i8(<vscale x 1 x i1> %0, <vscale x 1 x i8> %1, i8 %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv1i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i8.i8(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i8> %1,
    i8 %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i8.i8(
  <vscale x 2 x i8>,
  i8,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_vx_nxv2i8_i8(<vscale x 2 x i8> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv2i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i8.i8(
    <vscale x 2 x i8> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i8.i8(
  <vscale x 2 x i1>,
  <vscale x 2 x i8>,
  i8,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vx_nxv2i8_i8(<vscale x 2 x i1> %0, <vscale x 2 x i8> %1, i8 %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv2i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i8.i8(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i8> %1,
    i8 %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i8.i8(
  <vscale x 4 x i8>,
  i8,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_vx_nxv4i8_i8(<vscale x 4 x i8> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv4i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i8.i8(
    <vscale x 4 x i8> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i8.i8(
  <vscale x 4 x i1>,
  <vscale x 4 x i8>,
  i8,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vx_nxv4i8_i8(<vscale x 4 x i1> %0, <vscale x 4 x i8> %1, i8 %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv4i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i8.i8(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i8> %1,
    i8 %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i8.i8(
  <vscale x 8 x i8>,
  i8,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_vx_nxv8i8_i8(<vscale x 8 x i8> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv8i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i8.i8(
    <vscale x 8 x i8> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i8.i8(
  <vscale x 8 x i1>,
  <vscale x 8 x i8>,
  i8,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_mask_vx_nxv8i8_i8(<vscale x 8 x i1> %0, <vscale x 8 x i8> %1, i8 %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv8i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i8.i8(
    <vscale x 8 x i1> %0,
    <vscale x 8 x i8> %1,
    i8 %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i8.i8(
  <vscale x 16 x i8>,
  i8,
  i64);

define <vscale x 16 x i1> @intrinsic_vmslt_vx_nxv16i8_i8(<vscale x 16 x i8> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv16i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i8.i8(
    <vscale x 16 x i8> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmslt.mask.nxv16i8.i8(
  <vscale x 16 x i1>,
  <vscale x 16 x i8>,
  i8,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i1> @intrinsic_vmslt_mask_vx_nxv16i8_i8(<vscale x 16 x i1> %0, <vscale x 16 x i8> %1, i8 %2, <vscale x 16 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv16i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.mask.nxv16i8.i8(
    <vscale x 16 x i1> %0,
    <vscale x 16 x i8> %1,
    i8 %2,
    <vscale x 16 x i1> %3,
    i64 %4)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 32 x i1> @llvm.riscv.vmslt.nxv32i8.i8(
  <vscale x 32 x i8>,
  i8,
  i64);

define <vscale x 32 x i1> @intrinsic_vmslt_vx_nxv32i8_i8(<vscale x 32 x i8> %0, i8 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv32i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 32 x i1> @llvm.riscv.vmslt.nxv32i8.i8(
    <vscale x 32 x i8> %0,
    i8 %1,
    i64 %2)

  ret <vscale x 32 x i1> %a
}

declare <vscale x 32 x i1> @llvm.riscv.vmslt.mask.nxv32i8.i8(
  <vscale x 32 x i1>,
  <vscale x 32 x i8>,
  i8,
  <vscale x 32 x i1>,
  i64);

define <vscale x 32 x i1> @intrinsic_vmslt_mask_vx_nxv32i8_i8(<vscale x 32 x i1> %0, <vscale x 32 x i8> %1, i8 %2, <vscale x 32 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv32i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 32 x i1> @llvm.riscv.vmslt.mask.nxv32i8.i8(
    <vscale x 32 x i1> %0,
    <vscale x 32 x i8> %1,
    i8 %2,
    <vscale x 32 x i1> %3,
    i64 %4)

  ret <vscale x 32 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i16.i16(
  <vscale x 1 x i16>,
  i16,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_vx_nxv1i16_i16(<vscale x 1 x i16> %0, i16 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv1i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i16.i16(
    <vscale x 1 x i16> %0,
    i16 %1,
    i64 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i16.i16(
  <vscale x 1 x i1>,
  <vscale x 1 x i16>,
  i16,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vx_nxv1i16_i16(<vscale x 1 x i1> %0, <vscale x 1 x i16> %1, i16 %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv1i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i16.i16(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i16> %1,
    i16 %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i16.i16(
  <vscale x 2 x i16>,
  i16,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_vx_nxv2i16_i16(<vscale x 2 x i16> %0, i16 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv2i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i16.i16(
    <vscale x 2 x i16> %0,
    i16 %1,
    i64 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i16.i16(
  <vscale x 2 x i1>,
  <vscale x 2 x i16>,
  i16,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vx_nxv2i16_i16(<vscale x 2 x i1> %0, <vscale x 2 x i16> %1, i16 %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv2i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i16.i16(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i16> %1,
    i16 %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i16.i16(
  <vscale x 4 x i16>,
  i16,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_vx_nxv4i16_i16(<vscale x 4 x i16> %0, i16 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv4i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i16.i16(
    <vscale x 4 x i16> %0,
    i16 %1,
    i64 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i16.i16(
  <vscale x 4 x i1>,
  <vscale x 4 x i16>,
  i16,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vx_nxv4i16_i16(<vscale x 4 x i1> %0, <vscale x 4 x i16> %1, i16 %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv4i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i16.i16(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i16> %1,
    i16 %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i16.i16(
  <vscale x 8 x i16>,
  i16,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_vx_nxv8i16_i16(<vscale x 8 x i16> %0, i16 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv8i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i16.i16(
    <vscale x 8 x i16> %0,
    i16 %1,
    i64 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i16.i16(
  <vscale x 8 x i1>,
  <vscale x 8 x i16>,
  i16,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_mask_vx_nxv8i16_i16(<vscale x 8 x i1> %0, <vscale x 8 x i16> %1, i16 %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv8i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i16.i16(
    <vscale x 8 x i1> %0,
    <vscale x 8 x i16> %1,
    i16 %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i16.i16(
  <vscale x 16 x i16>,
  i16,
  i64);

define <vscale x 16 x i1> @intrinsic_vmslt_vx_nxv16i16_i16(<vscale x 16 x i16> %0, i16 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv16i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i16.i16(
    <vscale x 16 x i16> %0,
    i16 %1,
    i64 %2)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 16 x i1> @llvm.riscv.vmslt.mask.nxv16i16.i16(
  <vscale x 16 x i1>,
  <vscale x 16 x i16>,
  i16,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x i1> @intrinsic_vmslt_mask_vx_nxv16i16_i16(<vscale x 16 x i1> %0, <vscale x 16 x i16> %1, i16 %2, <vscale x 16 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv16i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.mask.nxv16i16.i16(
    <vscale x 16 x i1> %0,
    <vscale x 16 x i16> %1,
    i16 %2,
    <vscale x 16 x i1> %3,
    i64 %4)

  ret <vscale x 16 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i32.i32(
  <vscale x 1 x i32>,
  i32,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_vx_nxv1i32_i32(<vscale x 1 x i32> %0, i32 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv1i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i32.i32(
    <vscale x 1 x i32> %0,
    i32 %1,
    i64 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i32.i32(
  <vscale x 1 x i1>,
  <vscale x 1 x i32>,
  i32,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vx_nxv1i32_i32(<vscale x 1 x i1> %0, <vscale x 1 x i32> %1, i32 %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv1i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i32.i32(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i32> %1,
    i32 %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i32.i32(
  <vscale x 2 x i32>,
  i32,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_vx_nxv2i32_i32(<vscale x 2 x i32> %0, i32 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv2i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i32.i32(
    <vscale x 2 x i32> %0,
    i32 %1,
    i64 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i32.i32(
  <vscale x 2 x i1>,
  <vscale x 2 x i32>,
  i32,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vx_nxv2i32_i32(<vscale x 2 x i1> %0, <vscale x 2 x i32> %1, i32 %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv2i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i32.i32(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i32> %1,
    i32 %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i32.i32(
  <vscale x 4 x i32>,
  i32,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_vx_nxv4i32_i32(<vscale x 4 x i32> %0, i32 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv4i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i32.i32(
    <vscale x 4 x i32> %0,
    i32 %1,
    i64 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i32.i32(
  <vscale x 4 x i1>,
  <vscale x 4 x i32>,
  i32,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vx_nxv4i32_i32(<vscale x 4 x i1> %0, <vscale x 4 x i32> %1, i32 %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv4i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i32.i32(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i32> %1,
    i32 %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i32.i32(
  <vscale x 8 x i32>,
  i32,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_vx_nxv8i32_i32(<vscale x 8 x i32> %0, i32 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv8i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i32.i32(
    <vscale x 8 x i32> %0,
    i32 %1,
    i64 %2)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i32.i32(
  <vscale x 8 x i1>,
  <vscale x 8 x i32>,
  i32,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x i1> @intrinsic_vmslt_mask_vx_nxv8i32_i32(<vscale x 8 x i1> %0, <vscale x 8 x i32> %1, i32 %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv8i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i32.i32(
    <vscale x 8 x i1> %0,
    <vscale x 8 x i32> %1,
    i32 %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i64.i64(
  <vscale x 1 x i64>,
  i64,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_vx_nxv1i64_i64(<vscale x 1 x i64> %0, i64 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv1i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i64.i64(
    <vscale x 1 x i64> %0,
    i64 %1,
    i64 %2)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i64.i64(
  <vscale x 1 x i1>,
  <vscale x 1 x i64>,
  i64,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vx_nxv1i64_i64(<vscale x 1 x i1> %0, <vscale x 1 x i64> %1, i64 %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv1i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i64.i64(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i64> %1,
    i64 %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i64.i64(
  <vscale x 2 x i64>,
  i64,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_vx_nxv2i64_i64(<vscale x 2 x i64> %0, i64 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv2i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i64.i64(
    <vscale x 2 x i64> %0,
    i64 %1,
    i64 %2)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i64.i64(
  <vscale x 2 x i1>,
  <vscale x 2 x i64>,
  i64,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vx_nxv2i64_i64(<vscale x 2 x i1> %0, <vscale x 2 x i64> %1, i64 %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv2i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i64.i64(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i64> %1,
    i64 %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i64.i64(
  <vscale x 4 x i64>,
  i64,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_vx_nxv4i64_i64(<vscale x 4 x i64> %0, i64 %1, i64 %2) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vx_nxv4i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,ta,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i64.i64(
    <vscale x 4 x i64> %0,
    i64 %1,
    i64 %2)

  ret <vscale x 4 x i1> %a
}

declare <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i64.i64(
  <vscale x 4 x i1>,
  <vscale x 4 x i64>,
  i64,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vx_nxv4i64_i64(<vscale x 4 x i1> %0, <vscale x 4 x i64> %1, i64 %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vx_nxv4i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,tu,mu
; CHECK:       vmslt.vx {{v[0-9]+}}, {{v[0-9]+}}, {{a[0-9]+}}, v0.t
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i64.i64(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i64> %1,
    i64 %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x i1> %a
}

define <vscale x 1 x i1> @intrinsic_vmslt_vi_nxv1i8_i8(<vscale x 1 x i8> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv1i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -16
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i8.i8(
    <vscale x 1 x i8> %0,
    i8 -15,
    i64 %1)

  ret <vscale x 1 x i1> %a
}

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vi_nxv1i8_i8(<vscale x 1 x i1> %0, <vscale x 1 x i8> %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv1i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf8,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -15, v0.t
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i8.i8(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i8> %1,
    i8 -14,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x i1> %a
}

define <vscale x 2 x i1> @intrinsic_vmslt_vi_nxv2i8_i8(<vscale x 2 x i8> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv2i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -14
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i8.i8(
    <vscale x 2 x i8> %0,
    i8 -13,
    i64 %1)

  ret <vscale x 2 x i1> %a
}

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vi_nxv2i8_i8(<vscale x 2 x i1> %0, <vscale x 2 x i8> %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv2i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf4,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -13, v0.t
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i8.i8(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i8> %1,
    i8 -12,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x i1> %a
}

define <vscale x 4 x i1> @intrinsic_vmslt_vi_nxv4i8_i8(<vscale x 4 x i8> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv4i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -12
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i8.i8(
    <vscale x 4 x i8> %0,
    i8 -11,
    i64 %1)

  ret <vscale x 4 x i1> %a
}

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vi_nxv4i8_i8(<vscale x 4 x i1> %0, <vscale x 4 x i8> %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv4i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,mf2,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -11, v0.t
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i8.i8(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i8> %1,
    i8 -10,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x i1> %a
}

define <vscale x 8 x i1> @intrinsic_vmslt_vi_nxv8i8_i8(<vscale x 8 x i8> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv8i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -10
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i8.i8(
    <vscale x 8 x i8> %0,
    i8 -9,
    i64 %1)

  ret <vscale x 8 x i1> %a
}

define <vscale x 8 x i1> @intrinsic_vmslt_mask_vi_nxv8i8_i8(<vscale x 8 x i1> %0, <vscale x 8 x i8> %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv8i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m1,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -9, v0.t
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i8.i8(
    <vscale x 8 x i1> %0,
    <vscale x 8 x i8> %1,
    i8 -8,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x i1> %a
}

define <vscale x 16 x i1> @intrinsic_vmslt_vi_nxv16i8_i8(<vscale x 16 x i8> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv16i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -8
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i8.i8(
    <vscale x 16 x i8> %0,
    i8 -7,
    i64 %1)

  ret <vscale x 16 x i1> %a
}

define <vscale x 16 x i1> @intrinsic_vmslt_mask_vi_nxv16i8_i8(<vscale x 16 x i1> %0, <vscale x 16 x i8> %1, <vscale x 16 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv16i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m2,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -7, v0.t
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.mask.nxv16i8.i8(
    <vscale x 16 x i1> %0,
    <vscale x 16 x i8> %1,
    i8 -6,
    <vscale x 16 x i1> %2,
    i64 %3)

  ret <vscale x 16 x i1> %a
}

define <vscale x 32 x i1> @intrinsic_vmslt_vi_nxv32i8_i8(<vscale x 32 x i8> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv32i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -6
  %a = call <vscale x 32 x i1> @llvm.riscv.vmslt.nxv32i8.i8(
    <vscale x 32 x i8> %0,
    i8 -5,
    i64 %1)

  ret <vscale x 32 x i1> %a
}

define <vscale x 32 x i1> @intrinsic_vmslt_mask_vi_nxv32i8_i8(<vscale x 32 x i1> %0, <vscale x 32 x i8> %1, <vscale x 32 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv32i8_i8
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e8,m4,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -5, v0.t
  %a = call <vscale x 32 x i1> @llvm.riscv.vmslt.mask.nxv32i8.i8(
    <vscale x 32 x i1> %0,
    <vscale x 32 x i8> %1,
    i8 -4,
    <vscale x 32 x i1> %2,
    i64 %3)

  ret <vscale x 32 x i1> %a
}

define <vscale x 1 x i1> @intrinsic_vmslt_vi_nxv1i16_i16(<vscale x 1 x i16> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv1i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -4
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i16.i16(
    <vscale x 1 x i16> %0,
    i16 -3,
    i64 %1)

  ret <vscale x 1 x i1> %a
}

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vi_nxv1i16_i16(<vscale x 1 x i1> %0, <vscale x 1 x i16> %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv1i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -3, v0.t
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i16.i16(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i16> %1,
    i16 -2,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x i1> %a
}

define <vscale x 2 x i1> @intrinsic_vmslt_vi_nxv2i16_i16(<vscale x 2 x i16> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv2i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -2
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i16.i16(
    <vscale x 2 x i16> %0,
    i16 -1,
    i64 %1)

  ret <vscale x 2 x i1> %a
}

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vi_nxv2i16_i16(<vscale x 2 x i1> %0, <vscale x 2 x i16> %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv2i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -1, v0.t
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i16.i16(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i16> %1,
    i16 0,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x i1> %a
}

define <vscale x 4 x i1> @intrinsic_vmslt_vi_nxv4i16_i16(<vscale x 4 x i16> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv4i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -1
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i16.i16(
    <vscale x 4 x i16> %0,
    i16 0,
    i64 %1)

  ret <vscale x 4 x i1> %a
}

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vi_nxv4i16_i16(<vscale x 4 x i1> %0, <vscale x 4 x i16> %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv4i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 0, v0.t
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i16.i16(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i16> %1,
    i16 1,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x i1> %a
}

define <vscale x 8 x i1> @intrinsic_vmslt_vi_nxv8i16_i16(<vscale x 8 x i16> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv8i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 1
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i16.i16(
    <vscale x 8 x i16> %0,
    i16 2,
    i64 %1)

  ret <vscale x 8 x i1> %a
}

define <vscale x 8 x i1> @intrinsic_vmslt_mask_vi_nxv8i16_i16(<vscale x 8 x i1> %0, <vscale x 8 x i16> %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv8i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 2, v0.t
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i16.i16(
    <vscale x 8 x i1> %0,
    <vscale x 8 x i16> %1,
    i16 3,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x i1> %a
}

define <vscale x 16 x i1> @intrinsic_vmslt_vi_nxv16i16_i16(<vscale x 16 x i16> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv16i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 3
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.nxv16i16.i16(
    <vscale x 16 x i16> %0,
    i16 4,
    i64 %1)

  ret <vscale x 16 x i1> %a
}

define <vscale x 16 x i1> @intrinsic_vmslt_mask_vi_nxv16i16_i16(<vscale x 16 x i1> %0, <vscale x 16 x i16> %1, <vscale x 16 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv16i16_i16
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 4, v0.t
  %a = call <vscale x 16 x i1> @llvm.riscv.vmslt.mask.nxv16i16.i16(
    <vscale x 16 x i1> %0,
    <vscale x 16 x i16> %1,
    i16 5,
    <vscale x 16 x i1> %2,
    i64 %3)

  ret <vscale x 16 x i1> %a
}

define <vscale x 1 x i1> @intrinsic_vmslt_vi_nxv1i32_i32(<vscale x 1 x i32> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv1i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 5
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i32.i32(
    <vscale x 1 x i32> %0,
    i32 6,
    i64 %1)

  ret <vscale x 1 x i1> %a
}

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vi_nxv1i32_i32(<vscale x 1 x i1> %0, <vscale x 1 x i32> %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv1i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 6, v0.t
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i32.i32(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i32> %1,
    i32 7,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x i1> %a
}

define <vscale x 2 x i1> @intrinsic_vmslt_vi_nxv2i32_i32(<vscale x 2 x i32> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv2i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 7
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i32.i32(
    <vscale x 2 x i32> %0,
    i32 8,
    i64 %1)

  ret <vscale x 2 x i1> %a
}

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vi_nxv2i32_i32(<vscale x 2 x i1> %0, <vscale x 2 x i32> %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv2i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 8, v0.t
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i32.i32(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i32> %1,
    i32 9,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x i1> %a
}

define <vscale x 4 x i1> @intrinsic_vmslt_vi_nxv4i32_i32(<vscale x 4 x i32> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv4i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 9
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i32.i32(
    <vscale x 4 x i32> %0,
    i32 10,
    i64 %1)

  ret <vscale x 4 x i1> %a
}

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vi_nxv4i32_i32(<vscale x 4 x i1> %0, <vscale x 4 x i32> %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv4i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 10, v0.t
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i32.i32(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i32> %1,
    i32 11,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x i1> %a
}

define <vscale x 8 x i1> @intrinsic_vmslt_vi_nxv8i32_i32(<vscale x 8 x i32> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv8i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 11
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.nxv8i32.i32(
    <vscale x 8 x i32> %0,
    i32 12,
    i64 %1)

  ret <vscale x 8 x i1> %a
}

define <vscale x 8 x i1> @intrinsic_vmslt_mask_vi_nxv8i32_i32(<vscale x 8 x i1> %0, <vscale x 8 x i32> %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv8i32_i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 12, v0.t
  %a = call <vscale x 8 x i1> @llvm.riscv.vmslt.mask.nxv8i32.i32(
    <vscale x 8 x i1> %0,
    <vscale x 8 x i32> %1,
    i32 13,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x i1> %a
}

define <vscale x 1 x i1> @intrinsic_vmslt_vi_nxv1i64_i64(<vscale x 1 x i64> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv1i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 13
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.nxv1i64.i64(
    <vscale x 1 x i64> %0,
    i64 14,
    i64 %1)

  ret <vscale x 1 x i1> %a
}

define <vscale x 1 x i1> @intrinsic_vmslt_mask_vi_nxv1i64_i64(<vscale x 1 x i1> %0, <vscale x 1 x i64> %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv1i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m1,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 14, v0.t
  %a = call <vscale x 1 x i1> @llvm.riscv.vmslt.mask.nxv1i64.i64(
    <vscale x 1 x i1> %0,
    <vscale x 1 x i64> %1,
    i64 15,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x i1> %a
}

define <vscale x 2 x i1> @intrinsic_vmslt_vi_nxv2i64_i64(<vscale x 2 x i64> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv2i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, 15
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.nxv2i64.i64(
    <vscale x 2 x i64> %0,
    i64 16,
    i64 %1)

  ret <vscale x 2 x i1> %a
}

define <vscale x 2 x i1> @intrinsic_vmslt_mask_vi_nxv2i64_i64(<vscale x 2 x i1> %0, <vscale x 2 x i64> %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv2i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m2,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -16, v0.t
  %a = call <vscale x 2 x i1> @llvm.riscv.vmslt.mask.nxv2i64.i64(
    <vscale x 2 x i1> %0,
    <vscale x 2 x i64> %1,
    i64 -15,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x i1> %a
}

define <vscale x 4 x i1> @intrinsic_vmslt_vi_nxv4i64_i64(<vscale x 4 x i64> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_vi_nxv4i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,ta,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -15
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.nxv4i64.i64(
    <vscale x 4 x i64> %0,
    i64 -14,
    i64 %1)

  ret <vscale x 4 x i1> %a
}

define <vscale x 4 x i1> @intrinsic_vmslt_mask_vi_nxv4i64_i64(<vscale x 4 x i1> %0, <vscale x 4 x i64> %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vmslt_mask_vi_nxv4i64_i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e64,m4,tu,mu
; CHECK:       vmsle.vi {{v[0-9]+}}, {{v[0-9]+}}, -14, v0.t
  %a = call <vscale x 4 x i1> @llvm.riscv.vmslt.mask.nxv4i64.i64(
    <vscale x 4 x i1> %0,
    <vscale x 4 x i64> %1,
    i64 -13,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x i1> %a
}
