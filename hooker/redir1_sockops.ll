; ModuleID = 'redir1_sockops.c'
source_filename = "redir1_sockops.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.bpf_sock_ops = type { i32, %union.anon, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64 }
%union.anon = type { [4 x i32] }
%struct.sock_key = type { i32, i32, i32, i32 }

@sock_key_map = global %struct.bpf_map_def { i32 2, i32 4, i32 16, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@hooker_map = global %struct.bpf_map_def { i32 18, i32 16, i32 4, i32 20, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !6
@hk_add_hmap.____fmt = private unnamed_addr constant [10 x i8] c"sport: %d\00", align 1
@redirector_sockops.____fmt = private unnamed_addr constant [9 x i8] c"serveur\0A\00", align 1
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !20
@llvm.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* bitcast (i32 (%struct.bpf_sock_ops*)* @redirector_sockops to i8*), i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define void @hk_add_hmap(%struct.bpf_sock_ops*) local_unnamed_addr #0 !dbg !47 {
  %2 = alloca %struct.sock_key, align 4
  %3 = alloca [10 x i8], align 1
  %4 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !99, metadata !DIExpression()), !dbg !117
  %5 = bitcast %struct.sock_key* %2 to i8*, !dbg !118
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %5) #3, !dbg !118
  %6 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 3, !dbg !119
  %7 = load i32, i32* %6, align 8, !dbg !119, !tbaa !120
  %8 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 1, !dbg !126
  store i32 %7, i32* %8, align 4, !dbg !127, !tbaa !128
  %9 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 4, !dbg !130
  %10 = load i32, i32* %9, align 4, !dbg !130, !tbaa !131
  %11 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 0, !dbg !132
  store i32 %10, i32* %11, align 4, !dbg !133, !tbaa !134
  %12 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 7, !dbg !135
  %13 = load i32, i32* %12, align 8, !dbg !135, !tbaa !136
  %14 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 3, !dbg !137
  store i32 %13, i32* %14, align 4, !dbg !138, !tbaa !139
  %15 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 8, !dbg !140
  %16 = load i32, i32* %15, align 4, !dbg !140, !tbaa !141
  %17 = tail call i32 @llvm.bswap.i32(i32 %16), !dbg !140
  %18 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 2, !dbg !142
  store i32 %17, i32* %18, align 4, !dbg !143, !tbaa !144
  %19 = getelementptr inbounds [10 x i8], [10 x i8]* %3, i64 0, i64 0, !dbg !145
  call void @llvm.lifetime.start.p0i8(i64 10, i8* nonnull %19) #3, !dbg !145
  call void @llvm.dbg.declare(metadata [10 x i8]* %3, metadata !109, metadata !DIExpression()), !dbg !145
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %19, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @hk_add_hmap.____fmt, i64 0, i64 0), i64 10, i32 1, i1 false), !dbg !145
  %20 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %19, i32 10, i32 %16) #3, !dbg !145
  call void @llvm.lifetime.end.p0i8(i64 10, i8* nonnull %19) #3, !dbg !146
  %21 = load i32, i32* %15, align 4, !dbg !147, !tbaa !141
  %22 = icmp eq i32 %21, 9092, !dbg !148
  br i1 %22, label %23, label %26, !dbg !149

; <label>:23:                                     ; preds = %1
  %24 = bitcast i32* %4 to i8*, !dbg !150
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %24) #3, !dbg !150
  call void @llvm.dbg.value(metadata i32 0, metadata !114, metadata !DIExpression()), !dbg !151
  store i32 0, i32* %4, align 4, !dbg !151, !tbaa !152
  %25 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*), i8* nonnull %24, i8* nonnull %5, i64 0) #3, !dbg !153
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %24) #3, !dbg !154
  br label %26, !dbg !155

; <label>:26:                                     ; preds = %23, %1
  %27 = bitcast %struct.bpf_sock_ops* %0 to i8*, !dbg !156
  %28 = call i32 inttoptr (i64 70 to i32 (i8*, i8*, i8*, i64)*)(i8* %27, i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* nonnull %5, i64 1) #3, !dbg !157
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %5) #3, !dbg !158
  ret void, !dbg !158
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind readnone speculatable
declare i32 @llvm.bswap.i32(i32) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
define i32 @redirector_sockops(%struct.bpf_sock_ops*) #0 section "sockops" !dbg !159 {
  %2 = alloca %struct.sock_key, align 4
  %3 = alloca i32, align 4
  %4 = alloca %struct.sock_key, align 4
  %5 = alloca [10 x i8], align 1
  call void @llvm.dbg.declare(metadata [10 x i8]* %5, metadata !109, metadata !DIExpression()), !dbg !176
  call void @llvm.dbg.declare(metadata [10 x i8]* %5, metadata !109, metadata !DIExpression()), !dbg !178
  %6 = alloca i32, align 4
  %7 = alloca [9 x i8], align 1
  %8 = alloca i64, align 8
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !163, metadata !DIExpression()), !dbg !180
  %9 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 0, !dbg !181
  %10 = load i32, i32* %9, align 8, !dbg !181, !tbaa !182
  call void @llvm.dbg.value(metadata i32 %10, metadata !164, metadata !DIExpression()), !dbg !183
  switch i32 %10, label %65 [
    i32 5, label %11
    i32 4, label %38
  ], !dbg !184

; <label>:11:                                     ; preds = %1
  %12 = getelementptr inbounds [9 x i8], [9 x i8]* %7, i64 0, i64 0, !dbg !185
  call void @llvm.lifetime.start.p0i8(i64 9, i8* nonnull %12) #3, !dbg !185
  call void @llvm.dbg.declare(metadata [9 x i8]* %7, metadata !165, metadata !DIExpression()), !dbg !185
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %12, i8* getelementptr inbounds ([9 x i8], [9 x i8]* @redirector_sockops.____fmt, i64 0, i64 0), i64 9, i32 1, i1 false), !dbg !185
  %13 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %12, i32 9) #3, !dbg !185
  call void @llvm.lifetime.end.p0i8(i64 9, i8* nonnull %12) #3, !dbg !186
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !99, metadata !DIExpression()) #3, !dbg !187
  %14 = bitcast %struct.sock_key* %4 to i8*, !dbg !188
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %14) #3, !dbg !188
  %15 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 3, !dbg !189
  %16 = load i32, i32* %15, align 8, !dbg !189, !tbaa !120
  %17 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %4, i64 0, i32 1, !dbg !190
  store i32 %16, i32* %17, align 4, !dbg !191, !tbaa !128
  %18 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 4, !dbg !192
  %19 = load i32, i32* %18, align 4, !dbg !192, !tbaa !131
  %20 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %4, i64 0, i32 0, !dbg !193
  store i32 %19, i32* %20, align 4, !dbg !194, !tbaa !134
  %21 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 7, !dbg !195
  %22 = load i32, i32* %21, align 8, !dbg !195, !tbaa !136
  %23 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %4, i64 0, i32 3, !dbg !196
  store i32 %22, i32* %23, align 4, !dbg !197, !tbaa !139
  %24 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 8, !dbg !198
  %25 = load i32, i32* %24, align 4, !dbg !198, !tbaa !141
  %26 = call i32 @llvm.bswap.i32(i32 %25) #3, !dbg !198
  %27 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %4, i64 0, i32 2, !dbg !199
  store i32 %26, i32* %27, align 4, !dbg !200, !tbaa !144
  %28 = getelementptr inbounds [10 x i8], [10 x i8]* %5, i64 0, i64 0, !dbg !178
  call void @llvm.lifetime.start.p0i8(i64 10, i8* nonnull %28) #3, !dbg !178
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %28, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @hk_add_hmap.____fmt, i64 0, i64 0), i64 10, i32 1, i1 false) #3, !dbg !178
  %29 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %28, i32 10, i32 %25) #3, !dbg !178
  call void @llvm.lifetime.end.p0i8(i64 10, i8* nonnull %28) #3, !dbg !201
  %30 = load i32, i32* %24, align 4, !dbg !202, !tbaa !141
  %31 = icmp eq i32 %30, 9092, !dbg !203
  br i1 %31, label %32, label %35, !dbg !204

; <label>:32:                                     ; preds = %11
  %33 = bitcast i32* %6 to i8*, !dbg !205
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %33) #3, !dbg !205
  call void @llvm.dbg.value(metadata i32 0, metadata !114, metadata !DIExpression()) #3, !dbg !206
  store i32 0, i32* %6, align 4, !dbg !206, !tbaa !152
  %34 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*), i8* nonnull %33, i8* nonnull %14, i64 0) #3, !dbg !207
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %33) #3, !dbg !208
  br label %35, !dbg !209

; <label>:35:                                     ; preds = %11, %32
  %36 = bitcast %struct.bpf_sock_ops* %0 to i8*, !dbg !210
  %37 = call i32 inttoptr (i64 70 to i32 (i8*, i8*, i8*, i64)*)(i8* %36, i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* nonnull %14, i64 1) #3, !dbg !211
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %14) #3, !dbg !212
  br label %65, !dbg !213

; <label>:38:                                     ; preds = %1
  %39 = bitcast i64* %8 to i8*, !dbg !214
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %39) #3, !dbg !214
  call void @llvm.dbg.value(metadata i64 2942767263738979, metadata !171, metadata !DIExpression()), !dbg !214
  store i64 2942767263738979, i64* %8, align 8, !dbg !214
  %40 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %39, i32 8) #3, !dbg !214
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %39) #3, !dbg !215
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !99, metadata !DIExpression()) #3, !dbg !216
  %41 = bitcast %struct.sock_key* %2 to i8*, !dbg !217
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %41) #3, !dbg !217
  %42 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 3, !dbg !218
  %43 = load i32, i32* %42, align 8, !dbg !218, !tbaa !120
  %44 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 1, !dbg !219
  store i32 %43, i32* %44, align 4, !dbg !220, !tbaa !128
  %45 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 4, !dbg !221
  %46 = load i32, i32* %45, align 4, !dbg !221, !tbaa !131
  %47 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 0, !dbg !222
  store i32 %46, i32* %47, align 4, !dbg !223, !tbaa !134
  %48 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 7, !dbg !224
  %49 = load i32, i32* %48, align 8, !dbg !224, !tbaa !136
  %50 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 3, !dbg !225
  store i32 %49, i32* %50, align 4, !dbg !226, !tbaa !139
  %51 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 8, !dbg !227
  %52 = load i32, i32* %51, align 4, !dbg !227, !tbaa !141
  %53 = call i32 @llvm.bswap.i32(i32 %52) #3, !dbg !227
  %54 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 2, !dbg !228
  store i32 %53, i32* %54, align 4, !dbg !229, !tbaa !144
  %55 = getelementptr inbounds [10 x i8], [10 x i8]* %5, i64 0, i64 0, !dbg !176
  call void @llvm.lifetime.start.p0i8(i64 10, i8* nonnull %55) #3, !dbg !176
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %55, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @hk_add_hmap.____fmt, i64 0, i64 0), i64 10, i32 1, i1 false) #3, !dbg !176
  %56 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %55, i32 10, i32 %52) #3, !dbg !176
  call void @llvm.lifetime.end.p0i8(i64 10, i8* nonnull %55) #3, !dbg !230
  %57 = load i32, i32* %51, align 4, !dbg !231, !tbaa !141
  %58 = icmp eq i32 %57, 9092, !dbg !232
  br i1 %58, label %59, label %62, !dbg !233

; <label>:59:                                     ; preds = %38
  %60 = bitcast i32* %3 to i8*, !dbg !234
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %60) #3, !dbg !234
  call void @llvm.dbg.value(metadata i32 0, metadata !114, metadata !DIExpression()) #3, !dbg !235
  store i32 0, i32* %3, align 4, !dbg !235, !tbaa !152
  %61 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*), i8* nonnull %60, i8* nonnull %41, i64 0) #3, !dbg !236
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %60) #3, !dbg !237
  br label %62, !dbg !238

; <label>:62:                                     ; preds = %38, %59
  %63 = bitcast %struct.bpf_sock_ops* %0 to i8*, !dbg !239
  %64 = call i32 inttoptr (i64 70 to i32 (i8*, i8*, i8*, i64)*)(i8* %63, i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* nonnull %41, i64 1) #3, !dbg !240
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %41) #3, !dbg !241
  br label %65, !dbg !242

; <label>:65:                                     ; preds = %1, %62, %35
  ret i32 0, !dbg !243
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!43, !44, !45}
!llvm.ident = !{!46}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sock_key_map", scope: !2, file: !8, line: 14, type: !9, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5)
!3 = !DIFile(filename: "redir1_sockops.c", directory: "/home/ubuntu/hooker/hooker")
!4 = !{}
!5 = !{!0, !6, !20, !26, !34, !41}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "hooker_map", scope: !2, file: !8, line: 22, type: !9, isLocal: false, isDefinition: true)
!8 = !DIFile(filename: "./../lib/maps.h", directory: "/home/ubuntu/hooker/hooker")
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !10, line: 210, size: 224, elements: !11)
!10 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/ubuntu/hooker/hooker")
!11 = !{!12, !14, !15, !16, !17, !18, !19}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !9, file: !10, line: 211, baseType: !13, size: 32)
!13 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!14 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !9, file: !10, line: 212, baseType: !13, size: 32, offset: 32)
!15 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !9, file: !10, line: 213, baseType: !13, size: 32, offset: 64)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !9, file: !10, line: 214, baseType: !13, size: 32, offset: 96)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !9, file: !10, line: 215, baseType: !13, size: 32, offset: 128)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !9, file: !10, line: 216, baseType: !13, size: 32, offset: 160)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !9, file: !10, line: 217, baseType: !13, size: 32, offset: 192)
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 74, type: !22, isLocal: false, isDefinition: true)
!22 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 32, elements: !24)
!23 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!24 = !{!25}
!25 = !DISubrange(count: 4)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !10, line: 38, type: !28, isLocal: true, isDefinition: true)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DISubroutineType(types: !30)
!30 = !{!31, !32, !31, null}
!31 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !23)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !10, line: 22, type: !36, isLocal: true, isDefinition: true)
!36 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !37, size: 64)
!37 = !DISubroutineType(types: !38)
!38 = !{!31, !39, !39, !39, !40}
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!40 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "bpf_sock_hash_update", scope: !2, file: !10, line: 100, type: !36, isLocal: true, isDefinition: true)
!43 = !{i32 2, !"Dwarf Version", i32 4}
!44 = !{i32 2, !"Debug Info Version", i32 3}
!45 = !{i32 1, !"wchar_size", i32 4}
!46 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!47 = distinct !DISubprogram(name: "hk_add_hmap", scope: !3, file: !3, line: 24, type: !48, isLocal: false, isDefinition: true, scopeLine: 25, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !98)
!48 = !DISubroutineType(types: !49)
!49 = !{null, !50}
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock_ops", file: !52, line: 3006, size: 1472, elements: !53)
!52 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/ubuntu/hooker/hooker")
!53 = !{!54, !57, !64, !65, !66, !67, !68, !69, !70, !71, !72, !73, !74, !75, !76, !77, !78, !79, !80, !81, !82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !95, !97}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "op", scope: !51, file: !52, line: 3007, baseType: !55, size: 32)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !56, line: 27, baseType: !13)
!56 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/hooker/hooker")
!57 = !DIDerivedType(tag: DW_TAG_member, scope: !51, file: !52, line: 3008, baseType: !58, size: 128, offset: 32)
!58 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !51, file: !52, line: 3008, size: 128, elements: !59)
!59 = !{!60, !62, !63}
!60 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !58, file: !52, line: 3009, baseType: !61, size: 128)
!61 = !DICompositeType(tag: DW_TAG_array_type, baseType: !55, size: 128, elements: !24)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "reply", scope: !58, file: !52, line: 3010, baseType: !55, size: 32)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "replylong", scope: !58, file: !52, line: 3011, baseType: !61, size: 128)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !51, file: !52, line: 3013, baseType: !55, size: 32, offset: 160)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !51, file: !52, line: 3014, baseType: !55, size: 32, offset: 192)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !51, file: !52, line: 3015, baseType: !55, size: 32, offset: 224)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !51, file: !52, line: 3016, baseType: !61, size: 128, offset: 256)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !51, file: !52, line: 3017, baseType: !61, size: 128, offset: 384)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !51, file: !52, line: 3018, baseType: !55, size: 32, offset: 512)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !51, file: !52, line: 3019, baseType: !55, size: 32, offset: 544)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "is_fullsock", scope: !51, file: !52, line: 3020, baseType: !55, size: 32, offset: 576)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "snd_cwnd", scope: !51, file: !52, line: 3024, baseType: !55, size: 32, offset: 608)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "srtt_us", scope: !51, file: !52, line: 3025, baseType: !55, size: 32, offset: 640)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "bpf_sock_ops_cb_flags", scope: !51, file: !52, line: 3026, baseType: !55, size: 32, offset: 672)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !51, file: !52, line: 3027, baseType: !55, size: 32, offset: 704)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "rtt_min", scope: !51, file: !52, line: 3028, baseType: !55, size: 32, offset: 736)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "snd_ssthresh", scope: !51, file: !52, line: 3029, baseType: !55, size: 32, offset: 768)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "rcv_nxt", scope: !51, file: !52, line: 3030, baseType: !55, size: 32, offset: 800)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "snd_nxt", scope: !51, file: !52, line: 3031, baseType: !55, size: 32, offset: 832)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "snd_una", scope: !51, file: !52, line: 3032, baseType: !55, size: 32, offset: 864)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "mss_cache", scope: !51, file: !52, line: 3033, baseType: !55, size: 32, offset: 896)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "ecn_flags", scope: !51, file: !52, line: 3034, baseType: !55, size: 32, offset: 928)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "rate_delivered", scope: !51, file: !52, line: 3035, baseType: !55, size: 32, offset: 960)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "rate_interval_us", scope: !51, file: !52, line: 3036, baseType: !55, size: 32, offset: 992)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "packets_out", scope: !51, file: !52, line: 3037, baseType: !55, size: 32, offset: 1024)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "retrans_out", scope: !51, file: !52, line: 3038, baseType: !55, size: 32, offset: 1056)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "total_retrans", scope: !51, file: !52, line: 3039, baseType: !55, size: 32, offset: 1088)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "segs_in", scope: !51, file: !52, line: 3040, baseType: !55, size: 32, offset: 1120)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "data_segs_in", scope: !51, file: !52, line: 3041, baseType: !55, size: 32, offset: 1152)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "segs_out", scope: !51, file: !52, line: 3042, baseType: !55, size: 32, offset: 1184)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "data_segs_out", scope: !51, file: !52, line: 3043, baseType: !55, size: 32, offset: 1216)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "lost_out", scope: !51, file: !52, line: 3044, baseType: !55, size: 32, offset: 1248)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "sacked_out", scope: !51, file: !52, line: 3045, baseType: !55, size: 32, offset: 1280)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "sk_txhash", scope: !51, file: !52, line: 3046, baseType: !55, size: 32, offset: 1312)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "bytes_received", scope: !51, file: !52, line: 3047, baseType: !96, size: 64, offset: 1344)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !56, line: 31, baseType: !40)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "bytes_acked", scope: !51, file: !52, line: 3048, baseType: !96, size: 64, offset: 1408)
!98 = !{!99, !100, !109, !114}
!99 = !DILocalVariable(name: "skops", arg: 1, scope: !47, file: !3, line: 24, type: !50)
!100 = !DILocalVariable(name: "skey", scope: !47, file: !3, line: 27, type: !101)
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "sock_key_t", file: !102, line: 24, baseType: !103)
!102 = !DIFile(filename: "./../lib/config.h", directory: "/home/ubuntu/hooker/hooker")
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "sock_key", file: !102, line: 25, size: 128, elements: !104)
!104 = !{!105, !106, !107, !108}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "sip4", scope: !103, file: !102, line: 27, baseType: !55, size: 32)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "dip4", scope: !103, file: !102, line: 28, baseType: !55, size: 32, offset: 32)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !103, file: !102, line: 29, baseType: !55, size: 32, offset: 64)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !103, file: !102, line: 30, baseType: !55, size: 32, offset: 96)
!109 = !DILocalVariable(name: "____fmt", scope: !110, file: !3, line: 34, type: !111)
!110 = distinct !DILexicalBlock(scope: !47, file: !3, line: 34, column: 5)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 80, elements: !112)
!112 = !{!113}
!113 = !DISubrange(count: 10)
!114 = !DILocalVariable(name: "key", scope: !115, file: !3, line: 36, type: !31)
!115 = distinct !DILexicalBlock(scope: !116, file: !3, line: 35, column: 45)
!116 = distinct !DILexicalBlock(scope: !47, file: !3, line: 35, column: 8)
!117 = !DILocation(line: 24, column: 39, scope: !47)
!118 = !DILocation(line: 27, column: 5, scope: !47)
!119 = !DILocation(line: 28, column: 24, scope: !47)
!120 = !{!121, !122, i64 24}
!121 = !{!"bpf_sock_ops", !122, i64 0, !123, i64 4, !122, i64 20, !122, i64 24, !122, i64 28, !123, i64 32, !123, i64 48, !122, i64 64, !122, i64 68, !122, i64 72, !122, i64 76, !122, i64 80, !122, i64 84, !122, i64 88, !122, i64 92, !122, i64 96, !122, i64 100, !122, i64 104, !122, i64 108, !122, i64 112, !122, i64 116, !122, i64 120, !122, i64 124, !122, i64 128, !122, i64 132, !122, i64 136, !122, i64 140, !122, i64 144, !122, i64 148, !122, i64 152, !122, i64 156, !122, i64 160, !122, i64 164, !125, i64 168, !125, i64 176}
!122 = !{!"int", !123, i64 0}
!123 = !{!"omnipotent char", !124, i64 0}
!124 = !{!"Simple C/C++ TBAA"}
!125 = !{!"long long", !123, i64 0}
!126 = !DILocation(line: 28, column: 10, scope: !47)
!127 = !DILocation(line: 28, column: 15, scope: !47)
!128 = !{!129, !122, i64 4}
!129 = !{!"sock_key", !122, i64 0, !122, i64 4, !122, i64 8, !122, i64 12}
!130 = !DILocation(line: 29, column: 24, scope: !47)
!131 = !{!121, !122, i64 28}
!132 = !DILocation(line: 29, column: 10, scope: !47)
!133 = !DILocation(line: 29, column: 15, scope: !47)
!134 = !{!129, !122, i64 0}
!135 = !DILocation(line: 30, column: 25, scope: !47)
!136 = !{!121, !122, i64 64}
!137 = !DILocation(line: 30, column: 10, scope: !47)
!138 = !DILocation(line: 30, column: 16, scope: !47)
!139 = !{!129, !122, i64 12}
!140 = !DILocation(line: 31, column: 18, scope: !47)
!141 = !{!121, !122, i64 68}
!142 = !DILocation(line: 31, column: 10, scope: !47)
!143 = !DILocation(line: 31, column: 16, scope: !47)
!144 = !{!129, !122, i64 8}
!145 = !DILocation(line: 34, column: 5, scope: !110)
!146 = !DILocation(line: 34, column: 5, scope: !47)
!147 = !DILocation(line: 35, column: 15, scope: !116)
!148 = !DILocation(line: 35, column: 26, scope: !116)
!149 = !DILocation(line: 35, column: 8, scope: !47)
!150 = !DILocation(line: 36, column: 9, scope: !115)
!151 = !DILocation(line: 36, column: 13, scope: !115)
!152 = !{!122, !122, i64 0}
!153 = !DILocation(line: 37, column: 9, scope: !115)
!154 = !DILocation(line: 38, column: 5, scope: !116)
!155 = !DILocation(line: 38, column: 5, scope: !115)
!156 = !DILocation(line: 40, column: 26, scope: !47)
!157 = !DILocation(line: 40, column: 5, scope: !47)
!158 = !DILocation(line: 41, column: 1, scope: !47)
!159 = distinct !DISubprogram(name: "redirector_sockops", scope: !3, file: !3, line: 44, type: !160, isLocal: false, isDefinition: true, scopeLine: 45, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !162)
!160 = !DISubroutineType(types: !161)
!161 = !{!31, !50}
!162 = !{!163, !164, !165, !171}
!163 = !DILocalVariable(name: "skops", arg: 1, scope: !159, file: !3, line: 44, type: !50)
!164 = !DILocalVariable(name: "op", scope: !159, file: !3, line: 51, type: !55)
!165 = !DILocalVariable(name: "____fmt", scope: !166, file: !3, line: 56, type: !168)
!166 = distinct !DILexicalBlock(scope: !167, file: !3, line: 56, column: 17)
!167 = distinct !DILexicalBlock(scope: !159, file: !3, line: 53, column: 15)
!168 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 72, elements: !169)
!169 = !{!170}
!170 = !DISubrange(count: 9)
!171 = !DILocalVariable(name: "____fmt", scope: !172, file: !3, line: 61, type: !173)
!172 = distinct !DILexicalBlock(scope: !167, file: !3, line: 61, column: 17)
!173 = !DICompositeType(tag: DW_TAG_array_type, baseType: !23, size: 64, elements: !174)
!174 = !{!175}
!175 = !DISubrange(count: 8)
!176 = !DILocation(line: 34, column: 5, scope: !110, inlinedAt: !177)
!177 = distinct !DILocation(line: 62, column: 17, scope: !167)
!178 = !DILocation(line: 34, column: 5, scope: !110, inlinedAt: !179)
!179 = distinct !DILocation(line: 57, column: 17, scope: !167)
!180 = !DILocation(line: 44, column: 45, scope: !159)
!181 = !DILocation(line: 51, column: 23, scope: !159)
!182 = !{!121, !122, i64 0}
!183 = !DILocation(line: 51, column: 11, scope: !159)
!184 = !DILocation(line: 53, column: 5, scope: !159)
!185 = !DILocation(line: 56, column: 17, scope: !166)
!186 = !DILocation(line: 56, column: 17, scope: !167)
!187 = !DILocation(line: 24, column: 39, scope: !47, inlinedAt: !179)
!188 = !DILocation(line: 27, column: 5, scope: !47, inlinedAt: !179)
!189 = !DILocation(line: 28, column: 24, scope: !47, inlinedAt: !179)
!190 = !DILocation(line: 28, column: 10, scope: !47, inlinedAt: !179)
!191 = !DILocation(line: 28, column: 15, scope: !47, inlinedAt: !179)
!192 = !DILocation(line: 29, column: 24, scope: !47, inlinedAt: !179)
!193 = !DILocation(line: 29, column: 10, scope: !47, inlinedAt: !179)
!194 = !DILocation(line: 29, column: 15, scope: !47, inlinedAt: !179)
!195 = !DILocation(line: 30, column: 25, scope: !47, inlinedAt: !179)
!196 = !DILocation(line: 30, column: 10, scope: !47, inlinedAt: !179)
!197 = !DILocation(line: 30, column: 16, scope: !47, inlinedAt: !179)
!198 = !DILocation(line: 31, column: 18, scope: !47, inlinedAt: !179)
!199 = !DILocation(line: 31, column: 10, scope: !47, inlinedAt: !179)
!200 = !DILocation(line: 31, column: 16, scope: !47, inlinedAt: !179)
!201 = !DILocation(line: 34, column: 5, scope: !47, inlinedAt: !179)
!202 = !DILocation(line: 35, column: 15, scope: !116, inlinedAt: !179)
!203 = !DILocation(line: 35, column: 26, scope: !116, inlinedAt: !179)
!204 = !DILocation(line: 35, column: 8, scope: !47, inlinedAt: !179)
!205 = !DILocation(line: 36, column: 9, scope: !115, inlinedAt: !179)
!206 = !DILocation(line: 36, column: 13, scope: !115, inlinedAt: !179)
!207 = !DILocation(line: 37, column: 9, scope: !115, inlinedAt: !179)
!208 = !DILocation(line: 38, column: 5, scope: !116, inlinedAt: !179)
!209 = !DILocation(line: 38, column: 5, scope: !115, inlinedAt: !179)
!210 = !DILocation(line: 40, column: 26, scope: !47, inlinedAt: !179)
!211 = !DILocation(line: 40, column: 5, scope: !47, inlinedAt: !179)
!212 = !DILocation(line: 41, column: 1, scope: !47, inlinedAt: !179)
!213 = !DILocation(line: 58, column: 13, scope: !167)
!214 = !DILocation(line: 61, column: 17, scope: !172)
!215 = !DILocation(line: 61, column: 17, scope: !167)
!216 = !DILocation(line: 24, column: 39, scope: !47, inlinedAt: !177)
!217 = !DILocation(line: 27, column: 5, scope: !47, inlinedAt: !177)
!218 = !DILocation(line: 28, column: 24, scope: !47, inlinedAt: !177)
!219 = !DILocation(line: 28, column: 10, scope: !47, inlinedAt: !177)
!220 = !DILocation(line: 28, column: 15, scope: !47, inlinedAt: !177)
!221 = !DILocation(line: 29, column: 24, scope: !47, inlinedAt: !177)
!222 = !DILocation(line: 29, column: 10, scope: !47, inlinedAt: !177)
!223 = !DILocation(line: 29, column: 15, scope: !47, inlinedAt: !177)
!224 = !DILocation(line: 30, column: 25, scope: !47, inlinedAt: !177)
!225 = !DILocation(line: 30, column: 10, scope: !47, inlinedAt: !177)
!226 = !DILocation(line: 30, column: 16, scope: !47, inlinedAt: !177)
!227 = !DILocation(line: 31, column: 18, scope: !47, inlinedAt: !177)
!228 = !DILocation(line: 31, column: 10, scope: !47, inlinedAt: !177)
!229 = !DILocation(line: 31, column: 16, scope: !47, inlinedAt: !177)
!230 = !DILocation(line: 34, column: 5, scope: !47, inlinedAt: !177)
!231 = !DILocation(line: 35, column: 15, scope: !116, inlinedAt: !177)
!232 = !DILocation(line: 35, column: 26, scope: !116, inlinedAt: !177)
!233 = !DILocation(line: 35, column: 8, scope: !47, inlinedAt: !177)
!234 = !DILocation(line: 36, column: 9, scope: !115, inlinedAt: !177)
!235 = !DILocation(line: 36, column: 13, scope: !115, inlinedAt: !177)
!236 = !DILocation(line: 37, column: 9, scope: !115, inlinedAt: !177)
!237 = !DILocation(line: 38, column: 5, scope: !116, inlinedAt: !177)
!238 = !DILocation(line: 38, column: 5, scope: !115, inlinedAt: !177)
!239 = !DILocation(line: 40, column: 26, scope: !47, inlinedAt: !177)
!240 = !DILocation(line: 40, column: 5, scope: !47, inlinedAt: !177)
!241 = !DILocation(line: 41, column: 1, scope: !47, inlinedAt: !177)
!242 = !DILocation(line: 64, column: 13, scope: !167)
!243 = !DILocation(line: 70, column: 5, scope: !159)
