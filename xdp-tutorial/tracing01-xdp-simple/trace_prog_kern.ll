; ModuleID = 'trace_prog_kern.c'
source_filename = "trace_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_exception_ctx = type { i64, i32, i32, i32 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 5, i32 4, i32 8, i32 10, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !15
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_exception_ctx*)* @trace_xdp_exception to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @trace_xdp_exception(%struct.xdp_exception_ctx* nocapture readonly) #0 section "tracepoint/xdp/xdp_exception" !dbg !48 {
  %2 = alloca i32, align 4
  %3 = alloca i64, align 8
  call void @llvm.dbg.value(metadata %struct.xdp_exception_ctx* %0, metadata !63, metadata !DIExpression()), !dbg !70
  %4 = bitcast i32* %2 to i8*, !dbg !71
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4) #3, !dbg !71
  %5 = getelementptr inbounds %struct.xdp_exception_ctx, %struct.xdp_exception_ctx* %0, i64 0, i32 3, !dbg !72
  %6 = load i32, i32* %5, align 8, !dbg !72, !tbaa !73
  call void @llvm.dbg.value(metadata i32 %6, metadata !64, metadata !DIExpression()), !dbg !79
  store i32 %6, i32* %2, align 4, !dbg !79, !tbaa !80
  %7 = getelementptr inbounds %struct.xdp_exception_ctx, %struct.xdp_exception_ctx* %0, i64 0, i32 2, !dbg !81
  %8 = load i32, i32* %7, align 4, !dbg !81, !tbaa !83
  %9 = icmp eq i32 %8, 0, !dbg !84
  br i1 %9, label %10, label %22, !dbg !85

; <label>:10:                                     ; preds = %1
  %11 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %4) #3, !dbg !86
  %12 = bitcast i8* %11 to i32*, !dbg !86
  call void @llvm.dbg.value(metadata i32* %12, metadata !65, metadata !DIExpression()), !dbg !87
  %13 = icmp eq i8* %11, null, !dbg !88
  br i1 %13, label %14, label %19, !dbg !89

; <label>:14:                                     ; preds = %10
  %15 = bitcast i64* %3 to i8*, !dbg !90
  call void @llvm.lifetime.start.p0i8(i64 8, i8* nonnull %15) #3, !dbg !90
  call void @llvm.dbg.value(metadata i64 1, metadata !67, metadata !DIExpression()), !dbg !91
  store i64 1, i64* %3, align 8, !dbg !91, !tbaa !92
  %16 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %4, i8* nonnull %15, i64 0) #3, !dbg !93
  %17 = icmp ne i32 %16, 0, !dbg !93
  %18 = zext i1 %17 to i32, !dbg !93
  call void @llvm.lifetime.end.p0i8(i64 8, i8* nonnull %15) #3, !dbg !94
  br label %22

; <label>:19:                                     ; preds = %10
  %20 = load i32, i32* %12, align 4, !dbg !95, !tbaa !80
  %21 = add i32 %20, 1, !dbg !95
  store i32 %21, i32* %12, align 4, !dbg !95, !tbaa !80
  br label %22, !dbg !96

; <label>:22:                                     ; preds = %1, %19, %14
  %23 = phi i32 [ 0, %19 ], [ %18, %14 ], [ 0, %1 ], !dbg !97
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #3, !dbg !98
  ret i32 %23, !dbg !98
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!44, !45, !46}
!llvm.ident = !{!47}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !3, line: 5, type: !35, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !14, nameTableKind: None)
!3 = !DIFile(filename: "trace_prog_kern.c", directory: "/home/fedora/xdp-tutorial/tracing01-xdp-simple")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/fedora/xdp-tutorial/tracing01-xdp-simple")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !{!0, !15, !21, !28}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 44, type: !17, isLocal: false, isDefinition: true)
!17 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 32, elements: !19)
!18 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!19 = !{!20}
!20 = !DISubrange(count: 4)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !23, line: 20, type: !24, isLocal: true, isDefinition: true)
!23 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/fedora/xdp-tutorial/tracing01-xdp-simple")
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DISubroutineType(types: !26)
!26 = !{!27, !27, !27}
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = !DIGlobalVariableExpression(var: !29, expr: !DIExpression())
!29 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !23, line: 22, type: !30, isLocal: true, isDefinition: true)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DISubroutineType(types: !32)
!32 = !{!33, !27, !27, !27, !34}
!33 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!34 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!35 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !23, line: 210, size: 224, elements: !36)
!36 = !{!37, !38, !39, !40, !41, !42, !43}
!37 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !35, file: !23, line: 211, baseType: !7, size: 32)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !35, file: !23, line: 212, baseType: !7, size: 32, offset: 32)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !35, file: !23, line: 213, baseType: !7, size: 32, offset: 64)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !35, file: !23, line: 214, baseType: !7, size: 32, offset: 96)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !35, file: !23, line: 215, baseType: !7, size: 32, offset: 128)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !35, file: !23, line: 216, baseType: !7, size: 32, offset: 160)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !35, file: !23, line: 217, baseType: !7, size: 32, offset: 192)
!44 = !{i32 2, !"Dwarf Version", i32 4}
!45 = !{i32 2, !"Debug Info Version", i32 3}
!46 = !{i32 1, !"wchar_size", i32 4}
!47 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!48 = distinct !DISubprogram(name: "trace_xdp_exception", scope: !3, file: !3, line: 20, type: !49, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !62)
!49 = !DISubroutineType(types: !50)
!50 = !{!33, !51}
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_exception_ctx", file: !3, line: 12, size: 192, elements: !53)
!53 = !{!54, !57, !59, !61}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "__pad", scope: !52, file: !3, line: 13, baseType: !55, size: 64)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !56, line: 31, baseType: !34)
!56 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!57 = !DIDerivedType(tag: DW_TAG_member, name: "prog_id", scope: !52, file: !3, line: 14, baseType: !58, size: 32, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__s32", file: !56, line: 26, baseType: !33)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "act", scope: !52, file: !3, line: 15, baseType: !60, size: 32, offset: 96)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !56, line: 27, baseType: !7)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !52, file: !3, line: 16, baseType: !58, size: 32, offset: 128)
!62 = !{!63, !64, !65, !67}
!63 = !DILocalVariable(name: "ctx", arg: 1, scope: !48, file: !3, line: 20, type: !51)
!64 = !DILocalVariable(name: "key", scope: !48, file: !3, line: 22, type: !58)
!65 = !DILocalVariable(name: "valp", scope: !48, file: !3, line: 23, type: !66)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!67 = !DILocalVariable(name: "one", scope: !68, file: !3, line: 36, type: !55)
!68 = distinct !DILexicalBlock(scope: !69, file: !3, line: 35, column: 13)
!69 = distinct !DILexicalBlock(scope: !48, file: !3, line: 35, column: 6)
!70 = !DILocation(line: 20, column: 51, scope: !48)
!71 = !DILocation(line: 22, column: 2, scope: !48)
!72 = !DILocation(line: 22, column: 19, scope: !48)
!73 = !{!74, !78, i64 16}
!74 = !{!"xdp_exception_ctx", !75, i64 0, !78, i64 8, !78, i64 12, !78, i64 16}
!75 = !{!"long long", !76, i64 0}
!76 = !{!"omnipotent char", !77, i64 0}
!77 = !{!"Simple C/C++ TBAA"}
!78 = !{!"int", !76, i64 0}
!79 = !DILocation(line: 22, column: 8, scope: !48)
!80 = !{!78, !78, i64 0}
!81 = !DILocation(line: 26, column: 11, scope: !82)
!82 = distinct !DILexicalBlock(scope: !48, file: !3, line: 26, column: 6)
!83 = !{!74, !78, i64 12}
!84 = !DILocation(line: 26, column: 15, scope: !82)
!85 = !DILocation(line: 26, column: 6, scope: !48)
!86 = !DILocation(line: 30, column: 9, scope: !48)
!87 = !DILocation(line: 23, column: 9, scope: !48)
!88 = !DILocation(line: 35, column: 7, scope: !69)
!89 = !DILocation(line: 35, column: 6, scope: !48)
!90 = !DILocation(line: 36, column: 3, scope: !68)
!91 = !DILocation(line: 36, column: 9, scope: !68)
!92 = !{!75, !75, i64 0}
!93 = !DILocation(line: 37, column: 10, scope: !68)
!94 = !DILocation(line: 38, column: 2, scope: !69)
!95 = !DILocation(line: 40, column: 9, scope: !48)
!96 = !DILocation(line: 41, column: 2, scope: !48)
!97 = !DILocation(line: 0, scope: !48)
!98 = !DILocation(line: 42, column: 1, scope: !48)
