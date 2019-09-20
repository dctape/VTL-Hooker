; ModuleID = 'trace_prog_kern.c'
source_filename = "trace_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.____btf_map_devmap_xmit_cnt = type { i32, %struct.datarec }
%struct.datarec = type { i64, i64, i64, i64 }
%struct.xdp_redirect_ctx = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_exception_ctx = type { i32, i32, i32 }
%struct.cpumap_enqueue_ctx = type { i32, i32, i32, i32, i32, i32 }
%struct.cpumap_kthread_ctx = type { i32, i32, i32, i32, i32, i32 }
%struct.devmap_xmit_ctx = type { i32, i32, i32, i32, i32, i32, i32, i32 }

@redirect_err_cnt = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 2, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@exception_cnt = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 8, i32 6, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !19
@cpumap_enqueue_cnt = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 32, i32 64, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !31
@cpumap_kthread_cnt = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 32, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !33
@devmap_xmit_cnt = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 32, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !35
@____btf_map_devmap_xmit_cnt = dso_local global %struct.____btf_map_devmap_xmit_cnt zeroinitializer, section ".maps.devmap_xmit_cnt", align 8, !dbg !37
@llvm.used = appending global [14 x i8*] [i8* bitcast (%struct.____btf_map_devmap_xmit_cnt* @____btf_map_devmap_xmit_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @cpumap_enqueue_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @cpumap_kthread_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @devmap_xmit_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @exception_cnt to i8*), i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* bitcast (i32 (%struct.cpumap_enqueue_ctx*)* @trace_xdp_cpumap_enqueue to i8*), i8* bitcast (i32 (%struct.cpumap_kthread_ctx*)* @trace_xdp_cpumap_kthread to i8*), i8* bitcast (i32 (%struct.devmap_xmit_ctx*)* @trace_xdp_devmap_xmit to i8*), i8* bitcast (i32 (%struct.xdp_exception_ctx*)* @trace_xdp_exception to i8*), i8* bitcast (i32 (%struct.xdp_redirect_ctx*)* @trace_xdp_redirect to i8*), i8* bitcast (i32 (%struct.xdp_redirect_ctx*)* @trace_xdp_redirect_err to i8*), i8* bitcast (i32 (%struct.xdp_redirect_ctx*)* @trace_xdp_redirect_map to i8*), i8* bitcast (i32 (%struct.xdp_redirect_ctx*)* @trace_xdp_redirect_map_err to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @trace_xdp_redirect_err(%struct.xdp_redirect_ctx* nocapture readonly) #0 section "raw_tracepoint/xdp/xdp_redirect_err" !dbg !63 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_redirect_ctx* %0, metadata !78, metadata !DIExpression()), !dbg !79
  call void @llvm.dbg.value(metadata %struct.xdp_redirect_ctx* %0, metadata !80, metadata !DIExpression()) #3, !dbg !87
  %3 = bitcast i32* %2 to i8*, !dbg !89
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !89
  call void @llvm.dbg.value(metadata i32 1, metadata !83, metadata !DIExpression()) #3, !dbg !90
  %4 = getelementptr inbounds %struct.xdp_redirect_ctx, %struct.xdp_redirect_ctx* %0, i64 0, i32 3, !dbg !91
  %5 = load i32, i32* %4, align 4, !dbg !91, !tbaa !92
  call void @llvm.dbg.value(metadata i32 %5, metadata !84, metadata !DIExpression()) #3, !dbg !97
  %6 = icmp ne i32 %5, 0, !dbg !98
  %7 = zext i1 %6 to i32, !dbg !100
  store i32 %7, i32* %2, align 4, !dbg !101
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* nonnull %3) #3, !dbg !102
  %9 = bitcast i8* %8 to i64*, !dbg !102
  call void @llvm.dbg.value(metadata i64* %9, metadata !85, metadata !DIExpression()) #3, !dbg !103
  %10 = icmp eq i8* %8, null, !dbg !104
  br i1 %10, label %14, label %11, !dbg !106

; <label>:11:                                     ; preds = %1
  %12 = load i64, i64* %9, align 8, !dbg !107, !tbaa !108
  %13 = add i64 %12, 1, !dbg !107
  store i64 %13, i64* %9, align 8, !dbg !107, !tbaa !108
  br label %14, !dbg !110

; <label>:14:                                     ; preds = %1, %11
  %15 = phi i32 [ 0, %11 ], [ 1, %1 ], !dbg !101
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !111
  ret i32 %15, !dbg !112
}

; Function Attrs: nounwind
define dso_local i32 @trace_xdp_redirect_map_err(%struct.xdp_redirect_ctx* nocapture readonly) #0 section "raw_tracepoint/xdp/xdp_redirect_map_err" !dbg !113 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_redirect_ctx* %0, metadata !115, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata %struct.xdp_redirect_ctx* %0, metadata !80, metadata !DIExpression()) #3, !dbg !117
  %3 = bitcast i32* %2 to i8*, !dbg !119
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !119
  call void @llvm.dbg.value(metadata i32 1, metadata !83, metadata !DIExpression()) #3, !dbg !120
  %4 = getelementptr inbounds %struct.xdp_redirect_ctx, %struct.xdp_redirect_ctx* %0, i64 0, i32 3, !dbg !121
  %5 = load i32, i32* %4, align 4, !dbg !121, !tbaa !92
  call void @llvm.dbg.value(metadata i32 %5, metadata !84, metadata !DIExpression()) #3, !dbg !122
  %6 = icmp ne i32 %5, 0, !dbg !123
  %7 = zext i1 %6 to i32, !dbg !124
  store i32 %7, i32* %2, align 4, !dbg !125
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* nonnull %3) #3, !dbg !126
  %9 = bitcast i8* %8 to i64*, !dbg !126
  call void @llvm.dbg.value(metadata i64* %9, metadata !85, metadata !DIExpression()) #3, !dbg !127
  %10 = icmp eq i8* %8, null, !dbg !128
  br i1 %10, label %14, label %11, !dbg !129

; <label>:11:                                     ; preds = %1
  %12 = load i64, i64* %9, align 8, !dbg !130, !tbaa !108
  %13 = add i64 %12, 1, !dbg !130
  store i64 %13, i64* %9, align 8, !dbg !130, !tbaa !108
  br label %14, !dbg !131

; <label>:14:                                     ; preds = %1, %11
  %15 = phi i32 [ 0, %11 ], [ 1, %1 ], !dbg !125
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !132
  ret i32 %15, !dbg !133
}

; Function Attrs: nounwind
define dso_local i32 @trace_xdp_redirect(%struct.xdp_redirect_ctx* nocapture readonly) #0 section "raw_tracepoint/xdp/xdp_redirect" !dbg !134 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_redirect_ctx* %0, metadata !136, metadata !DIExpression()), !dbg !137
  call void @llvm.dbg.value(metadata %struct.xdp_redirect_ctx* %0, metadata !80, metadata !DIExpression()) #3, !dbg !138
  %3 = bitcast i32* %2 to i8*, !dbg !140
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !140
  call void @llvm.dbg.value(metadata i32 1, metadata !83, metadata !DIExpression()) #3, !dbg !141
  %4 = getelementptr inbounds %struct.xdp_redirect_ctx, %struct.xdp_redirect_ctx* %0, i64 0, i32 3, !dbg !142
  %5 = load i32, i32* %4, align 4, !dbg !142, !tbaa !92
  call void @llvm.dbg.value(metadata i32 %5, metadata !84, metadata !DIExpression()) #3, !dbg !143
  %6 = icmp ne i32 %5, 0, !dbg !144
  %7 = zext i1 %6 to i32, !dbg !145
  store i32 %7, i32* %2, align 4, !dbg !146
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* nonnull %3) #3, !dbg !147
  %9 = bitcast i8* %8 to i64*, !dbg !147
  call void @llvm.dbg.value(metadata i64* %9, metadata !85, metadata !DIExpression()) #3, !dbg !148
  %10 = icmp eq i8* %8, null, !dbg !149
  br i1 %10, label %14, label %11, !dbg !150

; <label>:11:                                     ; preds = %1
  %12 = load i64, i64* %9, align 8, !dbg !151, !tbaa !108
  %13 = add i64 %12, 1, !dbg !151
  store i64 %13, i64* %9, align 8, !dbg !151, !tbaa !108
  br label %14, !dbg !152

; <label>:14:                                     ; preds = %1, %11
  %15 = phi i32 [ 0, %11 ], [ 1, %1 ], !dbg !146
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !153
  ret i32 %15, !dbg !154
}

; Function Attrs: nounwind
define dso_local i32 @trace_xdp_redirect_map(%struct.xdp_redirect_ctx* nocapture readonly) #0 section "raw_tracepoint/xdp/xdp_redirect_map" !dbg !155 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_redirect_ctx* %0, metadata !157, metadata !DIExpression()), !dbg !158
  call void @llvm.dbg.value(metadata %struct.xdp_redirect_ctx* %0, metadata !80, metadata !DIExpression()) #3, !dbg !159
  %3 = bitcast i32* %2 to i8*, !dbg !161
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !161
  call void @llvm.dbg.value(metadata i32 1, metadata !83, metadata !DIExpression()) #3, !dbg !162
  %4 = getelementptr inbounds %struct.xdp_redirect_ctx, %struct.xdp_redirect_ctx* %0, i64 0, i32 3, !dbg !163
  %5 = load i32, i32* %4, align 4, !dbg !163, !tbaa !92
  call void @llvm.dbg.value(metadata i32 %5, metadata !84, metadata !DIExpression()) #3, !dbg !164
  %6 = icmp ne i32 %5, 0, !dbg !165
  %7 = zext i1 %6 to i32, !dbg !166
  store i32 %7, i32* %2, align 4, !dbg !167
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_err_cnt to i8*), i8* nonnull %3) #3, !dbg !168
  %9 = bitcast i8* %8 to i64*, !dbg !168
  call void @llvm.dbg.value(metadata i64* %9, metadata !85, metadata !DIExpression()) #3, !dbg !169
  %10 = icmp eq i8* %8, null, !dbg !170
  br i1 %10, label %14, label %11, !dbg !171

; <label>:11:                                     ; preds = %1
  %12 = load i64, i64* %9, align 8, !dbg !172, !tbaa !108
  %13 = add i64 %12, 1, !dbg !172
  store i64 %13, i64* %9, align 8, !dbg !172, !tbaa !108
  br label %14, !dbg !173

; <label>:14:                                     ; preds = %1, %11
  %15 = phi i32 [ 0, %11 ], [ 1, %1 ], !dbg !167
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !174
  ret i32 %15, !dbg !175
}

; Function Attrs: nounwind
define dso_local i32 @trace_xdp_exception(%struct.xdp_exception_ctx* nocapture readonly) #0 section "raw_tracepoint/xdp/xdp_exception" !dbg !176 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_exception_ctx* %0, metadata !186, metadata !DIExpression()), !dbg !189
  %3 = bitcast i32* %2 to i8*, !dbg !190
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !190
  %4 = getelementptr inbounds %struct.xdp_exception_ctx, %struct.xdp_exception_ctx* %0, i64 0, i32 1, !dbg !191
  %5 = load i32, i32* %4, align 4, !dbg !191, !tbaa !192
  %6 = icmp ult i32 %5, 5, !dbg !194
  %7 = select i1 %6, i32 %5, i32 5, !dbg !196
  call void @llvm.dbg.value(metadata i32 %7, metadata !188, metadata !DIExpression()), !dbg !197
  store i32 %7, i32* %2, align 4, !dbg !198
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @exception_cnt to i8*), i8* nonnull %3) #3, !dbg !199
  %9 = bitcast i8* %8 to i64*, !dbg !199
  call void @llvm.dbg.value(metadata i64* %9, metadata !187, metadata !DIExpression()), !dbg !200
  %10 = icmp eq i8* %8, null, !dbg !201
  br i1 %10, label %14, label %11, !dbg !203

; <label>:11:                                     ; preds = %1
  %12 = load i64, i64* %9, align 8, !dbg !204, !tbaa !108
  %13 = add i64 %12, 1, !dbg !204
  store i64 %13, i64* %9, align 8, !dbg !204, !tbaa !108
  br label %14, !dbg !205

; <label>:14:                                     ; preds = %1, %11
  %15 = phi i32 [ 0, %11 ], [ 1, %1 ], !dbg !198
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !206
  ret i32 %15, !dbg !206
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind
define dso_local i32 @trace_xdp_cpumap_enqueue(%struct.cpumap_enqueue_ctx* nocapture readonly) #0 section "raw_tracepoint/xdp/xdp_cpumap_enqueue" !dbg !207 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.cpumap_enqueue_ctx* %0, metadata !220, metadata !DIExpression()), !dbg !224
  %3 = bitcast i32* %2 to i8*, !dbg !225
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !225
  %4 = getelementptr inbounds %struct.cpumap_enqueue_ctx, %struct.cpumap_enqueue_ctx* %0, i64 0, i32 5, !dbg !226
  %5 = load i32, i32* %4, align 4, !dbg !226, !tbaa !227
  call void @llvm.dbg.value(metadata i32 %5, metadata !221, metadata !DIExpression()), !dbg !229
  store i32 %5, i32* %2, align 4, !dbg !229, !tbaa !230
  %6 = icmp ugt i32 %5, 63, !dbg !231
  br i1 %6, label %30, label %7, !dbg !233

; <label>:7:                                      ; preds = %1
  %8 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpumap_enqueue_cnt to i8*), i8* nonnull %3) #3, !dbg !234
  call void @llvm.dbg.value(metadata i8* %8, metadata !222, metadata !DIExpression()), !dbg !235
  %9 = icmp eq i8* %8, null, !dbg !236
  br i1 %9, label %30, label %10, !dbg !238

; <label>:10:                                     ; preds = %7
  %11 = getelementptr inbounds %struct.cpumap_enqueue_ctx, %struct.cpumap_enqueue_ctx* %0, i64 0, i32 4, !dbg !239
  %12 = load i32, i32* %11, align 4, !dbg !239, !tbaa !240
  %13 = zext i32 %12 to i64, !dbg !241
  %14 = bitcast i8* %8 to i64*, !dbg !242
  %15 = load i64, i64* %14, align 8, !dbg !243, !tbaa !244
  %16 = add i64 %15, %13, !dbg !243
  store i64 %16, i64* %14, align 8, !dbg !243, !tbaa !244
  %17 = getelementptr inbounds %struct.cpumap_enqueue_ctx, %struct.cpumap_enqueue_ctx* %0, i64 0, i32 3, !dbg !246
  %18 = load i32, i32* %17, align 4, !dbg !246, !tbaa !247
  %19 = zext i32 %18 to i64, !dbg !248
  %20 = getelementptr inbounds i8, i8* %8, i64 8, !dbg !249
  %21 = bitcast i8* %20 to i64*, !dbg !249
  %22 = load i64, i64* %21, align 8, !dbg !250, !tbaa !251
  %23 = add i64 %22, %19, !dbg !250
  store i64 %23, i64* %21, align 8, !dbg !250, !tbaa !251
  %24 = icmp eq i32 %12, 0, !dbg !252
  br i1 %24, label %30, label %25, !dbg !254

; <label>:25:                                     ; preds = %10
  %26 = getelementptr inbounds i8, i8* %8, i64 16, !dbg !255
  %27 = bitcast i8* %26 to i64*, !dbg !255
  %28 = load i64, i64* %27, align 8, !dbg !256, !tbaa !257
  %29 = add i64 %28, 1, !dbg !256
  store i64 %29, i64* %27, align 8, !dbg !256, !tbaa !257
  br label %30, !dbg !258

; <label>:30:                                     ; preds = %25, %10, %7, %1
  %31 = phi i32 [ 1, %1 ], [ 0, %7 ], [ 0, %10 ], [ 0, %25 ], !dbg !259
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !260
  ret i32 %31, !dbg !260
}

; Function Attrs: nounwind
define dso_local i32 @trace_xdp_cpumap_kthread(%struct.cpumap_kthread_ctx* nocapture readonly) #0 section "raw_tracepoint/xdp/xdp_cpumap_kthread" !dbg !261 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.cpumap_kthread_ctx* %0, metadata !274, metadata !DIExpression()), !dbg !277
  %3 = bitcast i32* %2 to i8*, !dbg !278
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !278
  call void @llvm.dbg.value(metadata i32 0, metadata !276, metadata !DIExpression()), !dbg !279
  store i32 0, i32* %2, align 4, !dbg !279, !tbaa !230
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @cpumap_kthread_cnt to i8*), i8* nonnull %3) #3, !dbg !280
  call void @llvm.dbg.value(metadata i8* %4, metadata !275, metadata !DIExpression()), !dbg !281
  %5 = icmp eq i8* %4, null, !dbg !282
  br i1 %5, label %28, label %6, !dbg !284

; <label>:6:                                      ; preds = %1
  %7 = getelementptr inbounds %struct.cpumap_kthread_ctx, %struct.cpumap_kthread_ctx* %0, i64 0, i32 4, !dbg !285
  %8 = load i32, i32* %7, align 4, !dbg !285, !tbaa !286
  %9 = zext i32 %8 to i64, !dbg !288
  %10 = bitcast i8* %4 to i64*, !dbg !289
  %11 = load i64, i64* %10, align 8, !dbg !290, !tbaa !244
  %12 = add i64 %11, %9, !dbg !290
  store i64 %12, i64* %10, align 8, !dbg !290, !tbaa !244
  %13 = getelementptr inbounds %struct.cpumap_kthread_ctx, %struct.cpumap_kthread_ctx* %0, i64 0, i32 3, !dbg !291
  %14 = load i32, i32* %13, align 4, !dbg !291, !tbaa !292
  %15 = zext i32 %14 to i64, !dbg !293
  %16 = getelementptr inbounds i8, i8* %4, i64 8, !dbg !294
  %17 = bitcast i8* %16 to i64*, !dbg !294
  %18 = load i64, i64* %17, align 8, !dbg !295, !tbaa !251
  %19 = add i64 %18, %15, !dbg !295
  store i64 %19, i64* %17, align 8, !dbg !295, !tbaa !251
  %20 = getelementptr inbounds %struct.cpumap_kthread_ctx, %struct.cpumap_kthread_ctx* %0, i64 0, i32 5, !dbg !296
  %21 = load i32, i32* %20, align 4, !dbg !296, !tbaa !298
  %22 = icmp eq i32 %21, 0, !dbg !299
  br i1 %22, label %28, label %23, !dbg !300

; <label>:23:                                     ; preds = %6
  %24 = getelementptr inbounds i8, i8* %4, i64 16, !dbg !301
  %25 = bitcast i8* %24 to i64*, !dbg !301
  %26 = load i64, i64* %25, align 8, !dbg !302, !tbaa !257
  %27 = add i64 %26, 1, !dbg !302
  store i64 %27, i64* %25, align 8, !dbg !302, !tbaa !257
  br label %28, !dbg !303

; <label>:28:                                     ; preds = %23, %6, %1
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !304
  ret i32 0, !dbg !304
}

; Function Attrs: nounwind
define dso_local i32 @trace_xdp_devmap_xmit(%struct.devmap_xmit_ctx* nocapture readonly) #0 section "raw_tracepoint/xdp/xdp_devmap_xmit" !dbg !305 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.devmap_xmit_ctx* %0, metadata !320, metadata !DIExpression()), !dbg !323
  %3 = bitcast i32* %2 to i8*, !dbg !324
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !324
  call void @llvm.dbg.value(metadata i32 0, metadata !322, metadata !DIExpression()), !dbg !325
  store i32 0, i32* %2, align 4, !dbg !325, !tbaa !230
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @devmap_xmit_cnt to i8*), i8* nonnull %3) #3, !dbg !326
  call void @llvm.dbg.value(metadata i8* %4, metadata !321, metadata !DIExpression()), !dbg !327
  %5 = icmp eq i8* %4, null, !dbg !328
  br i1 %5, label %39, label %6, !dbg !330

; <label>:6:                                      ; preds = %1
  %7 = getelementptr inbounds %struct.devmap_xmit_ctx, %struct.devmap_xmit_ctx* %0, i64 0, i32 4, !dbg !331
  %8 = load i32, i32* %7, align 4, !dbg !331, !tbaa !332
  %9 = sext i32 %8 to i64, !dbg !334
  %10 = bitcast i8* %4 to i64*, !dbg !335
  %11 = load i64, i64* %10, align 8, !dbg !336, !tbaa !244
  %12 = add i64 %11, %9, !dbg !336
  store i64 %12, i64* %10, align 8, !dbg !336, !tbaa !244
  %13 = getelementptr inbounds %struct.devmap_xmit_ctx, %struct.devmap_xmit_ctx* %0, i64 0, i32 3, !dbg !337
  %14 = load i32, i32* %13, align 4, !dbg !337, !tbaa !338
  %15 = sext i32 %14 to i64, !dbg !339
  %16 = getelementptr inbounds i8, i8* %4, i64 8, !dbg !340
  %17 = bitcast i8* %16 to i64*, !dbg !340
  %18 = load i64, i64* %17, align 8, !dbg !341, !tbaa !251
  %19 = add i64 %18, %15, !dbg !341
  store i64 %19, i64* %17, align 8, !dbg !341, !tbaa !251
  %20 = getelementptr inbounds i8, i8* %4, i64 16, !dbg !342
  %21 = bitcast i8* %20 to i64*, !dbg !342
  %22 = load i64, i64* %21, align 8, !dbg !343, !tbaa !257
  %23 = add i64 %22, 1, !dbg !343
  store i64 %23, i64* %21, align 8, !dbg !343, !tbaa !257
  %24 = getelementptr inbounds %struct.devmap_xmit_ctx, %struct.devmap_xmit_ctx* %0, i64 0, i32 7, !dbg !344
  %25 = load i32, i32* %24, align 4, !dbg !344, !tbaa !346
  %26 = icmp eq i32 %25, 0, !dbg !347
  br i1 %26, label %32, label %27, !dbg !348

; <label>:27:                                     ; preds = %6
  %28 = getelementptr inbounds i8, i8* %4, i64 24, !dbg !349
  %29 = bitcast i8* %28 to i64*, !dbg !349
  %30 = load i64, i64* %29, align 8, !dbg !350, !tbaa !351
  %31 = add i64 %30, 1, !dbg !350
  store i64 %31, i64* %29, align 8, !dbg !350, !tbaa !351
  br label %32, !dbg !352

; <label>:32:                                     ; preds = %6, %27
  %33 = icmp slt i32 %14, 0, !dbg !353
  br i1 %33, label %34, label %39, !dbg !355

; <label>:34:                                     ; preds = %32
  %35 = getelementptr inbounds i8, i8* %4, i64 24, !dbg !356
  %36 = bitcast i8* %35 to i64*, !dbg !356
  %37 = load i64, i64* %36, align 8, !dbg !357, !tbaa !351
  %38 = add i64 %37, 1, !dbg !357
  store i64 %38, i64* %36, align 8, !dbg !357, !tbaa !351
  br label %39, !dbg !358

; <label>:39:                                     ; preds = %32, %34, %1
  %40 = phi i32 [ 0, %1 ], [ 1, %34 ], [ 1, %32 ], !dbg !359
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !360
  ret i32 %40, !dbg !360
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!59, !60, !61}
!llvm.ident = !{!62}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "redirect_err_cnt", scope: !2, file: !3, line: 5, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !18, nameTableKind: None)
!3 = !DIFile(filename: "trace_prog_kern.c", directory: "/home/fedora/xdp-tutorial/tracing02-xdp-monitor")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/fedora/xdp-tutorial/tracing02-xdp-monitor")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !3, line: 35, baseType: !7, size: 32, elements: !15)
!15 = !{!16, !17}
!16 = !DIEnumerator(name: "XDP_REDIRECT_SUCCESS", value: 0, isUnsigned: true)
!17 = !DIEnumerator(name: "XDP_REDIRECT_ERROR", value: 1, isUnsigned: true)
!18 = !{!0, !19, !31, !33, !35, !37, !53}
!19 = !DIGlobalVariableExpression(var: !20, expr: !DIExpression())
!20 = distinct !DIGlobalVariable(name: "exception_cnt", scope: !2, file: !3, line: 14, type: !21, isLocal: false, isDefinition: true)
!21 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !22, line: 210, size: 224, elements: !23)
!22 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/fedora/xdp-tutorial/tracing02-xdp-monitor")
!23 = !{!24, !25, !26, !27, !28, !29, !30}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !21, file: !22, line: 211, baseType: !7, size: 32)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !21, file: !22, line: 212, baseType: !7, size: 32, offset: 32)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !21, file: !22, line: 213, baseType: !7, size: 32, offset: 64)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !21, file: !22, line: 214, baseType: !7, size: 32, offset: 96)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !21, file: !22, line: 215, baseType: !7, size: 32, offset: 128)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !21, file: !22, line: 216, baseType: !7, size: 32, offset: 160)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !21, file: !22, line: 217, baseType: !7, size: 32, offset: 192)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "cpumap_enqueue_cnt", scope: !2, file: !3, line: 127, type: !21, isLocal: false, isDefinition: true)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "cpumap_kthread_cnt", scope: !2, file: !3, line: 134, type: !21, isLocal: false, isDefinition: true)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "devmap_xmit_cnt", scope: !2, file: !3, line: 208, type: !21, isLocal: false, isDefinition: true)
!37 = !DIGlobalVariableExpression(var: !38, expr: !DIExpression())
!38 = distinct !DIGlobalVariable(name: "____btf_map_devmap_xmit_cnt", scope: !2, file: !3, line: 214, type: !39, isLocal: false, isDefinition: true)
!39 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "____btf_map_devmap_xmit_cnt", file: !3, line: 214, size: 320, elements: !40)
!40 = !{!41, !43}
!41 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !39, file: !3, line: 214, baseType: !42, size: 32)
!42 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !39, file: !3, line: 214, baseType: !44, size: 256, offset: 64)
!44 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !3, line: 119, size: 256, elements: !45)
!45 = !{!46, !50, !51, !52}
!46 = !DIDerivedType(tag: DW_TAG_member, name: "processed", scope: !44, file: !3, line: 120, baseType: !47, size: 64)
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !48, line: 31, baseType: !49)
!48 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!49 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "dropped", scope: !44, file: !3, line: 121, baseType: !47, size: 64, offset: 64)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "info", scope: !44, file: !3, line: 122, baseType: !47, size: 64, offset: 128)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "err", scope: !44, file: !3, line: 123, baseType: !47, size: 64, offset: 192)
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !22, line: 20, type: !55, isLocal: true, isDefinition: true)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = !DISubroutineType(types: !57)
!57 = !{!58, !58, !58}
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!59 = !{i32 2, !"Dwarf Version", i32 4}
!60 = !{i32 2, !"Debug Info Version", i32 3}
!61 = !{i32 1, !"wchar_size", i32 4}
!62 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!63 = distinct !DISubprogram(name: "trace_xdp_redirect_err", scope: !3, file: !3, line: 65, type: !64, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !77)
!64 = !DISubroutineType(types: !65)
!65 = !{!42, !66}
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_redirect_ctx", file: !3, line: 25, size: 224, elements: !68)
!68 = !{!69, !70, !72, !73, !74, !75, !76}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "prog_id", scope: !67, file: !3, line: 26, baseType: !42, size: 32)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "act", scope: !67, file: !3, line: 27, baseType: !71, size: 32, offset: 32)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !48, line: 27, baseType: !7)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !67, file: !3, line: 28, baseType: !42, size: 32, offset: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "err", scope: !67, file: !3, line: 29, baseType: !42, size: 32, offset: 96)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "to_ifindex", scope: !67, file: !3, line: 30, baseType: !42, size: 32, offset: 128)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "map_id", scope: !67, file: !3, line: 31, baseType: !71, size: 32, offset: 160)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "map_index", scope: !67, file: !3, line: 32, baseType: !42, size: 32, offset: 192)
!77 = !{!78}
!78 = !DILocalVariable(name: "ctx", arg: 1, scope: !63, file: !3, line: 65, type: !66)
!79 = !DILocation(line: 65, column: 53, scope: !63)
!80 = !DILocalVariable(name: "ctx", arg: 1, scope: !81, file: !3, line: 41, type: !66)
!81 = distinct !DISubprogram(name: "xdp_redirect_collect_stat", scope: !3, file: !3, line: 41, type: !64, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !82)
!82 = !{!80, !83, !84, !85}
!83 = !DILocalVariable(name: "key", scope: !81, file: !3, line: 43, type: !71)
!84 = !DILocalVariable(name: "err", scope: !81, file: !3, line: 44, type: !42)
!85 = !DILocalVariable(name: "cnt", scope: !81, file: !3, line: 45, type: !86)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!87 = !DILocation(line: 41, column: 56, scope: !81, inlinedAt: !88)
!88 = distinct !DILocation(line: 67, column: 9, scope: !63)
!89 = !DILocation(line: 43, column: 2, scope: !81, inlinedAt: !88)
!90 = !DILocation(line: 43, column: 8, scope: !81, inlinedAt: !88)
!91 = !DILocation(line: 44, column: 17, scope: !81, inlinedAt: !88)
!92 = !{!93, !94, i64 12}
!93 = !{!"xdp_redirect_ctx", !94, i64 0, !94, i64 4, !94, i64 8, !94, i64 12, !94, i64 16, !94, i64 20, !94, i64 24}
!94 = !{!"int", !95, i64 0}
!95 = !{!"omnipotent char", !96, i64 0}
!96 = !{!"Simple C/C++ TBAA"}
!97 = !DILocation(line: 44, column: 6, scope: !81, inlinedAt: !88)
!98 = !DILocation(line: 47, column: 7, scope: !99, inlinedAt: !88)
!99 = distinct !DILexicalBlock(scope: !81, file: !3, line: 47, column: 6)
!100 = !DILocation(line: 47, column: 6, scope: !81, inlinedAt: !88)
!101 = !DILocation(line: 0, scope: !81, inlinedAt: !88)
!102 = !DILocation(line: 50, column: 9, scope: !81, inlinedAt: !88)
!103 = !DILocation(line: 45, column: 9, scope: !81, inlinedAt: !88)
!104 = !DILocation(line: 51, column: 7, scope: !105, inlinedAt: !88)
!105 = distinct !DILexicalBlock(scope: !81, file: !3, line: 51, column: 6)
!106 = !DILocation(line: 51, column: 6, scope: !81, inlinedAt: !88)
!107 = !DILocation(line: 53, column: 7, scope: !81, inlinedAt: !88)
!108 = !{!109, !109, i64 0}
!109 = !{!"long long", !95, i64 0}
!110 = !DILocation(line: 55, column: 2, scope: !81, inlinedAt: !88)
!111 = !DILocation(line: 62, column: 1, scope: !81, inlinedAt: !88)
!112 = !DILocation(line: 67, column: 2, scope: !63)
!113 = distinct !DISubprogram(name: "trace_xdp_redirect_map_err", scope: !3, file: !3, line: 71, type: !64, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !114)
!114 = !{!115}
!115 = !DILocalVariable(name: "ctx", arg: 1, scope: !113, file: !3, line: 71, type: !66)
!116 = !DILocation(line: 71, column: 57, scope: !113)
!117 = !DILocation(line: 41, column: 56, scope: !81, inlinedAt: !118)
!118 = distinct !DILocation(line: 73, column: 9, scope: !113)
!119 = !DILocation(line: 43, column: 2, scope: !81, inlinedAt: !118)
!120 = !DILocation(line: 43, column: 8, scope: !81, inlinedAt: !118)
!121 = !DILocation(line: 44, column: 17, scope: !81, inlinedAt: !118)
!122 = !DILocation(line: 44, column: 6, scope: !81, inlinedAt: !118)
!123 = !DILocation(line: 47, column: 7, scope: !99, inlinedAt: !118)
!124 = !DILocation(line: 47, column: 6, scope: !81, inlinedAt: !118)
!125 = !DILocation(line: 0, scope: !81, inlinedAt: !118)
!126 = !DILocation(line: 50, column: 9, scope: !81, inlinedAt: !118)
!127 = !DILocation(line: 45, column: 9, scope: !81, inlinedAt: !118)
!128 = !DILocation(line: 51, column: 7, scope: !105, inlinedAt: !118)
!129 = !DILocation(line: 51, column: 6, scope: !81, inlinedAt: !118)
!130 = !DILocation(line: 53, column: 7, scope: !81, inlinedAt: !118)
!131 = !DILocation(line: 55, column: 2, scope: !81, inlinedAt: !118)
!132 = !DILocation(line: 62, column: 1, scope: !81, inlinedAt: !118)
!133 = !DILocation(line: 73, column: 2, scope: !113)
!134 = distinct !DISubprogram(name: "trace_xdp_redirect", scope: !3, file: !3, line: 78, type: !64, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !135)
!135 = !{!136}
!136 = !DILocalVariable(name: "ctx", arg: 1, scope: !134, file: !3, line: 78, type: !66)
!137 = !DILocation(line: 78, column: 49, scope: !134)
!138 = !DILocation(line: 41, column: 56, scope: !81, inlinedAt: !139)
!139 = distinct !DILocation(line: 80, column: 9, scope: !134)
!140 = !DILocation(line: 43, column: 2, scope: !81, inlinedAt: !139)
!141 = !DILocation(line: 43, column: 8, scope: !81, inlinedAt: !139)
!142 = !DILocation(line: 44, column: 17, scope: !81, inlinedAt: !139)
!143 = !DILocation(line: 44, column: 6, scope: !81, inlinedAt: !139)
!144 = !DILocation(line: 47, column: 7, scope: !99, inlinedAt: !139)
!145 = !DILocation(line: 47, column: 6, scope: !81, inlinedAt: !139)
!146 = !DILocation(line: 0, scope: !81, inlinedAt: !139)
!147 = !DILocation(line: 50, column: 9, scope: !81, inlinedAt: !139)
!148 = !DILocation(line: 45, column: 9, scope: !81, inlinedAt: !139)
!149 = !DILocation(line: 51, column: 7, scope: !105, inlinedAt: !139)
!150 = !DILocation(line: 51, column: 6, scope: !81, inlinedAt: !139)
!151 = !DILocation(line: 53, column: 7, scope: !81, inlinedAt: !139)
!152 = !DILocation(line: 55, column: 2, scope: !81, inlinedAt: !139)
!153 = !DILocation(line: 62, column: 1, scope: !81, inlinedAt: !139)
!154 = !DILocation(line: 80, column: 2, scope: !134)
!155 = distinct !DISubprogram(name: "trace_xdp_redirect_map", scope: !3, file: !3, line: 85, type: !64, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !156)
!156 = !{!157}
!157 = !DILocalVariable(name: "ctx", arg: 1, scope: !155, file: !3, line: 85, type: !66)
!158 = !DILocation(line: 85, column: 53, scope: !155)
!159 = !DILocation(line: 41, column: 56, scope: !81, inlinedAt: !160)
!160 = distinct !DILocation(line: 87, column: 9, scope: !155)
!161 = !DILocation(line: 43, column: 2, scope: !81, inlinedAt: !160)
!162 = !DILocation(line: 43, column: 8, scope: !81, inlinedAt: !160)
!163 = !DILocation(line: 44, column: 17, scope: !81, inlinedAt: !160)
!164 = !DILocation(line: 44, column: 6, scope: !81, inlinedAt: !160)
!165 = !DILocation(line: 47, column: 7, scope: !99, inlinedAt: !160)
!166 = !DILocation(line: 47, column: 6, scope: !81, inlinedAt: !160)
!167 = !DILocation(line: 0, scope: !81, inlinedAt: !160)
!168 = !DILocation(line: 50, column: 9, scope: !81, inlinedAt: !160)
!169 = !DILocation(line: 45, column: 9, scope: !81, inlinedAt: !160)
!170 = !DILocation(line: 51, column: 7, scope: !105, inlinedAt: !160)
!171 = !DILocation(line: 51, column: 6, scope: !81, inlinedAt: !160)
!172 = !DILocation(line: 53, column: 7, scope: !81, inlinedAt: !160)
!173 = !DILocation(line: 55, column: 2, scope: !81, inlinedAt: !160)
!174 = !DILocation(line: 62, column: 1, scope: !81, inlinedAt: !160)
!175 = !DILocation(line: 87, column: 2, scope: !155)
!176 = distinct !DISubprogram(name: "trace_xdp_exception", scope: !3, file: !3, line: 101, type: !177, scopeLine: 102, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !185)
!177 = !DISubroutineType(types: !178)
!178 = !{!42, !179}
!179 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !180, size: 64)
!180 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_exception_ctx", file: !3, line: 94, size: 96, elements: !181)
!181 = !{!182, !183, !184}
!182 = !DIDerivedType(tag: DW_TAG_member, name: "prog_id", scope: !180, file: !3, line: 95, baseType: !42, size: 32)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "act", scope: !180, file: !3, line: 96, baseType: !71, size: 32, offset: 32)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !180, file: !3, line: 97, baseType: !42, size: 32, offset: 64)
!185 = !{!186, !187, !188}
!186 = !DILocalVariable(name: "ctx", arg: 1, scope: !176, file: !3, line: 101, type: !179)
!187 = !DILocalVariable(name: "cnt", scope: !176, file: !3, line: 103, type: !86)
!188 = !DILocalVariable(name: "key", scope: !176, file: !3, line: 104, type: !71)
!189 = !DILocation(line: 101, column: 51, scope: !176)
!190 = !DILocation(line: 104, column: 2, scope: !176)
!191 = !DILocation(line: 106, column: 13, scope: !176)
!192 = !{!193, !94, i64 4}
!193 = !{!"xdp_exception_ctx", !94, i64 0, !94, i64 4, !94, i64 8}
!194 = !DILocation(line: 107, column: 10, scope: !195)
!195 = distinct !DILexicalBlock(scope: !176, file: !3, line: 107, column: 6)
!196 = !DILocation(line: 107, column: 6, scope: !176)
!197 = !DILocation(line: 104, column: 8, scope: !176)
!198 = !DILocation(line: 0, scope: !176)
!199 = !DILocation(line: 110, column: 8, scope: !176)
!200 = !DILocation(line: 103, column: 9, scope: !176)
!201 = !DILocation(line: 111, column: 7, scope: !202)
!202 = distinct !DILexicalBlock(scope: !176, file: !3, line: 111, column: 6)
!203 = !DILocation(line: 111, column: 6, scope: !176)
!204 = !DILocation(line: 113, column: 7, scope: !176)
!205 = !DILocation(line: 115, column: 2, scope: !176)
!206 = !DILocation(line: 116, column: 1, scope: !176)
!207 = distinct !DISubprogram(name: "trace_xdp_cpumap_enqueue", scope: !3, file: !3, line: 155, type: !208, scopeLine: 156, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !219)
!208 = !DISubroutineType(types: !209)
!209 = !{!42, !210}
!210 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !211, size: 64)
!211 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "cpumap_enqueue_ctx", file: !3, line: 145, size: 192, elements: !212)
!212 = !{!213, !214, !215, !216, !217, !218}
!213 = !DIDerivedType(tag: DW_TAG_member, name: "map_id", scope: !211, file: !3, line: 146, baseType: !42, size: 32)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "act", scope: !211, file: !3, line: 147, baseType: !71, size: 32, offset: 32)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "cpu", scope: !211, file: !3, line: 148, baseType: !42, size: 32, offset: 64)
!216 = !DIDerivedType(tag: DW_TAG_member, name: "drops", scope: !211, file: !3, line: 149, baseType: !7, size: 32, offset: 96)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "processed", scope: !211, file: !3, line: 150, baseType: !7, size: 32, offset: 128)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "to_cpu", scope: !211, file: !3, line: 151, baseType: !42, size: 32, offset: 160)
!219 = !{!220, !221, !222}
!220 = !DILocalVariable(name: "ctx", arg: 1, scope: !207, file: !3, line: 155, type: !210)
!221 = !DILocalVariable(name: "to_cpu", scope: !207, file: !3, line: 157, type: !71)
!222 = !DILocalVariable(name: "rec", scope: !207, file: !3, line: 158, type: !223)
!223 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!224 = !DILocation(line: 155, column: 57, scope: !207)
!225 = !DILocation(line: 157, column: 2, scope: !207)
!226 = !DILocation(line: 157, column: 22, scope: !207)
!227 = !{!228, !94, i64 20}
!228 = !{!"cpumap_enqueue_ctx", !94, i64 0, !94, i64 4, !94, i64 8, !94, i64 12, !94, i64 16, !94, i64 20}
!229 = !DILocation(line: 157, column: 8, scope: !207)
!230 = !{!94, !94, i64 0}
!231 = !DILocation(line: 160, column: 13, scope: !232)
!232 = distinct !DILexicalBlock(scope: !207, file: !3, line: 160, column: 6)
!233 = !DILocation(line: 160, column: 6, scope: !207)
!234 = !DILocation(line: 163, column: 8, scope: !207)
!235 = !DILocation(line: 158, column: 18, scope: !207)
!236 = !DILocation(line: 164, column: 7, scope: !237)
!237 = distinct !DILexicalBlock(scope: !207, file: !3, line: 164, column: 6)
!238 = !DILocation(line: 164, column: 6, scope: !207)
!239 = !DILocation(line: 166, column: 25, scope: !207)
!240 = !{!228, !94, i64 16}
!241 = !DILocation(line: 166, column: 20, scope: !207)
!242 = !DILocation(line: 166, column: 7, scope: !207)
!243 = !DILocation(line: 166, column: 17, scope: !207)
!244 = !{!245, !109, i64 0}
!245 = !{!"datarec", !109, i64 0, !109, i64 8, !109, i64 16, !109, i64 24}
!246 = !DILocation(line: 167, column: 25, scope: !207)
!247 = !{!228, !94, i64 12}
!248 = !DILocation(line: 167, column: 20, scope: !207)
!249 = !DILocation(line: 167, column: 7, scope: !207)
!250 = !DILocation(line: 167, column: 17, scope: !207)
!251 = !{!245, !109, i64 8}
!252 = !DILocation(line: 170, column: 21, scope: !253)
!253 = distinct !DILexicalBlock(scope: !207, file: !3, line: 170, column: 6)
!254 = !DILocation(line: 170, column: 6, scope: !207)
!255 = !DILocation(line: 171, column: 8, scope: !253)
!256 = !DILocation(line: 171, column: 13, scope: !253)
!257 = !{!245, !109, i64 16}
!258 = !DILocation(line: 171, column: 3, scope: !253)
!259 = !DILocation(line: 0, scope: !207)
!260 = !DILocation(line: 174, column: 1, scope: !207)
!261 = distinct !DISubprogram(name: "trace_xdp_cpumap_kthread", scope: !3, file: !3, line: 190, type: !262, scopeLine: 191, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !273)
!262 = !DISubroutineType(types: !263)
!263 = !{!42, !264}
!264 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !265, size: 64)
!265 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "cpumap_kthread_ctx", file: !3, line: 180, size: 192, elements: !266)
!266 = !{!267, !268, !269, !270, !271, !272}
!267 = !DIDerivedType(tag: DW_TAG_member, name: "map_id", scope: !265, file: !3, line: 181, baseType: !42, size: 32)
!268 = !DIDerivedType(tag: DW_TAG_member, name: "act", scope: !265, file: !3, line: 182, baseType: !71, size: 32, offset: 32)
!269 = !DIDerivedType(tag: DW_TAG_member, name: "cpu", scope: !265, file: !3, line: 183, baseType: !42, size: 32, offset: 64)
!270 = !DIDerivedType(tag: DW_TAG_member, name: "drops", scope: !265, file: !3, line: 184, baseType: !7, size: 32, offset: 96)
!271 = !DIDerivedType(tag: DW_TAG_member, name: "processed", scope: !265, file: !3, line: 185, baseType: !7, size: 32, offset: 128)
!272 = !DIDerivedType(tag: DW_TAG_member, name: "sched", scope: !265, file: !3, line: 186, baseType: !42, size: 32, offset: 160)
!273 = !{!274, !275, !276}
!274 = !DILocalVariable(name: "ctx", arg: 1, scope: !261, file: !3, line: 190, type: !264)
!275 = !DILocalVariable(name: "rec", scope: !261, file: !3, line: 192, type: !223)
!276 = !DILocalVariable(name: "key", scope: !261, file: !3, line: 193, type: !71)
!277 = !DILocation(line: 190, column: 57, scope: !261)
!278 = !DILocation(line: 193, column: 2, scope: !261)
!279 = !DILocation(line: 193, column: 8, scope: !261)
!280 = !DILocation(line: 195, column: 8, scope: !261)
!281 = !DILocation(line: 192, column: 18, scope: !261)
!282 = !DILocation(line: 196, column: 7, scope: !283)
!283 = distinct !DILexicalBlock(scope: !261, file: !3, line: 196, column: 6)
!284 = !DILocation(line: 196, column: 6, scope: !261)
!285 = !DILocation(line: 198, column: 25, scope: !261)
!286 = !{!287, !94, i64 16}
!287 = !{!"cpumap_kthread_ctx", !94, i64 0, !94, i64 4, !94, i64 8, !94, i64 12, !94, i64 16, !94, i64 20}
!288 = !DILocation(line: 198, column: 20, scope: !261)
!289 = !DILocation(line: 198, column: 7, scope: !261)
!290 = !DILocation(line: 198, column: 17, scope: !261)
!291 = !DILocation(line: 199, column: 25, scope: !261)
!292 = !{!287, !94, i64 12}
!293 = !DILocation(line: 199, column: 20, scope: !261)
!294 = !DILocation(line: 199, column: 7, scope: !261)
!295 = !DILocation(line: 199, column: 17, scope: !261)
!296 = !DILocation(line: 202, column: 11, scope: !297)
!297 = distinct !DILexicalBlock(scope: !261, file: !3, line: 202, column: 6)
!298 = !{!287, !94, i64 20}
!299 = !DILocation(line: 202, column: 6, scope: !297)
!300 = !DILocation(line: 202, column: 6, scope: !261)
!301 = !DILocation(line: 203, column: 8, scope: !297)
!302 = !DILocation(line: 203, column: 12, scope: !297)
!303 = !DILocation(line: 203, column: 3, scope: !297)
!304 = !DILocation(line: 206, column: 1, scope: !261)
!305 = distinct !DISubprogram(name: "trace_xdp_devmap_xmit", scope: !3, file: !3, line: 232, type: !306, scopeLine: 233, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !319)
!306 = !DISubroutineType(types: !307)
!307 = !{!42, !308}
!308 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !309, size: 64)
!309 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "devmap_xmit_ctx", file: !3, line: 220, size: 256, elements: !310)
!310 = !{!311, !312, !313, !314, !315, !316, !317, !318}
!311 = !DIDerivedType(tag: DW_TAG_member, name: "map_id", scope: !309, file: !3, line: 221, baseType: !42, size: 32)
!312 = !DIDerivedType(tag: DW_TAG_member, name: "act", scope: !309, file: !3, line: 222, baseType: !71, size: 32, offset: 32)
!313 = !DIDerivedType(tag: DW_TAG_member, name: "map_index", scope: !309, file: !3, line: 223, baseType: !71, size: 32, offset: 64)
!314 = !DIDerivedType(tag: DW_TAG_member, name: "drops", scope: !309, file: !3, line: 224, baseType: !42, size: 32, offset: 96)
!315 = !DIDerivedType(tag: DW_TAG_member, name: "sent", scope: !309, file: !3, line: 225, baseType: !42, size: 32, offset: 128)
!316 = !DIDerivedType(tag: DW_TAG_member, name: "from_ifindex", scope: !309, file: !3, line: 226, baseType: !42, size: 32, offset: 160)
!317 = !DIDerivedType(tag: DW_TAG_member, name: "to_ifindex", scope: !309, file: !3, line: 227, baseType: !42, size: 32, offset: 192)
!318 = !DIDerivedType(tag: DW_TAG_member, name: "err", scope: !309, file: !3, line: 228, baseType: !42, size: 32, offset: 224)
!319 = !{!320, !321, !322}
!320 = !DILocalVariable(name: "ctx", arg: 1, scope: !305, file: !3, line: 232, type: !308)
!321 = !DILocalVariable(name: "rec", scope: !305, file: !3, line: 234, type: !223)
!322 = !DILocalVariable(name: "key", scope: !305, file: !3, line: 235, type: !71)
!323 = !DILocation(line: 232, column: 51, scope: !305)
!324 = !DILocation(line: 235, column: 2, scope: !305)
!325 = !DILocation(line: 235, column: 8, scope: !305)
!326 = !DILocation(line: 237, column: 8, scope: !305)
!327 = !DILocation(line: 234, column: 18, scope: !305)
!328 = !DILocation(line: 238, column: 7, scope: !329)
!329 = distinct !DILexicalBlock(scope: !305, file: !3, line: 238, column: 6)
!330 = !DILocation(line: 238, column: 6, scope: !305)
!331 = !DILocation(line: 240, column: 25, scope: !305)
!332 = !{!333, !94, i64 16}
!333 = !{!"devmap_xmit_ctx", !94, i64 0, !94, i64 4, !94, i64 8, !94, i64 12, !94, i64 16, !94, i64 20, !94, i64 24, !94, i64 28}
!334 = !DILocation(line: 240, column: 20, scope: !305)
!335 = !DILocation(line: 240, column: 7, scope: !305)
!336 = !DILocation(line: 240, column: 17, scope: !305)
!337 = !DILocation(line: 241, column: 25, scope: !305)
!338 = !{!333, !94, i64 12}
!339 = !DILocation(line: 241, column: 20, scope: !305)
!340 = !DILocation(line: 241, column: 7, scope: !305)
!341 = !DILocation(line: 241, column: 17, scope: !305)
!342 = !DILocation(line: 244, column: 7, scope: !305)
!343 = !DILocation(line: 244, column: 12, scope: !305)
!344 = !DILocation(line: 247, column: 11, scope: !345)
!345 = distinct !DILexicalBlock(scope: !305, file: !3, line: 247, column: 6)
!346 = !{!333, !94, i64 28}
!347 = !DILocation(line: 247, column: 6, scope: !345)
!348 = !DILocation(line: 247, column: 6, scope: !305)
!349 = !DILocation(line: 248, column: 8, scope: !345)
!350 = !DILocation(line: 248, column: 11, scope: !345)
!351 = !{!245, !109, i64 24}
!352 = !DILocation(line: 248, column: 3, scope: !345)
!353 = !DILocation(line: 251, column: 17, scope: !354)
!354 = distinct !DILexicalBlock(scope: !305, file: !3, line: 251, column: 6)
!355 = !DILocation(line: 251, column: 6, scope: !305)
!356 = !DILocation(line: 252, column: 8, scope: !354)
!357 = !DILocation(line: 252, column: 11, scope: !354)
!358 = !DILocation(line: 252, column: 3, scope: !354)
!359 = !DILocation(line: 0, scope: !305)
!360 = !DILocation(line: 255, column: 1, scope: !305)
