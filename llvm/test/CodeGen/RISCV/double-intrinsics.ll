; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IFD %s
; RUN: llc -mtriple=riscv64 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64IFD %s

declare double @llvm.sqrt.f64(double)

define double @sqrt_f64(double %a) nounwind {
; RV32IFD-LABEL: sqrt_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw a0, 8(sp)
; RV32IFD-NEXT:    sw a1, 12(sp)
; RV32IFD-NEXT:    fld ft0, 8(sp)
; RV32IFD-NEXT:    fsqrt.d ft0, ft0
; RV32IFD-NEXT:    fsd ft0, 8(sp)
; RV32IFD-NEXT:    lw a0, 8(sp)
; RV32IFD-NEXT:    lw a1, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: sqrt_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fmv.d.x ft0, a0
; RV64IFD-NEXT:    fsqrt.d ft0, ft0
; RV64IFD-NEXT:    fmv.x.d a0, ft0
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.sqrt.f64(double %a)
  ret double %1
}

declare double @llvm.powi.f64(double, i32)

define double @powi_f64(double %a, i32 %b) nounwind {
; RV32IFD-LABEL: powi_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call __powidf2
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: powi_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    sext.w a1, a1
; RV64IFD-NEXT:    call __powidf2
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.powi.f64(double %a, i32 %b)
  ret double %1
}

declare double @llvm.sin.f64(double)

define double @sin_f64(double %a) nounwind {
; RV32IFD-LABEL: sin_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call sin
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: sin_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call sin
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.sin.f64(double %a)
  ret double %1
}

declare double @llvm.cos.f64(double)

define double @cos_f64(double %a) nounwind {
; RV32IFD-LABEL: cos_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call cos
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: cos_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call cos
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.cos.f64(double %a)
  ret double %1
}

; The sin+cos combination results in an FSINCOS SelectionDAG node.
define double @sincos_f64(double %a) nounwind {
; RV32IFD-LABEL: sincos_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -32
; RV32IFD-NEXT:    sw ra, 28(sp)
; RV32IFD-NEXT:    sw s0, 24(sp)
; RV32IFD-NEXT:    sw s1, 20(sp)
; RV32IFD-NEXT:    mv s0, a1
; RV32IFD-NEXT:    mv s1, a0
; RV32IFD-NEXT:    call sin
; RV32IFD-NEXT:    sw a0, 8(sp)
; RV32IFD-NEXT:    sw a1, 12(sp)
; RV32IFD-NEXT:    fld ft0, 8(sp)
; RV32IFD-NEXT:    fsd ft0, 0(sp)
; RV32IFD-NEXT:    mv a0, s1
; RV32IFD-NEXT:    mv a1, s0
; RV32IFD-NEXT:    call cos
; RV32IFD-NEXT:    sw a0, 8(sp)
; RV32IFD-NEXT:    sw a1, 12(sp)
; RV32IFD-NEXT:    fld ft0, 8(sp)
; RV32IFD-NEXT:    fld ft1, 0(sp)
; RV32IFD-NEXT:    fadd.d ft0, ft1, ft0
; RV32IFD-NEXT:    fsd ft0, 8(sp)
; RV32IFD-NEXT:    lw a0, 8(sp)
; RV32IFD-NEXT:    lw a1, 12(sp)
; RV32IFD-NEXT:    lw s1, 20(sp)
; RV32IFD-NEXT:    lw s0, 24(sp)
; RV32IFD-NEXT:    lw ra, 28(sp)
; RV32IFD-NEXT:    addi sp, sp, 32
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: sincos_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -32
; RV64IFD-NEXT:    sd ra, 24(sp)
; RV64IFD-NEXT:    sd s0, 16(sp)
; RV64IFD-NEXT:    mv s0, a0
; RV64IFD-NEXT:    call sin
; RV64IFD-NEXT:    fmv.d.x ft0, a0
; RV64IFD-NEXT:    fsd ft0, 8(sp)
; RV64IFD-NEXT:    mv a0, s0
; RV64IFD-NEXT:    call cos
; RV64IFD-NEXT:    fmv.d.x ft0, a0
; RV64IFD-NEXT:    fld ft1, 8(sp)
; RV64IFD-NEXT:    fadd.d ft0, ft1, ft0
; RV64IFD-NEXT:    fmv.x.d a0, ft0
; RV64IFD-NEXT:    ld s0, 16(sp)
; RV64IFD-NEXT:    ld ra, 24(sp)
; RV64IFD-NEXT:    addi sp, sp, 32
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.sin.f64(double %a)
  %2 = call double @llvm.cos.f64(double %a)
  %3 = fadd double %1, %2
  ret double %3
}

declare double @llvm.pow.f64(double, double)

define double @pow_f64(double %a, double %b) nounwind {
; RV32IFD-LABEL: pow_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call pow
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: pow_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call pow
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.pow.f64(double %a, double %b)
  ret double %1
}

declare double @llvm.exp.f64(double)

define double @exp_f64(double %a) nounwind {
; RV32IFD-LABEL: exp_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call exp
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: exp_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call exp
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.exp.f64(double %a)
  ret double %1
}

declare double @llvm.exp2.f64(double)

define double @exp2_f64(double %a) nounwind {
; RV32IFD-LABEL: exp2_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call exp2
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: exp2_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call exp2
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.exp2.f64(double %a)
  ret double %1
}

declare double @llvm.log.f64(double)

define double @log_f64(double %a) nounwind {
; RV32IFD-LABEL: log_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call log
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: log_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call log
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.log.f64(double %a)
  ret double %1
}

declare double @llvm.log10.f64(double)

define double @log10_f64(double %a) nounwind {
; RV32IFD-LABEL: log10_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call log10
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: log10_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call log10
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.log10.f64(double %a)
  ret double %1
}

declare double @llvm.log2.f64(double)

define double @log2_f64(double %a) nounwind {
; RV32IFD-LABEL: log2_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call log2
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: log2_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call log2
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.log2.f64(double %a)
  ret double %1
}

declare double @llvm.fma.f64(double, double, double)

define double @fma_f64(double %a, double %b, double %c) nounwind {
; RV32IFD-LABEL: fma_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw a4, 8(sp)
; RV32IFD-NEXT:    sw a5, 12(sp)
; RV32IFD-NEXT:    fld ft0, 8(sp)
; RV32IFD-NEXT:    sw a2, 8(sp)
; RV32IFD-NEXT:    sw a3, 12(sp)
; RV32IFD-NEXT:    fld ft1, 8(sp)
; RV32IFD-NEXT:    sw a0, 8(sp)
; RV32IFD-NEXT:    sw a1, 12(sp)
; RV32IFD-NEXT:    fld ft2, 8(sp)
; RV32IFD-NEXT:    fmadd.d ft0, ft2, ft1, ft0
; RV32IFD-NEXT:    fsd ft0, 8(sp)
; RV32IFD-NEXT:    lw a0, 8(sp)
; RV32IFD-NEXT:    lw a1, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fma_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fmv.d.x ft0, a2
; RV64IFD-NEXT:    fmv.d.x ft1, a1
; RV64IFD-NEXT:    fmv.d.x ft2, a0
; RV64IFD-NEXT:    fmadd.d ft0, ft2, ft1, ft0
; RV64IFD-NEXT:    fmv.x.d a0, ft0
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.fma.f64(double %a, double %b, double %c)
  ret double %1
}

declare double @llvm.fmuladd.f64(double, double, double)

define double @fmuladd_f64(double %a, double %b, double %c) nounwind {
; RV32IFD-LABEL: fmuladd_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw a4, 8(sp)
; RV32IFD-NEXT:    sw a5, 12(sp)
; RV32IFD-NEXT:    fld ft0, 8(sp)
; RV32IFD-NEXT:    sw a2, 8(sp)
; RV32IFD-NEXT:    sw a3, 12(sp)
; RV32IFD-NEXT:    fld ft1, 8(sp)
; RV32IFD-NEXT:    sw a0, 8(sp)
; RV32IFD-NEXT:    sw a1, 12(sp)
; RV32IFD-NEXT:    fld ft2, 8(sp)
; RV32IFD-NEXT:    fmadd.d ft0, ft2, ft1, ft0
; RV32IFD-NEXT:    fsd ft0, 8(sp)
; RV32IFD-NEXT:    lw a0, 8(sp)
; RV32IFD-NEXT:    lw a1, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fmuladd_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fmv.d.x ft0, a2
; RV64IFD-NEXT:    fmv.d.x ft1, a1
; RV64IFD-NEXT:    fmv.d.x ft2, a0
; RV64IFD-NEXT:    fmadd.d ft0, ft2, ft1, ft0
; RV64IFD-NEXT:    fmv.x.d a0, ft0
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.fmuladd.f64(double %a, double %b, double %c)
  ret double %1
}

declare double @llvm.fabs.f64(double)

define double @fabs_f64(double %a) nounwind {
; RV32IFD-LABEL: fabs_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    lui a2, 524288
; RV32IFD-NEXT:    addi a2, a2, -1
; RV32IFD-NEXT:    and a1, a1, a2
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fabs_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi a1, zero, -1
; RV64IFD-NEXT:    slli a1, a1, 63
; RV64IFD-NEXT:    addi a1, a1, -1
; RV64IFD-NEXT:    and a0, a0, a1
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.fabs.f64(double %a)
  ret double %1
}

declare double @llvm.minnum.f64(double, double)

define double @minnum_f64(double %a, double %b) nounwind {
; RV32IFD-LABEL: minnum_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw a2, 8(sp)
; RV32IFD-NEXT:    sw a3, 12(sp)
; RV32IFD-NEXT:    fld ft0, 8(sp)
; RV32IFD-NEXT:    sw a0, 8(sp)
; RV32IFD-NEXT:    sw a1, 12(sp)
; RV32IFD-NEXT:    fld ft1, 8(sp)
; RV32IFD-NEXT:    fmin.d ft0, ft1, ft0
; RV32IFD-NEXT:    fsd ft0, 8(sp)
; RV32IFD-NEXT:    lw a0, 8(sp)
; RV32IFD-NEXT:    lw a1, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: minnum_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fmv.d.x ft0, a1
; RV64IFD-NEXT:    fmv.d.x ft1, a0
; RV64IFD-NEXT:    fmin.d ft0, ft1, ft0
; RV64IFD-NEXT:    fmv.x.d a0, ft0
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.minnum.f64(double %a, double %b)
  ret double %1
}

declare double @llvm.maxnum.f64(double, double)

define double @maxnum_f64(double %a, double %b) nounwind {
; RV32IFD-LABEL: maxnum_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw a2, 8(sp)
; RV32IFD-NEXT:    sw a3, 12(sp)
; RV32IFD-NEXT:    fld ft0, 8(sp)
; RV32IFD-NEXT:    sw a0, 8(sp)
; RV32IFD-NEXT:    sw a1, 12(sp)
; RV32IFD-NEXT:    fld ft1, 8(sp)
; RV32IFD-NEXT:    fmax.d ft0, ft1, ft0
; RV32IFD-NEXT:    fsd ft0, 8(sp)
; RV32IFD-NEXT:    lw a0, 8(sp)
; RV32IFD-NEXT:    lw a1, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: maxnum_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fmv.d.x ft0, a1
; RV64IFD-NEXT:    fmv.d.x ft1, a0
; RV64IFD-NEXT:    fmax.d ft0, ft1, ft0
; RV64IFD-NEXT:    fmv.x.d a0, ft0
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.maxnum.f64(double %a, double %b)
  ret double %1
}

; TODO: FMINNAN and FMAXNAN aren't handled in
; SelectionDAGLegalize::ExpandNode.

; declare double @llvm.minimum.f64(double, double)

; define double @fminimum_f64(double %a, double %b) nounwind {
;   %1 = call double @llvm.minimum.f64(double %a, double %b)
;   ret double %1
; }

; declare double @llvm.maximum.f64(double, double)

; define double @fmaximum_f64(double %a, double %b) nounwind {
;   %1 = call double @llvm.maximum.f64(double %a, double %b)
;   ret double %1
; }

declare double @llvm.copysign.f64(double, double)

define double @copysign_f64(double %a, double %b) nounwind {
; RV32IFD-LABEL: copysign_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw a2, 8(sp)
; RV32IFD-NEXT:    sw a3, 12(sp)
; RV32IFD-NEXT:    fld ft0, 8(sp)
; RV32IFD-NEXT:    sw a0, 8(sp)
; RV32IFD-NEXT:    sw a1, 12(sp)
; RV32IFD-NEXT:    fld ft1, 8(sp)
; RV32IFD-NEXT:    fsgnj.d ft0, ft1, ft0
; RV32IFD-NEXT:    fsd ft0, 8(sp)
; RV32IFD-NEXT:    lw a0, 8(sp)
; RV32IFD-NEXT:    lw a1, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: copysign_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fmv.d.x ft0, a1
; RV64IFD-NEXT:    fmv.d.x ft1, a0
; RV64IFD-NEXT:    fsgnj.d ft0, ft1, ft0
; RV64IFD-NEXT:    fmv.x.d a0, ft0
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.copysign.f64(double %a, double %b)
  ret double %1
}

declare double @llvm.floor.f64(double)

define double @floor_f64(double %a) nounwind {
; RV32IFD-LABEL: floor_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call floor
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: floor_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call floor
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.floor.f64(double %a)
  ret double %1
}

declare double @llvm.ceil.f64(double)

define double @ceil_f64(double %a) nounwind {
; RV32IFD-LABEL: ceil_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call ceil
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: ceil_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call ceil
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.ceil.f64(double %a)
  ret double %1
}

declare double @llvm.trunc.f64(double)

define double @trunc_f64(double %a) nounwind {
; RV32IFD-LABEL: trunc_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call trunc
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: trunc_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call trunc
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.trunc.f64(double %a)
  ret double %1
}

declare double @llvm.rint.f64(double)

define double @rint_f64(double %a) nounwind {
; RV32IFD-LABEL: rint_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call rint
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: rint_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call rint
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.rint.f64(double %a)
  ret double %1
}

declare double @llvm.nearbyint.f64(double)

define double @nearbyint_f64(double %a) nounwind {
; RV32IFD-LABEL: nearbyint_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call nearbyint
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: nearbyint_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call nearbyint
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.nearbyint.f64(double %a)
  ret double %1
}

declare double @llvm.round.f64(double)

define double @round_f64(double %a) nounwind {
; RV32IFD-LABEL: round_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp)
; RV32IFD-NEXT:    call round
; RV32IFD-NEXT:    lw ra, 12(sp)
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: round_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp)
; RV64IFD-NEXT:    call round
; RV64IFD-NEXT:    ld ra, 8(sp)
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = call double @llvm.round.f64(double %a)
  ret double %1
}
