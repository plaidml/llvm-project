; RUN: llc -mtriple=riscv64 -mattr=+experimental-v,+d,+experimental-zfh -verify-machineinstrs \
; RUN:   --riscv-no-aliases < %s | FileCheck %s
declare <vscale x 1 x half> @llvm.riscv.vfncvt.f.x.w.nxv1f16.nxv1i32(
  <vscale x 1 x i32>,
  i64);

define <vscale x 1 x half> @intrinsic_vfncvt_f.x.w_nxv1f16_nxv1i32(<vscale x 1 x i32> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_f.x.w_nxv1f16_nxv1i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,ta,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 1 x half> @llvm.riscv.vfncvt.f.x.w.nxv1f16.nxv1i32(
    <vscale x 1 x i32> %0,
    i64 %1)

  ret <vscale x 1 x half> %a
}

declare <vscale x 1 x half> @llvm.riscv.vfncvt.f.x.w.mask.nxv1f16.nxv1i32(
  <vscale x 1 x half>,
  <vscale x 1 x i32>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x half> @intrinsic_vfncvt_mask_f.x.w_nxv1f16_nxv1i32(<vscale x 1 x half> %0, <vscale x 1 x i32> %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_mask_f.x.w_nxv1f16_nxv1i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf4,tu,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 1 x half> @llvm.riscv.vfncvt.f.x.w.mask.nxv1f16.nxv1i32(
    <vscale x 1 x half> %0,
    <vscale x 1 x i32> %1,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfncvt.f.x.w.nxv2f16.nxv2i32(
  <vscale x 2 x i32>,
  i64);

define <vscale x 2 x half> @intrinsic_vfncvt_f.x.w_nxv2f16_nxv2i32(<vscale x 2 x i32> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_f.x.w_nxv2f16_nxv2i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,ta,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 2 x half> @llvm.riscv.vfncvt.f.x.w.nxv2f16.nxv2i32(
    <vscale x 2 x i32> %0,
    i64 %1)

  ret <vscale x 2 x half> %a
}

declare <vscale x 2 x half> @llvm.riscv.vfncvt.f.x.w.mask.nxv2f16.nxv2i32(
  <vscale x 2 x half>,
  <vscale x 2 x i32>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x half> @intrinsic_vfncvt_mask_f.x.w_nxv2f16_nxv2i32(<vscale x 2 x half> %0, <vscale x 2 x i32> %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_mask_f.x.w_nxv2f16_nxv2i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,mf2,tu,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 2 x half> @llvm.riscv.vfncvt.f.x.w.mask.nxv2f16.nxv2i32(
    <vscale x 2 x half> %0,
    <vscale x 2 x i32> %1,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfncvt.f.x.w.nxv4f16.nxv4i32(
  <vscale x 4 x i32>,
  i64);

define <vscale x 4 x half> @intrinsic_vfncvt_f.x.w_nxv4f16_nxv4i32(<vscale x 4 x i32> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_f.x.w_nxv4f16_nxv4i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,ta,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 4 x half> @llvm.riscv.vfncvt.f.x.w.nxv4f16.nxv4i32(
    <vscale x 4 x i32> %0,
    i64 %1)

  ret <vscale x 4 x half> %a
}

declare <vscale x 4 x half> @llvm.riscv.vfncvt.f.x.w.mask.nxv4f16.nxv4i32(
  <vscale x 4 x half>,
  <vscale x 4 x i32>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x half> @intrinsic_vfncvt_mask_f.x.w_nxv4f16_nxv4i32(<vscale x 4 x half> %0, <vscale x 4 x i32> %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_mask_f.x.w_nxv4f16_nxv4i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m1,tu,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 4 x half> @llvm.riscv.vfncvt.f.x.w.mask.nxv4f16.nxv4i32(
    <vscale x 4 x half> %0,
    <vscale x 4 x i32> %1,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfncvt.f.x.w.nxv8f16.nxv8i32(
  <vscale x 8 x i32>,
  i64);

define <vscale x 8 x half> @intrinsic_vfncvt_f.x.w_nxv8f16_nxv8i32(<vscale x 8 x i32> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_f.x.w_nxv8f16_nxv8i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,ta,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 8 x half> @llvm.riscv.vfncvt.f.x.w.nxv8f16.nxv8i32(
    <vscale x 8 x i32> %0,
    i64 %1)

  ret <vscale x 8 x half> %a
}

declare <vscale x 8 x half> @llvm.riscv.vfncvt.f.x.w.mask.nxv8f16.nxv8i32(
  <vscale x 8 x half>,
  <vscale x 8 x i32>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x half> @intrinsic_vfncvt_mask_f.x.w_nxv8f16_nxv8i32(<vscale x 8 x half> %0, <vscale x 8 x i32> %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_mask_f.x.w_nxv8f16_nxv8i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m2,tu,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 8 x half> @llvm.riscv.vfncvt.f.x.w.mask.nxv8f16.nxv8i32(
    <vscale x 8 x half> %0,
    <vscale x 8 x i32> %1,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfncvt.f.x.w.nxv16f16.nxv16i32(
  <vscale x 16 x i32>,
  i64);

define <vscale x 16 x half> @intrinsic_vfncvt_f.x.w_nxv16f16_nxv16i32(<vscale x 16 x i32> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_f.x.w_nxv16f16_nxv16i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,ta,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 16 x half> @llvm.riscv.vfncvt.f.x.w.nxv16f16.nxv16i32(
    <vscale x 16 x i32> %0,
    i64 %1)

  ret <vscale x 16 x half> %a
}

declare <vscale x 16 x half> @llvm.riscv.vfncvt.f.x.w.mask.nxv16f16.nxv16i32(
  <vscale x 16 x half>,
  <vscale x 16 x i32>,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x half> @intrinsic_vfncvt_mask_f.x.w_nxv16f16_nxv16i32(<vscale x 16 x half> %0, <vscale x 16 x i32> %1, <vscale x 16 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_mask_f.x.w_nxv16f16_nxv16i32
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e16,m4,tu,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 16 x half> @llvm.riscv.vfncvt.f.x.w.mask.nxv16f16.nxv16i32(
    <vscale x 16 x half> %0,
    <vscale x 16 x i32> %1,
    <vscale x 16 x i1> %2,
    i64 %3)

  ret <vscale x 16 x half> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfncvt.f.x.w.nxv1f32.nxv1i64(
  <vscale x 1 x i64>,
  i64);

define <vscale x 1 x float> @intrinsic_vfncvt_f.x.w_nxv1f32_nxv1i64(<vscale x 1 x i64> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_f.x.w_nxv1f32_nxv1i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,ta,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 1 x float> @llvm.riscv.vfncvt.f.x.w.nxv1f32.nxv1i64(
    <vscale x 1 x i64> %0,
    i64 %1)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfncvt.f.x.w.mask.nxv1f32.nxv1i64(
  <vscale x 1 x float>,
  <vscale x 1 x i64>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x float> @intrinsic_vfncvt_mask_f.x.w_nxv1f32_nxv1i64(<vscale x 1 x float> %0, <vscale x 1 x i64> %1, <vscale x 1 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_mask_f.x.w_nxv1f32_nxv1i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,mf2,tu,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 1 x float> @llvm.riscv.vfncvt.f.x.w.mask.nxv1f32.nxv1i64(
    <vscale x 1 x float> %0,
    <vscale x 1 x i64> %1,
    <vscale x 1 x i1> %2,
    i64 %3)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfncvt.f.x.w.nxv2f32.nxv2i64(
  <vscale x 2 x i64>,
  i64);

define <vscale x 2 x float> @intrinsic_vfncvt_f.x.w_nxv2f32_nxv2i64(<vscale x 2 x i64> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_f.x.w_nxv2f32_nxv2i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,ta,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 2 x float> @llvm.riscv.vfncvt.f.x.w.nxv2f32.nxv2i64(
    <vscale x 2 x i64> %0,
    i64 %1)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfncvt.f.x.w.mask.nxv2f32.nxv2i64(
  <vscale x 2 x float>,
  <vscale x 2 x i64>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x float> @intrinsic_vfncvt_mask_f.x.w_nxv2f32_nxv2i64(<vscale x 2 x float> %0, <vscale x 2 x i64> %1, <vscale x 2 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_mask_f.x.w_nxv2f32_nxv2i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m1,tu,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 2 x float> @llvm.riscv.vfncvt.f.x.w.mask.nxv2f32.nxv2i64(
    <vscale x 2 x float> %0,
    <vscale x 2 x i64> %1,
    <vscale x 2 x i1> %2,
    i64 %3)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfncvt.f.x.w.nxv4f32.nxv4i64(
  <vscale x 4 x i64>,
  i64);

define <vscale x 4 x float> @intrinsic_vfncvt_f.x.w_nxv4f32_nxv4i64(<vscale x 4 x i64> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_f.x.w_nxv4f32_nxv4i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,ta,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 4 x float> @llvm.riscv.vfncvt.f.x.w.nxv4f32.nxv4i64(
    <vscale x 4 x i64> %0,
    i64 %1)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfncvt.f.x.w.mask.nxv4f32.nxv4i64(
  <vscale x 4 x float>,
  <vscale x 4 x i64>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x float> @intrinsic_vfncvt_mask_f.x.w_nxv4f32_nxv4i64(<vscale x 4 x float> %0, <vscale x 4 x i64> %1, <vscale x 4 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_mask_f.x.w_nxv4f32_nxv4i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m2,tu,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 4 x float> @llvm.riscv.vfncvt.f.x.w.mask.nxv4f32.nxv4i64(
    <vscale x 4 x float> %0,
    <vscale x 4 x i64> %1,
    <vscale x 4 x i1> %2,
    i64 %3)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfncvt.f.x.w.nxv8f32.nxv8i64(
  <vscale x 8 x i64>,
  i64);

define <vscale x 8 x float> @intrinsic_vfncvt_f.x.w_nxv8f32_nxv8i64(<vscale x 8 x i64> %0, i64 %1) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_f.x.w_nxv8f32_nxv8i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,ta,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}
  %a = call <vscale x 8 x float> @llvm.riscv.vfncvt.f.x.w.nxv8f32.nxv8i64(
    <vscale x 8 x i64> %0,
    i64 %1)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfncvt.f.x.w.mask.nxv8f32.nxv8i64(
  <vscale x 8 x float>,
  <vscale x 8 x i64>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x float> @intrinsic_vfncvt_mask_f.x.w_nxv8f32_nxv8i64(<vscale x 8 x float> %0, <vscale x 8 x i64> %1, <vscale x 8 x i1> %2, i64 %3) nounwind {
entry:
; CHECK-LABEL: intrinsic_vfncvt_mask_f.x.w_nxv8f32_nxv8i64
; CHECK:       vsetvli {{.*}}, {{a[0-9]+}}, e32,m4,tu,mu
; CHECK:       vfncvt.f.x.w {{v[0-9]+}}, {{v[0-9]+}}, v0.t
  %a = call <vscale x 8 x float> @llvm.riscv.vfncvt.f.x.w.mask.nxv8f32.nxv8i64(
    <vscale x 8 x float> %0,
    <vscale x 8 x i64> %1,
    <vscale x 8 x i1> %2,
    i64 %3)

  ret <vscale x 8 x float> %a
}
