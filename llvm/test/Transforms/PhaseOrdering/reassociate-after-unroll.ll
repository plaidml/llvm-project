; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; REQUIRES: powerpc-registered-target
; RUN: opt -O2 -enable-new-pm=0 -S < %s | FileCheck %s --check-prefix=OLDPM
; RUN: opt -passes='default<O2>' -S < %s | FileCheck %s --check-prefix=NEWPM

target datalayout = "e-m:e-i64:64-n32:64"
target triple = "powerpc64le-unknown-linux-gnu"

define dso_local i64 @func(i64 %blah, i64 %limit) #0 {
; OLDPM-LABEL: @func(
; OLDPM-NEXT:  entry:
; OLDPM-NEXT:    [[CMP4:%.*]] = icmp eq i64 [[LIMIT:%.*]], 0
; OLDPM-NEXT:    br i1 [[CMP4]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_LR_PH:%.*]]
; OLDPM:       for.body.lr.ph:
; OLDPM-NEXT:    [[CONV:%.*]] = and i64 [[BLAH:%.*]], 4294967295
; OLDPM-NEXT:    [[TMP0:%.*]] = add i64 [[LIMIT]], -1
; OLDPM-NEXT:    [[XTRAITER:%.*]] = and i64 [[LIMIT]], 7
; OLDPM-NEXT:    [[TMP1:%.*]] = icmp ult i64 [[TMP0]], 7
; OLDPM-NEXT:    br i1 [[TMP1]], label [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA:%.*]], label [[FOR_BODY_LR_PH_NEW:%.*]]
; OLDPM:       for.body.lr.ph.new:
; OLDPM-NEXT:    [[UNROLL_ITER:%.*]] = and i64 [[LIMIT]], -8
; OLDPM-NEXT:    br label [[FOR_BODY:%.*]]
; OLDPM:       for.cond.cleanup.loopexit.unr-lcssa:
; OLDPM-NEXT:    [[ADD_LCSSA_PH:%.*]] = phi i64 [ undef, [[FOR_BODY_LR_PH]] ], [ [[ADD_7:%.*]], [[FOR_BODY]] ]
; OLDPM-NEXT:    [[K_05_UNR:%.*]] = phi i64 [ 1, [[FOR_BODY_LR_PH]] ], [ [[AND:%.*]], [[FOR_BODY]] ]
; OLDPM-NEXT:    [[LCMP_MOD:%.*]] = icmp eq i64 [[XTRAITER]], 0
; OLDPM-NEXT:    br i1 [[LCMP_MOD]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY_EPIL:%.*]]
; OLDPM:       for.body.epil:
; OLDPM-NEXT:    [[G_06_EPIL:%.*]] = phi i64 [ [[ADD_EPIL:%.*]], [[FOR_BODY_EPIL]] ], [ [[ADD_LCSSA_PH]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]] ]
; OLDPM-NEXT:    [[K_05_EPIL:%.*]] = phi i64 [ [[AND_EPIL:%.*]], [[FOR_BODY_EPIL]] ], [ [[K_05_UNR]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]] ]
; OLDPM-NEXT:    [[EPIL_ITER:%.*]] = phi i64 [ [[EPIL_ITER_SUB:%.*]], [[FOR_BODY_EPIL]] ], [ [[XTRAITER]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]] ]
; OLDPM-NEXT:    [[AND_EPIL]] = and i64 [[CONV]], [[K_05_EPIL]]
; OLDPM-NEXT:    [[ADD_EPIL]] = add i64 [[AND_EPIL]], [[G_06_EPIL]]
; OLDPM-NEXT:    [[EPIL_ITER_SUB]] = add i64 [[EPIL_ITER]], -1
; OLDPM-NEXT:    [[EPIL_ITER_CMP:%.*]] = icmp eq i64 [[EPIL_ITER_SUB]], 0
; OLDPM-NEXT:    br i1 [[EPIL_ITER_CMP]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY_EPIL]], !llvm.loop !0
; OLDPM:       for.cond.cleanup:
; OLDPM-NEXT:    [[G_0_LCSSA:%.*]] = phi i64 [ undef, [[ENTRY:%.*]] ], [ [[ADD_LCSSA_PH]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]] ], [ [[ADD_EPIL]], [[FOR_BODY_EPIL]] ]
; OLDPM-NEXT:    ret i64 [[G_0_LCSSA]]
; OLDPM:       for.body:
; OLDPM-NEXT:    [[G_06:%.*]] = phi i64 [ undef, [[FOR_BODY_LR_PH_NEW]] ], [ [[ADD_7]], [[FOR_BODY]] ]
; OLDPM-NEXT:    [[K_05:%.*]] = phi i64 [ 1, [[FOR_BODY_LR_PH_NEW]] ], [ [[AND]], [[FOR_BODY]] ]
; OLDPM-NEXT:    [[NITER:%.*]] = phi i64 [ [[UNROLL_ITER]], [[FOR_BODY_LR_PH_NEW]] ], [ [[NITER_NSUB_7:%.*]], [[FOR_BODY]] ]
; OLDPM-NEXT:    [[AND]] = and i64 [[CONV]], [[K_05]]
; OLDPM-NEXT:    [[REASS_ADD:%.*]] = shl nuw nsw i64 [[AND]], 1
; OLDPM-NEXT:    [[ADD_1:%.*]] = add i64 [[G_06]], [[REASS_ADD]]
; OLDPM-NEXT:    [[REASS_ADD9:%.*]] = shl nuw nsw i64 [[AND]], 1
; OLDPM-NEXT:    [[ADD_3:%.*]] = add i64 [[ADD_1]], [[REASS_ADD9]]
; OLDPM-NEXT:    [[REASS_ADD10:%.*]] = shl nuw nsw i64 [[AND]], 1
; OLDPM-NEXT:    [[ADD_5:%.*]] = add i64 [[ADD_3]], [[REASS_ADD10]]
; OLDPM-NEXT:    [[REASS_ADD11:%.*]] = shl nuw nsw i64 [[AND]], 1
; OLDPM-NEXT:    [[ADD_7]] = add i64 [[ADD_5]], [[REASS_ADD11]]
; OLDPM-NEXT:    [[NITER_NSUB_7]] = add i64 [[NITER]], -8
; OLDPM-NEXT:    [[NITER_NCMP_7:%.*]] = icmp eq i64 [[NITER_NSUB_7]], 0
; OLDPM-NEXT:    br i1 [[NITER_NCMP_7]], label [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]], label [[FOR_BODY]]
;
; NEWPM-LABEL: @func(
; NEWPM-NEXT:  entry:
; NEWPM-NEXT:    [[CMP4:%.*]] = icmp eq i64 [[LIMIT:%.*]], 0
; NEWPM-NEXT:    br i1 [[CMP4]], label [[FOR_COND_CLEANUP:%.*]], label [[FOR_BODY_LR_PH:%.*]]
; NEWPM:       for.body.lr.ph:
; NEWPM-NEXT:    [[CONV:%.*]] = and i64 [[BLAH:%.*]], 4294967295
; NEWPM-NEXT:    [[TMP0:%.*]] = add i64 [[LIMIT]], -1
; NEWPM-NEXT:    [[XTRAITER:%.*]] = and i64 [[LIMIT]], 7
; NEWPM-NEXT:    [[TMP1:%.*]] = icmp ult i64 [[TMP0]], 7
; NEWPM-NEXT:    br i1 [[TMP1]], label [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA:%.*]], label [[FOR_BODY_LR_PH_NEW:%.*]]
; NEWPM:       for.body.lr.ph.new:
; NEWPM-NEXT:    [[UNROLL_ITER:%.*]] = and i64 [[LIMIT]], -8
; NEWPM-NEXT:    [[AND_0:%.*]] = and i64 [[CONV]], 1
; NEWPM-NEXT:    br label [[FOR_BODY:%.*]]
; NEWPM:       for.cond.cleanup.loopexit.unr-lcssa:
; NEWPM-NEXT:    [[ADD_LCSSA_PH:%.*]] = phi i64 [ undef, [[FOR_BODY_LR_PH]] ], [ [[ADD_7:%.*]], [[FOR_BODY]] ]
; NEWPM-NEXT:    [[K_05_UNR:%.*]] = phi i64 [ 1, [[FOR_BODY_LR_PH]] ], [ [[AND_PHI:%.*]], [[FOR_BODY]] ]
; NEWPM-NEXT:    [[LCMP_MOD:%.*]] = icmp eq i64 [[XTRAITER]], 0
; NEWPM-NEXT:    br i1 [[LCMP_MOD]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY_EPIL:%.*]]
; NEWPM:       for.body.epil:
; NEWPM-NEXT:    [[G_06_EPIL:%.*]] = phi i64 [ [[ADD_EPIL:%.*]], [[FOR_BODY_EPIL]] ], [ [[ADD_LCSSA_PH]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]] ]
; NEWPM-NEXT:    [[K_05_EPIL:%.*]] = phi i64 [ [[AND_EPIL:%.*]], [[FOR_BODY_EPIL]] ], [ [[K_05_UNR]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]] ]
; NEWPM-NEXT:    [[EPIL_ITER:%.*]] = phi i64 [ [[EPIL_ITER_SUB:%.*]], [[FOR_BODY_EPIL]] ], [ [[XTRAITER]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]] ]
; NEWPM-NEXT:    [[AND_EPIL]] = and i64 [[CONV]], [[K_05_EPIL]]
; NEWPM-NEXT:    [[ADD_EPIL]] = add i64 [[AND_EPIL]], [[G_06_EPIL]]
; NEWPM-NEXT:    [[EPIL_ITER_SUB]] = add i64 [[EPIL_ITER]], -1
; NEWPM-NEXT:    [[EPIL_ITER_CMP:%.*]] = icmp eq i64 [[EPIL_ITER_SUB]], 0
; NEWPM-NEXT:    br i1 [[EPIL_ITER_CMP]], label [[FOR_COND_CLEANUP]], label [[FOR_BODY_EPIL]], !llvm.loop !0
; NEWPM:       for.cond.cleanup:
; NEWPM-NEXT:    [[G_0_LCSSA:%.*]] = phi i64 [ undef, [[ENTRY:%.*]] ], [ [[ADD_LCSSA_PH]], [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]] ], [ [[ADD_EPIL]], [[FOR_BODY_EPIL]] ]
; NEWPM-NEXT:    ret i64 [[G_0_LCSSA]]
; NEWPM:       for.body:
; NEWPM-NEXT:    [[G_06:%.*]] = phi i64 [ undef, [[FOR_BODY_LR_PH_NEW]] ], [ [[ADD_7]], [[FOR_BODY_FOR_BODY_CRIT_EDGE:%.*]] ]
; NEWPM-NEXT:    [[AND_PHI]] = phi i64 [ [[AND_0]], [[FOR_BODY_LR_PH_NEW]] ], [ [[AND_1:%.*]], [[FOR_BODY_FOR_BODY_CRIT_EDGE]] ]
; NEWPM-NEXT:    [[NITER:%.*]] = phi i64 [ [[UNROLL_ITER]], [[FOR_BODY_LR_PH_NEW]] ], [ [[NITER_NSUB_7:%.*]], [[FOR_BODY_FOR_BODY_CRIT_EDGE]] ]
; NEWPM-NEXT:    [[REASS_ADD:%.*]] = shl nuw nsw i64 [[AND_PHI]], 1
; NEWPM-NEXT:    [[ADD_1:%.*]] = add i64 [[G_06]], [[REASS_ADD]]
; NEWPM-NEXT:    [[REASS_ADD9:%.*]] = shl nuw nsw i64 [[AND_PHI]], 1
; NEWPM-NEXT:    [[ADD_3:%.*]] = add i64 [[ADD_1]], [[REASS_ADD9]]
; NEWPM-NEXT:    [[REASS_ADD10:%.*]] = shl nuw nsw i64 [[AND_PHI]], 1
; NEWPM-NEXT:    [[ADD_5:%.*]] = add i64 [[ADD_3]], [[REASS_ADD10]]
; NEWPM-NEXT:    [[REASS_ADD11:%.*]] = shl nuw nsw i64 [[AND_PHI]], 1
; NEWPM-NEXT:    [[ADD_7]] = add i64 [[ADD_5]], [[REASS_ADD11]]
; NEWPM-NEXT:    [[NITER_NSUB_7]] = add i64 [[NITER]], -8
; NEWPM-NEXT:    [[NITER_NCMP_7:%.*]] = icmp eq i64 [[NITER_NSUB_7]], 0
; NEWPM-NEXT:    br i1 [[NITER_NCMP_7]], label [[FOR_COND_CLEANUP_LOOPEXIT_UNR_LCSSA]], label [[FOR_BODY_FOR_BODY_CRIT_EDGE]]
; NEWPM:       for.body.for.body_crit_edge:
; NEWPM-NEXT:    [[AND_1]] = and i64 [[CONV]], [[AND_PHI]]
; NEWPM-NEXT:    br label [[FOR_BODY]]
;
entry:
  %blah.addr = alloca i64, align 8
  %limit.addr = alloca i64, align 8
  %k = alloca i32, align 4
  %g = alloca i64, align 8
  %i = alloca i64, align 8
  store i64 %blah, i64* %blah.addr, align 8
  store i64 %limit, i64* %limit.addr, align 8
  store i32 1, i32* %k, align 4
  store i64 0, i64* %i, align 8
  br label %for.cond

for.cond:
  %0 = load i64, i64* %i, align 8
  %1 = load i64, i64* %limit.addr, align 8
  %cmp = icmp ult i64 %0, %1
  br i1 %cmp, label %for.body, label %for.cond.cleanup

for.cond.cleanup:
  %2 = load i64, i64* %g, align 8
  ret i64 %2

for.body:
  %3 = load i64, i64* %blah.addr, align 8
  %4 = load i32, i32* %k, align 4
  %conv = zext i32 %4 to i64
  %and = and i64 %conv, %3
  %conv1 = trunc i64 %and to i32
  store i32 %conv1, i32* %k, align 4
  %5 = load i32, i32* %k, align 4
  %conv2 = zext i32 %5 to i64
  %6 = load i64, i64* %g, align 8
  %add = add i64 %6, %conv2
  store i64 %add, i64* %g, align 8
  %7 = load i64, i64* %i, align 8
  %inc = add i64 %7, 1
  store i64 %inc, i64* %i, align 8
  br label %for.cond
}

attributes #0 = { "use-soft-float"="false" }
