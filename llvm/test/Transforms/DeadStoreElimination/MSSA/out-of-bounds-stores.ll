; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -dse -S %s | FileCheck %s

declare void @use(i32)

; Out-of-bounds stores can be considered killing any other stores to the same
; object in the same BB, because they are UB and guaranteed to execute. Note
; that cases in which the BB is exited through unwinding are handled separately
; by DSE and the unwinding call will be considered as clobber.
define i32 @test_out_of_bounds_store_local(i1 %c) {
; CHECK-LABEL: @test_out_of_bounds_store_local(
; CHECK-NEXT:    [[D:%.*]] = alloca [1 x i32], align 4
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds [1 x i32], [1 x i32]* [[D]], i64 0, i64 0
; CHECK-NEXT:    [[LV1:%.*]] = load i32, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    call void @use(i32 [[LV1]])
; CHECK-NEXT:    ret i32 0
;
  %d = alloca [1 x i32], align 4
  %arrayidx = getelementptr inbounds [1 x i32], [1 x i32]* %d, i64 0, i64 0
  store i32 10, i32* %arrayidx, align 4
  %arrayidx.1 = getelementptr inbounds [1 x i32], [1 x i32]* %d, i64 0, i64 1
  store i32 20, i32* %arrayidx.1, align 4
  %arrayidx1 = getelementptr inbounds [1 x i32], [1 x i32]* %d, i64 0, i64 0
  %lv1 = load i32, i32* %arrayidx1, align 4
  call void @use(i32 %lv1)
  ret i32 0
}

; Make sure that out-of-bound stores are not considered killing other stores to
; the same underlying object, if they are in different basic blocks. The
; out-of-bounds store may not be executed.
;
; Test case from PR48279. FIXME.
define i32 @test_out_of_bounds_store_nonlocal(i1 %c) {
; CHECK-LABEL: @test_out_of_bounds_store_nonlocal(
; CHECK-NEXT:    [[D:%.*]] = alloca [1 x i32], align 4
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br label [[FOR_INC:%.*]]
; CHECK:       for.inc:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[FOR_BODY_1:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.1:
; CHECK-NEXT:    ret i32 1
; CHECK:       for.end:
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds [1 x i32], [1 x i32]* [[D]], i64 0, i64 0
; CHECK-NEXT:    [[LV1:%.*]] = load i32, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    call void @use(i32 [[LV1]])
; CHECK-NEXT:    ret i32 0
;
  %d = alloca [1 x i32], align 4
  br label %for.body

for.body:                                         ; preds = %for.cond
  %arrayidx = getelementptr inbounds [1 x i32], [1 x i32]* %d, i64 0, i64 0
  store i32 10, i32* %arrayidx, align 4
  br label %for.inc

for.inc:                                          ; preds = %for.body
  br i1 %c, label %for.body.1, label %for.end

for.body.1:                                       ; preds = %for.inc
  %arrayidx.1 = getelementptr inbounds [1 x i32], [1 x i32]* %d, i64 0, i64 1
  store i32 20, i32* %arrayidx.1, align 4
  ret i32 1

for.end:                                          ; preds = %for.inc
  %arrayidx1 = getelementptr inbounds [1 x i32], [1 x i32]* %d, i64 0, i64 0
  %lv1 = load i32, i32* %arrayidx1, align 4
  call void @use(i32 %lv1)
  ret i32 0
}
