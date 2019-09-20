; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !21
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_parser_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_parser_func(%struct.xdp_md* nocapture readonly) #0 section "xdp_packet_parser" !dbg !47 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !61, metadata !DIExpression()), !dbg !84
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !85
  %4 = load i32, i32* %3, align 4, !dbg !85, !tbaa !86
  %5 = zext i32 %4 to i64, !dbg !91
  %6 = inttoptr i64 %5 to i8*, !dbg !92
  call void @llvm.dbg.value(metadata i8* %6, metadata !62, metadata !DIExpression()), !dbg !93
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !94
  %8 = load i32, i32* %7, align 4, !dbg !94, !tbaa !95
  %9 = zext i32 %8 to i64, !dbg !96
  %10 = inttoptr i64 %9 to i8*, !dbg !97
  call void @llvm.dbg.value(metadata i8* %10, metadata !63, metadata !DIExpression()), !dbg !98
  call void @llvm.dbg.value(metadata i32 2, metadata !78, metadata !DIExpression()), !dbg !99
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !64, metadata !DIExpression(DW_OP_deref)), !dbg !100
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !79, metadata !DIExpression(DW_OP_deref)), !dbg !101
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !102, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.value(metadata i8* %6, metadata !109, metadata !DIExpression()), !dbg !115
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !110, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i32 14, metadata !112, metadata !DIExpression()), !dbg !117
  %11 = getelementptr i8, i8* %10, i64 1, !dbg !118
  %12 = icmp ugt i8* %11, %6, !dbg !120
  br i1 %12, label %19, label %13, !dbg !121

; <label>:13:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !111, metadata !DIExpression()), !dbg !122
  %14 = getelementptr inbounds i8, i8* %10, i64 12, !dbg !123
  %15 = bitcast i8* %14 to i16*, !dbg !123
  %16 = load i16, i16* %15, align 1, !dbg !123, !tbaa !124
  %17 = icmp eq i16 %16, -8826, !dbg !127
  %18 = select i1 %17, i32 1, i32 2, !dbg !129
  br label %19, !dbg !129

; <label>:19:                                     ; preds = %13, %1
  %20 = phi i32 [ 2, %1 ], [ %18, %13 ]
  call void @llvm.dbg.value(metadata i32 %20, metadata !78, metadata !DIExpression()), !dbg !99
  %21 = bitcast i32* %2 to i8*, !dbg !130
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %21), !dbg !130
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !135, metadata !DIExpression()) #3, !dbg !130
  call void @llvm.dbg.value(metadata i32 %20, metadata !136, metadata !DIExpression()) #3, !dbg !147
  store i32 %20, i32* %2, align 4, !tbaa !148
  %22 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %21) #3, !dbg !149
  %23 = icmp eq i8* %22, null, !dbg !150
  br i1 %23, label %37, label %24, !dbg !152

; <label>:24:                                     ; preds = %19
  call void @llvm.dbg.value(metadata i8* %22, metadata !137, metadata !DIExpression()) #3, !dbg !153
  %25 = bitcast i8* %22 to i64*, !dbg !154
  %26 = load i64, i64* %25, align 8, !dbg !155, !tbaa !156
  %27 = add i64 %26, 1, !dbg !155
  store i64 %27, i64* %25, align 8, !dbg !155, !tbaa !156
  %28 = load i32, i32* %3, align 4, !dbg !159, !tbaa !86
  %29 = load i32, i32* %7, align 4, !dbg !160, !tbaa !95
  %30 = sub i32 %28, %29, !dbg !161
  %31 = zext i32 %30 to i64, !dbg !162
  %32 = getelementptr inbounds i8, i8* %22, i64 8, !dbg !163
  %33 = bitcast i8* %32 to i64*, !dbg !163
  %34 = load i64, i64* %33, align 8, !dbg !164, !tbaa !165
  %35 = add i64 %34, %31, !dbg !164
  store i64 %35, i64* %33, align 8, !dbg !164, !tbaa !165
  %36 = load i32, i32* %2, align 4, !dbg !166, !tbaa !148
  call void @llvm.dbg.value(metadata i32 %36, metadata !136, metadata !DIExpression()) #3, !dbg !147
  br label %37, !dbg !167

; <label>:37:                                     ; preds = %19, %24
  %38 = phi i32 [ %36, %24 ], [ 0, %19 ], !dbg !168
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %21), !dbg !169
  ret i32 %38, !dbg !170
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
!llvm.module.flags = !{!43, !44, !45}
!llvm.ident = !{!46}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !33, line: 16, type: !34, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !20, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/fedora/xdp-tutorial/packet01-parsing")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/fedora/xdp-tutorial/packet01-parsing")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !{!15, !16, !17}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !18, line: 24, baseType: !19)
!18 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!19 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!20 = !{!0, !21, !27}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 97, type: !23, isLocal: false, isDefinition: true)
!23 = !DICompositeType(tag: DW_TAG_array_type, baseType: !24, size: 32, elements: !25)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!25 = !{!26}
!26 = !DISubrange(count: 4)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !29, line: 20, type: !30, isLocal: true, isDefinition: true)
!29 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/fedora/xdp-tutorial/packet01-parsing")
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DISubroutineType(types: !32)
!32 = !{!15, !15, !15}
!33 = !DIFile(filename: "./../common/xdp_stats_kern.h", directory: "/home/fedora/xdp-tutorial/packet01-parsing")
!34 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !29, line: 210, size: 224, elements: !35)
!35 = !{!36, !37, !38, !39, !40, !41, !42}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !34, file: !29, line: 211, baseType: !7, size: 32)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !34, file: !29, line: 212, baseType: !7, size: 32, offset: 32)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !34, file: !29, line: 213, baseType: !7, size: 32, offset: 64)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !34, file: !29, line: 214, baseType: !7, size: 32, offset: 96)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !34, file: !29, line: 215, baseType: !7, size: 32, offset: 128)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !34, file: !29, line: 216, baseType: !7, size: 32, offset: 160)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !34, file: !29, line: 217, baseType: !7, size: 32, offset: 192)
!43 = !{i32 2, !"Dwarf Version", i32 4}
!44 = !{i32 2, !"Debug Info Version", i32 3}
!45 = !{i32 1, !"wchar_size", i32 4}
!46 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!47 = distinct !DISubprogram(name: "xdp_parser_func", scope: !3, file: !3, line: 63, type: !48, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !60)
!48 = !DISubroutineType(types: !49)
!49 = !{!50, !51}
!50 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!51 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !52, size: 64)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !53)
!53 = !{!54, !56, !57, !58, !59}
!54 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !52, file: !6, line: 2857, baseType: !55, size: 32)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !18, line: 27, baseType: !7)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !52, file: !6, line: 2858, baseType: !55, size: 32, offset: 32)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !52, file: !6, line: 2859, baseType: !55, size: 32, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !52, file: !6, line: 2861, baseType: !55, size: 32, offset: 96)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !52, file: !6, line: 2862, baseType: !55, size: 32, offset: 128)
!60 = !{!61, !62, !63, !64, !78, !79, !83}
!61 = !DILocalVariable(name: "ctx", arg: 1, scope: !47, file: !3, line: 63, type: !51)
!62 = !DILocalVariable(name: "data_end", scope: !47, file: !3, line: 65, type: !15)
!63 = !DILocalVariable(name: "data", scope: !47, file: !3, line: 66, type: !15)
!64 = !DILocalVariable(name: "eth", scope: !47, file: !3, line: 67, type: !65)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !67, line: 161, size: 112, elements: !68)
!67 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!68 = !{!69, !74, !75}
!69 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !66, file: !67, line: 162, baseType: !70, size: 48)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 48, elements: !72)
!71 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!72 = !{!73}
!73 = !DISubrange(count: 6)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !66, file: !67, line: 163, baseType: !70, size: 48, offset: 48)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !66, file: !67, line: 164, baseType: !76, size: 16, offset: 96)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !77, line: 25, baseType: !17)
!77 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!78 = !DILocalVariable(name: "action", scope: !47, file: !3, line: 73, type: !55)
!79 = !DILocalVariable(name: "nh", scope: !47, file: !3, line: 76, type: !80)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !3, line: 16, size: 64, elements: !81)
!81 = !{!82}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !80, file: !3, line: 17, baseType: !15, size: 64)
!83 = !DILocalVariable(name: "nh_type", scope: !47, file: !3, line: 77, type: !50)
!84 = !DILocation(line: 63, column: 37, scope: !47)
!85 = !DILocation(line: 65, column: 38, scope: !47)
!86 = !{!87, !88, i64 4}
!87 = !{!"xdp_md", !88, i64 0, !88, i64 4, !88, i64 8, !88, i64 12, !88, i64 16}
!88 = !{!"int", !89, i64 0}
!89 = !{!"omnipotent char", !90, i64 0}
!90 = !{!"Simple C/C++ TBAA"}
!91 = !DILocation(line: 65, column: 27, scope: !47)
!92 = !DILocation(line: 65, column: 19, scope: !47)
!93 = !DILocation(line: 65, column: 8, scope: !47)
!94 = !DILocation(line: 66, column: 34, scope: !47)
!95 = !{!87, !88, i64 0}
!96 = !DILocation(line: 66, column: 23, scope: !47)
!97 = !DILocation(line: 66, column: 15, scope: !47)
!98 = !DILocation(line: 66, column: 8, scope: !47)
!99 = !DILocation(line: 73, column: 8, scope: !47)
!100 = !DILocation(line: 67, column: 17, scope: !47)
!101 = !DILocation(line: 76, column: 20, scope: !47)
!102 = !DILocalVariable(name: "nh", arg: 1, scope: !103, file: !3, line: 29, type: !106)
!103 = distinct !DISubprogram(name: "parse_ethhdr", scope: !3, file: !3, line: 29, type: !104, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !108)
!104 = !DISubroutineType(types: !105)
!105 = !{!50, !106, !15, !107}
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !65, size: 64)
!108 = !{!102, !109, !110, !111, !112}
!109 = !DILocalVariable(name: "data_end", arg: 2, scope: !103, file: !3, line: 30, type: !15)
!110 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !103, file: !3, line: 31, type: !107)
!111 = !DILocalVariable(name: "eth", scope: !103, file: !3, line: 33, type: !65)
!112 = !DILocalVariable(name: "hdrsize", scope: !103, file: !3, line: 34, type: !50)
!113 = !DILocation(line: 29, column: 60, scope: !103, inlinedAt: !114)
!114 = distinct !DILocation(line: 86, column: 12, scope: !47)
!115 = !DILocation(line: 30, column: 12, scope: !103, inlinedAt: !114)
!116 = !DILocation(line: 31, column: 22, scope: !103, inlinedAt: !114)
!117 = !DILocation(line: 34, column: 6, scope: !103, inlinedAt: !114)
!118 = !DILocation(line: 39, column: 14, scope: !119, inlinedAt: !114)
!119 = distinct !DILexicalBlock(scope: !103, file: !3, line: 39, column: 6)
!120 = !DILocation(line: 39, column: 18, scope: !119, inlinedAt: !114)
!121 = !DILocation(line: 39, column: 6, scope: !103, inlinedAt: !114)
!122 = !DILocation(line: 33, column: 17, scope: !103, inlinedAt: !114)
!123 = !DILocation(line: 45, column: 14, scope: !103, inlinedAt: !114)
!124 = !{!125, !126, i64 12}
!125 = !{!"ethhdr", !89, i64 0, !89, i64 6, !126, i64 12}
!126 = !{!"short", !89, i64 0}
!127 = !DILocation(line: 87, column: 14, scope: !128)
!128 = distinct !DILexicalBlock(scope: !47, file: !3, line: 87, column: 6)
!129 = !DILocation(line: 87, column: 6, scope: !47)
!130 = !DILocation(line: 24, column: 46, scope: !131, inlinedAt: !146)
!131 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !33, file: !33, line: 24, type: !132, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !134)
!132 = !DISubroutineType(types: !133)
!133 = !{!55, !51, !55}
!134 = !{!135, !136, !137}
!135 = !DILocalVariable(name: "ctx", arg: 1, scope: !131, file: !33, line: 24, type: !51)
!136 = !DILocalVariable(name: "action", arg: 2, scope: !131, file: !33, line: 24, type: !55)
!137 = !DILocalVariable(name: "rec", scope: !131, file: !33, line: 30, type: !138)
!138 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !139, size: 64)
!139 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !140, line: 10, size: 128, elements: !141)
!140 = !DIFile(filename: "./../common/xdp_stats_kern_user.h", directory: "/home/fedora/xdp-tutorial/packet01-parsing")
!141 = !{!142, !145}
!142 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !139, file: !140, line: 11, baseType: !143, size: 64)
!143 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !18, line: 31, baseType: !144)
!144 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !139, file: !140, line: 12, baseType: !143, size: 64, offset: 64)
!146 = distinct !DILocation(line: 94, column: 9, scope: !47)
!147 = !DILocation(line: 24, column: 57, scope: !131, inlinedAt: !146)
!148 = !{!88, !88, i64 0}
!149 = !DILocation(line: 30, column: 24, scope: !131, inlinedAt: !146)
!150 = !DILocation(line: 31, column: 7, scope: !151, inlinedAt: !146)
!151 = distinct !DILexicalBlock(scope: !131, file: !33, line: 31, column: 6)
!152 = !DILocation(line: 31, column: 6, scope: !131, inlinedAt: !146)
!153 = !DILocation(line: 30, column: 18, scope: !131, inlinedAt: !146)
!154 = !DILocation(line: 38, column: 7, scope: !131, inlinedAt: !146)
!155 = !DILocation(line: 38, column: 17, scope: !131, inlinedAt: !146)
!156 = !{!157, !158, i64 0}
!157 = !{!"datarec", !158, i64 0, !158, i64 8}
!158 = !{!"long long", !89, i64 0}
!159 = !DILocation(line: 39, column: 25, scope: !131, inlinedAt: !146)
!160 = !DILocation(line: 39, column: 41, scope: !131, inlinedAt: !146)
!161 = !DILocation(line: 39, column: 34, scope: !131, inlinedAt: !146)
!162 = !DILocation(line: 39, column: 19, scope: !131, inlinedAt: !146)
!163 = !DILocation(line: 39, column: 7, scope: !131, inlinedAt: !146)
!164 = !DILocation(line: 39, column: 16, scope: !131, inlinedAt: !146)
!165 = !{!157, !158, i64 8}
!166 = !DILocation(line: 41, column: 9, scope: !131, inlinedAt: !146)
!167 = !DILocation(line: 41, column: 2, scope: !131, inlinedAt: !146)
!168 = !DILocation(line: 0, scope: !131, inlinedAt: !146)
!169 = !DILocation(line: 42, column: 1, scope: !131, inlinedAt: !146)
!170 = !DILocation(line: 94, column: 2, scope: !47)
