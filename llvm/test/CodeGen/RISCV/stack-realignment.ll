; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I

declare void @callee(i8*)

define void @caller32() nounwind {
; RV32I-LABEL: caller32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 24(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 32
; RV32I-NEXT:    andi sp, sp, -32
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    addi sp, s0, -32
; RV32I-NEXT:    lw s0, 24(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 28(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 32
; RV64I-NEXT:    andi sp, sp, -32
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    addi sp, s0, -32
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %1 = alloca i8, align 32
  call void @callee(i8* %1)
  ret void
}

define void @caller_no_realign32() nounwind "no-realign-stack" {
; RV32I-LABEL: caller_no_realign32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller_no_realign32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = alloca i8, align 32
  call void @callee(i8* %1)
  ret void
}

define void @caller64() nounwind {
; RV32I-LABEL: caller64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -64
; RV32I-NEXT:    sw ra, 60(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 56(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 64
; RV32I-NEXT:    andi sp, sp, -64
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    addi sp, s0, -64
; RV32I-NEXT:    lw s0, 56(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 60(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 64
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -64
; RV64I-NEXT:    sd ra, 56(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 48(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 64
; RV64I-NEXT:    andi sp, sp, -64
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    addi sp, s0, -64
; RV64I-NEXT:    ld s0, 48(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 56(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 64
; RV64I-NEXT:    ret
  %1 = alloca i8, align 64
  call void @callee(i8* %1)
  ret void
}

define void @caller_no_realign64() nounwind "no-realign-stack" {
; RV32I-LABEL: caller_no_realign64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller_no_realign64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = alloca i8, align 64
  call void @callee(i8* %1)
  ret void
}

define void @caller128() nounwind {
; RV32I-LABEL: caller128:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -128
; RV32I-NEXT:    sw ra, 124(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 120(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 128
; RV32I-NEXT:    andi sp, sp, -128
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    addi sp, s0, -128
; RV32I-NEXT:    lw s0, 120(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 124(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 128
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller128:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -128
; RV64I-NEXT:    sd ra, 120(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 112(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 128
; RV64I-NEXT:    andi sp, sp, -128
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    addi sp, s0, -128
; RV64I-NEXT:    ld s0, 112(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 120(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 128
; RV64I-NEXT:    ret
  %1 = alloca i8, align 128
  call void @callee(i8* %1)
  ret void
}

define void @caller_no_realign128() nounwind "no-realign-stack" {
; RV32I-LABEL: caller_no_realign128:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller_no_realign128:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = alloca i8, align 128
  call void @callee(i8* %1)
  ret void
}

define void @caller256() nounwind {
; RV32I-LABEL: caller256:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -256
; RV32I-NEXT:    sw ra, 252(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 248(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 256
; RV32I-NEXT:    andi sp, sp, -256
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    addi sp, s0, -256
; RV32I-NEXT:    lw s0, 248(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 252(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 256
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller256:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -256
; RV64I-NEXT:    sd ra, 248(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 240(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 256
; RV64I-NEXT:    andi sp, sp, -256
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    addi sp, s0, -256
; RV64I-NEXT:    ld s0, 240(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 248(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 256
; RV64I-NEXT:    ret
  %1 = alloca i8, align 256
  call void @callee(i8* %1)
  ret void
}

define void @caller_no_realign256() nounwind "no-realign-stack" {
; RV32I-LABEL: caller_no_realign256:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller_no_realign256:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = alloca i8, align 256
  call void @callee(i8* %1)
  ret void
}

define void @caller512() nounwind {
; RV32I-LABEL: caller512:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -1024
; RV32I-NEXT:    sw ra, 1020(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 1016(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 1024
; RV32I-NEXT:    andi sp, sp, -512
; RV32I-NEXT:    addi a0, sp, 512
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    addi sp, s0, -1024
; RV32I-NEXT:    lw s0, 1016(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 1020(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 1024
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller512:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -1024
; RV64I-NEXT:    sd ra, 1016(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 1008(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 1024
; RV64I-NEXT:    andi sp, sp, -512
; RV64I-NEXT:    addi a0, sp, 512
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    addi sp, s0, -1024
; RV64I-NEXT:    ld s0, 1008(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 1016(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 1024
; RV64I-NEXT:    ret
  %1 = alloca i8, align 512
  call void @callee(i8* %1)
  ret void
}

define void @caller_no_realign512() nounwind "no-realign-stack" {
; RV32I-LABEL: caller_no_realign512:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller_no_realign512:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = alloca i8, align 512
  call void @callee(i8* %1)
  ret void
}

define void @caller1024() nounwind {
; RV32I-LABEL: caller1024:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -2032
; RV32I-NEXT:    sw ra, 2028(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 2024(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 2032
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    andi sp, sp, -1024
; RV32I-NEXT:    addi a0, sp, 1024
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    addi sp, s0, -2048
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    lw s0, 2024(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 2028(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 2032
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller1024:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -2032
; RV64I-NEXT:    sd ra, 2024(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 2016(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 2032
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    andi sp, sp, -1024
; RV64I-NEXT:    addi a0, sp, 1024
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    addi sp, s0, -2048
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ld s0, 2016(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 2024(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 2032
; RV64I-NEXT:    ret
  %1 = alloca i8, align 1024
  call void @callee(i8* %1)
  ret void
}

define void @caller_no_realign1024() nounwind "no-realign-stack" {
; RV32I-LABEL: caller_no_realign1024:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller_no_realign1024:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = alloca i8, align 1024
  call void @callee(i8* %1)
  ret void
}

define void @caller2048() nounwind {
; RV32I-LABEL: caller2048:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -2032
; RV32I-NEXT:    sw ra, 2028(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 2024(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 2032
; RV32I-NEXT:    lui a0, 1
; RV32I-NEXT:    addi a0, a0, -2032
; RV32I-NEXT:    sub sp, sp, a0
; RV32I-NEXT:    andi sp, sp, -2048
; RV32I-NEXT:    lui a0, 1
; RV32I-NEXT:    addi a0, a0, -2048
; RV32I-NEXT:    add a0, sp, a0
; RV32I-NEXT:    mv a0, a0
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    lui a0, 1
; RV32I-NEXT:    sub sp, s0, a0
; RV32I-NEXT:    lui a0, 1
; RV32I-NEXT:    addi a0, a0, -2032
; RV32I-NEXT:    add sp, sp, a0
; RV32I-NEXT:    lw s0, 2024(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 2028(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 2032
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller2048:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -2032
; RV64I-NEXT:    sd ra, 2024(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 2016(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 2032
; RV64I-NEXT:    lui a0, 1
; RV64I-NEXT:    addiw a0, a0, -2032
; RV64I-NEXT:    sub sp, sp, a0
; RV64I-NEXT:    andi sp, sp, -2048
; RV64I-NEXT:    lui a0, 1
; RV64I-NEXT:    addiw a0, a0, -2048
; RV64I-NEXT:    add a0, sp, a0
; RV64I-NEXT:    mv a0, a0
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    lui a0, 1
; RV64I-NEXT:    sub sp, s0, a0
; RV64I-NEXT:    lui a0, 1
; RV64I-NEXT:    addiw a0, a0, -2032
; RV64I-NEXT:    add sp, sp, a0
; RV64I-NEXT:    ld s0, 2016(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 2024(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 2032
; RV64I-NEXT:    ret
  %1 = alloca i8, align 2048
  call void @callee(i8* %1)
  ret void
}

define void @caller_no_realign2048() nounwind "no-realign-stack" {
; RV32I-LABEL: caller_no_realign2048:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller_no_realign2048:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = alloca i8, align 2048
  call void @callee(i8* %1)
  ret void
}

define void @caller4096() nounwind {
; RV32I-LABEL: caller4096:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -2032
; RV32I-NEXT:    sw ra, 2028(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 2024(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 2032
; RV32I-NEXT:    lui a0, 2
; RV32I-NEXT:    addi a0, a0, -2032
; RV32I-NEXT:    sub sp, sp, a0
; RV32I-NEXT:    srli a0, sp, 12
; RV32I-NEXT:    slli sp, a0, 12
; RV32I-NEXT:    lui a0, 1
; RV32I-NEXT:    add a0, sp, a0
; RV32I-NEXT:    mv a0, a0
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    lui a0, 2
; RV32I-NEXT:    sub sp, s0, a0
; RV32I-NEXT:    lui a0, 2
; RV32I-NEXT:    addi a0, a0, -2032
; RV32I-NEXT:    add sp, sp, a0
; RV32I-NEXT:    lw s0, 2024(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 2028(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 2032
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller4096:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -2032
; RV64I-NEXT:    sd ra, 2024(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 2016(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 2032
; RV64I-NEXT:    lui a0, 2
; RV64I-NEXT:    addiw a0, a0, -2032
; RV64I-NEXT:    sub sp, sp, a0
; RV64I-NEXT:    srli a0, sp, 12
; RV64I-NEXT:    slli sp, a0, 12
; RV64I-NEXT:    lui a0, 1
; RV64I-NEXT:    add a0, sp, a0
; RV64I-NEXT:    mv a0, a0
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    lui a0, 2
; RV64I-NEXT:    sub sp, s0, a0
; RV64I-NEXT:    lui a0, 2
; RV64I-NEXT:    addiw a0, a0, -2032
; RV64I-NEXT:    add sp, sp, a0
; RV64I-NEXT:    ld s0, 2016(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 2024(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 2032
; RV64I-NEXT:    ret
  %1 = alloca i8, align 4096
  call void @callee(i8* %1)
  ret void
}

define void @caller_no_realign4096() nounwind "no-realign-stack" {
; RV32I-LABEL: caller_no_realign4096:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a0, sp
; RV32I-NEXT:    call callee@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: caller_no_realign4096:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a0, sp
; RV64I-NEXT:    call callee@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = alloca i8, align 4096
  call void @callee(i8* %1)
  ret void
}
