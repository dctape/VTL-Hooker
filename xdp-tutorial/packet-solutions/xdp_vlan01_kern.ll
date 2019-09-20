; ModuleID = 'xdp_vlan01_kern.c'
source_filename = "xdp_vlan01_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.hdr_cursor = type { i8* }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@llvm.used = appending global [1 x i8*] [i8* bitcast (i32 (%struct.xdp_md*)* @xdp_vlan_01 to i8*)], section "llvm.metadata"

; Function Attrs: nounwind readonly
define dso_local i32 @xdp_vlan_01(%struct.xdp_md* nocapture readonly) #0 section "xdp_vlan01" !dbg !22 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !36, metadata !DIExpression()), !dbg !58
  %2 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !59
  %3 = load i32, i32* %2, align 4, !dbg !59, !tbaa !60
  %4 = zext i32 %3 to i64, !dbg !65
  %5 = inttoptr i64 %4 to i8*, !dbg !66
  call void @llvm.dbg.value(metadata i8* %5, metadata !37, metadata !DIExpression()), !dbg !67
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !68
  %7 = load i32, i32* %6, align 4, !dbg !68, !tbaa !69
  %8 = zext i32 %7 to i64, !dbg !70
  %9 = inttoptr i64 %8 to i8*, !dbg !71
  call void @llvm.dbg.value(metadata i8* %9, metadata !38, metadata !DIExpression()), !dbg !72
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !39, metadata !DIExpression(DW_OP_deref)), !dbg !73
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !74, metadata !DIExpression()), !dbg !93
  call void @llvm.dbg.value(metadata i8* %5, metadata !81, metadata !DIExpression()), !dbg !95
  call void @llvm.dbg.value(metadata i32 14, metadata !84, metadata !DIExpression()), !dbg !96
  %10 = getelementptr i8, i8* %9, i64 14, !dbg !97
  %11 = icmp ugt i8* %10, %5, !dbg !99
  br i1 %11, label %20, label %12, !dbg !100

; <label>:12:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %9, metadata !83, metadata !DIExpression()), !dbg !101
  %13 = inttoptr i64 %8 to %struct.ethhdr*, !dbg !102
  call void @llvm.dbg.value(metadata i8* %10, metadata !85, metadata !DIExpression()), !dbg !103
  call void @llvm.dbg.value(metadata i8* %9, metadata !91, metadata !DIExpression(DW_OP_plus_uconst, 12, DW_OP_deref, DW_OP_stack_value)), !dbg !104
  call void @llvm.dbg.value(metadata i32 0, metadata !92, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i8* %10, metadata !85, metadata !DIExpression()), !dbg !103
  call void @llvm.dbg.value(metadata i32 0, metadata !92, metadata !DIExpression()), !dbg !105
  call void @llvm.dbg.value(metadata i8* %10, metadata !85, metadata !DIExpression()), !dbg !103
  call void @llvm.dbg.value(metadata %struct.ethhdr* %13, metadata !44, metadata !DIExpression()), !dbg !106
  %14 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 2, !dbg !107
  %15 = load i16, i16* %14, align 1, !dbg !107, !tbaa !109
  call void @llvm.dbg.value(metadata i16 %15, metadata !112, metadata !DIExpression()), !dbg !117
  %16 = icmp ne i16 %15, 129, !dbg !119
  %17 = icmp ne i16 %15, -22392, !dbg !120
  %18 = and i1 %16, %17, !dbg !121
  %19 = select i1 %18, i32 2, i32 1, !dbg !122
  br label %20, !dbg !122

; <label>:20:                                     ; preds = %1, %12
  %21 = phi i32 [ %19, %12 ], [ 0, %1 ], !dbg !122
  ret i32 %21, !dbg !123
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!18, !19, !20}
!llvm.ident = !{!21}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !12, nameTableKind: None)
!1 = !DIFile(filename: "xdp_vlan01_kern.c", directory: "/home/fedora/xdp-tutorial/packet-solutions")
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
!22 = distinct !DISubprogram(name: "xdp_vlan_01", scope: !1, file: !1, line: 82, type: !23, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !35)
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
!35 = !{!36, !37, !38, !39, !43, !44}
!36 = !DILocalVariable(name: "ctx", arg: 1, scope: !22, file: !1, line: 82, type: !26)
!37 = !DILocalVariable(name: "data_end", scope: !22, file: !1, line: 84, type: !13)
!38 = !DILocalVariable(name: "data", scope: !22, file: !1, line: 85, type: !13)
!39 = !DILocalVariable(name: "nh", scope: !22, file: !1, line: 88, type: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !1, line: 17, size: 64, elements: !41)
!41 = !{!42}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !40, file: !1, line: 18, baseType: !13, size: 64)
!43 = !DILocalVariable(name: "nh_type", scope: !22, file: !1, line: 89, type: !25)
!44 = !DILocalVariable(name: "eth", scope: !22, file: !1, line: 92, type: !45)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !47, line: 161, size: 112, elements: !48)
!47 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!48 = !{!49, !54, !55}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !46, file: !47, line: 162, baseType: !50, size: 48)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !51, size: 48, elements: !52)
!51 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!52 = !{!53}
!53 = !DISubrange(count: 6)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !46, file: !47, line: 163, baseType: !50, size: 48, offset: 48)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !46, file: !47, line: 164, baseType: !56, size: 16, offset: 96)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !57, line: 25, baseType: !15)
!57 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!58 = !DILocation(line: 82, column: 32, scope: !22)
!59 = !DILocation(line: 84, column: 38, scope: !22)
!60 = !{!61, !62, i64 4}
!61 = !{!"xdp_md", !62, i64 0, !62, i64 4, !62, i64 8, !62, i64 12, !62, i64 16}
!62 = !{!"int", !63, i64 0}
!63 = !{!"omnipotent char", !64, i64 0}
!64 = !{!"Simple C/C++ TBAA"}
!65 = !DILocation(line: 84, column: 27, scope: !22)
!66 = !DILocation(line: 84, column: 19, scope: !22)
!67 = !DILocation(line: 84, column: 8, scope: !22)
!68 = !DILocation(line: 85, column: 34, scope: !22)
!69 = !{!61, !62, i64 0}
!70 = !DILocation(line: 85, column: 23, scope: !22)
!71 = !DILocation(line: 85, column: 15, scope: !22)
!72 = !DILocation(line: 85, column: 8, scope: !22)
!73 = !DILocation(line: 88, column: 20, scope: !22)
!74 = !DILocalVariable(name: "nh", arg: 1, scope: !75, file: !1, line: 42, type: !78)
!75 = distinct !DISubprogram(name: "parse_ethhdr", scope: !1, file: !1, line: 42, type: !76, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !80)
!76 = !DISubroutineType(types: !77)
!77 = !{!25, !78, !13, !79}
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!80 = !{!74, !81, !82, !83, !84, !85, !91, !92}
!81 = !DILocalVariable(name: "data_end", arg: 2, scope: !75, file: !1, line: 42, type: !13)
!82 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !75, file: !1, line: 43, type: !79)
!83 = !DILocalVariable(name: "eth", scope: !75, file: !1, line: 45, type: !45)
!84 = !DILocalVariable(name: "hdrsize", scope: !75, file: !1, line: 46, type: !25)
!85 = !DILocalVariable(name: "vlh", scope: !75, file: !1, line: 47, type: !86)
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !1, line: 32, size: 32, elements: !88)
!88 = !{!89, !90}
!89 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !87, file: !1, line: 33, baseType: !56, size: 16)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !87, file: !1, line: 34, baseType: !56, size: 16, offset: 16)
!91 = !DILocalVariable(name: "h_proto", scope: !75, file: !1, line: 48, type: !15)
!92 = !DILocalVariable(name: "i", scope: !75, file: !1, line: 49, type: !25)
!93 = !DILocation(line: 42, column: 60, scope: !75, inlinedAt: !94)
!94 = distinct !DILocation(line: 93, column: 12, scope: !22)
!95 = !DILocation(line: 42, column: 70, scope: !75, inlinedAt: !94)
!96 = !DILocation(line: 46, column: 6, scope: !75, inlinedAt: !94)
!97 = !DILocation(line: 54, column: 14, scope: !98, inlinedAt: !94)
!98 = distinct !DILexicalBlock(scope: !75, file: !1, line: 54, column: 6)
!99 = !DILocation(line: 54, column: 24, scope: !98, inlinedAt: !94)
!100 = !DILocation(line: 54, column: 6, scope: !75, inlinedAt: !94)
!101 = !DILocation(line: 45, column: 17, scope: !75, inlinedAt: !94)
!102 = !DILocation(line: 58, column: 10, scope: !75, inlinedAt: !94)
!103 = !DILocation(line: 47, column: 19, scope: !75, inlinedAt: !94)
!104 = !DILocation(line: 48, column: 8, scope: !75, inlinedAt: !94)
!105 = !DILocation(line: 49, column: 6, scope: !75, inlinedAt: !94)
!106 = !DILocation(line: 92, column: 17, scope: !22)
!107 = !DILocation(line: 108, column: 25, scope: !108)
!108 = distinct !DILexicalBlock(scope: !22, file: !1, line: 108, column: 6)
!109 = !{!110, !111, i64 12}
!110 = !{!"ethhdr", !63, i64 0, !63, i64 6, !111, i64 12}
!111 = !{!"short", !63, i64 0}
!112 = !DILocalVariable(name: "h_proto", arg: 1, scope: !113, file: !1, line: 21, type: !15)
!113 = distinct !DISubprogram(name: "proto_is_vlan", scope: !1, file: !1, line: 21, type: !114, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !116)
!114 = !DISubroutineType(types: !115)
!115 = !{!25, !15}
!116 = !{!112}
!117 = !DILocation(line: 21, column: 48, scope: !113, inlinedAt: !118)
!118 = distinct !DILocation(line: 108, column: 6, scope: !108)
!119 = !DILocation(line: 23, column: 20, scope: !113, inlinedAt: !118)
!120 = !DILocation(line: 23, column: 46, scope: !113, inlinedAt: !118)
!121 = !DILocation(line: 108, column: 6, scope: !108)
!122 = !DILocation(line: 0, scope: !22)
!123 = !DILocation(line: 115, column: 1, scope: !22)
