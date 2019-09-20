; ModuleID = 'xdp_sample_pkts_kern.c'
source_filename = "xdp_sample_pkts_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.S = type { i16, i16 }

@my_map = dso_local global %struct.bpf_map_def { i32 4, i32 4, i32 4, i32 128, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@__const.xdp_sample_prog.____fmt = private unnamed_addr constant [30 x i8] c"perf_event_output failed: %d\0A\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !23
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @my_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_sample_prog to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_sample_prog(%struct.xdp_md*) #0 section "xdp_sample" !dbg !56 {
  %2 = alloca %struct.S, align 2
  %3 = alloca [30 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !69, metadata !DIExpression()), !dbg !88
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !89
  %5 = load i32, i32* %4, align 4, !dbg !89, !tbaa !90
  %6 = zext i32 %5 to i64, !dbg !95
  %7 = inttoptr i64 %6 to i8*, !dbg !96
  call void @llvm.dbg.value(metadata i8* %7, metadata !70, metadata !DIExpression()), !dbg !97
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !98
  %9 = load i32, i32* %8, align 4, !dbg !98, !tbaa !99
  %10 = zext i32 %9 to i64, !dbg !100
  %11 = inttoptr i64 %10 to i8*, !dbg !101
  call void @llvm.dbg.value(metadata i8* %11, metadata !71, metadata !DIExpression()), !dbg !102
  %12 = icmp ult i8* %11, %7, !dbg !103
  br i1 %12, label %13, label %31, !dbg !104

; <label>:13:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i64 4294967295, metadata !72, metadata !DIExpression()), !dbg !105
  %14 = bitcast %struct.S* %2 to i8*, !dbg !106
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %14) #3, !dbg !106
  %15 = getelementptr inbounds %struct.S, %struct.S* %2, i64 0, i32 0, !dbg !107
  store i16 -8531, i16* %15, align 2, !dbg !108, !tbaa !109
  %16 = sub nsw i64 %6, %10, !dbg !112
  %17 = trunc i64 %16 to i16, !dbg !113
  %18 = getelementptr inbounds %struct.S, %struct.S* %2, i64 0, i32 1, !dbg !114
  store i16 %17, i16* %18, align 2, !dbg !115, !tbaa !116
  %19 = and i64 %16, 65535, !dbg !117
  %20 = icmp ult i64 %19, 1024, !dbg !117
  %21 = select i1 %20, i64 %19, i64 1024, !dbg !117
  call void @llvm.dbg.value(metadata i64 %21, metadata !75, metadata !DIExpression()), !dbg !118
  %22 = shl nuw nsw i64 %21, 32, !dbg !119
  %23 = or i64 %22, 4294967295, !dbg !120
  call void @llvm.dbg.value(metadata i64 %23, metadata !72, metadata !DIExpression()), !dbg !105
  %24 = bitcast %struct.xdp_md* %0 to i8*, !dbg !121
  %25 = call i32 inttoptr (i64 25 to i32 (i8*, i8*, i64, i8*, i32)*)(i8* %24, i8* bitcast (%struct.bpf_map_def* @my_map to i8*), i64 %23, i8* nonnull %14, i32 4) #3, !dbg !122
  call void @llvm.dbg.value(metadata i32 %25, metadata !76, metadata !DIExpression()), !dbg !123
  %26 = icmp eq i32 %25, 0, !dbg !124
  br i1 %26, label %30, label %27, !dbg !125

; <label>:27:                                     ; preds = %13
  %28 = getelementptr inbounds [30 x i8], [30 x i8]* %3, i64 0, i64 0, !dbg !126
  call void @llvm.lifetime.start.p0i8(i64 30, i8* nonnull %28) #3, !dbg !126
  call void @llvm.dbg.declare(metadata [30 x i8]* %3, metadata !82, metadata !DIExpression()), !dbg !126
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 %28, i8* align 1 getelementptr inbounds ([30 x i8], [30 x i8]* @__const.xdp_sample_prog.____fmt, i64 0, i64 0), i64 30, i1 false), !dbg !126
  %29 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %28, i32 30, i32 %25) #3, !dbg !126
  call void @llvm.lifetime.end.p0i8(i64 30, i8* nonnull %28) #3, !dbg !127
  br label %30, !dbg !127

; <label>:30:                                     ; preds = %13, %27
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %14) #3, !dbg !128
  br label %31, !dbg !129

; <label>:31:                                     ; preds = %30, %1
  ret i32 2, !dbg !130
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!52, !53, !54}
!llvm.ident = !{!55}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "my_map", scope: !2, file: !3, line: 27, type: !43, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !22, nameTableKind: None)
!3 = !DIFile(filename: "xdp_sample_pkts_kern.c", directory: "/home/fedora/xdp-tutorial/tracing04-xdp-tcpdump")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/fedora/xdp-tutorial/tracing04-xdp-tcpdump")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !{!15, !16, !17, !20}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !18, line: 24, baseType: !19)
!18 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!19 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !18, line: 31, baseType: !21)
!21 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!22 = !{!0, !23, !29, !36}
!23 = !DIGlobalVariableExpression(var: !24, expr: !DIExpression())
!24 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 71, type: !25, isLocal: false, isDefinition: true)
!25 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 32, elements: !27)
!26 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!27 = !{!28}
!28 = !DISubrange(count: 4)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "bpf_perf_event_output", scope: !2, file: !31, line: 59, type: !32, isLocal: true, isDefinition: true)
!31 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/fedora/xdp-tutorial/tracing04-xdp-tcpdump")
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = !DISubroutineType(types: !34)
!34 = !{!35, !15, !15, !21, !15, !35}
!35 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !31, line: 38, type: !38, isLocal: true, isDefinition: true)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DISubroutineType(types: !40)
!40 = !{!35, !41, !35, null}
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!43 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !31, line: 210, size: 224, elements: !44)
!44 = !{!45, !46, !47, !48, !49, !50, !51}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !43, file: !31, line: 211, baseType: !7, size: 32)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !43, file: !31, line: 212, baseType: !7, size: 32, offset: 32)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !43, file: !31, line: 213, baseType: !7, size: 32, offset: 64)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !43, file: !31, line: 214, baseType: !7, size: 32, offset: 96)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !43, file: !31, line: 215, baseType: !7, size: 32, offset: 128)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !43, file: !31, line: 216, baseType: !7, size: 32, offset: 160)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !43, file: !31, line: 217, baseType: !7, size: 32, offset: 192)
!52 = !{i32 2, !"Dwarf Version", i32 4}
!53 = !{i32 2, !"Debug Info Version", i32 3}
!54 = !{i32 1, !"wchar_size", i32 4}
!55 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!56 = distinct !DISubprogram(name: "xdp_sample_prog", scope: !3, file: !3, line: 35, type: !57, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !68)
!57 = !DISubroutineType(types: !58)
!58 = !{!35, !59}
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!60 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !61)
!61 = !{!62, !64, !65, !66, !67}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !60, file: !6, line: 2857, baseType: !63, size: 32)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !18, line: 27, baseType: !7)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !60, file: !6, line: 2858, baseType: !63, size: 32, offset: 32)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !60, file: !6, line: 2859, baseType: !63, size: 32, offset: 64)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !60, file: !6, line: 2861, baseType: !63, size: 32, offset: 96)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !60, file: !6, line: 2862, baseType: !63, size: 32, offset: 128)
!68 = !{!69, !70, !71, !72, !75, !76, !77, !82}
!69 = !DILocalVariable(name: "ctx", arg: 1, scope: !56, file: !3, line: 35, type: !59)
!70 = !DILocalVariable(name: "data_end", scope: !56, file: !3, line: 37, type: !15)
!71 = !DILocalVariable(name: "data", scope: !56, file: !3, line: 38, type: !15)
!72 = !DILocalVariable(name: "flags", scope: !73, file: !3, line: 51, type: !20)
!73 = distinct !DILexicalBlock(scope: !74, file: !3, line: 40, column: 23)
!74 = distinct !DILexicalBlock(scope: !56, file: !3, line: 40, column: 6)
!75 = !DILocalVariable(name: "sample_size", scope: !73, file: !3, line: 52, type: !17)
!76 = !DILocalVariable(name: "ret", scope: !73, file: !3, line: 53, type: !35)
!77 = !DILocalVariable(name: "metadata", scope: !73, file: !3, line: 54, type: !78)
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "S", file: !3, line: 22, size: 32, elements: !79)
!79 = !{!80, !81}
!80 = !DIDerivedType(tag: DW_TAG_member, name: "cookie", scope: !78, file: !3, line: 23, baseType: !17, size: 16)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_len", scope: !78, file: !3, line: 24, baseType: !17, size: 16, offset: 16)
!82 = !DILocalVariable(name: "____fmt", scope: !83, file: !3, line: 65, type: !85)
!83 = distinct !DILexicalBlock(scope: !84, file: !3, line: 65, column: 4)
!84 = distinct !DILexicalBlock(scope: !73, file: !3, line: 64, column: 7)
!85 = !DICompositeType(tag: DW_TAG_array_type, baseType: !26, size: 240, elements: !86)
!86 = !{!87}
!87 = !DISubrange(count: 30)
!88 = !DILocation(line: 35, column: 36, scope: !56)
!89 = !DILocation(line: 37, column: 38, scope: !56)
!90 = !{!91, !92, i64 4}
!91 = !{!"xdp_md", !92, i64 0, !92, i64 4, !92, i64 8, !92, i64 12, !92, i64 16}
!92 = !{!"int", !93, i64 0}
!93 = !{!"omnipotent char", !94, i64 0}
!94 = !{!"Simple C/C++ TBAA"}
!95 = !DILocation(line: 37, column: 27, scope: !56)
!96 = !DILocation(line: 37, column: 19, scope: !56)
!97 = !DILocation(line: 37, column: 8, scope: !56)
!98 = !DILocation(line: 38, column: 34, scope: !56)
!99 = !{!91, !92, i64 0}
!100 = !DILocation(line: 38, column: 23, scope: !56)
!101 = !DILocation(line: 38, column: 15, scope: !56)
!102 = !DILocation(line: 38, column: 8, scope: !56)
!103 = !DILocation(line: 40, column: 11, scope: !74)
!104 = !DILocation(line: 40, column: 6, scope: !56)
!105 = !DILocation(line: 51, column: 9, scope: !73)
!106 = !DILocation(line: 54, column: 3, scope: !73)
!107 = !DILocation(line: 56, column: 12, scope: !73)
!108 = !DILocation(line: 56, column: 19, scope: !73)
!109 = !{!110, !111, i64 0}
!110 = !{!"S", !111, i64 0, !111, i64 2}
!111 = !{!"short", !93, i64 0}
!112 = !DILocation(line: 57, column: 39, scope: !73)
!113 = !DILocation(line: 57, column: 22, scope: !73)
!114 = !DILocation(line: 57, column: 12, scope: !73)
!115 = !DILocation(line: 57, column: 20, scope: !73)
!116 = !{!110, !111, i64 2}
!117 = !DILocation(line: 58, column: 17, scope: !73)
!118 = !DILocation(line: 52, column: 9, scope: !73)
!119 = !DILocation(line: 60, column: 31, scope: !73)
!120 = !DILocation(line: 60, column: 9, scope: !73)
!121 = !DILocation(line: 62, column: 31, scope: !73)
!122 = !DILocation(line: 62, column: 9, scope: !73)
!123 = !DILocation(line: 53, column: 7, scope: !73)
!124 = !DILocation(line: 64, column: 7, scope: !84)
!125 = !DILocation(line: 64, column: 7, scope: !73)
!126 = !DILocation(line: 65, column: 4, scope: !83)
!127 = !DILocation(line: 65, column: 4, scope: !84)
!128 = !DILocation(line: 66, column: 2, scope: !74)
!129 = !DILocation(line: 66, column: 2, scope: !73)
!130 = !DILocation(line: 68, column: 2, scope: !56)
