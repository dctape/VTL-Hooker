; ModuleID = 'bpf_hooker.c'
source_filename = "bpf_hooker.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.bpf_sock_ops = type { i32, %union.anon, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64, %union.anon.0 }
%union.anon = type { [4 x i32] }
%union.anon.0 = type { %struct.bpf_sock* }
%struct.bpf_sock = type { i32, i32, i32, i32, i32, i32, i32, [4 x i32], i32, i32, i32, [4 x i32], i32 }
%struct.sock_cookie = type { i64 }
%struct.sock_key = type { i32, i32, i32, i32 }
%struct.sk_msg_md = type { %union.anon.1, %union.anon.2, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32 }
%union.anon.1 = type { i8* }
%union.anon.2 = type { i8* }

@LEG_APP_MAP = global %struct.bpf_map_def { i32 18, i32 16, i32 4, i32 64, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@LEG_ADDR_MAP = global %struct.bpf_map_def { i32 1, i32 16, i32 8, i32 64, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !14
@SK_STORAGE_MAP = global %struct.bpf_map_def { i32 24, i32 4, i32 8, i32 0, i32 1, i32 0, i32 0 }, section "maps", align 4, !dbg !27
@hooker_monitor.____fmt = private unnamed_addr constant [23 x i8] c"legacy app registered\0A\00", align 1
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !29
@llvm.used = appending global [6 x i8*] [i8* bitcast (%struct.bpf_map_def* @LEG_ADDR_MAP to i8*), i8* bitcast (%struct.bpf_map_def* @LEG_APP_MAP to i8*), i8* bitcast (%struct.bpf_map_def* @SK_STORAGE_MAP to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.bpf_sock_ops*)* @hooker_monitor to i8*), i8* bitcast (i32 (%struct.sk_msg_md*)* @hooker_redirector to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define void @legapp_register(%struct.bpf_sock_ops*) local_unnamed_addr #0 !dbg !80 {
  %2 = alloca %struct.sock_cookie, align 8
  %3 = alloca %struct.sock_key, align 4
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !151, metadata !DIExpression()), !dbg !163
  %4 = bitcast %struct.sock_cookie* %2 to i8*, !dbg !164
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %4) #3, !dbg !164
  %5 = getelementptr inbounds %struct.sock_cookie, %struct.sock_cookie* %2, i64 0, i32 0, !dbg !165
  %6 = bitcast %struct.sock_key* %3 to i8*, !dbg !166
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %6) #3, !dbg !166
  %7 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 3, !dbg !167
  %8 = load i32, i32* %7, align 8, !dbg !167, !tbaa !168
  %9 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %3, i64 0, i32 1, !dbg !174
  store i32 %8, i32* %9, align 4, !dbg !175, !tbaa !176
  %10 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 4, !dbg !178
  %11 = load i32, i32* %10, align 4, !dbg !178, !tbaa !179
  %12 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %3, i64 0, i32 0, !dbg !180
  store i32 %11, i32* %12, align 4, !dbg !181, !tbaa !182
  %13 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 7, !dbg !183
  %14 = load i32, i32* %13, align 8, !dbg !183, !tbaa !184
  %15 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %3, i64 0, i32 3, !dbg !185
  store i32 %14, i32* %15, align 4, !dbg !186, !tbaa !187
  %16 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 8, !dbg !188
  %17 = load i32, i32* %16, align 4, !dbg !188, !tbaa !189
  %18 = tail call i32 @llvm.bswap.i32(i32 %17), !dbg !188
  %19 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %3, i64 0, i32 2, !dbg !190
  store i32 %18, i32* %19, align 4, !dbg !191, !tbaa !192
  %20 = bitcast %struct.bpf_sock_ops* %0 to i8*, !dbg !193
  %21 = tail call i32 inttoptr (i64 46 to i32 (i8*)*)(i8* %20) #3, !dbg !194
  %22 = sext i32 %21 to i64, !dbg !194
  store i64 %22, i64* %5, align 8, !dbg !195, !tbaa !196
  %23 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @LEG_ADDR_MAP to i8*), i8* nonnull %6, i8* nonnull %4, i64 0) #3, !dbg !198
  %24 = call i32 inttoptr (i64 70 to i32 (i8*, i8*, i8*, i64)*)(i8* %20, i8* bitcast (%struct.bpf_map_def* @LEG_APP_MAP to i8*), i8* nonnull %6, i64 1) #3, !dbg !199
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %6) #3, !dbg !200
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %4) #3, !dbg !200
  ret void, !dbg !200
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
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
define i32 @hooker_monitor(%struct.bpf_sock_ops*) #0 section "sockops" !dbg !201 {
  %2 = alloca %struct.sock_cookie, align 8
  %3 = alloca %struct.sock_key, align 4
  %4 = alloca [23 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !205, metadata !DIExpression()), !dbg !213
  %5 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 0, !dbg !214
  %6 = load i32, i32* %5, align 8, !dbg !214, !tbaa !215
  call void @llvm.dbg.value(metadata i32 %6, metadata !206, metadata !DIExpression()), !dbg !216
  %7 = and i32 %6, -2, !dbg !217
  %8 = icmp eq i32 %7, 4, !dbg !217
  br i1 %8, label %9, label %33, !dbg !217

; <label>:9:                                      ; preds = %1
  %10 = getelementptr inbounds [23 x i8], [23 x i8]* %4, i64 0, i64 0, !dbg !218
  call void @llvm.lifetime.start.p0i8(i64 23, i8* nonnull %10) #3, !dbg !218
  call void @llvm.dbg.declare(metadata [23 x i8]* %4, metadata !207, metadata !DIExpression()), !dbg !218
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %10, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @hooker_monitor.____fmt, i64 0, i64 0), i64 23, i32 1, i1 false), !dbg !218
  %11 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %10, i32 23) #3, !dbg !218
  call void @llvm.lifetime.end.p0i8(i64 23, i8* nonnull %10) #3, !dbg !219
  call void @llvm.dbg.value(metadata %struct.bpf_sock_ops* %0, metadata !151, metadata !DIExpression()) #3, !dbg !220
  %12 = bitcast %struct.sock_cookie* %2 to i8*, !dbg !222
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %12) #3, !dbg !222
  %13 = getelementptr inbounds %struct.sock_cookie, %struct.sock_cookie* %2, i64 0, i32 0, !dbg !223
  %14 = bitcast %struct.sock_key* %3 to i8*, !dbg !224
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %14) #3, !dbg !224
  %15 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 3, !dbg !225
  %16 = load i32, i32* %15, align 8, !dbg !225, !tbaa !168
  %17 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %3, i64 0, i32 1, !dbg !226
  store i32 %16, i32* %17, align 4, !dbg !227, !tbaa !176
  %18 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 4, !dbg !228
  %19 = load i32, i32* %18, align 4, !dbg !228, !tbaa !179
  %20 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %3, i64 0, i32 0, !dbg !229
  store i32 %19, i32* %20, align 4, !dbg !230, !tbaa !182
  %21 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 7, !dbg !231
  %22 = load i32, i32* %21, align 8, !dbg !231, !tbaa !184
  %23 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %3, i64 0, i32 3, !dbg !232
  store i32 %22, i32* %23, align 4, !dbg !233, !tbaa !187
  %24 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 8, !dbg !234
  %25 = load i32, i32* %24, align 4, !dbg !234, !tbaa !189
  %26 = call i32 @llvm.bswap.i32(i32 %25) #3, !dbg !234
  %27 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %3, i64 0, i32 2, !dbg !235
  store i32 %26, i32* %27, align 4, !dbg !236, !tbaa !192
  %28 = bitcast %struct.bpf_sock_ops* %0 to i8*, !dbg !237
  %29 = call i32 inttoptr (i64 46 to i32 (i8*)*)(i8* %28) #3, !dbg !238
  %30 = sext i32 %29 to i64, !dbg !238
  store i64 %30, i64* %13, align 8, !dbg !239, !tbaa !196
  %31 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @LEG_ADDR_MAP to i8*), i8* nonnull %14, i8* nonnull %12, i64 0) #3, !dbg !240
  %32 = call i32 inttoptr (i64 70 to i32 (i8*, i8*, i8*, i64)*)(i8* %28, i8* bitcast (%struct.bpf_map_def* @LEG_APP_MAP to i8*), i8* nonnull %14, i64 1) #3, !dbg !241
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %14) #3, !dbg !242
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %12) #3, !dbg !242
  br label %33, !dbg !243

; <label>:33:                                     ; preds = %1, %9
  ret i32 0, !dbg !244
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #2

; Function Attrs: nounwind
define i32 @hooker_redirector(%struct.sk_msg_md*) #0 section "sk_msg" !dbg !245 {
  %2 = alloca %struct.sock_key, align 4
  %3 = alloca %struct.sock_key, align 4
  call void @llvm.dbg.value(metadata %struct.sk_msg_md* %0, metadata !268, metadata !DIExpression()), !dbg !278
  call void @llvm.dbg.value(metadata i64 1, metadata !269, metadata !DIExpression()), !dbg !279
  %4 = getelementptr inbounds %struct.sk_msg_md, %struct.sk_msg_md* %0, i64 0, i32 8, !dbg !280
  %5 = load i32, i32* %4, align 8, !dbg !280, !tbaa !281
  call void @llvm.dbg.value(metadata i32 %5, metadata !270, metadata !DIExpression()), !dbg !283
  %6 = icmp eq i32 %5, 10002, !dbg !284
  br i1 %6, label %32, label %7, !dbg !285

; <label>:7:                                      ; preds = %1
  %8 = bitcast %struct.sock_key* %2 to i8*, !dbg !286
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %8) #3, !dbg !286
  %9 = bitcast %struct.sock_key* %3 to i8*, !dbg !287
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %9) #3, !dbg !287
  call void @llvm.memset.p0i8.i64(i8* nonnull %9, i8 0, i64 16, i32 4, i1 false), !dbg !288
  %10 = getelementptr inbounds %struct.sk_msg_md, %struct.sk_msg_md* %0, i64 0, i32 3, !dbg !289
  %11 = load i32, i32* %10, align 4, !dbg !289, !tbaa !290
  %12 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 1, !dbg !291
  store i32 %11, i32* %12, align 4, !dbg !292, !tbaa !176
  %13 = getelementptr inbounds %struct.sk_msg_md, %struct.sk_msg_md* %0, i64 0, i32 4, !dbg !293
  %14 = load i32, i32* %13, align 8, !dbg !293, !tbaa !294
  %15 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 0, !dbg !295
  store i32 %14, i32* %15, align 4, !dbg !296, !tbaa !182
  %16 = getelementptr inbounds %struct.sk_msg_md, %struct.sk_msg_md* %0, i64 0, i32 7, !dbg !297
  %17 = load i32, i32* %16, align 4, !dbg !297, !tbaa !298
  %18 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 3, !dbg !299
  store i32 %17, i32* %18, align 4, !dbg !300, !tbaa !187
  %19 = tail call i32 @llvm.bswap.i32(i32 %5), !dbg !301
  %20 = getelementptr inbounds %struct.sock_key, %struct.sock_key* %2, i64 0, i32 2, !dbg !302
  store i32 %19, i32* %20, align 4, !dbg !303, !tbaa !192
  %21 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @SK_STORAGE_MAP to i8*), i8* nonnull %8) #3, !dbg !304
  call void @llvm.dbg.value(metadata i8* %21, metadata !271, metadata !DIExpression()), !dbg !305
  %22 = icmp eq i8* %21, null, !dbg !306
  br i1 %22, label %31, label %23, !dbg !308

; <label>:23:                                     ; preds = %7
  %24 = bitcast %struct.sk_msg_md* %0 to i64**, !dbg !309
  %25 = load i64*, i64** %24, align 8, !dbg !309, !tbaa !310
  call void @llvm.dbg.value(metadata %struct.sk_msg_md* %0, metadata !277, metadata !DIExpression(DW_OP_deref, DW_OP_stack_value)), !dbg !311
  %26 = bitcast %struct.sk_msg_md* %0 to i8*, !dbg !312
  %27 = call i32 inttoptr (i64 90 to i32 (i8*, i32, i32, i32)*)(i8* %26, i32 0, i32 8, i32 0) #3, !dbg !313
  %28 = bitcast i8* %21 to i64*, !dbg !314
  %29 = load i64, i64* %28, align 1, !dbg !314
  store i64 %29, i64* %25, align 1, !dbg !314
  %30 = call i32 inttoptr (i64 71 to i32 (i8*, i8*, i8*, i32)*)(i8* %26, i8* bitcast (%struct.bpf_map_def* @LEG_APP_MAP to i8*), i8* nonnull %9, i32 1) #3, !dbg !315
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %9) #3, !dbg !316
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %8) #3, !dbg !316
  br label %32

; <label>:31:                                     ; preds = %7
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %9) #3, !dbg !316
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %8) #3, !dbg !316
  br label %32

; <label>:32:                                     ; preds = %1, %23, %31
  %33 = phi i32 [ 0, %31 ], [ 1, %23 ], [ 1, %1 ]
  ret i32 %33, !dbg !317
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!76, !77, !78}
!llvm.ident = !{!79}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "LEG_APP_MAP", scope: !2, file: !3, line: 46, type: !16, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !10, globals: !13)
!3 = !DIFile(filename: "bpf_hooker.c", directory: "/home/ubuntu/Hooker/src/bpf")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "sk_action", file: !6, line: 3132, size: 32, elements: !7)
!6 = !DIFile(filename: "./include/linux/bpf.h", directory: "/home/ubuntu/Hooker/src/bpf")
!7 = !{!8, !9}
!8 = !DIEnumerator(name: "SK_DROP", value: 0)
!9 = !DIEnumerator(name: "SK_PASS", value: 1)
!10 = !{!11, !12}
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!12 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!13 = !{!0, !14, !27, !29, !35, !41, !49, !54, !61, !66, !71}
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "LEG_ADDR_MAP", scope: !2, file: !3, line: 53, type: !16, isLocal: false, isDefinition: true)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !17, line: 259, size: 224, elements: !18)
!17 = !DIFile(filename: "./include/bpf/bpf_helpers.h", directory: "/home/ubuntu/Hooker/src/bpf")
!18 = !{!19, !21, !22, !23, !24, !25, !26}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !16, file: !17, line: 260, baseType: !20, size: 32)
!20 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !16, file: !17, line: 261, baseType: !20, size: 32, offset: 32)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !16, file: !17, line: 262, baseType: !20, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !16, file: !17, line: 263, baseType: !20, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !16, file: !17, line: 264, baseType: !20, size: 32, offset: 128)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !16, file: !17, line: 265, baseType: !20, size: 32, offset: 160)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !16, file: !17, line: 266, baseType: !20, size: 32, offset: 192)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "SK_STORAGE_MAP", scope: !2, file: !3, line: 60, type: !16, isLocal: false, isDefinition: true)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 195, type: !31, isLocal: false, isDefinition: true)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 32, elements: !33)
!32 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!33 = !{!34}
!34 = !DISubrange(count: 4)
!35 = !DIGlobalVariableExpression(var: !36, expr: !DIExpression())
!36 = distinct !DIGlobalVariable(name: "bpf_get_socket_cookie", scope: !2, file: !17, line: 96, type: !37, isLocal: true, isDefinition: true)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!38 = !DISubroutineType(types: !39)
!39 = !{!40, !11}
!40 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!41 = !DIGlobalVariableExpression(var: !42, expr: !DIExpression())
!42 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !17, line: 35, type: !43, isLocal: true, isDefinition: true)
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!44 = !DISubroutineType(types: !45)
!45 = !{!40, !11, !46, !46, !48}
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!48 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "bpf_sock_hash_update", scope: !2, file: !17, line: 113, type: !51, isLocal: true, isDefinition: true)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = !DISubroutineType(types: !53)
!53 = !{!40, !11, !11, !11, !48}
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !17, line: 51, type: !56, isLocal: true, isDefinition: true)
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = !DISubroutineType(types: !58)
!58 = !{!40, !59, !40, null}
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!60 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !32)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !17, line: 33, type: !63, isLocal: true, isDefinition: true)
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !64, size: 64)
!64 = !DISubroutineType(types: !65)
!65 = !{!11, !11, !46}
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "bpf_msg_push_data", scope: !2, file: !17, line: 135, type: !68, isLocal: true, isDefinition: true)
!68 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !69, size: 64)
!69 = !DISubroutineType(types: !70)
!70 = !{!40, !11, !40, !40, !40}
!71 = !DIGlobalVariableExpression(var: !72, expr: !DIExpression())
!72 = distinct !DIGlobalVariable(name: "bpf_msg_redirect_hash", scope: !2, file: !17, line: 126, type: !73, isLocal: true, isDefinition: true)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DISubroutineType(types: !75)
!75 = !{!40, !11, !11, !11, !40}
!76 = !{i32 2, !"Dwarf Version", i32 4}
!77 = !{i32 2, !"Debug Info Version", i32 3}
!78 = !{i32 1, !"wchar_size", i32 4}
!79 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!80 = distinct !DISubprogram(name: "legapp_register", scope: !3, file: !3, line: 69, type: !81, isLocal: false, isDefinition: true, scopeLine: 70, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !150)
!81 = !DISubroutineType(types: !82)
!82 = !{null, !83}
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock_ops", file: !6, line: 3275, size: 1536, elements: !85)
!85 = !{!86, !89, !96, !97, !98, !99, !100, !101, !102, !103, !104, !105, !106, !107, !108, !109, !110, !111, !112, !113, !114, !115, !116, !117, !118, !119, !120, !121, !122, !123, !124, !125, !126, !127, !129, !130}
!86 = !DIDerivedType(tag: DW_TAG_member, name: "op", scope: !84, file: !6, line: 3276, baseType: !87, size: 32)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !88, line: 27, baseType: !20)
!88 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/Hooker/src/bpf")
!89 = !DIDerivedType(tag: DW_TAG_member, scope: !84, file: !6, line: 3277, baseType: !90, size: 128, offset: 32)
!90 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !84, file: !6, line: 3277, size: 128, elements: !91)
!91 = !{!92, !94, !95}
!92 = !DIDerivedType(tag: DW_TAG_member, name: "args", scope: !90, file: !6, line: 3278, baseType: !93, size: 128)
!93 = !DICompositeType(tag: DW_TAG_array_type, baseType: !87, size: 128, elements: !33)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "reply", scope: !90, file: !6, line: 3279, baseType: !87, size: 32)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "replylong", scope: !90, file: !6, line: 3280, baseType: !93, size: 128)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !84, file: !6, line: 3282, baseType: !87, size: 32, offset: 160)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !84, file: !6, line: 3283, baseType: !87, size: 32, offset: 192)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !84, file: !6, line: 3284, baseType: !87, size: 32, offset: 224)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !84, file: !6, line: 3285, baseType: !93, size: 128, offset: 256)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !84, file: !6, line: 3286, baseType: !93, size: 128, offset: 384)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !84, file: !6, line: 3287, baseType: !87, size: 32, offset: 512)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !84, file: !6, line: 3288, baseType: !87, size: 32, offset: 544)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "is_fullsock", scope: !84, file: !6, line: 3289, baseType: !87, size: 32, offset: 576)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "snd_cwnd", scope: !84, file: !6, line: 3293, baseType: !87, size: 32, offset: 608)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "srtt_us", scope: !84, file: !6, line: 3294, baseType: !87, size: 32, offset: 640)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "bpf_sock_ops_cb_flags", scope: !84, file: !6, line: 3295, baseType: !87, size: 32, offset: 672)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !84, file: !6, line: 3296, baseType: !87, size: 32, offset: 704)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "rtt_min", scope: !84, file: !6, line: 3297, baseType: !87, size: 32, offset: 736)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "snd_ssthresh", scope: !84, file: !6, line: 3298, baseType: !87, size: 32, offset: 768)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "rcv_nxt", scope: !84, file: !6, line: 3299, baseType: !87, size: 32, offset: 800)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "snd_nxt", scope: !84, file: !6, line: 3300, baseType: !87, size: 32, offset: 832)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "snd_una", scope: !84, file: !6, line: 3301, baseType: !87, size: 32, offset: 864)
!113 = !DIDerivedType(tag: DW_TAG_member, name: "mss_cache", scope: !84, file: !6, line: 3302, baseType: !87, size: 32, offset: 896)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "ecn_flags", scope: !84, file: !6, line: 3303, baseType: !87, size: 32, offset: 928)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "rate_delivered", scope: !84, file: !6, line: 3304, baseType: !87, size: 32, offset: 960)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "rate_interval_us", scope: !84, file: !6, line: 3305, baseType: !87, size: 32, offset: 992)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "packets_out", scope: !84, file: !6, line: 3306, baseType: !87, size: 32, offset: 1024)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "retrans_out", scope: !84, file: !6, line: 3307, baseType: !87, size: 32, offset: 1056)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "total_retrans", scope: !84, file: !6, line: 3308, baseType: !87, size: 32, offset: 1088)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "segs_in", scope: !84, file: !6, line: 3309, baseType: !87, size: 32, offset: 1120)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "data_segs_in", scope: !84, file: !6, line: 3310, baseType: !87, size: 32, offset: 1152)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "segs_out", scope: !84, file: !6, line: 3311, baseType: !87, size: 32, offset: 1184)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "data_segs_out", scope: !84, file: !6, line: 3312, baseType: !87, size: 32, offset: 1216)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "lost_out", scope: !84, file: !6, line: 3313, baseType: !87, size: 32, offset: 1248)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "sacked_out", scope: !84, file: !6, line: 3314, baseType: !87, size: 32, offset: 1280)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "sk_txhash", scope: !84, file: !6, line: 3315, baseType: !87, size: 32, offset: 1312)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "bytes_received", scope: !84, file: !6, line: 3316, baseType: !128, size: 64, offset: 1344)
!128 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !88, line: 31, baseType: !48)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "bytes_acked", scope: !84, file: !6, line: 3317, baseType: !128, size: 64, offset: 1408)
!130 = !DIDerivedType(tag: DW_TAG_member, scope: !84, file: !6, line: 3318, baseType: !131, size: 64, align: 64, offset: 1472)
!131 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !84, file: !6, line: 3318, size: 64, align: 64, elements: !132)
!132 = !{!133}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "sk", scope: !131, file: !6, line: 3318, baseType: !134, size: 64)
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !135, size: 64)
!135 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock", file: !6, line: 3022, size: 608, elements: !136)
!136 = !{!137, !138, !139, !140, !141, !142, !143, !144, !145, !146, !147, !148, !149}
!137 = !DIDerivedType(tag: DW_TAG_member, name: "bound_dev_if", scope: !135, file: !6, line: 3023, baseType: !87, size: 32)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !135, file: !6, line: 3024, baseType: !87, size: 32, offset: 32)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !135, file: !6, line: 3025, baseType: !87, size: 32, offset: 64)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !135, file: !6, line: 3026, baseType: !87, size: 32, offset: 96)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !135, file: !6, line: 3027, baseType: !87, size: 32, offset: 128)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !135, file: !6, line: 3028, baseType: !87, size: 32, offset: 160)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip4", scope: !135, file: !6, line: 3030, baseType: !87, size: 32, offset: 192)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip6", scope: !135, file: !6, line: 3031, baseType: !93, size: 128, offset: 224)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "src_port", scope: !135, file: !6, line: 3032, baseType: !87, size: 32, offset: 352)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "dst_port", scope: !135, file: !6, line: 3033, baseType: !87, size: 32, offset: 384)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip4", scope: !135, file: !6, line: 3034, baseType: !87, size: 32, offset: 416)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip6", scope: !135, file: !6, line: 3035, baseType: !93, size: 128, offset: 448)
!149 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !135, file: !6, line: 3036, baseType: !87, size: 32, offset: 576)
!150 = !{!151, !152, !156}
!151 = !DILocalVariable(name: "skops", arg: 1, scope: !80, file: !3, line: 69, type: !83)
!152 = !DILocalVariable(name: "cookie", scope: !80, file: !3, line: 72, type: !153)
!153 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "sock_cookie", file: !3, line: 41, size: 64, elements: !154)
!154 = !{!155}
!155 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !153, file: !3, line: 42, baseType: !128, size: 64)
!156 = !DILocalVariable(name: "skey", scope: !80, file: !3, line: 75, type: !157)
!157 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "sock_key", file: !3, line: 32, size: 128, elements: !158)
!158 = !{!159, !160, !161, !162}
!159 = !DIDerivedType(tag: DW_TAG_member, name: "sip4", scope: !157, file: !3, line: 34, baseType: !87, size: 32)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "dip4", scope: !157, file: !3, line: 35, baseType: !87, size: 32, offset: 32)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !157, file: !3, line: 36, baseType: !87, size: 32, offset: 64)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !157, file: !3, line: 37, baseType: !87, size: 32, offset: 96)
!163 = !DILocation(line: 69, column: 43, scope: !80)
!164 = !DILocation(line: 72, column: 9, scope: !80)
!165 = !DILocation(line: 72, column: 28, scope: !80)
!166 = !DILocation(line: 75, column: 9, scope: !80)
!167 = !DILocation(line: 76, column: 28, scope: !80)
!168 = !{!169, !170, i64 24}
!169 = !{!"bpf_sock_ops", !170, i64 0, !171, i64 4, !170, i64 20, !170, i64 24, !170, i64 28, !171, i64 32, !171, i64 48, !170, i64 64, !170, i64 68, !170, i64 72, !170, i64 76, !170, i64 80, !170, i64 84, !170, i64 88, !170, i64 92, !170, i64 96, !170, i64 100, !170, i64 104, !170, i64 108, !170, i64 112, !170, i64 116, !170, i64 120, !170, i64 124, !170, i64 128, !170, i64 132, !170, i64 136, !170, i64 140, !170, i64 144, !170, i64 148, !170, i64 152, !170, i64 156, !170, i64 160, !170, i64 164, !173, i64 168, !173, i64 176, !171, i64 184}
!170 = !{!"int", !171, i64 0}
!171 = !{!"omnipotent char", !172, i64 0}
!172 = !{!"Simple C/C++ TBAA"}
!173 = !{!"long long", !171, i64 0}
!174 = !DILocation(line: 76, column: 14, scope: !80)
!175 = !DILocation(line: 76, column: 19, scope: !80)
!176 = !{!177, !170, i64 4}
!177 = !{!"sock_key", !170, i64 0, !170, i64 4, !170, i64 8, !170, i64 12}
!178 = !DILocation(line: 77, column: 28, scope: !80)
!179 = !{!169, !170, i64 28}
!180 = !DILocation(line: 77, column: 14, scope: !80)
!181 = !DILocation(line: 77, column: 19, scope: !80)
!182 = !{!177, !170, i64 0}
!183 = !DILocation(line: 78, column: 29, scope: !80)
!184 = !{!169, !170, i64 64}
!185 = !DILocation(line: 78, column: 14, scope: !80)
!186 = !DILocation(line: 78, column: 20, scope: !80)
!187 = !{!177, !170, i64 12}
!188 = !DILocation(line: 79, column: 22, scope: !80)
!189 = !{!169, !170, i64 68}
!190 = !DILocation(line: 79, column: 14, scope: !80)
!191 = !DILocation(line: 79, column: 20, scope: !80)
!192 = !{!177, !170, i64 8}
!193 = !DILocation(line: 82, column: 44, scope: !80)
!194 = !DILocation(line: 82, column: 22, scope: !80)
!195 = !DILocation(line: 82, column: 20, scope: !80)
!196 = !{!197, !173, i64 0}
!197 = !{!"sock_cookie", !173, i64 0}
!198 = !DILocation(line: 85, column: 9, scope: !80)
!199 = !DILocation(line: 88, column: 9, scope: !80)
!200 = !DILocation(line: 89, column: 1, scope: !80)
!201 = distinct !DISubprogram(name: "hooker_monitor", scope: !3, file: !3, line: 92, type: !202, isLocal: false, isDefinition: true, scopeLine: 93, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !204)
!202 = !DISubroutineType(types: !203)
!203 = !{!40, !83}
!204 = !{!205, !206, !207}
!205 = !DILocalVariable(name: "skops", arg: 1, scope: !201, file: !3, line: 92, type: !83)
!206 = !DILocalVariable(name: "op", scope: !201, file: !3, line: 96, type: !87)
!207 = !DILocalVariable(name: "____fmt", scope: !208, file: !3, line: 103, type: !210)
!208 = distinct !DILexicalBlock(scope: !209, file: !3, line: 103, column: 17)
!209 = distinct !DILexicalBlock(scope: !201, file: !3, line: 99, column: 9)
!210 = !DICompositeType(tag: DW_TAG_array_type, baseType: !32, size: 184, elements: !211)
!211 = !{!212}
!212 = !DISubrange(count: 23)
!213 = !DILocation(line: 92, column: 41, scope: !201)
!214 = !DILocation(line: 96, column: 27, scope: !201)
!215 = !{!169, !170, i64 0}
!216 = !DILocation(line: 96, column: 15, scope: !201)
!217 = !DILocation(line: 98, column: 9, scope: !201)
!218 = !DILocation(line: 103, column: 17, scope: !208)
!219 = !DILocation(line: 103, column: 17, scope: !209)
!220 = !DILocation(line: 69, column: 43, scope: !80, inlinedAt: !221)
!221 = distinct !DILocation(line: 104, column: 17, scope: !209)
!222 = !DILocation(line: 72, column: 9, scope: !80, inlinedAt: !221)
!223 = !DILocation(line: 72, column: 28, scope: !80, inlinedAt: !221)
!224 = !DILocation(line: 75, column: 9, scope: !80, inlinedAt: !221)
!225 = !DILocation(line: 76, column: 28, scope: !80, inlinedAt: !221)
!226 = !DILocation(line: 76, column: 14, scope: !80, inlinedAt: !221)
!227 = !DILocation(line: 76, column: 19, scope: !80, inlinedAt: !221)
!228 = !DILocation(line: 77, column: 28, scope: !80, inlinedAt: !221)
!229 = !DILocation(line: 77, column: 14, scope: !80, inlinedAt: !221)
!230 = !DILocation(line: 77, column: 19, scope: !80, inlinedAt: !221)
!231 = !DILocation(line: 78, column: 29, scope: !80, inlinedAt: !221)
!232 = !DILocation(line: 78, column: 14, scope: !80, inlinedAt: !221)
!233 = !DILocation(line: 78, column: 20, scope: !80, inlinedAt: !221)
!234 = !DILocation(line: 79, column: 22, scope: !80, inlinedAt: !221)
!235 = !DILocation(line: 79, column: 14, scope: !80, inlinedAt: !221)
!236 = !DILocation(line: 79, column: 20, scope: !80, inlinedAt: !221)
!237 = !DILocation(line: 82, column: 44, scope: !80, inlinedAt: !221)
!238 = !DILocation(line: 82, column: 22, scope: !80, inlinedAt: !221)
!239 = !DILocation(line: 82, column: 20, scope: !80, inlinedAt: !221)
!240 = !DILocation(line: 85, column: 9, scope: !80, inlinedAt: !221)
!241 = !DILocation(line: 88, column: 9, scope: !80, inlinedAt: !221)
!242 = !DILocation(line: 89, column: 1, scope: !80, inlinedAt: !221)
!243 = !DILocation(line: 106, column: 17, scope: !209)
!244 = !DILocation(line: 112, column: 9, scope: !201)
!245 = distinct !DISubprogram(name: "hooker_redirector", scope: !3, file: !3, line: 116, type: !246, isLocal: false, isDefinition: true, scopeLine: 117, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !267)
!246 = !DISubroutineType(types: !247)
!247 = !{!40, !248}
!248 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !249, size: 64)
!249 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "sk_msg_md", file: !6, line: 3140, size: 576, elements: !250)
!250 = !{!251, !255, !259, !260, !261, !262, !263, !264, !265, !266}
!251 = !DIDerivedType(tag: DW_TAG_member, scope: !249, file: !6, line: 3141, baseType: !252, size: 64, align: 64)
!252 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !249, file: !6, line: 3141, size: 64, align: 64, elements: !253)
!253 = !{!254}
!254 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !252, file: !6, line: 3141, baseType: !11, size: 64)
!255 = !DIDerivedType(tag: DW_TAG_member, scope: !249, file: !6, line: 3142, baseType: !256, size: 64, align: 64, offset: 64)
!256 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !249, file: !6, line: 3142, size: 64, align: 64, elements: !257)
!257 = !{!258}
!258 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !256, file: !6, line: 3142, baseType: !11, size: 64)
!259 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !249, file: !6, line: 3144, baseType: !87, size: 32, offset: 128)
!260 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !249, file: !6, line: 3145, baseType: !87, size: 32, offset: 160)
!261 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !249, file: !6, line: 3146, baseType: !87, size: 32, offset: 192)
!262 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !249, file: !6, line: 3147, baseType: !93, size: 128, offset: 224)
!263 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !249, file: !6, line: 3148, baseType: !93, size: 128, offset: 352)
!264 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !249, file: !6, line: 3149, baseType: !87, size: 32, offset: 480)
!265 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !249, file: !6, line: 3150, baseType: !87, size: 32, offset: 512)
!266 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !249, file: !6, line: 3151, baseType: !87, size: 32, offset: 544)
!267 = !{!268, !269, !270, !271, !275, !276, !277}
!268 = !DILocalVariable(name: "msg", arg: 1, scope: !245, file: !3, line: 116, type: !248)
!269 = !DILocalVariable(name: "flags", scope: !245, file: !3, line: 121, type: !128)
!270 = !DILocalVariable(name: "lport", scope: !245, file: !3, line: 122, type: !87)
!271 = !DILocalVariable(name: "cookie", scope: !272, file: !3, line: 138, type: !274)
!272 = distinct !DILexicalBlock(scope: !273, file: !3, line: 134, column: 14)
!273 = distinct !DILexicalBlock(scope: !245, file: !3, line: 127, column: 13)
!274 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !153, size: 64)
!275 = !DILocalVariable(name: "skey", scope: !272, file: !3, line: 140, type: !157)
!276 = !DILocalVariable(name: "hkey", scope: !272, file: !3, line: 141, type: !157)
!277 = !DILocalVariable(name: "data", scope: !272, file: !3, line: 154, type: !11)
!278 = !DILocation(line: 116, column: 41, scope: !245)
!279 = !DILocation(line: 121, column: 15, scope: !245)
!280 = !DILocation(line: 124, column: 22, scope: !245)
!281 = !{!282, !170, i64 64}
!282 = !{!"sk_msg_md", !171, i64 0, !171, i64 8, !170, i64 16, !170, i64 20, !170, i64 24, !171, i64 28, !171, i64 44, !170, i64 60, !170, i64 64, !170, i64 68}
!283 = !DILocation(line: 122, column: 15, scope: !245)
!284 = !DILocation(line: 127, column: 19, scope: !273)
!285 = !DILocation(line: 127, column: 13, scope: !245)
!286 = !DILocation(line: 140, column: 17, scope: !272)
!287 = !DILocation(line: 141, column: 17, scope: !272)
!288 = !DILocation(line: 141, column: 33, scope: !272)
!289 = !DILocation(line: 143, column: 34, scope: !272)
!290 = !{!282, !170, i64 20}
!291 = !DILocation(line: 143, column: 22, scope: !272)
!292 = !DILocation(line: 143, column: 27, scope: !272)
!293 = !DILocation(line: 144, column: 34, scope: !272)
!294 = !{!282, !170, i64 24}
!295 = !DILocation(line: 144, column: 22, scope: !272)
!296 = !DILocation(line: 144, column: 27, scope: !272)
!297 = !DILocation(line: 145, column: 35, scope: !272)
!298 = !{!282, !170, i64 60}
!299 = !DILocation(line: 145, column: 22, scope: !272)
!300 = !DILocation(line: 145, column: 28, scope: !272)
!301 = !DILocation(line: 146, column: 30, scope: !272)
!302 = !DILocation(line: 146, column: 22, scope: !272)
!303 = !DILocation(line: 146, column: 28, scope: !272)
!304 = !DILocation(line: 148, column: 26, scope: !272)
!305 = !DILocation(line: 138, column: 37, scope: !272)
!306 = !DILocation(line: 149, column: 22, scope: !307)
!307 = distinct !DILexicalBlock(scope: !272, file: !3, line: 149, column: 21)
!308 = !DILocation(line: 149, column: 21, scope: !272)
!309 = !DILocation(line: 154, column: 49, scope: !272)
!310 = !{!171, !171, i64 0}
!311 = !DILocation(line: 154, column: 23, scope: !272)
!312 = !DILocation(line: 155, column: 35, scope: !272)
!313 = !DILocation(line: 155, column: 17, scope: !272)
!314 = !DILocation(line: 156, column: 17, scope: !272)
!315 = !DILocation(line: 159, column: 17, scope: !272)
!316 = !DILocation(line: 160, column: 9, scope: !273)
!317 = !DILocation(line: 193, column: 1, scope: !245)
