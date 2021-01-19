; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -mtriple=x86_64-unknown-unknown -S | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; Verify that instcombine is able to fold identity shuffles.

define <4 x float> @identity_test_vpermilvar_ps(<4 x float> %v) {
; CHECK-LABEL: @identity_test_vpermilvar_ps(
; CHECK-NEXT:    ret <4 x float> [[V:%.*]]
;
  %a = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %v, <4 x i32> <i32 0, i32 1, i32 2, i32 3>)
  ret <4 x float> %a
}

define <8 x float> @identity_test_vpermilvar_ps_256(<8 x float> %v) {
; CHECK-LABEL: @identity_test_vpermilvar_ps_256(
; CHECK-NEXT:    ret <8 x float> [[V:%.*]]
;
  %a = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %v, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>)
  ret <8 x float> %a
}

define <16 x float> @identity_test_vpermilvar_ps_512(<16 x float> %v) {
; CHECK-LABEL: @identity_test_vpermilvar_ps_512(
; CHECK-NEXT:    ret <16 x float> [[V:%.*]]
;
  %a = tail call <16 x float> @llvm.x86.avx512.vpermilvar.ps.512(<16 x float> %v, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3, i32 0, i32 1, i32 2, i32 3>)
  ret <16 x float> %a
}

define <2 x double> @identity_test_vpermilvar_pd(<2 x double> %v) {
; CHECK-LABEL: @identity_test_vpermilvar_pd(
; CHECK-NEXT:    ret <2 x double> [[V:%.*]]
;
  %a = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double> %v, <2 x i64> <i64 0, i64 2>)
  ret <2 x double> %a
}

define <4 x double> @identity_test_vpermilvar_pd_256(<4 x double> %v) {
; CHECK-LABEL: @identity_test_vpermilvar_pd_256(
; CHECK-NEXT:    ret <4 x double> [[V:%.*]]
;
  %a = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %v, <4 x i64> <i64 0, i64 2, i64 0, i64 2>)
  ret <4 x double> %a
}

define <8 x double> @identity_test_vpermilvar_pd_512(<8 x double> %v) {
; CHECK-LABEL: @identity_test_vpermilvar_pd_512(
; CHECK-NEXT:    ret <8 x double> [[V:%.*]]
;
  %a = tail call <8 x double> @llvm.x86.avx512.vpermilvar.pd.512(<8 x double> %v, <8 x i64> <i64 0, i64 2, i64 0, i64 2, i64 0, i64 2, i64 0, i64 2>)
  ret <8 x double> %a
}

; Instcombine should be able to fold the following byte shuffle to a builtin shufflevector
; with a shuffle mask of all zeroes.

define <4 x float> @zero_test_vpermilvar_ps_zero(<4 x float> %v) {
; CHECK-LABEL: @zero_test_vpermilvar_ps_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x float> [[V:%.*]], <4 x float> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %a = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %v, <4 x i32> zeroinitializer)
  ret <4 x float> %a
}

define <8 x float> @zero_test_vpermilvar_ps_256_zero(<8 x float> %v) {
; CHECK-LABEL: @zero_test_vpermilvar_ps_256_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x float> [[V:%.*]], <8 x float> poison, <8 x i32> <i32 0, i32 0, i32 0, i32 0, i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    ret <8 x float> [[TMP1]]
;
  %a = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %v, <8 x i32> zeroinitializer)
  ret <8 x float> %a
}

define <16 x float> @zero_test_vpermilvar_ps_512_zero(<16 x float> %v) {
; CHECK-LABEL: @zero_test_vpermilvar_ps_512_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <16 x float> [[V:%.*]], <16 x float> poison, <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 4, i32 4, i32 4, i32 4, i32 8, i32 8, i32 8, i32 8, i32 12, i32 12, i32 12, i32 12>
; CHECK-NEXT:    ret <16 x float> [[TMP1]]
;
  %a = tail call <16 x float> @llvm.x86.avx512.vpermilvar.ps.512(<16 x float> %v, <16 x i32> zeroinitializer)
  ret <16 x float> %a
}

define <2 x double> @zero_test_vpermilvar_pd_zero(<2 x double> %v) {
; CHECK-LABEL: @zero_test_vpermilvar_pd_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[V:%.*]], <2 x double> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %a = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double> %v, <2 x i64> zeroinitializer)
  ret <2 x double> %a
}

define <4 x double> @zero_test_vpermilvar_pd_256_zero(<4 x double> %v) {
; CHECK-LABEL: @zero_test_vpermilvar_pd_256_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x double> [[V:%.*]], <4 x double> poison, <4 x i32> <i32 0, i32 0, i32 2, i32 2>
; CHECK-NEXT:    ret <4 x double> [[TMP1]]
;
  %a = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %v, <4 x i64> zeroinitializer)
  ret <4 x double> %a
}

define <8 x double> @zero_test_vpermilvar_pd_512_zero(<8 x double> %v) {
; CHECK-LABEL: @zero_test_vpermilvar_pd_512_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x double> [[V:%.*]], <8 x double> poison, <8 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6>
; CHECK-NEXT:    ret <8 x double> [[TMP1]]
;
  %a = tail call <8 x double> @llvm.x86.avx512.vpermilvar.pd.512(<8 x double> %v, <8 x i64> zeroinitializer)
  ret <8 x double> %a
}

; Verify that instcombine is able to fold constant shuffles.

define <4 x float> @test_vpermilvar_ps(<4 x float> %v) {
; CHECK-LABEL: @test_vpermilvar_ps(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x float> [[V:%.*]], <4 x float> poison, <4 x i32> <i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %a = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %v, <4 x i32> <i32 3, i32 2, i32 1, i32 0>)
  ret <4 x float> %a
}

define <8 x float> @test_vpermilvar_ps_256(<8 x float> %v) {
; CHECK-LABEL: @test_vpermilvar_ps_256(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x float> [[V:%.*]], <8 x float> poison, <8 x i32> <i32 3, i32 2, i32 1, i32 0, i32 7, i32 6, i32 5, i32 4>
; CHECK-NEXT:    ret <8 x float> [[TMP1]]
;
  %a = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %v, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>)
  ret <8 x float> %a
}

define <16 x float> @test_vpermilvar_ps_512(<16 x float> %v) {
; CHECK-LABEL: @test_vpermilvar_ps_512(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <16 x float> [[V:%.*]], <16 x float> poison, <16 x i32> <i32 3, i32 2, i32 1, i32 0, i32 7, i32 6, i32 5, i32 4, i32 11, i32 10, i32 9, i32 8, i32 15, i32 14, i32 13, i32 12>
; CHECK-NEXT:    ret <16 x float> [[TMP1]]
;
  %a = tail call <16 x float> @llvm.x86.avx512.vpermilvar.ps.512(<16 x float> %v, <16 x i32> <i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8, i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>)
  ret <16 x float> %a
}

define <2 x double> @test_vpermilvar_pd(<2 x double> %v) {
; CHECK-LABEL: @test_vpermilvar_pd(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[V:%.*]], <2 x double> poison, <2 x i32> <i32 1, i32 0>
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %a = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double> %v, <2 x i64> <i64 2, i64 0>)
  ret <2 x double> %a
}

define <4 x double> @test_vpermilvar_pd_256(<4 x double> %v) {
; CHECK-LABEL: @test_vpermilvar_pd_256(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x double> [[V:%.*]], <4 x double> poison, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
; CHECK-NEXT:    ret <4 x double> [[TMP1]]
;
  %a = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %v, <4 x i64> <i64 3, i64 1, i64 2, i64 0>)
  ret <4 x double> %a
}

define <8 x double> @test_vpermilvar_pd_512(<8 x double> %v) {
; CHECK-LABEL: @test_vpermilvar_pd_512(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x double> [[V:%.*]], <8 x double> poison, <8 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6>
; CHECK-NEXT:    ret <8 x double> [[TMP1]]
;
  %a = tail call <8 x double> @llvm.x86.avx512.vpermilvar.pd.512(<8 x double> %v, <8 x i64> <i64 3, i64 1, i64 2, i64 0, i64 7, i64 5, i64 6, i64 4>)
  ret <8 x double> %a
}

; Verify that instcombine is able to fold constant shuffles with undef mask elements.

define <4 x float> @undef_test_vpermilvar_ps(<4 x float> %v) {
; CHECK-LABEL: @undef_test_vpermilvar_ps(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x float> [[V:%.*]], <4 x float> poison, <4 x i32> <i32 undef, i32 2, i32 1, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %a = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %v, <4 x i32> <i32 undef, i32 2, i32 1, i32 undef>)
  ret <4 x float> %a
}

define <8 x float> @undef_test_vpermilvar_ps_256(<8 x float> %v) {
; CHECK-LABEL: @undef_test_vpermilvar_ps_256(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x float> [[V:%.*]], <8 x float> poison, <8 x i32> <i32 undef, i32 2, i32 1, i32 undef, i32 7, i32 6, i32 5, i32 4>
; CHECK-NEXT:    ret <8 x float> [[TMP1]]
;
  %a = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %v, <8 x i32> <i32 undef, i32 6, i32 5, i32 undef, i32 3, i32 2, i32 1, i32 0>)
  ret <8 x float> %a
}

define <16 x float> @undef_test_vpermilvar_ps_512(<16 x float> %v) {
; CHECK-LABEL: @undef_test_vpermilvar_ps_512(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <16 x float> [[V:%.*]], <16 x float> poison, <16 x i32> <i32 undef, i32 2, i32 1, i32 undef, i32 7, i32 6, i32 5, i32 4, i32 undef, i32 10, i32 9, i32 undef, i32 15, i32 14, i32 13, i32 12>
; CHECK-NEXT:    ret <16 x float> [[TMP1]]
;
  %a = tail call <16 x float> @llvm.x86.avx512.vpermilvar.ps.512(<16 x float> %v, <16 x i32> <i32 undef, i32 6, i32 5, i32 undef, i32 3, i32 2, i32 1, i32 0, i32 undef, i32 6, i32 5, i32 undef, i32 3, i32 2, i32 1, i32 0>)
  ret <16 x float> %a
}

define <2 x double> @undef_test_vpermilvar_pd(<2 x double> %v) {
; CHECK-LABEL: @undef_test_vpermilvar_pd(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[V:%.*]], <2 x double> poison, <2 x i32> <i32 undef, i32 0>
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %a = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double> %v, <2 x i64> <i64 undef, i64 0>)
  ret <2 x double> %a
}

define <4 x double> @undef_test_vpermilvar_pd_256(<4 x double> %v) {
; CHECK-LABEL: @undef_test_vpermilvar_pd_256(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x double> [[V:%.*]], <4 x double> poison, <4 x i32> <i32 undef, i32 0, i32 3, i32 undef>
; CHECK-NEXT:    ret <4 x double> [[TMP1]]
;
  %a = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %v, <4 x i64> <i64 undef, i64 1, i64 2, i64 undef>)
  ret <4 x double> %a
}

define <8 x double> @undef_test_vpermilvar_pd_512(<8 x double> %v) {
; CHECK-LABEL: @undef_test_vpermilvar_pd_512(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x double> [[V:%.*]], <8 x double> poison, <8 x i32> <i32 undef, i32 0, i32 3, i32 undef, i32 undef, i32 4, i32 7, i32 undef>
; CHECK-NEXT:    ret <8 x double> [[TMP1]]
;
  %a = tail call <8 x double> @llvm.x86.avx512.vpermilvar.pd.512(<8 x double> %v, <8 x i64> <i64 undef, i64 1, i64 2, i64 undef, i64 undef, i64 1, i64 2, i64 undef>)
  ret <8 x double> %a
}

; Simplify demanded elts

define <4 x float> @elts_test_vpermilvar_ps(<4 x float> %a0, i32 %a1) {
; CHECK-LABEL: @elts_test_vpermilvar_ps(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x float> [[A0:%.*]], <4 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
; CHECK-NEXT:    ret <4 x float> [[TMP1]]
;
  %1 = insertelement <4 x i32> <i32 0, i32 1, i32 2, i32 3>, i32 %a1, i32 3
  %2 = tail call <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float> %a0, <4 x i32> %1)
  %3 = shufflevector <4 x float> %2, <4 x float> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
  ret <4 x float> %3
}

define <8 x float> @elts_test_vpermilvar_ps_256(<8 x float> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @elts_test_vpermilvar_ps_256(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x float> [[A0:%.*]], <8 x float> poison, <8 x i32> <i32 undef, i32 0, i32 undef, i32 1, i32 undef, i32 6, i32 undef, i32 7>
; CHECK-NEXT:    ret <8 x float> [[TMP1]]
;
  %1 = shufflevector <8 x i32> %a1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 3, i32 2, i32 1, i32 0>, <8 x i32> <i32 0, i32 8, i32 1, i32 9, i32 2, i32 10, i32 3, i32 11>
  %2 = tail call <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float> %a0, <8 x i32> %1)
  %3 = shufflevector <8 x float> %2, <8 x float> undef, <8 x i32> <i32 undef, i32 1, i32 undef, i32 3, i32 undef, i32 5, i32 undef, i32 7>
  ret <8 x float> %3
}

define <16 x float> @elts_test_vpermilvar_ps_512(<16 x float> %a0, <16 x i32> %a1, i32 %a2) {
; CHECK-LABEL: @elts_test_vpermilvar_ps_512(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call <16 x float> @llvm.x86.avx512.vpermilvar.ps.512(<16 x float> [[A0:%.*]], <16 x i32> [[A1:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <16 x float> [[TMP1]], <16 x float> undef, <16 x i32> <i32 undef, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
; CHECK-NEXT:    ret <16 x float> [[TMP2]]
;
  %1 = insertelement <16 x i32> %a1, i32 %a2, i32 0
  %2 = tail call <16 x float> @llvm.x86.avx512.vpermilvar.ps.512(<16 x float> %a0, <16 x i32> %1)
  %3 = shufflevector <16 x float> %2, <16 x float> undef, <16 x i32> <i32 undef, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  ret <16 x float> %3
}

define <2 x double> @elts_test_vpermilvar_pd(<2 x double> %a0, i64 %a1) {
; CHECK-LABEL: @elts_test_vpermilvar_pd(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <2 x double> [[A0:%.*]], <2 x double> undef, <2 x i32> <i32 0, i32 undef>
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %1 = insertelement <2 x i64> <i64 0, i64 2>, i64 %a1, i32 1
  %2 = tail call <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double> %a0, <2 x i64> %1)
  %3 = shufflevector <2 x double> %2, <2 x double> undef, <2 x i32> <i32 0, i32 undef>
  ret <2 x double> %3
}

define <4 x double> @elts_test_vpermilvar_pd_256(<4 x double> %a0, <4 x i64> %a1) {
; CHECK-LABEL: @elts_test_vpermilvar_pd_256(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x double> [[A0:%.*]], <4 x double> poison, <4 x i32> <i32 1, i32 0, i32 3, i32 undef>
; CHECK-NEXT:    ret <4 x double> [[TMP1]]
;
  %1 = shufflevector <4 x i64> <i64 0, i64 2, i64 0, i64 2>, <4 x i64> %a1, <4 x i32> <i32 1, i32 2, i32 3, i32 4>
  %2 = tail call <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double> %a0, <4 x i64> %1)
  %3 = shufflevector <4 x double> %2, <4 x double> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
  ret <4 x double> %3
}

define <8 x double> @elts_test_vpermilvar_pd_512(<8 x double> %a0, <8 x i64> %a1, i64 %a2) {
; CHECK-LABEL: @elts_test_vpermilvar_pd_512(
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <8 x i64> poison, i64 [[A2:%.*]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = tail call <8 x double> @llvm.x86.avx512.vpermilvar.pd.512(<8 x double> [[A0:%.*]], <8 x i64> [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <8 x double> [[TMP2]], <8 x double> undef, <8 x i32> zeroinitializer
; CHECK-NEXT:    ret <8 x double> [[TMP3]]
;
  %1 = insertelement <8 x i64> %a1, i64 %a2, i32 0
  %2 = tail call <8 x double> @llvm.x86.avx512.vpermilvar.pd.512(<8 x double> %a0, <8 x i64> %1)
  %3 = shufflevector <8 x double> %2, <8 x double> undef, <8 x i32> zeroinitializer
  ret <8 x double> %3
}

declare <2 x double> @llvm.x86.avx.vpermilvar.pd(<2 x double>, <2 x i64>)
declare <4 x double> @llvm.x86.avx.vpermilvar.pd.256(<4 x double>, <4 x i64>)
declare <8 x double> @llvm.x86.avx512.vpermilvar.pd.512(<8 x double>, <8 x i64>)

declare <4 x float> @llvm.x86.avx.vpermilvar.ps(<4 x float>, <4 x i32>)
declare <8 x float> @llvm.x86.avx.vpermilvar.ps.256(<8 x float>, <8 x i32>)
declare <16 x float> @llvm.x86.avx512.vpermilvar.ps.512(<16 x float>, <16 x i32>)
