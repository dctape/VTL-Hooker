; ModuleID = 'capture_kern.c'
source_filename = "capture_kern.c"
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
define i32 @xdp_sock_prog(%struct.xdp_md* nocapture readonly) #0 section "xdp_sock" !dbg !84 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !96, metadata !DIExpression()), !dbg !102
  %3 = bitcast i32* %2 to i8*, !dbg !103
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !103
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !104
  %5 = load i32, i32* %4, align 4, !dbg !104, !tbaa !105
  call void @llvm.dbg.value(metadata i32 %5, metadata !97, metadata !DIExpression()), !dbg !110
  store i32 %5, i32* %2, align 4, !dbg !110, !tbaa !111
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !112
  %7 = load i32, i32* %6, align 4, !dbg !112, !tbaa !113
  %8 = zext i32 %7 to i64, !dbg !114
  call void @llvm.dbg.value(metadata i64 %8, metadata !98, metadata !DIExpression()), !dbg !115
  %9 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !116
  %10 = load i32, i32* %9, align 4, !dbg !116, !tbaa !117
  %11 = zext i32 %10 to i64, !dbg !118
  call void @llvm.dbg.value(metadata i64 %11, metadata !99, metadata !DIExpression()), !dbg !119
  %12 = inttoptr i64 %8 to %struct.ethhdr*, !dbg !120
  call void @llvm.dbg.value(metadata %struct.ethhdr* %12, metadata !100, metadata !DIExpression()), !dbg !121
  %13 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 1, !dbg !122
  %14 = inttoptr i64 %11 to %struct.ethhdr*, !dbg !124
  %15 = icmp ugt %struct.ethhdr* %13, %14, !dbg !125
  br i1 %15, label %31, label %16, !dbg !126

; <label>:16:                                     ; preds = %1
  call void @llvm.dbg.value(metadata %struct.ethhdr* %13, metadata !101, metadata !DIExpression()), !dbg !127
  %17 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 2, i32 1, !dbg !128
  %18 = bitcast [6 x i8]* %17 to %struct.iphdr*, !dbg !128
  %19 = inttoptr i64 %11 to %struct.iphdr*, !dbg !130
  %20 = icmp ugt %struct.iphdr* %18, %19, !dbg !131
  br i1 %20, label %31, label %21, !dbg !132

; <label>:21:                                     ; preds = %16
  %22 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 1, i32 1, i64 3, !dbg !133
  %23 = load i8, i8* %22, align 1, !dbg !133, !tbaa !135
  %24 = icmp eq i8 %23, -56, !dbg !138
  br i1 %24, label %25, label %31, !dbg !139

; <label>:25:                                     ; preds = %21
  %26 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i8* nonnull %3) #3, !dbg !140
  %27 = icmp eq i8* %26, null, !dbg !140
  br i1 %27, label %31, label %28, !dbg !142

; <label>:28:                                     ; preds = %25
  %29 = load i32, i32* %2, align 4, !dbg !143, !tbaa !111
  call void @llvm.dbg.value(metadata i32 %29, metadata !97, metadata !DIExpression()), !dbg !110
  %30 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 %29, i32 0) #3, !dbg !144
  br label %31, !dbg !145

; <label>:31:                                     ; preds = %28, %16, %21, %25, %1
  %32 = phi i32 [ 1, %1 ], [ %30, %28 ], [ 1, %16 ], [ 2, %21 ], [ 2, %25 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !146
  ret i32 %32, !dbg !146
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
!llvm.module.flags = !{!80, !81, !82}
!llvm.ident = !{!83}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 11, type: !71, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !52)
!3 = !DIFile(filename: "capture_kern.c", directory: "/home/ubuntu/Hooker/capture")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, size: 32, elements: !7)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/ubuntu/Hooker/capture")
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
!17 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !18, line: 159, size: 112, elements: !19)
!18 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "/home/ubuntu/Hooker/capture")
!19 = !{!20, !25, !26}
!20 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !17, file: !18, line: 160, baseType: !21, size: 48)
!21 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 48, elements: !23)
!22 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!23 = !{!24}
!24 = !DISubrange(count: 6)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !17, file: !18, line: 161, baseType: !21, size: 48, offset: 48)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !17, file: !18, line: 162, baseType: !27, size: 16, offset: 96)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !28, line: 25, baseType: !29)
!28 = !DIFile(filename: "/usr/include/linux/types.h", directory: "/home/ubuntu/Hooker/capture")
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !30, line: 24, baseType: !31)
!30 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/Hooker/capture")
!31 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !34, line: 86, size: 160, elements: !35)
!34 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "/home/ubuntu/Hooker/capture")
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
!52 = !{!0, !53, !59, !65}
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 86, type: !55, isLocal: false, isDefinition: true)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 32, elements: !57)
!56 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!57 = !{!58}
!58 = !DISubrange(count: 4)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !61, line: 20, type: !62, isLocal: true, isDefinition: true)
!61 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/ubuntu/Hooker/capture")
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DISubroutineType(types: !64)
!64 = !{!14, !14, !14}
!65 = !DIGlobalVariableExpression(var: !66, expr: !DIExpression())
!66 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !61, line: 57, type: !67, isLocal: true, isDefinition: true)
!67 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !68, size: 64)
!68 = !DISubroutineType(types: !69)
!69 = !{!70, !14, !70, !70}
!70 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!71 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !61, line: 210, size: 224, elements: !72)
!72 = !{!73, !74, !75, !76, !77, !78, !79}
!73 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !71, file: !61, line: 211, baseType: !50, size: 32)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !71, file: !61, line: 212, baseType: !50, size: 32, offset: 32)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !71, file: !61, line: 213, baseType: !50, size: 32, offset: 64)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !71, file: !61, line: 214, baseType: !50, size: 32, offset: 96)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !71, file: !61, line: 215, baseType: !50, size: 32, offset: 128)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !71, file: !61, line: 216, baseType: !50, size: 32, offset: 160)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !71, file: !61, line: 217, baseType: !50, size: 32, offset: 192)
!80 = !{i32 2, !"Dwarf Version", i32 4}
!81 = !{i32 2, !"Debug Info Version", i32 3}
!82 = !{i32 1, !"wchar_size", i32 4}
!83 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!84 = distinct !DISubprogram(name: "xdp_sock_prog", scope: !3, file: !3, line: 34, type: !85, isLocal: false, isDefinition: true, scopeLine: 35, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !95)
!85 = !DISubroutineType(types: !86)
!86 = !{!70, !87}
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !89)
!89 = !{!90, !91, !92, !93, !94}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !88, file: !6, line: 2857, baseType: !49, size: 32)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !88, file: !6, line: 2858, baseType: !49, size: 32, offset: 32)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !88, file: !6, line: 2859, baseType: !49, size: 32, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !88, file: !6, line: 2861, baseType: !49, size: 32, offset: 96)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !88, file: !6, line: 2862, baseType: !49, size: 32, offset: 128)
!95 = !{!96, !97, !98, !99, !100, !101}
!96 = !DILocalVariable(name: "ctx", arg: 1, scope: !84, file: !3, line: 34, type: !87)
!97 = !DILocalVariable(name: "index", scope: !84, file: !3, line: 63, type: !70)
!98 = !DILocalVariable(name: "data", scope: !84, file: !3, line: 65, type: !14)
!99 = !DILocalVariable(name: "data_end", scope: !84, file: !3, line: 66, type: !14)
!100 = !DILocalVariable(name: "eth", scope: !84, file: !3, line: 68, type: !16)
!101 = !DILocalVariable(name: "iph", scope: !84, file: !3, line: 72, type: !32)
!102 = !DILocation(line: 34, column: 34, scope: !84)
!103 = !DILocation(line: 63, column: 9, scope: !84)
!104 = !DILocation(line: 63, column: 26, scope: !84)
!105 = !{!106, !107, i64 16}
!106 = !{!"xdp_md", !107, i64 0, !107, i64 4, !107, i64 8, !107, i64 12, !107, i64 16}
!107 = !{!"int", !108, i64 0}
!108 = !{!"omnipotent char", !109, i64 0}
!109 = !{!"Simple C/C++ TBAA"}
!110 = !DILocation(line: 63, column: 13, scope: !84)
!111 = !{!107, !107, i64 0}
!112 = !DILocation(line: 65, column: 41, scope: !84)
!113 = !{!106, !107, i64 0}
!114 = !DILocation(line: 65, column: 30, scope: !84)
!115 = !DILocation(line: 65, column: 15, scope: !84)
!116 = !DILocation(line: 66, column: 45, scope: !84)
!117 = !{!106, !107, i64 4}
!118 = !DILocation(line: 66, column: 34, scope: !84)
!119 = !DILocation(line: 66, column: 15, scope: !84)
!120 = !DILocation(line: 68, column: 30, scope: !84)
!121 = !DILocation(line: 68, column: 24, scope: !84)
!122 = !DILocation(line: 69, column: 16, scope: !123)
!123 = distinct !DILexicalBlock(scope: !84, file: !3, line: 69, column: 12)
!124 = !DILocation(line: 69, column: 22, scope: !123)
!125 = !DILocation(line: 69, column: 20, scope: !123)
!126 = !DILocation(line: 69, column: 12, scope: !84)
!127 = !DILocation(line: 72, column: 23, scope: !84)
!128 = !DILocation(line: 73, column: 16, scope: !129)
!129 = distinct !DILexicalBlock(scope: !84, file: !3, line: 73, column: 12)
!130 = !DILocation(line: 73, column: 22, scope: !129)
!131 = !DILocation(line: 73, column: 20, scope: !129)
!132 = !DILocation(line: 73, column: 12, scope: !84)
!133 = !DILocation(line: 76, column: 17, scope: !134)
!134 = distinct !DILexicalBlock(scope: !84, file: !3, line: 76, column: 12)
!135 = !{!136, !108, i64 9}
!136 = !{!"iphdr", !108, i64 0, !108, i64 0, !108, i64 1, !137, i64 2, !137, i64 4, !137, i64 6, !108, i64 8, !108, i64 9, !137, i64 10, !107, i64 12, !107, i64 16}
!137 = !{!"short", !108, i64 0}
!138 = !DILocation(line: 76, column: 26, scope: !134)
!139 = !DILocation(line: 76, column: 12, scope: !84)
!140 = !DILocation(line: 80, column: 13, scope: !141)
!141 = distinct !DILexicalBlock(scope: !84, file: !3, line: 80, column: 13)
!142 = !DILocation(line: 80, column: 13, scope: !84)
!143 = !DILocation(line: 81, column: 48, scope: !141)
!144 = !DILocation(line: 81, column: 20, scope: !141)
!145 = !DILocation(line: 81, column: 13, scope: !141)
!146 = !DILocation(line: 84, column: 1, scope: !84)
