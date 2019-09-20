; ModuleID = 'xdp_vlan02_kern.c'
source_filename = "xdp_vlan02_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.hdr_cursor = type { i8* }
%struct.vlans = type { [10 x i16] }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.vlan_hdr = type { i16, i16 }

@llvm.used = appending global [1 x i8*] [i8* bitcast (i32 (%struct.xdp_md*)* @xdp_vlan_02 to i8*)], section "llvm.metadata"

; Function Attrs: nounwind readonly
define dso_local i32 @xdp_vlan_02(%struct.xdp_md* nocapture readonly) #0 section "xdp_vlan02" !dbg !22 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !36, metadata !DIExpression()), !dbg !66
  %2 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !67
  %3 = load i32, i32* %2, align 4, !dbg !67, !tbaa !68
  %4 = zext i32 %3 to i64, !dbg !73
  %5 = inttoptr i64 %4 to i8*, !dbg !74
  call void @llvm.dbg.value(metadata i8* %5, metadata !37, metadata !DIExpression()), !dbg !75
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !76
  %7 = load i32, i32* %6, align 4, !dbg !76, !tbaa !77
  %8 = zext i32 %7 to i64, !dbg !78
  %9 = inttoptr i64 %8 to i8*, !dbg !79
  call void @llvm.dbg.value(metadata i8* %9, metadata !38, metadata !DIExpression()), !dbg !80
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !39, metadata !DIExpression(DW_OP_deref)), !dbg !81
  call void @llvm.dbg.value(metadata %struct.vlans* undef, metadata !45, metadata !DIExpression(DW_OP_deref)), !dbg !82
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !52, metadata !DIExpression(DW_OP_deref)), !dbg !83
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !84, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i8* %5, metadata !92, metadata !DIExpression()), !dbg !107
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !93, metadata !DIExpression()), !dbg !108
  call void @llvm.dbg.value(metadata %struct.vlans* undef, metadata !94, metadata !DIExpression()), !dbg !109
  call void @llvm.dbg.value(metadata i32 14, metadata !96, metadata !DIExpression()), !dbg !110
  %10 = getelementptr i8, i8* %9, i64 14, !dbg !111
  %11 = icmp ugt i8* %10, %5, !dbg !113
  br i1 %11, label %35, label %12, !dbg !114

; <label>:12:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %9, metadata !95, metadata !DIExpression()), !dbg !115
  call void @llvm.dbg.value(metadata i8* %10, metadata !97, metadata !DIExpression()), !dbg !116
  %13 = getelementptr inbounds i8, i8* %9, i64 12, !dbg !117
  %14 = bitcast i8* %13 to i16*, !dbg !117
  %15 = load i16, i16* %14, align 1, !dbg !117, !tbaa !118
  call void @llvm.dbg.value(metadata i16 %15, metadata !103, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i32 0, metadata !104, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i8* %10, metadata !97, metadata !DIExpression()), !dbg !116
  %16 = inttoptr i64 %4 to %struct.vlan_hdr*
  call void @llvm.dbg.value(metadata i64 0, metadata !104, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i16 %15, metadata !103, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i8* %10, metadata !97, metadata !DIExpression()), !dbg !116
  switch i16 %15, label %35 [
    i16 -22392, label %17
    i16 129, label %17
  ], !dbg !123

; <label>:17:                                     ; preds = %12, %12
  %18 = getelementptr inbounds i8, i8* %9, i64 18, !dbg !127
  %19 = bitcast i8* %18 to %struct.vlan_hdr*, !dbg !127
  %20 = icmp ugt %struct.vlan_hdr* %19, %16, !dbg !129
  br i1 %20, label %35, label %21, !dbg !130

; <label>:21:                                     ; preds = %17
  %22 = getelementptr inbounds i8, i8* %9, i64 16, !dbg !131
  %23 = bitcast i8* %22 to i16*, !dbg !131
  %24 = load i16, i16* %23, align 2, !dbg !131, !tbaa !132
  call void @llvm.dbg.value(metadata i32 undef, metadata !104, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !122
  call void @llvm.dbg.value(metadata i16 %24, metadata !103, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %19, metadata !97, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 1, metadata !104, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i16 %24, metadata !103, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %19, metadata !97, metadata !DIExpression()), !dbg !116
  switch i16 %24, label %35 [
    i16 -22392, label %25
    i16 129, label %25
  ], !dbg !123

; <label>:25:                                     ; preds = %21, %21
  %26 = getelementptr inbounds i8, i8* %9, i64 22, !dbg !127
  %27 = bitcast i8* %26 to %struct.vlan_hdr*, !dbg !127
  %28 = icmp ugt %struct.vlan_hdr* %27, %16, !dbg !129
  br i1 %28, label %35, label %29, !dbg !130

; <label>:29:                                     ; preds = %25
  %30 = bitcast i8* %18 to i16*, !dbg !134
  %31 = load i16, i16* %30, align 2, !dbg !134, !tbaa !137
  %32 = and i16 %31, 4095, !dbg !138
  call void @llvm.dbg.value(metadata i32 undef, metadata !104, metadata !DIExpression(DW_OP_plus_uconst, 1, DW_OP_stack_value)), !dbg !122
  call void @llvm.dbg.value(metadata i8* %9, metadata !103, metadata !DIExpression(DW_OP_plus_uconst, 20, DW_OP_deref, DW_OP_stack_value)), !dbg !121
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %27, metadata !97, metadata !DIExpression()), !dbg !116
  call void @llvm.dbg.value(metadata i64 2, metadata !104, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i8* %9, metadata !103, metadata !DIExpression(DW_OP_plus_uconst, 20, DW_OP_deref, DW_OP_stack_value)), !dbg !121
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %27, metadata !97, metadata !DIExpression()), !dbg !116
  %33 = icmp eq i16 %32, 42, !dbg !123
  %34 = select i1 %33, i32 0, i32 2, !dbg !123
  br label %35, !dbg !123

; <label>:35:                                     ; preds = %12, %17, %21, %25, %29, %1
  %36 = phi i32 [ 0, %1 ], [ 2, %12 ], [ 2, %17 ], [ 2, %21 ], [ 2, %25 ], [ %34, %29 ], !dbg !139
  ret i32 %36, !dbg !140
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!18, !19, !20}
!llvm.ident = !{!21}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !12, nameTableKind: None)
!1 = !DIFile(filename: "xdp_vlan02_kern.c", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!2 = !{!3}
!3 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !4, line: 2845, baseType: !5, size: 32, elements: !6)
!4 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!5 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!6 = !{!7, !8, !9, !10, !11}
!7 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!8 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!9 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!12 = !{!13, !14, !15}
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!14 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!15 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !16, line: 24, baseType: !17)
!16 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!17 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!18 = !{i32 2, !"Dwarf Version", i32 4}
!19 = !{i32 2, !"Debug Info Version", i32 3}
!20 = !{i32 1, !"wchar_size", i32 4}
!21 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!22 = distinct !DISubprogram(name: "xdp_vlan_02", scope: !1, file: !1, line: 64, type: !23, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !35)
!23 = !DISubroutineType(types: !24)
!24 = !{!25, !26}
!25 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !4, line: 2856, size: 160, elements: !28)
!28 = !{!29, !31, !32, !33, !34}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !27, file: !4, line: 2857, baseType: !30, size: 32)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !16, line: 27, baseType: !5)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !27, file: !4, line: 2858, baseType: !30, size: 32, offset: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !27, file: !4, line: 2859, baseType: !30, size: 32, offset: 64)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !27, file: !4, line: 2861, baseType: !30, size: 32, offset: 96)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !27, file: !4, line: 2862, baseType: !30, size: 32, offset: 128)
!35 = !{!36, !37, !38, !39, !44, !45, !52}
!36 = !DILocalVariable(name: "ctx", arg: 1, scope: !22, file: !1, line: 64, type: !26)
!37 = !DILocalVariable(name: "data_end", scope: !22, file: !1, line: 66, type: !13)
!38 = !DILocalVariable(name: "data", scope: !22, file: !1, line: 67, type: !13)
!39 = !DILocalVariable(name: "nh", scope: !22, file: !1, line: 70, type: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !41, line: 33, size: 64, elements: !42)
!41 = !DIFile(filename: "./../common/parsing_helpers.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!42 = !{!43}
!43 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !40, file: !41, line: 34, baseType: !13, size: 64)
!44 = !DILocalVariable(name: "eth_type", scope: !22, file: !1, line: 71, type: !25)
!45 = !DILocalVariable(name: "vlans", scope: !22, file: !1, line: 74, type: !46)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlans", file: !1, line: 14, size: 160, elements: !47)
!47 = !{!48}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !46, file: !1, line: 15, baseType: !49, size: 160)
!49 = !DICompositeType(tag: DW_TAG_array_type, baseType: !15, size: 160, elements: !50)
!50 = !{!51}
!51 = !DISubrange(count: 10)
!52 = !DILocalVariable(name: "eth", scope: !22, file: !1, line: 76, type: !53)
!53 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !54, size: 64)
!54 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !55, line: 161, size: 112, elements: !56)
!55 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!56 = !{!57, !62, !63}
!57 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !54, file: !55, line: 162, baseType: !58, size: 48)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !59, size: 48, elements: !60)
!59 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!60 = !{!61}
!61 = !DISubrange(count: 6)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !54, file: !55, line: 163, baseType: !58, size: 48, offset: 48)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !54, file: !55, line: 164, baseType: !64, size: 16, offset: 96)
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !65, line: 25, baseType: !15)
!65 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!66 = !DILocation(line: 64, column: 32, scope: !22)
!67 = !DILocation(line: 66, column: 38, scope: !22)
!68 = !{!69, !70, i64 4}
!69 = !{!"xdp_md", !70, i64 0, !70, i64 4, !70, i64 8, !70, i64 12, !70, i64 16}
!70 = !{!"int", !71, i64 0}
!71 = !{!"omnipotent char", !72, i64 0}
!72 = !{!"Simple C/C++ TBAA"}
!73 = !DILocation(line: 66, column: 27, scope: !22)
!74 = !DILocation(line: 66, column: 19, scope: !22)
!75 = !DILocation(line: 66, column: 8, scope: !22)
!76 = !DILocation(line: 67, column: 34, scope: !22)
!77 = !{!69, !70, i64 0}
!78 = !DILocation(line: 67, column: 23, scope: !22)
!79 = !DILocation(line: 67, column: 15, scope: !22)
!80 = !DILocation(line: 67, column: 8, scope: !22)
!81 = !DILocation(line: 70, column: 20, scope: !22)
!82 = !DILocation(line: 74, column: 15, scope: !22)
!83 = !DILocation(line: 76, column: 17, scope: !22)
!84 = !DILocalVariable(name: "nh", arg: 1, scope: !85, file: !1, line: 19, type: !88)
!85 = distinct !DISubprogram(name: "__parse_ethhdr_vlan", scope: !1, file: !1, line: 19, type: !86, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !91)
!86 = !DISubroutineType(types: !87)
!87 = !{!25, !88, !13, !89, !90}
!88 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!90 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!91 = !{!84, !92, !93, !94, !95, !96, !97, !103, !104}
!92 = !DILocalVariable(name: "data_end", arg: 2, scope: !85, file: !1, line: 20, type: !13)
!93 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !85, file: !1, line: 21, type: !89)
!94 = !DILocalVariable(name: "vlans", arg: 4, scope: !85, file: !1, line: 22, type: !90)
!95 = !DILocalVariable(name: "eth", scope: !85, file: !1, line: 24, type: !53)
!96 = !DILocalVariable(name: "hdrsize", scope: !85, file: !1, line: 25, type: !25)
!97 = !DILocalVariable(name: "vlh", scope: !85, file: !1, line: 26, type: !98)
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !41, line: 42, size: 32, elements: !100)
!100 = !{!101, !102}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !99, file: !41, line: 43, baseType: !64, size: 16)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !99, file: !41, line: 44, baseType: !64, size: 16, offset: 16)
!103 = !DILocalVariable(name: "h_proto", scope: !85, file: !1, line: 27, type: !15)
!104 = !DILocalVariable(name: "i", scope: !85, file: !1, line: 28, type: !25)
!105 = !DILocation(line: 19, column: 67, scope: !85, inlinedAt: !106)
!106 = distinct !DILocation(line: 77, column: 13, scope: !22)
!107 = !DILocation(line: 20, column: 19, scope: !85, inlinedAt: !106)
!108 = !DILocation(line: 21, column: 29, scope: !85, inlinedAt: !106)
!109 = !DILocation(line: 22, column: 27, scope: !85, inlinedAt: !106)
!110 = !DILocation(line: 25, column: 6, scope: !85, inlinedAt: !106)
!111 = !DILocation(line: 33, column: 14, scope: !112, inlinedAt: !106)
!112 = distinct !DILexicalBlock(scope: !85, file: !1, line: 33, column: 6)
!113 = !DILocation(line: 33, column: 24, scope: !112, inlinedAt: !106)
!114 = !DILocation(line: 33, column: 6, scope: !85, inlinedAt: !106)
!115 = !DILocation(line: 24, column: 17, scope: !85, inlinedAt: !106)
!116 = !DILocation(line: 26, column: 19, scope: !85, inlinedAt: !106)
!117 = !DILocation(line: 39, column: 17, scope: !85, inlinedAt: !106)
!118 = !{!119, !120, i64 12}
!119 = !{!"ethhdr", !71, i64 0, !71, i64 6, !120, i64 12}
!120 = !{!"short", !71, i64 0}
!121 = !DILocation(line: 27, column: 8, scope: !85, inlinedAt: !106)
!122 = !DILocation(line: 28, column: 6, scope: !85, inlinedAt: !106)
!123 = !DILocation(line: 46, column: 7, scope: !124, inlinedAt: !106)
!124 = distinct !DILexicalBlock(scope: !125, file: !1, line: 45, column: 39)
!125 = distinct !DILexicalBlock(scope: !126, file: !1, line: 45, column: 2)
!126 = distinct !DILexicalBlock(scope: !85, file: !1, line: 45, column: 2)
!127 = !DILocation(line: 49, column: 11, scope: !128, inlinedAt: !106)
!128 = distinct !DILexicalBlock(scope: !124, file: !1, line: 49, column: 7)
!129 = !DILocation(line: 49, column: 15, scope: !128, inlinedAt: !106)
!130 = !DILocation(line: 49, column: 7, scope: !124, inlinedAt: !106)
!131 = !DILocation(line: 52, column: 18, scope: !124, inlinedAt: !106)
!132 = !{!133, !120, i64 2}
!133 = !{!"vlan_hdr", !120, i64 0, !120, i64 2}
!134 = !DILocation(line: 54, column: 25, scope: !135, inlinedAt: !106)
!135 = distinct !DILexicalBlock(scope: !136, file: !1, line: 53, column: 14)
!136 = distinct !DILexicalBlock(scope: !124, file: !1, line: 53, column: 7)
!137 = !{!133, !120, i64 0}
!138 = !DILocation(line: 54, column: 36, scope: !135, inlinedAt: !106)
!139 = !DILocation(line: 0, scope: !22)
!140 = !DILocation(line: 118, column: 1, scope: !22)
