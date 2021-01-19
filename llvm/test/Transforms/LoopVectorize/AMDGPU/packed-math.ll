; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s  -loop-vectorize -dce -instcombine -S | FileCheck -check-prefix=GFX9 %s
; RUN: opt -mtriple=amdgcn-amd-amdhsa -mcpu=fiji < %s  -loop-vectorize -dce -instcombine -S | FileCheck -check-prefix=VI %s
; RUN: opt -mtriple=amdgcn-amd-amdhsa -mcpu=hawaii < %s  -loop-vectorize -dce -instcombine -S | FileCheck -check-prefix=CI %s

define half @vectorize_v2f16_loop(half addrspace(1)* noalias %s) {
; GFX9-LABEL: @vectorize_v2f16_loop(
; GFX9-NEXT:  entry:
; GFX9-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; GFX9:       vector.ph:
; GFX9-NEXT:    br label [[VECTOR_BODY:%.*]]
; GFX9:       vector.body:
; GFX9-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; GFX9-NEXT:    [[VEC_PHI:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP16:%.*]], [[VECTOR_BODY]] ]
; GFX9-NEXT:    [[VEC_PHI1:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP17:%.*]], [[VECTOR_BODY]] ]
; GFX9-NEXT:    [[VEC_PHI2:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP18:%.*]], [[VECTOR_BODY]] ]
; GFX9-NEXT:    [[VEC_PHI3:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP19:%.*]], [[VECTOR_BODY]] ]
; GFX9-NEXT:    [[VEC_PHI4:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP20:%.*]], [[VECTOR_BODY]] ]
; GFX9-NEXT:    [[VEC_PHI5:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP21:%.*]], [[VECTOR_BODY]] ]
; GFX9-NEXT:    [[VEC_PHI6:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP22:%.*]], [[VECTOR_BODY]] ]
; GFX9-NEXT:    [[VEC_PHI7:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP23:%.*]], [[VECTOR_BODY]] ]
; GFX9-NEXT:    [[TMP0:%.*]] = getelementptr inbounds half, half addrspace(1)* [[S:%.*]], i64 [[INDEX]]
; GFX9-NEXT:    [[TMP1:%.*]] = bitcast half addrspace(1)* [[TMP0]] to <2 x half> addrspace(1)*
; GFX9-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP1]], align 2
; GFX9-NEXT:    [[TMP2:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 2
; GFX9-NEXT:    [[TMP3:%.*]] = bitcast half addrspace(1)* [[TMP2]] to <2 x half> addrspace(1)*
; GFX9-NEXT:    [[WIDE_LOAD8:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP3]], align 2
; GFX9-NEXT:    [[TMP4:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 4
; GFX9-NEXT:    [[TMP5:%.*]] = bitcast half addrspace(1)* [[TMP4]] to <2 x half> addrspace(1)*
; GFX9-NEXT:    [[WIDE_LOAD9:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP5]], align 2
; GFX9-NEXT:    [[TMP6:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 6
; GFX9-NEXT:    [[TMP7:%.*]] = bitcast half addrspace(1)* [[TMP6]] to <2 x half> addrspace(1)*
; GFX9-NEXT:    [[WIDE_LOAD10:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP7]], align 2
; GFX9-NEXT:    [[TMP8:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 8
; GFX9-NEXT:    [[TMP9:%.*]] = bitcast half addrspace(1)* [[TMP8]] to <2 x half> addrspace(1)*
; GFX9-NEXT:    [[WIDE_LOAD11:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP9]], align 2
; GFX9-NEXT:    [[TMP10:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 10
; GFX9-NEXT:    [[TMP11:%.*]] = bitcast half addrspace(1)* [[TMP10]] to <2 x half> addrspace(1)*
; GFX9-NEXT:    [[WIDE_LOAD12:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP11]], align 2
; GFX9-NEXT:    [[TMP12:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 12
; GFX9-NEXT:    [[TMP13:%.*]] = bitcast half addrspace(1)* [[TMP12]] to <2 x half> addrspace(1)*
; GFX9-NEXT:    [[WIDE_LOAD13:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP13]], align 2
; GFX9-NEXT:    [[TMP14:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 14
; GFX9-NEXT:    [[TMP15:%.*]] = bitcast half addrspace(1)* [[TMP14]] to <2 x half> addrspace(1)*
; GFX9-NEXT:    [[WIDE_LOAD14:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP15]], align 2
; GFX9-NEXT:    [[TMP16]] = fadd fast <2 x half> [[VEC_PHI]], [[WIDE_LOAD]]
; GFX9-NEXT:    [[TMP17]] = fadd fast <2 x half> [[VEC_PHI1]], [[WIDE_LOAD8]]
; GFX9-NEXT:    [[TMP18]] = fadd fast <2 x half> [[VEC_PHI2]], [[WIDE_LOAD9]]
; GFX9-NEXT:    [[TMP19]] = fadd fast <2 x half> [[VEC_PHI3]], [[WIDE_LOAD10]]
; GFX9-NEXT:    [[TMP20]] = fadd fast <2 x half> [[VEC_PHI4]], [[WIDE_LOAD11]]
; GFX9-NEXT:    [[TMP21]] = fadd fast <2 x half> [[VEC_PHI5]], [[WIDE_LOAD12]]
; GFX9-NEXT:    [[TMP22]] = fadd fast <2 x half> [[VEC_PHI6]], [[WIDE_LOAD13]]
; GFX9-NEXT:    [[TMP23]] = fadd fast <2 x half> [[VEC_PHI7]], [[WIDE_LOAD14]]
; GFX9-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 16
; GFX9-NEXT:    [[TMP24:%.*]] = icmp eq i64 [[INDEX_NEXT]], 256
; GFX9-NEXT:    br i1 [[TMP24]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; GFX9:       middle.block:
; GFX9-NEXT:    [[BIN_RDX:%.*]] = fadd fast <2 x half> [[TMP17]], [[TMP16]]
; GFX9-NEXT:    [[BIN_RDX15:%.*]] = fadd fast <2 x half> [[TMP18]], [[BIN_RDX]]
; GFX9-NEXT:    [[BIN_RDX16:%.*]] = fadd fast <2 x half> [[TMP19]], [[BIN_RDX15]]
; GFX9-NEXT:    [[BIN_RDX17:%.*]] = fadd fast <2 x half> [[TMP20]], [[BIN_RDX16]]
; GFX9-NEXT:    [[BIN_RDX18:%.*]] = fadd fast <2 x half> [[TMP21]], [[BIN_RDX17]]
; GFX9-NEXT:    [[BIN_RDX19:%.*]] = fadd fast <2 x half> [[TMP22]], [[BIN_RDX18]]
; GFX9-NEXT:    [[BIN_RDX20:%.*]] = fadd fast <2 x half> [[TMP23]], [[BIN_RDX19]]
; GFX9-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <2 x half> [[BIN_RDX20]], <2 x half> poison, <2 x i32> <i32 1, i32 undef>
; GFX9-NEXT:    [[BIN_RDX21:%.*]] = fadd fast <2 x half> [[BIN_RDX20]], [[RDX_SHUF]]
; GFX9-NEXT:    [[TMP25:%.*]] = extractelement <2 x half> [[BIN_RDX21]], i32 0
; GFX9-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; GFX9:       scalar.ph:
; GFX9-NEXT:    br label [[FOR_BODY:%.*]]
; GFX9:       for.body:
; GFX9-NEXT:    br i1 undef, label [[FOR_END]], label [[FOR_BODY]], [[LOOP2:!llvm.loop !.*]]
; GFX9:       for.end:
; GFX9-NEXT:    [[ADD_LCSSA:%.*]] = phi half [ undef, [[FOR_BODY]] ], [ [[TMP25]], [[MIDDLE_BLOCK]] ]
; GFX9-NEXT:    ret half [[ADD_LCSSA]]
;
; VI-LABEL: @vectorize_v2f16_loop(
; VI-NEXT:  entry:
; VI-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; VI:       vector.ph:
; VI-NEXT:    br label [[VECTOR_BODY:%.*]]
; VI:       vector.body:
; VI-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; VI-NEXT:    [[VEC_PHI:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP16:%.*]], [[VECTOR_BODY]] ]
; VI-NEXT:    [[VEC_PHI1:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP17:%.*]], [[VECTOR_BODY]] ]
; VI-NEXT:    [[VEC_PHI2:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP18:%.*]], [[VECTOR_BODY]] ]
; VI-NEXT:    [[VEC_PHI3:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP19:%.*]], [[VECTOR_BODY]] ]
; VI-NEXT:    [[VEC_PHI4:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP20:%.*]], [[VECTOR_BODY]] ]
; VI-NEXT:    [[VEC_PHI5:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP21:%.*]], [[VECTOR_BODY]] ]
; VI-NEXT:    [[VEC_PHI6:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP22:%.*]], [[VECTOR_BODY]] ]
; VI-NEXT:    [[VEC_PHI7:%.*]] = phi <2 x half> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP23:%.*]], [[VECTOR_BODY]] ]
; VI-NEXT:    [[TMP0:%.*]] = getelementptr inbounds half, half addrspace(1)* [[S:%.*]], i64 [[INDEX]]
; VI-NEXT:    [[TMP1:%.*]] = bitcast half addrspace(1)* [[TMP0]] to <2 x half> addrspace(1)*
; VI-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP1]], align 2
; VI-NEXT:    [[TMP2:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 2
; VI-NEXT:    [[TMP3:%.*]] = bitcast half addrspace(1)* [[TMP2]] to <2 x half> addrspace(1)*
; VI-NEXT:    [[WIDE_LOAD8:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP3]], align 2
; VI-NEXT:    [[TMP4:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 4
; VI-NEXT:    [[TMP5:%.*]] = bitcast half addrspace(1)* [[TMP4]] to <2 x half> addrspace(1)*
; VI-NEXT:    [[WIDE_LOAD9:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP5]], align 2
; VI-NEXT:    [[TMP6:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 6
; VI-NEXT:    [[TMP7:%.*]] = bitcast half addrspace(1)* [[TMP6]] to <2 x half> addrspace(1)*
; VI-NEXT:    [[WIDE_LOAD10:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP7]], align 2
; VI-NEXT:    [[TMP8:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 8
; VI-NEXT:    [[TMP9:%.*]] = bitcast half addrspace(1)* [[TMP8]] to <2 x half> addrspace(1)*
; VI-NEXT:    [[WIDE_LOAD11:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP9]], align 2
; VI-NEXT:    [[TMP10:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 10
; VI-NEXT:    [[TMP11:%.*]] = bitcast half addrspace(1)* [[TMP10]] to <2 x half> addrspace(1)*
; VI-NEXT:    [[WIDE_LOAD12:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP11]], align 2
; VI-NEXT:    [[TMP12:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 12
; VI-NEXT:    [[TMP13:%.*]] = bitcast half addrspace(1)* [[TMP12]] to <2 x half> addrspace(1)*
; VI-NEXT:    [[WIDE_LOAD13:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP13]], align 2
; VI-NEXT:    [[TMP14:%.*]] = getelementptr inbounds half, half addrspace(1)* [[TMP0]], i64 14
; VI-NEXT:    [[TMP15:%.*]] = bitcast half addrspace(1)* [[TMP14]] to <2 x half> addrspace(1)*
; VI-NEXT:    [[WIDE_LOAD14:%.*]] = load <2 x half>, <2 x half> addrspace(1)* [[TMP15]], align 2
; VI-NEXT:    [[TMP16]] = fadd fast <2 x half> [[VEC_PHI]], [[WIDE_LOAD]]
; VI-NEXT:    [[TMP17]] = fadd fast <2 x half> [[VEC_PHI1]], [[WIDE_LOAD8]]
; VI-NEXT:    [[TMP18]] = fadd fast <2 x half> [[VEC_PHI2]], [[WIDE_LOAD9]]
; VI-NEXT:    [[TMP19]] = fadd fast <2 x half> [[VEC_PHI3]], [[WIDE_LOAD10]]
; VI-NEXT:    [[TMP20]] = fadd fast <2 x half> [[VEC_PHI4]], [[WIDE_LOAD11]]
; VI-NEXT:    [[TMP21]] = fadd fast <2 x half> [[VEC_PHI5]], [[WIDE_LOAD12]]
; VI-NEXT:    [[TMP22]] = fadd fast <2 x half> [[VEC_PHI6]], [[WIDE_LOAD13]]
; VI-NEXT:    [[TMP23]] = fadd fast <2 x half> [[VEC_PHI7]], [[WIDE_LOAD14]]
; VI-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 16
; VI-NEXT:    [[TMP24:%.*]] = icmp eq i64 [[INDEX_NEXT]], 256
; VI-NEXT:    br i1 [[TMP24]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; VI:       middle.block:
; VI-NEXT:    [[BIN_RDX:%.*]] = fadd fast <2 x half> [[TMP17]], [[TMP16]]
; VI-NEXT:    [[BIN_RDX15:%.*]] = fadd fast <2 x half> [[TMP18]], [[BIN_RDX]]
; VI-NEXT:    [[BIN_RDX16:%.*]] = fadd fast <2 x half> [[TMP19]], [[BIN_RDX15]]
; VI-NEXT:    [[BIN_RDX17:%.*]] = fadd fast <2 x half> [[TMP20]], [[BIN_RDX16]]
; VI-NEXT:    [[BIN_RDX18:%.*]] = fadd fast <2 x half> [[TMP21]], [[BIN_RDX17]]
; VI-NEXT:    [[BIN_RDX19:%.*]] = fadd fast <2 x half> [[TMP22]], [[BIN_RDX18]]
; VI-NEXT:    [[BIN_RDX20:%.*]] = fadd fast <2 x half> [[TMP23]], [[BIN_RDX19]]
; VI-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <2 x half> [[BIN_RDX20]], <2 x half> poison, <2 x i32> <i32 1, i32 undef>
; VI-NEXT:    [[BIN_RDX21:%.*]] = fadd fast <2 x half> [[BIN_RDX20]], [[RDX_SHUF]]
; VI-NEXT:    [[TMP25:%.*]] = extractelement <2 x half> [[BIN_RDX21]], i32 0
; VI-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; VI:       scalar.ph:
; VI-NEXT:    br label [[FOR_BODY:%.*]]
; VI:       for.body:
; VI-NEXT:    br i1 undef, label [[FOR_END]], label [[FOR_BODY]], [[LOOP2:!llvm.loop !.*]]
; VI:       for.end:
; VI-NEXT:    [[ADD_LCSSA:%.*]] = phi half [ undef, [[FOR_BODY]] ], [ [[TMP25]], [[MIDDLE_BLOCK]] ]
; VI-NEXT:    ret half [[ADD_LCSSA]]
;
; CI-LABEL: @vectorize_v2f16_loop(
; CI-NEXT:  entry:
; CI-NEXT:    br label [[FOR_BODY:%.*]]
; CI:       for.body:
; CI-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CI-NEXT:    [[Q_04:%.*]] = phi half [ 0xH0000, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CI-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds half, half addrspace(1)* [[S:%.*]], i64 [[INDVARS_IV]]
; CI-NEXT:    [[TMP0:%.*]] = load half, half addrspace(1)* [[ARRAYIDX]], align 2
; CI-NEXT:    [[ADD]] = fadd fast half [[Q_04]], [[TMP0]]
; CI-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CI-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 256
; CI-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CI:       for.end:
; CI-NEXT:    ret half [[ADD]]
;
entry:
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %q.04 = phi half [ 0.0, %entry ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds half, half addrspace(1)* %s, i64 %indvars.iv
  %0 = load half, half addrspace(1)* %arrayidx, align 2
  %add = fadd fast half %q.04, %0
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 256
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  %add.lcssa = phi half [ %add, %for.body ]
  ret half %add.lcssa
}
