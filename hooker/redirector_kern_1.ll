; ModuleID = 'redirector_kern_1.c'
source_filename = "redirector_kern_1.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.bpf_sock_ops = type { i32, %union.anon, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64 }
%union.anon = type { [4 x i32] }
%struct.sock_key = type { i32, i32, i32, i32 }
%struct.sk_msg_md = type { %union.anon.0, %union.anon.1, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32 }
%union.anon.0 = type { i8* }
%union.anon.1 = type { i8* }

@sock_key_map = global %struct.bpf_map_def { i32 2, i32 4, i32 16, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@hooker_map = global %struct.bpf_map_def { i32 18, i32 16, i32 4, i32 20, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !11
@hk_add_hmap.____fmt = private unnamed_addr constant [10 x i8] c"sport: %d\00", align 1
@redirector_skmsg.____fmt = private unnamed_addr constant [15 x i8] c"hooker -> app\0A\00", align 1
@redirector_sockops.____fmt = private unnamed_addr constant [9 x i8] c"serveur\0A\00", align 1
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !24
@llvm.used = appending global [5 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* bitcast (i32 (%struct.sk_msg_md*)* @redirector_skmsg to i8*), i8* bitcast (i32 (%struct.bpf_sock_ops*)* @redirector_sockops to i8*), i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define void @hk_add_hmap(%struct.bpf_sock_ops*) local_unnamed_addr #0 !dbg !61 {
  %2 = alloca %struct.sock_key, align 4
  %3 = alloca [10 x i8], align 1
  %4 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !112, metadata !DIExpression()), !dbg !130
  %5 = bitcast %struct.sock_key* %2 to i8*, !dbg !131
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %5) #3, !dbg !131
  %6 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 3, !dbg !132
  %7 = load i32, i32* %6, align 8, !dbg !132, !tbaa !133
  %8 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 1, !dbg !139
  store i32 %7, i32* %8, align 4, !dbg !140, !tbaa !141
  %9 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 4, !dbg !143
  %10 = load i32, i32* %9, align 4, !dbg !143, !tbaa !144
  %11 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 0, !dbg !145
  store i32 %10, i32* %11, align 4, !dbg !146, !tbaa !147
  %12 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 7, !dbg !148
  %13 = load i32, i32* %12, align 8, !dbg !148, !tbaa !149
  %14 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 3, !dbg !150
  store i32 %13, i32* %14, align 4, !dbg !151, !tbaa !152
  %15 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 8, !dbg !153
  %16 = load i32, i32* %15, align 4, !dbg !153, !tbaa !154
  %17 = tail call i32 @llvm.bswap.i32(i32 %16), !dbg !153
  %18 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 2, !dbg !155
  store i32 %17, i32* %18, align 4, !dbg !156, !tbaa !157
  %19 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i64 0, i64 0, !dbg !158
  call void @llvm.lifetime.start.p0i8(i64 10, i8* nonnull %19) #3, !dbg !158
  call void @llvm.dbg.declare(metadata [10 x i8]* %3, metadata !122, metadata !DIExpression()), !dbg !158
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %19, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @hk_add_hmap.____fmt, i64 0, i64 0), i64 10, i32 1, i1 false), !dbg !158
  %20 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %19, i32 10, i32 %16) #3, !dbg !158
  call void @llvm.lifetime.end.p0i8(i64 10, i8* nonnull %19) #3, !dbg !159
  %21 = load i32, i32* %15, align 4, !dbg !160, !tbaa !154
  %22 = icmp eq i32 %21, 9092, !dbg !161
  br i1 %22, label %23, label %26, !dbg !162

; <label>:23:                                     ; preds = %1
  %24 = bitcast i32* %4 to i8*, !dbg !163
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %24) #3, !dbg !163
  call void @llvm.dbg.value(metadata i32 0, metadata !127, metadata !DIExpression()), !dbg !164
  store i32 0, i32* %4, align 4, !dbg !164, !tbaa !165
  %25 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*), i8* nonnull %24, i8* nonnull %5, i64 0) #3, !dbg !166
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %24) #3, !dbg !167
  br label %26, !dbg !168

; <label>:26:                                     ; preds = %23, %1
  %27 = bitcast %struct.bpf_sock_ops* %0 to i8*, !dbg !169
  %28 = call i32 inttoptr (i64 70 to i32 (i8*, i8*, i8*, i64)*)(i8* %27, i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* nonnull %5, i64 1) #3, !dbg !170
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #3, !dbg !171
  ret void, !dbg !171
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i32, i1) #2

; Function Attrs: nounwind readnone speculatable
declare i32 @llvm.bswap.i32(i32) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
define i32 @redirector_skmsg(%struct.sk_msg_md*) #0 section "sk_msg" !dbg !172 {
  %2 = alloca %struct.sock_key, align 4
  %3 = alloca [15 x i8], align 1
  %4 = alloca i32, align 4
  %5 = alloca %struct.sock_key, align 4
  call void @llvm.dbg.value(metadata %struct.sk_msg_md* %0, metadata !195, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i64 1, metadata !196, metadata !DIExpression()), !dbg !210
  %6 = bitcast %struct.sock_key* %2 to i8*, !dbg !211
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %6) #3, !dbg !211
  call void @llvm.memset.p0i8.i64(i8* nonnull %6, i8 0, i64 16, i32 4, i1 false), !dbg !212
  %7 = getelementptr inbounds %struct.sk_msg_md, %struct.sk_msg_md* %0, i64 0, i32 8, !dbg !213
  %8 = load i32, i32* %7, align 8, !dbg !213, !tbaa !214
  call void @llvm.dbg.value(metadata i32 %8, metadata !197, metadata !DIExpression()), !dbg !216
  switch i32 %8, label %22 [
    i32 10002, label %9
    i32 9092, label %19
  ], !dbg !217

; <label>:9:                                      ; preds = %1
  %10 = getelementptr inbounds [15 x i8], [15 x i8]* %3, i64 0, i64 0, !dbg !218
  call void @llvm.lifetime.start.p0i8(i64 15, i8* nonnull %10) #3, !dbg !218
  call void @llvm.dbg.declare(metadata [15 x i8]* %3, metadata !199, metadata !DIExpression()), !dbg !218
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %10, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @redirector_skmsg.____fmt, i64 0, i64 0), i64 15, i32 1, i1 false), !dbg !218
  %11 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %10, i32 15) #3, !dbg !218
  call void @llvm.lifetime.end.p0i8(i64 15, i8* nonnull %10) #3, !dbg !219
  call void @llvm.dbg.value(metadata i32 0, metadata !205, metadata !DIExpression()), !dbg !220
  store i32 0, i32* %4, align 4, !dbg !220, !tbaa !165
  %12 = bitcast %struct.sock_key* %5 to i8*, !dbg !221
  call void @llvm.memset.p0i8.i64(i8* nonnull %12, i8 0, i64 16, i32 4, i1 false), !dbg !221
  %13 = bitcast i32* %4 to i8*, !dbg !222
  %14 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*), i8* nonnull %13) #3, !dbg !223
  call void @llvm.dbg.value(metadata i8* %14, metadata !206, metadata !DIExpression()), !dbg !224
  %15 = icmp eq i8* %14, null, !dbg !225
  br i1 %15, label %22, label %16, !dbg !227

; <label>:16:                                     ; preds = %9
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %12, i8* nonnull %14, i64 16, i32 4, i1 false), !dbg !228, !tbaa.struct !229
  %17 = bitcast %struct.sk_msg_md* %0 to i8*, !dbg !230
  %18 = call i32 inttoptr (i64 71 to i32 (i8*, i8*, i8*, i32)*)(i8* %17, i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* nonnull %12, i32 1) #3, !dbg !231
  br label %22, !dbg !232

; <label>:19:                                     ; preds = %1
  %20 = bitcast %struct.sk_msg_md* %0 to i8*, !dbg !233
  %21 = call i32 inttoptr (i64 71 to i32 (i8*, i8*, i8*, i32)*)(i8* %20, i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* nonnull %6, i32 1) #3, !dbg !234
  br label %22, !dbg !235

; <label>:22:                                     ; preds = %16, %19, %1, %9
  %23 = phi i32 [ 0, %9 ], [ 1, %1 ], [ 1, %19 ], [ 1, %16 ]
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %6) #3, !dbg !236
  ret i32 %23, !dbg !236
}

; Function Attrs: nounwind
define i32 @redirector_sockops(%struct.bpf_sock_ops*) #0 section "sockops" !dbg !237 {
  %2 = alloca %struct.sock_key, align 4
  %3 = alloca i32, align 4
  %4 = alloca %struct.sock_key, align 4
  %5 = alloca [10 x i8], align 1
  call void @llvm.dbg.declare(metadata [10 x i8]* %5, metadata !122, metadata !DIExpression()), !dbg !254
  call void @llvm.dbg.declare(metadata [10 x i8]* %5, metadata !122, metadata !DIExpression()), !dbg !256
  %6 = alloca i32, align 4
  %7 = alloca [9 x i8], align 1
  %8 = alloca i64, align 8
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !241, metadata !DIExpression()), !dbg !258
  %9 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 0, !dbg !259
  %10 = load i32, i32* %9, align 8, !dbg !259, !tbaa !260
  call void @llvm.dbg.value(metadata i32 %10, metadata !242, metadata !DIExpression()), !dbg !261
  switch i32 %10, label %65 [
    i32 5, label %11
    i32 4, label %38
  ], !dbg !262

; <label>:11:                                     ; preds = %1
  %12 = getelementptr inbounds [9 x i8], [9 x i8]* %7, i64 0, i64 0, !dbg !263
  call void @llvm.lifetime.start.p0i8(i64 9, i8* nonnull %12) #3, !dbg !263
  call void @llvm.dbg.declare(metadata [9 x i8]* %7, metadata !243, metadata !DIExpression()), !dbg !263
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %12, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @redirector_sockops.____fmt, i64 0, i64 0), i64 9, i32 1, i1 false), !dbg !263
  %13 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %12, i32 9) #3, !dbg !263
  call void @llvm.lifetime.end.p0i8(i64 9, i8* nonnull %12) #3, !dbg !264
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !112, metadata !DIExpression()) #3, !dbg !265
  %14 = bitcast %struct.sock_key* %4 to i8*, !dbg !266
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %14) #3, !dbg !266
  %15 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 3, !dbg !267
  %16 = load i32, i32* %15, align 8, !dbg !267, !tbaa !133
  %17 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %4, i64 0, i32 1, !dbg !268
  store i32 %16, i32* %17, align 4, !dbg !269, !tbaa !141
  %18 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 4, !dbg !270
  %19 = load i32, i32* %18, align 4, !dbg !270, !tbaa !144
  %20 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %4, i64 0, i32 0, !dbg !271
  store i32 %19, i32* %20, align 4, !dbg !272, !tbaa !147
  %21 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 7, !dbg !273
  %22 = load i32, i32* %21, align 8, !dbg !273, !tbaa !149
  %23 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %4, i64 0, i32 3, !dbg !274
  store i32 %22, i32* %23, align 4, !dbg !275, !tbaa !152
  %24 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 8, !dbg !276
  %25 = load i32, i32* %24, align 4, !dbg !276, !tbaa !154
  %26 = call i32 @llvm.bswap.i32(i32 %25) #3, !dbg !276
  %27 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %4, i64 0, i32 2, !dbg !277
  store i32 %26, i32* %27, align 4, !dbg !278, !tbaa !157
  %28 = getelementptr inbounds [10 x i8], [10 x i8]* %5, i64 0, i64 0, !dbg !256
  call void @llvm.lifetime.start.p0i8(i64 10, i8* nonnull %28) #3, !dbg !256
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %28, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @hk_add_hmap.____fmt, i64 0, i64 0), i64 10, i32 1, i1 false) #3, !dbg !256
  %29 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %28, i32 10, i32 %25) #3, !dbg !256
  call void @llvm.lifetime.end.p0i8(i64 10, i8* nonnull %28) #3, !dbg !279
  %30 = load i32, i32* %24, align 4, !dbg !280, !tbaa !154
  %31 = icmp eq i32 %30, 9092, !dbg !281
  br i1 %31, label %32, label %35, !dbg !282

; <label>:32:                                     ; preds = %11
  %33 = bitcast i32* %6 to i8*, !dbg !283
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %33) #3, !dbg !283
  call void @llvm.dbg.value(metadata i32 0, metadata !127, metadata !DIExpression()) #3, !dbg !284
  store i32 0, i32* %6, align 4, !dbg !284, !tbaa !165
  %34 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*), i8* nonnull %33, i8* nonnull %14, i64 0) #3, !dbg !285
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %33) #3, !dbg !286
  br label %35, !dbg !287

; <label>:35:                                     ; preds = %11, %32
  %36 = bitcast %struct.bpf_sock_ops* %0 to i8*, !dbg !288
  %37 = call i32 inttoptr (i64 70 to i32 (i8*, i8*, i8*, i64)*)(i8* %36, i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* nonnull %14, i64 1) #3, !dbg !289
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %14) #3, !dbg !290
  br label %65, !dbg !291

; <label>:38:                                     ; preds = %1
  %39 = bitcast i64* %8 to i8*, !dbg !292
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %39) #3, !dbg !292
  call void @llvm.dbg.value(metadata i64 2942767263738979, metadata !249, metadata !DIExpression()), !dbg !292
  store i64 2942767263738979, i64* %8, align 8, !dbg !292
  %40 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %39, i32 8) #3, !dbg !292
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %39) #3, !dbg !293
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !112, metadata !DIExpression()) #3, !dbg !294
  %41 = bitcast %struct.sock_key* %2 to i8*, !dbg !295
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %41) #3, !dbg !295
  %42 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 3, !dbg !296
  %43 = load i32, i32* %42, align 8, !dbg !296, !tbaa !133
  %44 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 1, !dbg !297
  store i32 %43, i32* %44, align 4, !dbg !298, !tbaa !141
  %45 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 4, !dbg !299
  %46 = load i32, i32* %45, align 4, !dbg !299, !tbaa !144
  %47 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 0, !dbg !300
  store i32 %46, i32* %47, align 4, !dbg !301, !tbaa !147
  %48 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 7, !dbg !302
  %49 = load i32, i32* %48, align 8, !dbg !302, !tbaa !149
  %50 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 3, !dbg !303
  store i32 %49, i32* %50, align 4, !dbg !304, !tbaa !152
  %51 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 8, !dbg !305
  %52 = load i32, i32* %51, align 4, !dbg !305, !tbaa !154
  %53 = call i32 @llvm.bswap.i32(i32 %52) #3, !dbg !305
  %54 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 2, !dbg !306
  store i32 %53, i32* %54, align 4, !dbg !307, !tbaa !157
  %55 = getelementptr inbounds [10 x i8], [10 x i8]* %5, i64 0, i64 0, !dbg !254
  call void @llvm.lifetime.start.p0i8(i64 10, i8* nonnull %55) #3, !dbg !254
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %55, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @hk_add_hmap.____fmt, i64 0, i64 0), i64 10, i32 1, i1 false) #3, !dbg !254
  %56 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %55, i32 10, i32 %52) #3, !dbg !254
  call void @llvm.lifetime.end.p0i8(i64 10, i8* nonnull %55) #3, !dbg !308
  %57 = load i32, i32* %51, align 4, !dbg !309, !tbaa !154
  %58 = icmp eq i32 %57, 9092, !dbg !310
  br i1 %58, label %59, label %62, !dbg !311

; <label>:59:                                     ; preds = %38
  %60 = bitcast i32* %3 to i8*, !dbg !312
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %60) #3, !dbg !312
  call void @llvm.dbg.value(metadata i32 0, metadata !127, metadata !DIExpression()) #3, !dbg !313
  store i32 0, i32* %3, align 4, !dbg !313, !tbaa !165
  %61 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*), i8* nonnull %60, i8* nonnull %41, i64 0) #3, !dbg !314
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %60) #3, !dbg !315
  br label %62, !dbg !316

; <label>:62:                                     ; preds = %38, %59
  %63 = bitcast %struct.bpf_sock_ops* %0 to i8*, !dbg !317
  %64 = call i32 inttoptr (i64 70 to i32 (i8*, i8*, i8*, i64)*)(i8* %63, i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* nonnull %41, i64 1) #3, !dbg !318
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %41) #3, !dbg !319
  br label %65, !dbg !320

; <label>:65:                                     ; preds = %1, %62, %35
  ret i32 0, !dbg !321
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!57, !58, !59}
!llvm.ident = !{!60}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sock_key_map", scope: !2, file: !3, line: 25, type: !13, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !10)
!3 = !DIFile(filename: "redirector_kern_1.c", directory: "/home/ubuntu/hooker/hooker")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "sk_action", file: !6, line: 2865, size: 32, elements: !7)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/ubuntu/hooker/hooker")
!7 = !{!8, !9}
!8 = !DIEnumerator(name: "SK_DROP", value: 0)
!9 = !DIEnumerator(name: "SK_PASS", value: 1)
!10 = !{!0, !11, !24, !30, !38, !45, !47, !52}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "hooker_map", scope: !2, file: !3, line: 32, type: !13, isLocal: false, isDefinition: true)
!13 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !14, line: 210, size: 224, elements: !15)
!14 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/ubuntu/hooker/hooker")
!15 = !{!16, !18, !19, !20, !21, !22, !23}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !13, file: !14, line: 211, baseType: !17, size: 32)
!17 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !13, file: !14, line: 212, baseType: !17, size: 32, offset: 32)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !13, file: !14, line: 213, baseType: !17, size: 32, offset: 64)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !13, file: !14, line: 214, baseType: !17, size: 32, offset: 96)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !13, file: !14, line: 215, baseType: !17, size: 32, offset: 128)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !13, file: !14, line: 216, baseType: !17, size: 32, offset: 160)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !13, file: !14, line: 217, baseType: !17, size: 32, offset: 192)
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 135, type: !26, isLocal: false, isDefinition: true)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 32, elements: !28)
!27 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!28 = !{!29}
!29 = !DISubrange(count: 4)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !14, line: 38, type: !32, isLocal: true, isDefinition: true)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = !DISubroutineType(types: !34)
!34 = !{!35, !36, !35, null}
!35 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !27)
!38 = !DIGlobalVariableExpression(var: !39, expr: !DIExpression())
!39 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !14, line: 22, type: !40, isLocal: true, isDefinition: true)
!40 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!41 = !DISubroutineType(types: !42)
!42 = !{!35, !43, !43, !43, !44}
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!44 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "bpf_sock_hash_update", scope: !2, file: !14, line: 100, type: !40, isLocal: true, isDefinition: true)
!47 = !DIGlobalVariableExpression(var: !48, expr: !DIExpression())
!48 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !14, line: 20, type: !49, isLocal: true, isDefinition: true)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = !DISubroutineType(types: !51)
!51 = !{!43, !43, !43}
!52 = !DIGlobalVariableExpression(var: !53, expr: !DIExpression())
!53 = distinct !DIGlobalVariable(name: "bpf_msg_redirect_hash", scope: !2, file: !14, line: 113, type: !54, isLocal: true, isDefinition: true)
!54 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !55, size: 64)
!55 = !DISubroutineType(types: !56)
!56 = !{!35, !43, !43, !43, !35}
!57 = !{i32 2, !"Dwarf Version", i32 4}
!58 = !{i32 2, !"Debug Info Version", i32 3}
!59 = !{i32 1, !"wchar_size", i32 4}
!60 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!61 = distinct !DISubprogram(name: "hk_add_hmap", scope: !3, file: !3, line: 40, type: !62, isLocal: false, isDefinition: true, scopeLine: 41, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !111)
!62 = !DISubroutineType(types: !63)
!63 = !{null, !64}
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!65 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock_ops", file: !6, line: 3006, size: 1472, elements: !66)
!66 = !{!67, !70, !77, !78, !79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !95, !96, !97, !98, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !110}
!67 = !DIDerivedType(tag: DW_TAG_member, name: "op", scope: !65, file: !6, line: 3007, baseType: !68, size: 32)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !69, line: 27, baseType: !17)
!69 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/hooker/hooker")
!70 = !DIDerivedType(tag: DW_TAG_member, scope: !65, file: !6, line: 3008, baseType: !71, size: 128, offset: 32)
!71 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !65, file: !6, line: 3008, size: 128, elements: !72)
!72 = !{!73, !75, !76}
!73 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !71, file: !6, line: 3009, baseType: !74, size: 128)
!74 = !DICompositeType(tag: DW_TAG_array_type, baseType: !68, size: 128, elements: !28)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "reply", scope: !71, file: !6, line: 3010, baseType: !68, size: 32)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "replylong", scope: !71, file: !6, line: 3011, baseType: !74, size: 128)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !65, file: !6, line: 3013, baseType: !68, size: 32, offset: 160)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !65, file: !6, line: 3014, baseType: !68, size: 32, offset: 192)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !65, file: !6, line: 3015, baseType: !68, size: 32, offset: 224)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !65, file: !6, line: 3016, baseType: !74, size: 128, offset: 256)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !65, file: !6, line: 3017, baseType: !74, size: 128, offset: 384)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !65, file: !6, line: 3018, baseType: !68, size: 32, offset: 512)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !65, file: !6, line: 3019, baseType: !68, size: 32, offset: 544)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "is_fullsock", scope: !65, file: !6, line: 3020, baseType: !68, size: 32, offset: 576)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "snd_cwnd", scope: !65, file: !6, line: 3024, baseType: !68, size: 32, offset: 608)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "srtt_us", scope: !65, file: !6, line: 3025, baseType: !68, size: 32, offset: 640)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "bpf_sock_ops_cb_flags", scope: !65, file: !6, line: 3026, baseType: !68, size: 32, offset: 672)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !65, file: !6, line: 3027, baseType: !68, size: 32, offset: 704)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "rtt_min", scope: !65, file: !6, line: 3028, baseType: !68, size: 32, offset: 736)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "snd_ssthresh", scope: !65, file: !6, line: 3029, baseType: !68, size: 32, offset: 768)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "rcv_nxt", scope: !65, file: !6, line: 3030, baseType: !68, size: 32, offset: 800)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "snd_nxt", scope: !65, file: !6, line: 3031, baseType: !68, size: 32, offset: 832)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "snd_una", scope: !65, file: !6, line: 3032, baseType: !68, size: 32, offset: 864)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "mss_cache", scope: !65, file: !6, line: 3033, baseType: !68, size: 32, offset: 896)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "ecn_flags", scope: !65, file: !6, line: 3034, baseType: !68, size: 32, offset: 928)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "rate_delivered", scope: !65, file: !6, line: 3035, baseType: !68, size: 32, offset: 960)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "rate_interval_us", scope: !65, file: !6, line: 3036, baseType: !68, size: 32, offset: 992)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "packets_out", scope: !65, file: !6, line: 3037, baseType: !68, size: 32, offset: 1024)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "retrans_out", scope: !65, file: !6, line: 3038, baseType: !68, size: 32, offset: 1056)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "total_retrans", scope: !65, file: !6, line: 3039, baseType: !68, size: 32, offset: 1088)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "segs_in", scope: !65, file: !6, line: 3040, baseType: !68, size: 32, offset: 1120)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "data_segs_in", scope: !65, file: !6, line: 3041, baseType: !68, size: 32, offset: 1152)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "segs_out", scope: !65, file: !6, line: 3042, baseType: !68, size: 32, offset: 1184)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "data_segs_out", scope: !65, file: !6, line: 3043, baseType: !68, size: 32, offset: 1216)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "lost_out", scope: !65, file: !6, line: 3044, baseType: !68, size: 32, offset: 1248)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "sacked_out", scope: !65, file: !6, line: 3045, baseType: !68, size: 32, offset: 1280)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "sk_txhash", scope: !65, file: !6, line: 3046, baseType: !68, size: 32, offset: 1312)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "bytes_received", scope: !65, file: !6, line: 3047, baseType: !109, size: 64, offset: 1344)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !69, line: 31, baseType: !44)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "bytes_acked", scope: !65, file: !6, line: 3048, baseType: !109, size: 64, offset: 1408)
!111 = !{!112, !113, !122, !127}
!112 = !DILocalVariable(name: "skops", arg: 1, scope: !61, file: !3, line: 40, type: !64)
!113 = !DILocalVariable(name: "skey", scope: !61, file: !3, line: 43, type: !114)
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "sock_key_t", file: !115, line: 24, baseType: !116)
!115 = !DIFile(filename: "./../lib/config.h", directory: "/home/ubuntu/hooker/hooker")
!116 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "sock_key", file: !115, line: 25, size: 128, elements: !117)
!117 = !{!118, !119, !120, !121}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "sip4", scope: !116, file: !115, line: 27, baseType: !68, size: 32)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "dip4", scope: !116, file: !115, line: 28, baseType: !68, size: 32, offset: 32)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !116, file: !115, line: 29, baseType: !68, size: 32, offset: 64)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !116, file: !115, line: 30, baseType: !68, size: 32, offset: 96)
!122 = !DILocalVariable(name: "____fmt", scope: !123, file: !3, line: 50, type: !124)
!123 = distinct !DILexicalBlock(scope: !61, file: !3, line: 50, column: 9)
!124 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 80, elements: !125)
!125 = !{!126}
!126 = !DISubrange(count: 10)
!127 = !DILocalVariable(name: "key", scope: !128, file: !3, line: 52, type: !35)
!128 = distinct !DILexicalBlock(scope: !129, file: !3, line: 51, column: 50)
!129 = distinct !DILexicalBlock(scope: !61, file: !3, line: 51, column: 13)
!130 = !DILocation(line: 40, column: 39, scope: !61)
!131 = !DILocation(line: 43, column: 9, scope: !61)
!132 = !DILocation(line: 44, column: 28, scope: !61)
!133 = !{!134, !135, i64 24}
!134 = !{!"bpf_sock_ops", !135, i64 0, !136, i64 4, !135, i64 20, !135, i64 24, !135, i64 28, !136, i64 32, !136, i64 48, !135, i64 64, !135, i64 68, !135, i64 72, !135, i64 76, !135, i64 80, !135, i64 84, !135, i64 88, !135, i64 92, !135, i64 96, !135, i64 100, !135, i64 104, !135, i64 108, !135, i64 112, !135, i64 116, !135, i64 120, !135, i64 124, !135, i64 128, !135, i64 132, !135, i64 136, !135, i64 140, !135, i64 144, !135, i64 148, !135, i64 152, !135, i64 156, !135, i64 160, !135, i64 164, !138, i64 168, !138, i64 176}
!135 = !{!"int", !136, i64 0}
!136 = !{!"omnipotent char", !137, i64 0}
!137 = !{!"Simple C/C++ TBAA"}
!138 = !{!"long long", !136, i64 0}
!139 = !DILocation(line: 44, column: 14, scope: !61)
!140 = !DILocation(line: 44, column: 19, scope: !61)
!141 = !{!142, !135, i64 4}
!142 = !{!"sock_key", !135, i64 0, !135, i64 4, !135, i64 8, !135, i64 12}
!143 = !DILocation(line: 45, column: 28, scope: !61)
!144 = !{!134, !135, i64 28}
!145 = !DILocation(line: 45, column: 14, scope: !61)
!146 = !DILocation(line: 45, column: 19, scope: !61)
!147 = !{!142, !135, i64 0}
!148 = !DILocation(line: 46, column: 29, scope: !61)
!149 = !{!134, !135, i64 64}
!150 = !DILocation(line: 46, column: 14, scope: !61)
!151 = !DILocation(line: 46, column: 20, scope: !61)
!152 = !{!142, !135, i64 12}
!153 = !DILocation(line: 47, column: 22, scope: !61)
!154 = !{!134, !135, i64 68}
!155 = !DILocation(line: 47, column: 14, scope: !61)
!156 = !DILocation(line: 47, column: 20, scope: !61)
!157 = !{!142, !135, i64 8}
!158 = !DILocation(line: 50, column: 9, scope: !123)
!159 = !DILocation(line: 50, column: 9, scope: !61)
!160 = !DILocation(line: 51, column: 20, scope: !129)
!161 = !DILocation(line: 51, column: 31, scope: !129)
!162 = !DILocation(line: 51, column: 13, scope: !61)
!163 = !DILocation(line: 52, column: 17, scope: !128)
!164 = !DILocation(line: 52, column: 21, scope: !128)
!165 = !{!135, !135, i64 0}
!166 = !DILocation(line: 53, column: 17, scope: !128)
!167 = !DILocation(line: 54, column: 9, scope: !129)
!168 = !DILocation(line: 54, column: 9, scope: !128)
!169 = !DILocation(line: 56, column: 30, scope: !61)
!170 = !DILocation(line: 56, column: 9, scope: !61)
!171 = !DILocation(line: 57, column: 1, scope: !61)
!172 = distinct !DISubprogram(name: "redirector_skmsg", scope: !3, file: !3, line: 63, type: !173, isLocal: false, isDefinition: true, scopeLine: 64, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !194)
!173 = !DISubroutineType(types: !174)
!174 = !{!35, !175}
!175 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !176, size: 64)
!176 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "sk_msg_md", file: !6, line: 2873, size: 576, elements: !177)
!177 = !{!178, !182, !186, !187, !188, !189, !190, !191, !192, !193}
!178 = !DIDerivedType(tag: DW_TAG_member, scope: !176, file: !6, line: 2874, baseType: !179, size: 64, align: 64)
!179 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !176, file: !6, line: 2874, size: 64, align: 64, elements: !180)
!180 = !{!181}
!181 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !179, file: !6, line: 2874, baseType: !43, size: 64)
!182 = !DIDerivedType(tag: DW_TAG_member, scope: !176, file: !6, line: 2875, baseType: !183, size: 64, align: 64, offset: 64)
!183 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !176, file: !6, line: 2875, size: 64, align: 64, elements: !184)
!184 = !{!185}
!185 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !183, file: !6, line: 2875, baseType: !43, size: 64)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !176, file: !6, line: 2877, baseType: !68, size: 32, offset: 128)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !176, file: !6, line: 2878, baseType: !68, size: 32, offset: 160)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !176, file: !6, line: 2879, baseType: !68, size: 32, offset: 192)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !176, file: !6, line: 2880, baseType: !74, size: 128, offset: 224)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !176, file: !6, line: 2881, baseType: !74, size: 128, offset: 352)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !176, file: !6, line: 2882, baseType: !68, size: 32, offset: 480)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !176, file: !6, line: 2883, baseType: !68, size: 32, offset: 512)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !176, file: !6, line: 2884, baseType: !68, size: 32, offset: 544)
!194 = !{!195, !196, !197, !198, !199, !205, !206, !208}
!195 = !DILocalVariable(name: "msg", arg: 1, scope: !172, file: !3, line: 63, type: !175)
!196 = !DILocalVariable(name: "flags", scope: !172, file: !3, line: 65, type: !109)
!197 = !DILocalVariable(name: "lport", scope: !172, file: !3, line: 66, type: !68)
!198 = !DILocalVariable(name: "hsock_key", scope: !172, file: !3, line: 67, type: !114)
!199 = !DILocalVariable(name: "____fmt", scope: !200, file: !3, line: 75, type: !202)
!200 = distinct !DILexicalBlock(scope: !201, file: !3, line: 75, column: 17)
!201 = distinct !DILexicalBlock(scope: !172, file: !3, line: 71, column: 23)
!202 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 120, elements: !203)
!203 = !{!204}
!204 = !DISubrange(count: 15)
!205 = !DILocalVariable(name: "key", scope: !201, file: !3, line: 78, type: !35)
!206 = !DILocalVariable(name: "value", scope: !201, file: !3, line: 79, type: !207)
!207 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!208 = !DILocalVariable(name: "c_skey", scope: !201, file: !3, line: 80, type: !114)
!209 = !DILocation(line: 63, column: 40, scope: !172)
!210 = !DILocation(line: 65, column: 15, scope: !172)
!211 = !DILocation(line: 67, column: 9, scope: !172)
!212 = !DILocation(line: 67, column: 20, scope: !172)
!213 = !DILocation(line: 69, column: 22, scope: !172)
!214 = !{!215, !135, i64 64}
!215 = !{!"sk_msg_md", !136, i64 0, !136, i64 8, !135, i64 16, !135, i64 20, !135, i64 24, !136, i64 28, !136, i64 44, !135, i64 60, !135, i64 64, !135, i64 68}
!216 = !DILocation(line: 66, column: 15, scope: !172)
!217 = !DILocation(line: 71, column: 9, scope: !172)
!218 = !DILocation(line: 75, column: 17, scope: !200)
!219 = !DILocation(line: 75, column: 17, scope: !201)
!220 = !DILocation(line: 78, column: 21, scope: !201)
!221 = !DILocation(line: 80, column: 28, scope: !201)
!222 = !DILocation(line: 81, column: 60, scope: !201)
!223 = !DILocation(line: 81, column: 25, scope: !201)
!224 = !DILocation(line: 79, column: 29, scope: !201)
!225 = !DILocation(line: 82, column: 21, scope: !226)
!226 = distinct !DILexicalBlock(scope: !201, file: !3, line: 82, column: 20)
!227 = !DILocation(line: 82, column: 20, scope: !201)
!228 = !DILocation(line: 84, column: 26, scope: !201)
!229 = !{i64 0, i64 4, !165, i64 4, i64 4, !165, i64 8, i64 4, !165, i64 12, i64 4, !165}
!230 = !DILocation(line: 87, column: 39, scope: !201)
!231 = !DILocation(line: 87, column: 17, scope: !201)
!232 = !DILocation(line: 88, column: 17, scope: !201)
!233 = !DILocation(line: 93, column: 39, scope: !201)
!234 = !DILocation(line: 93, column: 17, scope: !201)
!235 = !DILocation(line: 94, column: 17, scope: !201)
!236 = !DILocation(line: 103, column: 1, scope: !172)
!237 = distinct !DISubprogram(name: "redirector_sockops", scope: !3, file: !3, line: 106, type: !238, isLocal: false, isDefinition: true, scopeLine: 107, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !240)
!238 = !DISubroutineType(types: !239)
!239 = !{!35, !64}
!240 = !{!241, !242, !243, !249}
!241 = !DILocalVariable(name: "skops", arg: 1, scope: !237, file: !3, line: 106, type: !64)
!242 = !DILocalVariable(name: "op", scope: !237, file: !3, line: 113, type: !68)
!243 = !DILocalVariable(name: "____fmt", scope: !244, file: !3, line: 118, type: !246)
!244 = distinct !DILexicalBlock(scope: !245, file: !3, line: 118, column: 25)
!245 = distinct !DILexicalBlock(scope: !237, file: !3, line: 115, column: 20)
!246 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 72, elements: !247)
!247 = !{!248}
!248 = !DISubrange(count: 9)
!249 = !DILocalVariable(name: "____fmt", scope: !250, file: !3, line: 123, type: !251)
!250 = distinct !DILexicalBlock(scope: !245, file: !3, line: 123, column: 25)
!251 = !DICompositeType(tag: DW_TAG_array_type, baseType: !27, size: 64, elements: !252)
!252 = !{!253}
!253 = !DISubrange(count: 8)
!254 = !DILocation(line: 50, column: 9, scope: !123, inlinedAt: !255)
!255 = distinct !DILocation(line: 124, column: 25, scope: !245)
!256 = !DILocation(line: 50, column: 9, scope: !123, inlinedAt: !257)
!257 = distinct !DILocation(line: 119, column: 25, scope: !245)
!258 = !DILocation(line: 106, column: 45, scope: !237)
!259 = !DILocation(line: 113, column: 27, scope: !237)
!260 = !{!134, !135, i64 0}
!261 = !DILocation(line: 113, column: 15, scope: !237)
!262 = !DILocation(line: 115, column: 9, scope: !237)
!263 = !DILocation(line: 118, column: 25, scope: !244)
!264 = !DILocation(line: 118, column: 25, scope: !245)
!265 = !DILocation(line: 40, column: 39, scope: !61, inlinedAt: !257)
!266 = !DILocation(line: 43, column: 9, scope: !61, inlinedAt: !257)
!267 = !DILocation(line: 44, column: 28, scope: !61, inlinedAt: !257)
!268 = !DILocation(line: 44, column: 14, scope: !61, inlinedAt: !257)
!269 = !DILocation(line: 44, column: 19, scope: !61, inlinedAt: !257)
!270 = !DILocation(line: 45, column: 28, scope: !61, inlinedAt: !257)
!271 = !DILocation(line: 45, column: 14, scope: !61, inlinedAt: !257)
!272 = !DILocation(line: 45, column: 19, scope: !61, inlinedAt: !257)
!273 = !DILocation(line: 46, column: 29, scope: !61, inlinedAt: !257)
!274 = !DILocation(line: 46, column: 14, scope: !61, inlinedAt: !257)
!275 = !DILocation(line: 46, column: 20, scope: !61, inlinedAt: !257)
!276 = !DILocation(line: 47, column: 22, scope: !61, inlinedAt: !257)
!277 = !DILocation(line: 47, column: 14, scope: !61, inlinedAt: !257)
!278 = !DILocation(line: 47, column: 20, scope: !61, inlinedAt: !257)
!279 = !DILocation(line: 50, column: 9, scope: !61, inlinedAt: !257)
!280 = !DILocation(line: 51, column: 20, scope: !129, inlinedAt: !257)
!281 = !DILocation(line: 51, column: 31, scope: !129, inlinedAt: !257)
!282 = !DILocation(line: 51, column: 13, scope: !61, inlinedAt: !257)
!283 = !DILocation(line: 52, column: 17, scope: !128, inlinedAt: !257)
!284 = !DILocation(line: 52, column: 21, scope: !128, inlinedAt: !257)
!285 = !DILocation(line: 53, column: 17, scope: !128, inlinedAt: !257)
!286 = !DILocation(line: 54, column: 9, scope: !129, inlinedAt: !257)
!287 = !DILocation(line: 54, column: 9, scope: !128, inlinedAt: !257)
!288 = !DILocation(line: 56, column: 30, scope: !61, inlinedAt: !257)
!289 = !DILocation(line: 56, column: 9, scope: !61, inlinedAt: !257)
!290 = !DILocation(line: 57, column: 1, scope: !61, inlinedAt: !257)
!291 = !DILocation(line: 120, column: 17, scope: !245)
!292 = !DILocation(line: 123, column: 25, scope: !250)
!293 = !DILocation(line: 123, column: 25, scope: !245)
!294 = !DILocation(line: 40, column: 39, scope: !61, inlinedAt: !255)
!295 = !DILocation(line: 43, column: 9, scope: !61, inlinedAt: !255)
!296 = !DILocation(line: 44, column: 28, scope: !61, inlinedAt: !255)
!297 = !DILocation(line: 44, column: 14, scope: !61, inlinedAt: !255)
!298 = !DILocation(line: 44, column: 19, scope: !61, inlinedAt: !255)
!299 = !DILocation(line: 45, column: 28, scope: !61, inlinedAt: !255)
!300 = !DILocation(line: 45, column: 14, scope: !61, inlinedAt: !255)
!301 = !DILocation(line: 45, column: 19, scope: !61, inlinedAt: !255)
!302 = !DILocation(line: 46, column: 29, scope: !61, inlinedAt: !255)
!303 = !DILocation(line: 46, column: 14, scope: !61, inlinedAt: !255)
!304 = !DILocation(line: 46, column: 20, scope: !61, inlinedAt: !255)
!305 = !DILocation(line: 47, column: 22, scope: !61, inlinedAt: !255)
!306 = !DILocation(line: 47, column: 14, scope: !61, inlinedAt: !255)
!307 = !DILocation(line: 47, column: 20, scope: !61, inlinedAt: !255)
!308 = !DILocation(line: 50, column: 9, scope: !61, inlinedAt: !255)
!309 = !DILocation(line: 51, column: 20, scope: !129, inlinedAt: !255)
!310 = !DILocation(line: 51, column: 31, scope: !129, inlinedAt: !255)
!311 = !DILocation(line: 51, column: 13, scope: !61, inlinedAt: !255)
!312 = !DILocation(line: 52, column: 17, scope: !128, inlinedAt: !255)
!313 = !DILocation(line: 52, column: 21, scope: !128, inlinedAt: !255)
!314 = !DILocation(line: 53, column: 17, scope: !128, inlinedAt: !255)
!315 = !DILocation(line: 54, column: 9, scope: !129, inlinedAt: !255)
!316 = !DILocation(line: 54, column: 9, scope: !128, inlinedAt: !255)
!317 = !DILocation(line: 56, column: 30, scope: !61, inlinedAt: !255)
!318 = !DILocation(line: 56, column: 9, scope: !61, inlinedAt: !255)
!319 = !DILocation(line: 57, column: 1, scope: !61, inlinedAt: !255)
!320 = !DILocation(line: 126, column: 17, scope: !245)
!321 = !DILocation(line: 132, column: 9, scope: !237)
