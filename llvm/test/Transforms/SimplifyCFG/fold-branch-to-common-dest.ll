; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -bonus-inst-threshold=10 | FileCheck %s

declare void @sideeffect0()
declare void @sideeffect1()
declare void @sideeffect2()
declare void @use8(i8)
declare i1 @gen1()

; Basic cases, blocks have nothing other than the comparison itself.

define void @one_pred(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C0]], [[C1]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[DOTOLD:%.*]] = icmp eq i8 [[V3:%.*]], 0
; CHECK-NEXT:    [[OR_COND2:%.*]] = or i1 [[C1]], [[DOTOLD]]
; CHECK-NEXT:    br i1 [[OR_COND2]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C2]], [[C3]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %c3 = icmp eq i8 %v3, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; More complex case, there's an extra op that is safe to execute unconditionally.

define void @one_pred_with_extra_op(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C0]], [[C1]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %c1 = icmp eq i8 %v1_adj, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds_with_extra_op(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[DOTOLD:%.*]] = add i8 [[V1]], [[V2:%.*]]
; CHECK-NEXT:    [[DOTOLD1:%.*]] = icmp eq i8 [[DOTOLD]], 0
; CHECK-NEXT:    [[OR_COND4:%.*]] = or i1 [[C1]], [[DOTOLD1]]
; CHECK-NEXT:    br i1 [[OR_COND4]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C2]], [[C3]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3_adj, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; More complex case, there's an extra op that is safe to execute unconditionally, and it has multiple uses.

define void @one_pred_with_extra_op_multiuse(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_multiuse(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[V1_ADJ_ADJ:%.*]] = add i8 [[V1_ADJ]], [[V1_ADJ]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1_ADJ_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C0]], [[C1]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %v1_adj_adj = add i8 %v1_adj, %v1_adj
  %c1 = icmp eq i8 %v1_adj_adj, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds_with_extra_op_multiuse(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op_multiuse(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    [[DOTOLD:%.*]] = add i8 [[V1]], [[V2:%.*]]
; CHECK-NEXT:    [[DOTOLD1:%.*]] = add i8 [[DOTOLD]], [[DOTOLD]]
; CHECK-NEXT:    [[DOTOLD2:%.*]] = icmp eq i8 [[DOTOLD1]], 0
; CHECK-NEXT:    [[OR_COND6:%.*]] = or i1 [[C1]], [[DOTOLD2]]
; CHECK-NEXT:    br i1 [[OR_COND6]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[V3_ADJ_ADJ:%.*]] = add i8 [[V3_ADJ]], [[V3_ADJ]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C2]], [[C3]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %v3_adj_adj = add i8 %v3_adj, %v3_adj
  %c3 = icmp eq i8 %v3_adj_adj, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; More complex case, there's an op that is safe to execute unconditionally,
; and said op is live-out.

define void @one_pred_with_extra_op_liveout(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_liveout(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[DISPATCH:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1_ADJ]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %c1 = icmp eq i8 %v1_adj, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v1_adj)
  ret void
final_right:
  call void @sideeffect1()
  ret void
}
define void @one_pred_with_extra_op_liveout_multiuse(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_liveout_multiuse(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[DISPATCH:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1_ADJ]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %c1 = icmp eq i8 %v1_adj, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v1_adj)
  call void @use8(i8 %v1_adj)
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @one_pred_with_extra_op_liveout_distant_phi(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_liveout_distant_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED:%.*]], label [[LEFT_END:%.*]]
; CHECK:       pred:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[DISPATCH:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[V2_ADJ:%.*]] = add i8 [[V0]], [[V1]]
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2_ADJ]], 0
; CHECK-NEXT:    br i1 [[C2]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V2_ADJ]])
; CHECK-NEXT:    br label [[LEFT_END]]
; CHECK:       left_end:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[V2_ADJ]], [[FINAL_LEFT]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred, label %left_end
pred:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %dispatch, label %final_right
dispatch:
  %v2_adj = add i8 %v0, %v1
  %c2 = icmp eq i8 %v2_adj, 0
  br i1 %c2, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v2_adj)
  br label %left_end
left_end:
  %merge_left = phi i8 [ %v2_adj, %final_left ], [ 0, %entry ]
  call void @sideeffect1()
  call void @use8(i8 %merge_left)
  ret void
final_right:
  call void @sideeffect2()
  ret void
}

define void @two_preds_with_extra_op_liveout(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op_liveout(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C2]], [[C3]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[DOTOLD:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[DOTOLD1:%.*]] = icmp eq i8 [[DOTOLD]], 0
; CHECK-NEXT:    br i1 [[DOTOLD1]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[DOTOLD]], [[DISPATCH]] ], [ 0, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3_adj, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  %merge_left = phi i8 [ %v3_adj, %dispatch ], [ 0, %pred0 ]
  call void @use8(i8 %merge_left)
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds_with_extra_op_liveout_multiuse(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op_liveout_multiuse(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3_ADJ]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C2]], [[C3]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[DOTOLD:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[DOTOLD1:%.*]] = icmp eq i8 [[DOTOLD]], 0
; CHECK-NEXT:    br i1 [[DOTOLD1]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[DOTOLD]], [[DISPATCH]] ], [ 0, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    [[MERGE_LEFT_2:%.*]] = phi i8 [ [[DOTOLD]], [[DISPATCH]] ], [ 42, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT_2]])
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3_adj, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  %merge_left = phi i8 [ %v3_adj, %dispatch ], [ 0, %pred0 ]
  %merge_left_2 = phi i8 [ %v3_adj, %dispatch ], [ 42, %pred0 ]
  call void @use8(i8 %merge_left)
  call void @use8(i8 %merge_left_2)
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; More complex case, there's an op that is safe to execute unconditionally,
; and said op is live-out, and it is only used externally.

define void @one_pred_with_extra_op_eexternally_used_only(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_eexternally_used_only(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[DISPATCH:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v1_adj)
  ret void
final_right:
  call void @sideeffect1()
  ret void
}
define void @one_pred_with_extra_op_externally_used_only_multiuse(i8 %v0, i8 %v1) {
; CHECK-LABEL: @one_pred_with_extra_op_externally_used_only_multiuse(
; CHECK-NEXT:  pred:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[DISPATCH:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[V1_ADJ:%.*]] = add i8 [[V0]], [[V1:%.*]]
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    call void @use8(i8 [[V1_ADJ]])
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
pred:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %dispatch, label %final_right
dispatch:
  %v1_adj = add i8 %v0, %v1
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v1_adj)
  call void @use8(i8 %v1_adj)
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds_with_extra_op_externally_used_only(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op_externally_used_only(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3:%.*]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C2]], [[C3]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[DOTOLD:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[DOTOLD1:%.*]] = icmp eq i8 [[V3]], 0
; CHECK-NEXT:    br i1 [[DOTOLD1]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[DOTOLD]], [[DISPATCH]] ], [ 0, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  %merge_left = phi i8 [ %v3_adj, %dispatch ], [ 0, %pred0 ]
  call void @use8(i8 %merge_left)
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @two_preds_with_extra_op_externally_used_only_multiuse(i8 %v0, i8 %v1, i8 %v2, i8 %v3) {
; CHECK-LABEL: @two_preds_with_extra_op_externally_used_only_multiuse(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3:%.*]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C2]], [[C3]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[DOTOLD:%.*]] = add i8 [[V1]], [[V2]]
; CHECK-NEXT:    [[DOTOLD1:%.*]] = icmp eq i8 [[V3]], 0
; CHECK-NEXT:    br i1 [[DOTOLD1]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[DOTOLD]], [[DISPATCH]] ], [ 0, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    [[MERGE_LEFT_2:%.*]] = phi i8 [ [[DOTOLD]], [[DISPATCH]] ], [ 42, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT_2]])
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %v3_adj = add i8 %v1, %v2
  %c3 = icmp eq i8 %v3, 0
  br i1 %c3, label %final_left, label %final_right
final_left:
  %merge_left = phi i8 [ %v3_adj, %dispatch ], [ 0, %pred0 ]
  %merge_left_2 = phi i8 [ %v3_adj, %dispatch ], [ 42, %pred0 ]
  call void @use8(i8 %merge_left)
  call void @use8(i8 %merge_left_2)
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

; The liveout instruction can be located after the branch condition.
define void @one_pred_with_extra_op_externally_used_only_after_cond_distant_phi(i8 %v0, i8 %v1, i8 %v3, i8 %v4, i8 %v5) {
; CHECK-LABEL: @one_pred_with_extra_op_externally_used_only_after_cond_distant_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED:%.*]], label [[LEFT_END:%.*]]
; CHECK:       pred:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[DISPATCH:%.*]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3:%.*]], 0
; CHECK-NEXT:    [[V2_ADJ:%.*]] = add i8 [[V4:%.*]], [[V5:%.*]]
; CHECK-NEXT:    br i1 [[C3]], label [[FINAL_LEFT:%.*]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    call void @use8(i8 [[V2_ADJ]])
; CHECK-NEXT:    br label [[LEFT_END]]
; CHECK:       left_end:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[V2_ADJ]], [[FINAL_LEFT]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred, label %left_end
pred:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %dispatch, label %final_right
dispatch:
  %c3 = icmp eq i8 %v3, 0
  %v2_adj = add i8 %v4, %v5
  br i1 %c3, label %final_left, label %final_right
final_left:
  call void @sideeffect0()
  call void @use8(i8 %v2_adj)
  br label %left_end
left_end:
  %merge_left = phi i8 [ %v2_adj, %final_left ], [ 0, %entry ]
  call void @sideeffect1()
  call void @use8(i8 %merge_left)
  ret void
final_right:
  call void @sideeffect2()
  ret void
}
define void @two_preds_with_extra_op_externally_used_only_after_cond(i8 %v0, i8 %v1, i8 %v2, i8 %v3, i8 %v4, i8 %v5) {
; CHECK-LABEL: @two_preds_with_extra_op_externally_used_only_after_cond(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i8 [[V0:%.*]], 0
; CHECK-NEXT:    br i1 [[C0]], label [[PRED0:%.*]], label [[PRED1:%.*]]
; CHECK:       pred0:
; CHECK-NEXT:    [[C1:%.*]] = icmp eq i8 [[V1:%.*]], 0
; CHECK-NEXT:    br i1 [[C1]], label [[FINAL_LEFT:%.*]], label [[DISPATCH:%.*]]
; CHECK:       pred1:
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i8 [[V2:%.*]], 0
; CHECK-NEXT:    [[C3:%.*]] = icmp eq i8 [[V3:%.*]], 0
; CHECK-NEXT:    [[V3_ADJ:%.*]] = add i8 [[V4:%.*]], [[V5:%.*]]
; CHECK-NEXT:    [[OR_COND:%.*]] = and i1 [[C2]], [[C3]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[FINAL_LEFT]], label [[FINAL_RIGHT:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[DOTOLD:%.*]] = icmp eq i8 [[V3]], 0
; CHECK-NEXT:    [[DOTOLD1:%.*]] = add i8 [[V4]], [[V5]]
; CHECK-NEXT:    br i1 [[DOTOLD]], label [[FINAL_LEFT]], label [[FINAL_RIGHT]]
; CHECK:       final_left:
; CHECK-NEXT:    [[MERGE_LEFT:%.*]] = phi i8 [ [[DOTOLD1]], [[DISPATCH]] ], [ 0, [[PRED0]] ], [ [[V3_ADJ]], [[PRED1]] ]
; CHECK-NEXT:    call void @use8(i8 [[MERGE_LEFT]])
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    ret void
; CHECK:       final_right:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    ret void
;
entry:
  %c0 = icmp eq i8 %v0, 0
  br i1 %c0, label %pred0, label %pred1
pred0:
  %c1 = icmp eq i8 %v1, 0
  br i1 %c1, label %final_left, label %dispatch
pred1:
  %c2 = icmp eq i8 %v2, 0
  br i1 %c2, label %dispatch, label %final_right
dispatch:
  %c3 = icmp eq i8 %v3, 0
  %v3_adj = add i8 %v4, %v5
  br i1 %c3, label %final_left, label %final_right
final_left:
  %merge_left = phi i8 [ %v3_adj, %dispatch ], [ 0, %pred0 ]
  call void @use8(i8 %merge_left)
  call void @sideeffect0()
  ret void
final_right:
  call void @sideeffect1()
  ret void
}

define void @pr48450() {
; CHECK-LABEL: @pr48450(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[COUNTDOWN:%.*]] = phi i16 [ 128, [[ENTRY:%.*]] ], [ [[DEC:%.*]], [[FOR_BODYTHREAD_PRE_SPLIT:%.*]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @gen1()
; CHECK-NEXT:    br i1 [[C]], label [[FOR_INC:%.*]], label [[IF_THEN:%.*]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[DEC]] = add i16 [[COUNTDOWN]], -1
; CHECK-NEXT:    [[CMP_NOT:%.*]] = icmp eq i16 [[COUNTDOWN]], 0
; CHECK-NEXT:    br i1 [[CMP_NOT]], label [[IF_END_LOOPEXIT:%.*]], label [[FOR_BODYTHREAD_PRE_SPLIT]]
; CHECK:       if.then:
; CHECK-NEXT:    [[C2:%.*]] = call i1 @gen1()
; CHECK-NEXT:    br i1 [[C2]], label [[FOR_INC]], label [[IF_END_LOOPEXIT]]
; CHECK:       for.bodythread-pre-split:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[FOR_BODY]]
; CHECK:       if.end.loopexit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %countdown = phi i16 [ 128, %entry ], [ %dec, %for.bodythread-pre-split ]
  %c = call i1 @gen1()
  br i1 %c, label %for.inc, label %if.then

for.inc:
  %dec = add i16 %countdown, -1
  %cmp.not = icmp eq i16 %countdown, 0
  br i1 %cmp.not, label %if.end.loopexit, label %for.bodythread-pre-split

if.then:
  %c2 = call i1 @gen1()
  br i1 %c2, label %for.inc, label %if.end.loopexit

for.bodythread-pre-split:
  call void @sideeffect0()
  br label %for.body

if.end.loopexit:
  ret void
}

define void @pr48450_2(i1 %enable_loopback) {
; CHECK-LABEL: @pr48450_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[COUNTDOWN:%.*]] = phi i16 [ 128, [[ENTRY:%.*]] ], [ [[DEC:%.*]], [[FOR_BODYTHREAD_PRE_SPLIT:%.*]] ]
; CHECK-NEXT:    [[C:%.*]] = call i1 @gen1()
; CHECK-NEXT:    br i1 [[C]], label [[FOR_INC:%.*]], label [[IF_THEN:%.*]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[DEC]] = add i16 [[COUNTDOWN]], -1
; CHECK-NEXT:    [[CMP_NOT:%.*]] = icmp eq i16 [[COUNTDOWN]], 0
; CHECK-NEXT:    br i1 [[CMP_NOT]], label [[IF_END_LOOPEXIT:%.*]], label [[FOR_BODYTHREAD_PRE_SPLIT]]
; CHECK:       if.then:
; CHECK-NEXT:    [[C2:%.*]] = call i1 @gen1()
; CHECK-NEXT:    br i1 [[C2]], label [[FOR_INC]], label [[IF_END_LOOPEXIT]]
; CHECK:       for.bodythread-pre-split:
; CHECK-NEXT:    [[SHOULD_LOOPBACK:%.*]] = phi i1 [ true, [[FOR_INC]] ], [ false, [[FOR_BODYTHREAD_PRE_SPLIT_LOOPBACK:%.*]] ]
; CHECK-NEXT:    [[DO_LOOPBACK:%.*]] = and i1 [[SHOULD_LOOPBACK]], [[ENABLE_LOOPBACK:%.*]]
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br i1 [[DO_LOOPBACK]], label [[FOR_BODYTHREAD_PRE_SPLIT_LOOPBACK]], label [[FOR_BODY]]
; CHECK:       for.bodythread-pre-split.loopback:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br label [[FOR_BODYTHREAD_PRE_SPLIT]]
; CHECK:       if.end.loopexit:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %countdown = phi i16 [ 128, %entry ], [ %dec, %for.bodythread-pre-split ]
  %c = call i1 @gen1()
  br i1 %c, label %for.inc, label %if.then

for.inc:
  %dec = add i16 %countdown, -1
  %cmp.not = icmp eq i16 %countdown, 0
  br i1 %cmp.not, label %if.end.loopexit, label %for.bodythread-pre-split

if.then:
  %c2 = call i1 @gen1()
  br i1 %c2, label %for.inc, label %if.end.loopexit

for.bodythread-pre-split:
  %should_loopback = phi i1 [ 1, %for.inc ], [ 0, %for.bodythread-pre-split.loopback ]
  %do_loopback = and i1 %should_loopback, %enable_loopback
  call void @sideeffect0()
  br i1 %do_loopback, label %for.bodythread-pre-split.loopback, label %for.body

for.bodythread-pre-split.loopback:
  call void @sideeffect0()
  br label %for.bodythread-pre-split

if.end.loopexit:
  ret void
}

@f.b = external global i16, align 1
define void @pr48450_3() {
; CHECK-LABEL: @pr48450_3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND1:%.*]]
; CHECK:       for.cond1:
; CHECK-NEXT:    [[V:%.*]] = load i16, i16* @f.b, align 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[V]], 1
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    br label [[FOR_COND1]]
;
entry:
  br label %for.cond1

for.cond1:
  %v = load i16, i16* @f.b, align 1
  %cmp = icmp slt i16 %v, 1
  br i1 %cmp, label %for.body, label %for.end

for.body:
  br label %for.cond1

for.end:
  %tobool = icmp ne i16 %v, 0
  br i1 %tobool, label %if.then, label %if.end

if.then:
  unreachable

if.end:
  br label %for.cond2

for.cond2:
  %c.0 = phi i16 [ undef, %if.end ], [ %inc, %if.end7 ]
  %cmp3 = icmp slt i16 %c.0, 1
  br i1 %cmp3, label %for.body4, label %for.cond.cleanup

for.cond.cleanup:
  br label %cleanup

for.body4:
  br i1 undef, label %if.then6, label %if.end7

if.then6:
  br label %cleanup

if.end7:
  %inc = add nsw i16 %c.0, 1
  br label %for.cond2

cleanup:
  unreachable
}
