; ModuleID = 'bpf_xdp.c'
source_filename = "bpf_xdp.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }

@xsks_map = global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !53
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_sock_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @xdp_sock_prog(%struct.xdp_md* nocapture readonly) #0 section "xdp_sock" !dbg !86 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !98, metadata !DIExpression()), !dbg !104
  %3 = bitcast i32* %2 to i8*, !dbg !105
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !105
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !106
  %5 = load i32, i32* %4, align 4, !dbg !106, !tbaa !107
  call void @llvm.dbg.value(metadata i32 %5, metadata !99, metadata !DIExpression()), !dbg !112
  store i32 %5, i32* %2, align 4, !dbg !112, !tbaa !113
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !114
  %7 = load i32, i32* %6, align 4, !dbg !114, !tbaa !115
  %8 = zext i32 %7 to i64, !dbg !116
  call void @llvm.dbg.value(metadata i64 %8, metadata !100, metadata !DIExpression()), !dbg !117
  %9 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !118
  %10 = load i32, i32* %9, align 4, !dbg !118, !tbaa !119
  %11 = zext i32 %10 to i64, !dbg !120
  call void @llvm.dbg.value(metadata i64 %11, metadata !101, metadata !DIExpression()), !dbg !121
  %12 = inttoptr i64 %8 to %struct.ethhdr*, !dbg !122
  call void @llvm.dbg.value(metadata %struct.ethhdr* %12, metadata !102, metadata !DIExpression()), !dbg !123
  %13 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 1, !dbg !124
  %14 = inttoptr i64 %11 to %struct.ethhdr*, !dbg !126
  %15 = icmp ugt %struct.ethhdr* %13, %14, !dbg !127
  br i1 %15, label %31, label %16, !dbg !128

; <label>:16:                                     ; preds = %1
  call void @llvm.dbg.value(metadata %struct.ethhdr* %13, metadata !103, metadata !DIExpression()), !dbg !129
  %17 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 2, i32 1, !dbg !130
  %18 = bitcast [6 x i8]* %17 to %struct.iphdr*, !dbg !130
  %19 = inttoptr i64 %11 to %struct.iphdr*, !dbg !132
  %20 = icmp ugt %struct.iphdr* %18, %19, !dbg !133
  br i1 %20, label %31, label %21, !dbg !134

; <label>:21:                                     ; preds = %16
  %22 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 1, i32 1, i64 3, !dbg !135
  %23 = load i8, i8* %22, align 1, !dbg !135, !tbaa !137
  %24 = icmp eq i8 %23, -56, !dbg !140
  br i1 %24, label %25, label %31, !dbg !141

; <label>:25:                                     ; preds = %21
  %26 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i8* nonnull %3) #3, !dbg !142
  %27 = icmp eq i8* %26, null, !dbg !142
  br i1 %27, label %31, label %28, !dbg !144

; <label>:28:                                     ; preds = %25
  %29 = load i32, i32* %2, align 4, !dbg !145, !tbaa !113
  call void @llvm.dbg.value(metadata i32 %29, metadata !99, metadata !DIExpression()), !dbg !112
  %30 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 %29, i32 0) #3, !dbg !146
  br label %31, !dbg !147

; <label>:31:                                     ; preds = %28, %16, %21, %25, %1
  %32 = phi i32 [ 1, %1 ], [ %30, %28 ], [ 1, %16 ], [ 2, %21 ], [ 2, %25 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !148
  ret i32 %32, !dbg !148
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!82, !83, !84}
!llvm.ident = !{!85}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 13, type: !73, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !52)
!3 = !DIFile(filename: "bpf_xdp.c", directory: "/home/ubuntu/Hooker/src/bpf")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 3112, size: 32, elements: !7)
!6 = !DIFile(filename: "./include/linux/bpf.h", directory: "/home/ubuntu/Hooker/src/bpf")
!7 = !{!8, !9, !10, !11, !12}
!8 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!9 = !DIEnumerator(name: "XDP_DROP", value: 1)
!10 = !DIEnumerator(name: "XDP_PASS", value: 2)
!11 = !DIEnumerator(name: "XDP_TX", value: 3)
!12 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!13 = !{!14, !15, !16, !32}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!15 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !18, line: 163, size: 112, elements: !19)
!18 = !DIFile(filename: "./include/linux/if_ether.h", directory: "/home/ubuntu/Hooker/src/bpf")
!19 = !{!20, !25, !26}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !17, file: !18, line: 164, baseType: !21, size: 48)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 48, elements: !23)
!22 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!23 = !{!24}
!24 = !DISubrange(count: 6)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !17, file: !18, line: 165, baseType: !21, size: 48, offset: 48)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !17, file: !18, line: 166, baseType: !27, size: 16, offset: 96)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !28, line: 25, baseType: !29)
!28 = !DIFile(filename: "/usr/include/linux/types.h", directory: "/home/ubuntu/Hooker/src/bpf")
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !30, line: 24, baseType: !31)
!30 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/Hooker/src/bpf")
!31 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !34, line: 86, size: 160, elements: !35)
!34 = !DIFile(filename: "./include/linux/ip.h", directory: "/home/ubuntu/Hooker/src/bpf")
!35 = !{!36, !38, !39, !40, !41, !42, !43, !44, !45, !47, !51}
!36 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !33, file: !34, line: 88, baseType: !37, size: 4, flags: DIFlagBitField, extraData: i64 0)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !30, line: 21, baseType: !22)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !33, file: !34, line: 89, baseType: !37, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !33, file: !34, line: 96, baseType: !37, size: 8, offset: 8)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !33, file: !34, line: 97, baseType: !27, size: 16, offset: 16)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !33, file: !34, line: 98, baseType: !27, size: 16, offset: 32)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !33, file: !34, line: 99, baseType: !27, size: 16, offset: 48)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !33, file: !34, line: 100, baseType: !37, size: 8, offset: 64)
!44 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !33, file: !34, line: 101, baseType: !37, size: 8, offset: 72)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !33, file: !34, line: 102, baseType: !46, size: 16, offset: 80)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !28, line: 31, baseType: !29)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !33, file: !34, line: 103, baseType: !48, size: 32, offset: 96)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !28, line: 27, baseType: !49)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !30, line: 27, baseType: !50)
!50 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !33, file: !34, line: 104, baseType: !48, size: 32, offset: 128)
!52 = !{!0, !53, !59, !67}
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 87, type: !55, isLocal: false, isDefinition: true)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 32, elements: !57)
!56 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!57 = !{!58}
!58 = !DISubrange(count: 4)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !61, line: 33, type: !62, isLocal: true, isDefinition: true)
!61 = !DIFile(filename: "./include/bpf/bpf_helpers.h", directory: "/home/ubuntu/Hooker/src/bpf")
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DISubroutineType(types: !64)
!64 = !{!14, !14, !65}
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!67 = !DIGlobalVariableExpression(var: !68, expr: !DIExpression())
!68 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !61, line: 70, type: !69, isLocal: true, isDefinition: true)
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DISubroutineType(types: !71)
!71 = !{!72, !14, !72, !72}
!72 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!73 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !61, line: 259, size: 224, elements: !74)
!74 = !{!75, !76, !77, !78, !79, !80, !81}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !73, file: !61, line: 260, baseType: !50, size: 32)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !73, file: !61, line: 261, baseType: !50, size: 32, offset: 32)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !73, file: !61, line: 262, baseType: !50, size: 32, offset: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !73, file: !61, line: 263, baseType: !50, size: 32, offset: 96)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !73, file: !61, line: 264, baseType: !50, size: 32, offset: 128)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !73, file: !61, line: 265, baseType: !50, size: 32, offset: 160)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !73, file: !61, line: 266, baseType: !50, size: 32, offset: 192)
!82 = !{i32 2, !"Dwarf Version", i32 4}
!83 = !{i32 2, !"Debug Info Version", i32 3}
!84 = !{i32 1, !"wchar_size", i32 4}
!85 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!86 = distinct !DISubprogram(name: "xdp_sock_prog", scope: !3, file: !3, line: 35, type: !87, isLocal: false, isDefinition: true, scopeLine: 36, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !97)
!87 = !DISubroutineType(types: !88)
!88 = !{!72, !89}
!89 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !90, size: 64)
!90 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 3123, size: 160, elements: !91)
!91 = !{!92, !93, !94, !95, !96}
!92 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !90, file: !6, line: 3124, baseType: !49, size: 32)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !90, file: !6, line: 3125, baseType: !49, size: 32, offset: 32)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !90, file: !6, line: 3126, baseType: !49, size: 32, offset: 64)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !90, file: !6, line: 3128, baseType: !49, size: 32, offset: 96)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !90, file: !6, line: 3129, baseType: !49, size: 32, offset: 128)
!97 = !{!98, !99, !100, !101, !102, !103}
!98 = !DILocalVariable(name: "ctx", arg: 1, scope: !86, file: !3, line: 35, type: !89)
!99 = !DILocalVariable(name: "index", scope: !86, file: !3, line: 61, type: !72)
!100 = !DILocalVariable(name: "data", scope: !86, file: !3, line: 63, type: !14)
!101 = !DILocalVariable(name: "data_end", scope: !86, file: !3, line: 64, type: !14)
!102 = !DILocalVariable(name: "eth", scope: !86, file: !3, line: 66, type: !16)
!103 = !DILocalVariable(name: "iph", scope: !86, file: !3, line: 70, type: !32)
!104 = !DILocation(line: 35, column: 34, scope: !86)
!105 = !DILocation(line: 61, column: 5, scope: !86)
!106 = !DILocation(line: 61, column: 22, scope: !86)
!107 = !{!108, !109, i64 16}
!108 = !{!"xdp_md", !109, i64 0, !109, i64 4, !109, i64 8, !109, i64 12, !109, i64 16}
!109 = !{!"int", !110, i64 0}
!110 = !{!"omnipotent char", !111, i64 0}
!111 = !{!"Simple C/C++ TBAA"}
!112 = !DILocation(line: 61, column: 9, scope: !86)
!113 = !{!109, !109, i64 0}
!114 = !DILocation(line: 63, column: 37, scope: !86)
!115 = !{!108, !109, i64 0}
!116 = !DILocation(line: 63, column: 26, scope: !86)
!117 = !DILocation(line: 63, column: 11, scope: !86)
!118 = !DILocation(line: 64, column: 41, scope: !86)
!119 = !{!108, !109, i64 4}
!120 = !DILocation(line: 64, column: 30, scope: !86)
!121 = !DILocation(line: 64, column: 11, scope: !86)
!122 = !DILocation(line: 66, column: 26, scope: !86)
!123 = !DILocation(line: 66, column: 20, scope: !86)
!124 = !DILocation(line: 67, column: 13, scope: !125)
!125 = distinct !DILexicalBlock(scope: !86, file: !3, line: 67, column: 9)
!126 = !DILocation(line: 67, column: 19, scope: !125)
!127 = !DILocation(line: 67, column: 17, scope: !125)
!128 = !DILocation(line: 67, column: 9, scope: !86)
!129 = !DILocation(line: 70, column: 19, scope: !86)
!130 = !DILocation(line: 71, column: 13, scope: !131)
!131 = distinct !DILexicalBlock(scope: !86, file: !3, line: 71, column: 9)
!132 = !DILocation(line: 71, column: 19, scope: !131)
!133 = !DILocation(line: 71, column: 17, scope: !131)
!134 = !DILocation(line: 71, column: 9, scope: !86)
!135 = !DILocation(line: 74, column: 14, scope: !136)
!136 = distinct !DILexicalBlock(scope: !86, file: !3, line: 74, column: 9)
!137 = !{!138, !110, i64 9}
!138 = !{!"iphdr", !110, i64 0, !110, i64 0, !110, i64 1, !139, i64 2, !139, i64 4, !139, i64 6, !110, i64 8, !110, i64 9, !139, i64 10, !109, i64 12, !109, i64 16}
!139 = !{!"short", !110, i64 0}
!140 = !DILocation(line: 74, column: 23, scope: !136)
!141 = !DILocation(line: 74, column: 9, scope: !86)
!142 = !DILocation(line: 81, column: 9, scope: !143)
!143 = distinct !DILexicalBlock(scope: !86, file: !3, line: 81, column: 9)
!144 = !DILocation(line: 81, column: 9, scope: !86)
!145 = !DILocation(line: 82, column: 44, scope: !143)
!146 = !DILocation(line: 82, column: 16, scope: !143)
!147 = !DILocation(line: 82, column: 9, scope: !143)
!148 = !DILocation(line: 85, column: 1, scope: !86)
