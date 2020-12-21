; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve -o - %s | FileCheck %s
; RUN: llc -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve.fp -o - %s | FileCheck --check-prefix=CHECK --check-prefix=CHECK-FP %s

define <16 x i8> @vector_add_i8(<16 x i8> %lhs, <16 x i8> %rhs) {
; CHECK-LABEL: vector_add_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %sum = add <16 x i8> %lhs, %rhs
  ret <16 x i8> %sum
}

define <8 x i16> @vector_add_i16(<8 x i16> %lhs, <8 x i16> %rhs) {
; CHECK-LABEL: vector_add_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %sum = add <8 x i16> %lhs, %rhs
  ret <8 x i16> %sum
}

define <4 x i32> @vector_add_i32(<4 x i32> %lhs, <4 x i32> %rhs) {
; CHECK-LABEL: vector_add_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vmov d1, r2, r3
; CHECK-NEXT:    vmov d0, r0, r1
; CHECK-NEXT:    mov r0, sp
; CHECK-NEXT:    vldrw.u32 q1, [r0]
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vmov r0, r1, d0
; CHECK-NEXT:    vmov r2, r3, d1
; CHECK-NEXT:    bx lr
entry:
  %sum = add <4 x i32> %lhs, %rhs
  ret <4 x i32> %sum
}

define <2 x i64> @vector_add_i64(<2 x i64> %lhs, <2 x i64> %rhs) {
; CHECK-FP-LABEL: vector_add_i64:
; CHECK-FP:       @ %bb.0: @ %entry
; CHECK-FP-NEXT:    .save {r7, lr}
; CHECK-FP-NEXT:    push {r7, lr}
; CHECK-FP-NEXT:    vmov d1, r2, r3
; CHECK-FP-NEXT:    vmov d0, r0, r1
; CHECK-FP-NEXT:    add r0, sp, #8
; CHECK-FP-NEXT:    vldrw.u32 q1, [r0]
; CHECK-FP-NEXT:    vmov r1, s2
; CHECK-FP-NEXT:    vmov r0, s3
; CHECK-FP-NEXT:    vmov r3, s6
; CHECK-FP-NEXT:    vmov r2, s7
; CHECK-FP-NEXT:    adds.w lr, r1, r3
; CHECK-FP-NEXT:    vmov r3, s0
; CHECK-FP-NEXT:    vmov r1, s4
; CHECK-FP-NEXT:    adc.w r12, r0, r2
; CHECK-FP-NEXT:    vmov r2, s1
; CHECK-FP-NEXT:    vmov r0, s5
; CHECK-FP-NEXT:    adds r1, r1, r3
; CHECK-FP-NEXT:    vmov q0[2], q0[0], r1, lr
; CHECK-FP-NEXT:    adcs r0, r2
; CHECK-FP-NEXT:    vmov q0[3], q0[1], r0, r12
; CHECK-FP-NEXT:    vmov r0, r1, d0
; CHECK-FP-NEXT:    vmov r2, r3, d1
; CHECK-FP-NEXT:    pop {r7, pc}
entry:
  %sum = add <2 x i64> %lhs, %rhs
  ret <2 x i64> %sum
}

define <8 x half> @vector_add_f16(<8 x half> %lhs, <8 x half> %rhs) {
; CHECK-FP-LABEL: vector_add_f16:
; CHECK-FP:       @ %bb.0: @ %entry
; CHECK-FP-NEXT:    vmov d1, r2, r3
; CHECK-FP-NEXT:    vmov d0, r0, r1
; CHECK-FP-NEXT:    mov r0, sp
; CHECK-FP-NEXT:    vldrw.u32 q1, [r0]
; CHECK-FP-NEXT:    vadd.f16 q0, q0, q1
; CHECK-FP-NEXT:    vmov r0, r1, d0
; CHECK-FP-NEXT:    vmov r2, r3, d1
; CHECK-FP-NEXT:    bx lr
entry:
  %sum = fadd <8 x half> %lhs, %rhs
  ret <8 x half> %sum
}

define <4 x float> @vector_add_f32(<4 x float> %lhs, <4 x float> %rhs) {
; CHECK-FP-LABEL: vector_add_f32:
; CHECK-FP:       @ %bb.0: @ %entry
; CHECK-FP-NEXT:    vmov d1, r2, r3
; CHECK-FP-NEXT:    vmov d0, r0, r1
; CHECK-FP-NEXT:    mov r0, sp
; CHECK-FP-NEXT:    vldrw.u32 q1, [r0]
; CHECK-FP-NEXT:    vadd.f32 q0, q0, q1
; CHECK-FP-NEXT:    vmov r0, r1, d0
; CHECK-FP-NEXT:    vmov r2, r3, d1
; CHECK-FP-NEXT:    bx lr
entry:
  %sum = fadd <4 x float> %lhs, %rhs
  ret <4 x float> %sum
}

define <2 x double> @vector_add_f64(<2 x double> %lhs, <2 x double> %rhs) {
; CHECK-FP-LABEL: vector_add_f64:
; CHECK-FP:       @ %bb.0: @ %entry
; CHECK-FP-NEXT:    .save {r4, r5, r6, r7, lr}
; CHECK-FP-NEXT:    push {r4, r5, r6, r7, lr}
; CHECK-FP-NEXT:    .pad #4
; CHECK-FP-NEXT:    sub sp, #4
; CHECK-FP-NEXT:    .vsave {d8, d9}
; CHECK-FP-NEXT:    vpush {d8, d9}
; CHECK-FP-NEXT:    mov r5, r0
; CHECK-FP-NEXT:    add r0, sp, #40
; CHECK-FP-NEXT:    vldrw.u32 q4, [r0]
; CHECK-FP-NEXT:    mov r4, r2
; CHECK-FP-NEXT:    mov r6, r3
; CHECK-FP-NEXT:    mov r7, r1
; CHECK-FP-NEXT:    vmov r2, r3, d9
; CHECK-FP-NEXT:    mov r0, r4
; CHECK-FP-NEXT:    mov r1, r6
; CHECK-FP-NEXT:    bl __aeabi_dadd
; CHECK-FP-NEXT:    vmov r2, r3, d8
; CHECK-FP-NEXT:    vmov d9, r0, r1
; CHECK-FP-NEXT:    mov r0, r5
; CHECK-FP-NEXT:    mov r1, r7
; CHECK-FP-NEXT:    bl __aeabi_dadd
; CHECK-FP-NEXT:    vmov d8, r0, r1
; CHECK-FP-NEXT:    vmov r2, r3, d9
; CHECK-FP-NEXT:    vmov r0, r1, d8
; CHECK-FP-NEXT:    vpop {d8, d9}
; CHECK-FP-NEXT:    add sp, #4
; CHECK-FP-NEXT:    pop {r4, r5, r6, r7, pc}
entry:
  %sum = fadd <2 x double> %lhs, %rhs
  ret <2 x double> %sum
}
