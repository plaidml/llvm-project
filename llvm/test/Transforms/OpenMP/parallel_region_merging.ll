; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --include-generated-funcs
; RUN: opt -S -attributor -openmpopt -openmp-opt-enable-merging  < %s -enable-new-pm=0 | FileCheck %s
; RUN: opt -S -passes='attributor,cgscc(openmpopt)' -openmp-opt-enable-merging < %s | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @0, i32 0, i32 0) }, align 8

;   void merge_all() {
;       int a = 1;
;   #pragma omp parallel
;       {
;           a = 2;
;       }
;   #pragma omp parallel
;       {
;           a = 3;
;       }
;   }
;
; Merge all parallel regions.
define dso_local void @merge_all() local_unnamed_addr  {
  %1 = alloca i32, align 4
  %2 = bitcast i32* %1 to i8*
  store i32 1, i32* %1, align 4
  %3 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @1, i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_all..omp_par to void (i32*, i32*, ...)*), i32* nonnull %1)
  %4 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @1, i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_all..omp_par.1 to void (i32*, i32*, ...)*), i32* nonnull %1)
  ret void
}

define internal void @merge_all..omp_par.1(i32* noalias nocapture readnone %0, i32* noalias nocapture readnone %1, i32* nocapture %2)  {
  store i32 3, i32* %2, align 4
  ret void
}

define internal void @merge_all..omp_par(i32* noalias nocapture readnone %0, i32* noalias nocapture readnone %1, i32* nocapture %2)  {
  store i32 2, i32* %2, align 4
  ret void
}


declare i32 @__kmpc_global_thread_num(%struct.ident_t*) local_unnamed_addr

declare !callback !1 void @__kmpc_fork_call(%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) local_unnamed_addr

;   void merge_none() {
;       int a = 1;
;   #pragma omp parallel
;       {
;           a = 2;
;       }
;       a = 3;
;   #pragma omp parallel
;       {
;           a = 4;
;       }
;   }
;
; Does not merge parallel regions, in-between store
; instruction is unsafe to execute in parallel.
define dso_local void @merge_none() local_unnamed_addr  {
  %1 = alloca i32, align 4
  %2 = bitcast i32* %1 to i8*
  store i32 1, i32* %1, align 4
  %3 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @1, i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_none..omp_par to void (i32*, i32*, ...)*), i32* nonnull %1)
  store i32 3, i32* %1, align 4
  %4 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @1, i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_none..omp_par.2 to void (i32*, i32*, ...)*), i32* nonnull %1)
  ret void
}

define internal void @merge_none..omp_par.2(i32* noalias nocapture readnone %0, i32* noalias nocapture readnone %1, i32* nocapture %2)  {
  store i32 4, i32* %2, align 4
  ret void
}

define internal void @merge_none..omp_par(i32* noalias nocapture readnone %0, i32* noalias nocapture readnone %1, i32* nocapture %2)  {
  store i32 2, i32* %2, align 4
  ret void
}

;   void merge_some() {
;       int a = 1;
;   #pragma omp parallel
;       {
;           a = 2;
;       }
;       a = 3;
;   #pragma omp parallel
;       {
;           a = 4;
;       }
;   #pragma omp parallel
;       {
;           a = 5;
;       }
;   }
;
; Do not merge first parallel region, due to the
; unsafe store, but merge the two next parallel
; regions.
define dso_local void @merge_some() local_unnamed_addr  {
  %1 = alloca i32, align 4
  %2 = bitcast i32* %1 to i8*
  store i32 1, i32* %1, align 4
  %3 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @1, i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_some..omp_par to void (i32*, i32*, ...)*), i32* nonnull %1)
  store i32 3, i32* %1, align 4
  %4 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @1, i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_some..omp_par.3 to void (i32*, i32*, ...)*), i32* nonnull %1)
  %5 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @1, i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_some..omp_par.4 to void (i32*, i32*, ...)*), i32* nonnull %1)
  ret void
}

define internal void @merge_some..omp_par.4(i32* noalias nocapture readnone %0, i32* noalias nocapture readnone %1, i32* nocapture %2)  {
  store i32 5, i32* %2, align 4
  ret void
}

define internal void @merge_some..omp_par.3(i32* noalias nocapture readnone %0, i32* noalias nocapture readnone %1, i32* nocapture %2)  {
  store i32 4, i32* %2, align 4
  ret void
}

define internal void @merge_some..omp_par(i32* noalias nocapture readnone %0, i32* noalias nocapture readnone %1, i32* nocapture %2)  {
  store i32 2, i32* %2, align 4
  ret void
}

;   void merge_cancellable_regions(int cancel1, int cancel2)
;   {
;   #pragma omp parallel
;       {
;           if(cancel1) {
;   #pragma omp cancel parallel
;           }
;       }
;   #pragma omp parallel
;       {
;           if (cancel2) {
;   #pragma omp cancel parallel
;           }
;       }
;   }
;
; Merge correctly cancellable regions.
define dso_local void @merge_cancellable_regions(i32 %0, i32 %1) local_unnamed_addr  {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %5 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @1, i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_cancellable_regions..omp_par to void (i32*, i32*, ...)*), i32* nonnull %3)
  %6 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @1, i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_cancellable_regions..omp_par.5 to void (i32*, i32*, ...)*), i32* nonnull %4)
  ret void
}

define internal void @merge_cancellable_regions..omp_par.5(i32* noalias nocapture readnone %0, i32* noalias nocapture readnone %1, i32* nocapture readonly %2)  {
  %4 = load i32, i32* %2, align 4
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  ret void

7:                                                ; preds = %3
  %8 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  %9 = call i32 @__kmpc_cancel(%struct.ident_t* nonnull @1, i32 %8, i32 1)
  ret void
}

define internal void @merge_cancellable_regions..omp_par(i32* noalias nocapture readnone %0, i32* noalias nocapture readnone %1, i32* nocapture readonly %2)  {
  %4 = load i32, i32* %2, align 4
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %6, label %7

6:                                                ; preds = %3
  ret void

7:                                                ; preds = %3
  %8 = call i32 @__kmpc_global_thread_num(%struct.ident_t* nonnull @1)
  %9 = call i32 @__kmpc_cancel(%struct.ident_t* nonnull @1, i32 %8, i32 1)
  ret void
}

declare i32 @__kmpc_cancel(%struct.ident_t*, i32, i32) local_unnamed_addr


!llvm.module.flags = !{!0}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!2}
!2 = !{i64 2, i64 -1, i64 -1, i1 true}
; CHECK-LABEL: define {{[^@]+}}@merge_all() local_unnamed_addr {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) [[GLOB1:@.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 1, i32* [[TMP2]], align 4
; CHECK-NEXT:    [[OMP_GLOBAL_THREAD_NUM:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* [[GLOB1]])
; CHECK-NEXT:    br label [[OMP_PARALLEL:%.*]]
; CHECK:       omp_parallel:
; CHECK-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* [[GLOB1]], i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_all..omp_par.2 to void (i32*, i32*, ...)*), i32* [[TMP2]])
; CHECK-NEXT:    br label [[OMP_PAR_OUTLINED_EXIT:%.*]]
; CHECK:       omp.par.outlined.exit:
; CHECK-NEXT:    br label [[OMP_PAR_EXIT_SPLIT:%.*]]
; CHECK:       omp.par.exit.split:
; CHECK-NEXT:    br label [[DOTSPLIT_SPLIT:%.*]]
; CHECK:       .split.split:
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_all..omp_par.2
; CHECK-SAME: (i32* noalias [[TID_ADDR:%.*]], i32* noalias [[ZERO_ADDR:%.*]], i32* [[TMP0:%.*]]) [[ATTR0:#.*]] {
; CHECK-NEXT:  omp.par.entry:
; CHECK-NEXT:    [[TID_ADDR_LOCAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TID_ADDR]], align 4
; CHECK-NEXT:    store i32 [[TMP1]], i32* [[TID_ADDR_LOCAL]], align 4
; CHECK-NEXT:    [[TID:%.*]] = load i32, i32* [[TID_ADDR_LOCAL]], align 4
; CHECK-NEXT:    br label [[OMP_PAR_REGION:%.*]]
; CHECK:       omp.par.outlined.exit.exitStub:
; CHECK-NEXT:    ret void
; CHECK:       omp.par.region:
; CHECK-NEXT:    br label [[OMP_PAR_MERGED:%.*]]
; CHECK:       omp.par.merged:
; CHECK-NEXT:    call void @merge_all..omp_par(i32* [[TID_ADDR]], i32* [[ZERO_ADDR]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP0]])
; CHECK-NEXT:    [[OMP_GLOBAL_THREAD_NUM:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* [[GLOB1]])
; CHECK-NEXT:    call void @__kmpc_barrier(%struct.ident_t* [[GLOB2:@.*]], i32 [[OMP_GLOBAL_THREAD_NUM]])
; CHECK-NEXT:    call void @merge_all..omp_par.1(i32* [[TID_ADDR]], i32* [[ZERO_ADDR]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP0]])
; CHECK-NEXT:    br label [[DOTSPLIT:%.*]]
; CHECK:       .split:
; CHECK-NEXT:    br label [[OMP_PAR_REGION_SPLIT:%.*]]
; CHECK:       omp.par.region.split:
; CHECK-NEXT:    br label [[OMP_PAR_PRE_FINALIZE:%.*]]
; CHECK:       omp.par.pre_finalize:
; CHECK-NEXT:    br label [[OMP_PAR_OUTLINED_EXIT_EXITSTUB:%.*]]
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_all..omp_par.1
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[TMP0:%.*]], i32* noalias nocapture nofree readnone [[TMP1:%.*]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP2:%.*]]) [[ATTR1:#.*]] {
; CHECK-NEXT:    store i32 3, i32* [[TMP2]], align 4
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_all..omp_par
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[TMP0:%.*]], i32* noalias nocapture nofree readnone [[TMP1:%.*]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP2:%.*]]) [[ATTR1]] {
; CHECK-NEXT:    store i32 2, i32* [[TMP2]], align 4
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_none() local_unnamed_addr {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) [[GLOB1]])
; CHECK-NEXT:    [[TMP2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 1, i32* [[TMP2]], align 4
; CHECK-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) [[GLOB1]], i32 noundef 1, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*)* @merge_none..omp_par to void (i32*, i32*, ...)*), i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP2]])
; CHECK-NEXT:    store i32 3, i32* [[TMP2]], align 4
; CHECK-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) [[GLOB1]], i32 noundef 1, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*)* @merge_none..omp_par.2 to void (i32*, i32*, ...)*), i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP2]])
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_none..omp_par.2
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[TMP0:%.*]], i32* noalias nocapture nofree readnone [[TMP1:%.*]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP2:%.*]]) [[ATTR1]] {
; CHECK-NEXT:    store i32 4, i32* [[TMP2]], align 4
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_none..omp_par
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[TMP0:%.*]], i32* noalias nocapture nofree readnone [[TMP1:%.*]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP2:%.*]]) [[ATTR1]] {
; CHECK-NEXT:    store i32 2, i32* [[TMP2]], align 4
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_some() local_unnamed_addr {
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) [[GLOB1]])
; CHECK-NEXT:    [[TMP2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 1, i32* [[TMP2]], align 4
; CHECK-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) [[GLOB1]], i32 noundef 1, void (i32*, i32*, ...)* noundef bitcast (void (i32*, i32*, i32*)* @merge_some..omp_par to void (i32*, i32*, ...)*), i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP2]])
; CHECK-NEXT:    store i32 3, i32* [[TMP2]], align 4
; CHECK-NEXT:    [[OMP_GLOBAL_THREAD_NUM:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* [[GLOB1]])
; CHECK-NEXT:    br label [[OMP_PARALLEL:%.*]]
; CHECK:       omp_parallel:
; CHECK-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* [[GLOB1]], i32 1, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*)* @merge_some..omp_par.5 to void (i32*, i32*, ...)*), i32* [[TMP2]])
; CHECK-NEXT:    br label [[OMP_PAR_OUTLINED_EXIT:%.*]]
; CHECK:       omp.par.outlined.exit:
; CHECK-NEXT:    br label [[OMP_PAR_EXIT_SPLIT:%.*]]
; CHECK:       omp.par.exit.split:
; CHECK-NEXT:    br label [[DOTSPLIT_SPLIT:%.*]]
; CHECK:       .split.split:
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_some..omp_par.5
; CHECK-SAME: (i32* noalias [[TID_ADDR:%.*]], i32* noalias [[ZERO_ADDR:%.*]], i32* [[TMP0:%.*]]) [[ATTR0]] {
; CHECK-NEXT:  omp.par.entry:
; CHECK-NEXT:    [[TID_ADDR_LOCAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[TID_ADDR]], align 4
; CHECK-NEXT:    store i32 [[TMP1]], i32* [[TID_ADDR_LOCAL]], align 4
; CHECK-NEXT:    [[TID:%.*]] = load i32, i32* [[TID_ADDR_LOCAL]], align 4
; CHECK-NEXT:    br label [[OMP_PAR_REGION:%.*]]
; CHECK:       omp.par.outlined.exit.exitStub:
; CHECK-NEXT:    ret void
; CHECK:       omp.par.region:
; CHECK-NEXT:    br label [[OMP_PAR_MERGED:%.*]]
; CHECK:       omp.par.merged:
; CHECK-NEXT:    call void @merge_some..omp_par.3(i32* [[TID_ADDR]], i32* [[ZERO_ADDR]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP0]])
; CHECK-NEXT:    [[OMP_GLOBAL_THREAD_NUM:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* [[GLOB1]])
; CHECK-NEXT:    call void @__kmpc_barrier(%struct.ident_t* [[GLOB2]], i32 [[OMP_GLOBAL_THREAD_NUM]])
; CHECK-NEXT:    call void @merge_some..omp_par.4(i32* [[TID_ADDR]], i32* [[ZERO_ADDR]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP0]])
; CHECK-NEXT:    br label [[DOTSPLIT:%.*]]
; CHECK:       .split:
; CHECK-NEXT:    br label [[OMP_PAR_REGION_SPLIT:%.*]]
; CHECK:       omp.par.region.split:
; CHECK-NEXT:    br label [[OMP_PAR_PRE_FINALIZE:%.*]]
; CHECK:       omp.par.pre_finalize:
; CHECK-NEXT:    br label [[OMP_PAR_OUTLINED_EXIT_EXITSTUB:%.*]]
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_some..omp_par.4
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[TMP0:%.*]], i32* noalias nocapture nofree readnone [[TMP1:%.*]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP2:%.*]]) [[ATTR1]] {
; CHECK-NEXT:    store i32 5, i32* [[TMP2]], align 4
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_some..omp_par.3
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[TMP0:%.*]], i32* noalias nocapture nofree readnone [[TMP1:%.*]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP2:%.*]]) [[ATTR1]] {
; CHECK-NEXT:    store i32 4, i32* [[TMP2]], align 4
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_some..omp_par
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[TMP0:%.*]], i32* noalias nocapture nofree readnone [[TMP1:%.*]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[TMP2:%.*]]) [[ATTR1]] {
; CHECK-NEXT:    store i32 2, i32* [[TMP2]], align 4
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_cancellable_regions
; CHECK-SAME: (i32 [[TMP0:%.*]], i32 [[TMP1:%.*]]) local_unnamed_addr {
; CHECK-NEXT:    [[TMP3:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* noundef nonnull align 8 dereferenceable(24) [[GLOB1]])
; CHECK-NEXT:    [[TMP4:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[TMP5:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 [[TMP0]], i32* [[TMP4]], align 4
; CHECK-NEXT:    store i32 [[TMP1]], i32* [[TMP5]], align 4
; CHECK-NEXT:    [[OMP_GLOBAL_THREAD_NUM:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* [[GLOB1]])
; CHECK-NEXT:    br label [[OMP_PARALLEL:%.*]]
; CHECK:       omp_parallel:
; CHECK-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* [[GLOB1]], i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, i32*, i32*)* @merge_cancellable_regions..omp_par.6 to void (i32*, i32*, ...)*), i32* [[TMP4]], i32* [[TMP5]])
; CHECK-NEXT:    br label [[OMP_PAR_OUTLINED_EXIT:%.*]]
; CHECK:       omp.par.outlined.exit:
; CHECK-NEXT:    br label [[OMP_PAR_EXIT_SPLIT:%.*]]
; CHECK:       omp.par.exit.split:
; CHECK-NEXT:    br label [[DOTSPLIT_SPLIT:%.*]]
; CHECK:       .split.split:
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_cancellable_regions..omp_par.6
; CHECK-SAME: (i32* noalias [[TID_ADDR:%.*]], i32* noalias [[ZERO_ADDR:%.*]], i32* [[TMP0:%.*]], i32* [[TMP1:%.*]]) [[ATTR0]] {
; CHECK-NEXT:  omp.par.entry:
; CHECK-NEXT:    [[TID_ADDR_LOCAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TID_ADDR]], align 4
; CHECK-NEXT:    store i32 [[TMP2]], i32* [[TID_ADDR_LOCAL]], align 4
; CHECK-NEXT:    [[TID:%.*]] = load i32, i32* [[TID_ADDR_LOCAL]], align 4
; CHECK-NEXT:    br label [[OMP_PAR_REGION:%.*]]
; CHECK:       omp.par.outlined.exit.exitStub:
; CHECK-NEXT:    ret void
; CHECK:       omp.par.region:
; CHECK-NEXT:    br label [[OMP_PAR_MERGED:%.*]]
; CHECK:       omp.par.merged:
; CHECK-NEXT:    call void @merge_cancellable_regions..omp_par(i32* [[TID_ADDR]], i32* [[ZERO_ADDR]], i32* nocapture noundef nonnull readonly align 4 dereferenceable(4) [[TMP0]])
; CHECK-NEXT:    [[OMP_GLOBAL_THREAD_NUM:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* [[GLOB1]])
; CHECK-NEXT:    call void @__kmpc_barrier(%struct.ident_t* [[GLOB2]], i32 [[OMP_GLOBAL_THREAD_NUM]])
; CHECK-NEXT:    call void @merge_cancellable_regions..omp_par.5(i32* [[TID_ADDR]], i32* [[ZERO_ADDR]], i32* nocapture noundef nonnull readonly align 4 dereferenceable(4) [[TMP1]])
; CHECK-NEXT:    br label [[DOTSPLIT:%.*]]
; CHECK:       .split:
; CHECK-NEXT:    br label [[OMP_PAR_REGION_SPLIT:%.*]]
; CHECK:       omp.par.region.split:
; CHECK-NEXT:    br label [[OMP_PAR_PRE_FINALIZE:%.*]]
; CHECK:       omp.par.pre_finalize:
; CHECK-NEXT:    br label [[OMP_PAR_OUTLINED_EXIT_EXITSTUB:%.*]]
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_cancellable_regions..omp_par.5
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[TMP0:%.*]], i32* noalias nocapture nofree readnone [[TMP1:%.*]], i32* nocapture noundef nonnull readonly align 4 dereferenceable(4) [[TMP2:%.*]]) {
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i32 [[TMP4]], 0
; CHECK-NEXT:    br i1 [[TMP5]], label [[TMP6:%.*]], label [[TMP7:%.*]]
; CHECK:       6:
; CHECK-NEXT:    ret void
; CHECK:       7:
; CHECK-NEXT:    [[TMP8:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* noundef nonnull [[GLOB1]])
; CHECK-NEXT:    [[TMP9:%.*]] = call i32 @__kmpc_cancel(%struct.ident_t* noundef nonnull [[GLOB1]], i32 [[TMP8]], i32 noundef 1)
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@merge_cancellable_regions..omp_par
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[TMP0:%.*]], i32* noalias nocapture nofree readnone [[TMP1:%.*]], i32* nocapture noundef nonnull readonly align 4 dereferenceable(4) [[TMP2:%.*]]) {
; CHECK-NEXT:    [[TMP4:%.*]] = load i32, i32* [[TMP2]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i32 [[TMP4]], 0
; CHECK-NEXT:    br i1 [[TMP5]], label [[TMP6:%.*]], label [[TMP7:%.*]]
; CHECK:       6:
; CHECK-NEXT:    ret void
; CHECK:       7:
; CHECK-NEXT:    [[TMP8:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* noundef nonnull [[GLOB1]])
; CHECK-NEXT:    [[TMP9:%.*]] = call i32 @__kmpc_cancel(%struct.ident_t* noundef nonnull [[GLOB1]], i32 [[TMP8]], i32 noundef 1)
; CHECK-NEXT:    ret void
;
