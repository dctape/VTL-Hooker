; ModuleID = 'capture_kern.c'
source_filename = "capture_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }

@xsks_map = global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@xdp_sock_prog.____fmt = private unnamed_addr constant [18 x i8] c"ip protocol : %d\0A\00", align 1
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !53
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_sock_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @xdp_sock_prog(%struct.xdp_md* nocapture readonly) #0 section "xdp_sock" !dbg !91 {
  %2 = alloca i32, align 4
  %3 = alloca [18 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !103, metadata !DIExpression()), !dbg !114
  %4 = bitcast i32* %2 to i8*, !dbg !115
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4) #3, !dbg !115
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !116
  %6 = load i32, i32* %5, align 4, !dbg !116, !tbaa !117
  call void @llvm.dbg.value(metadata i32 %6, metadata !104, metadata !DIExpression()), !dbg !122
  store i32 %6, i32* %2, align 4, !dbg !122, !tbaa !123
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !124
  %8 = load i32, i32* %7, align 4, !dbg !124, !tbaa !125
  %9 = zext i32 %8 to i64, !dbg !126
  call void @llvm.dbg.value(metadata i64 %9, metadata !105, metadata !DIExpression()), !dbg !127
  %10 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !128
  %11 = load i32, i32* %10, align 4, !dbg !128, !tbaa !129
  %12 = zext i32 %11 to i64, !dbg !130
  call void @llvm.dbg.value(metadata i64 %12, metadata !106, metadata !DIExpression()), !dbg !131
  %13 = inttoptr i64 %9 to %struct.ethhdr*, !dbg !132
  call void @llvm.dbg.value(metadata %struct.ethhdr* %13, metadata !107, metadata !DIExpression()), !dbg !133
  %14 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 1, !dbg !134
  %15 = inttoptr i64 %12 to %struct.ethhdr*, !dbg !136
  %16 = icmp ugt %struct.ethhdr* %14, %15, !dbg !137
  br i1 %16, label %33, label %17, !dbg !138

; <label>:17:                                     ; preds = %1
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !108, metadata !DIExpression()), !dbg !139
  %18 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 2, i32 1, !dbg !140
  %19 = bitcast [6 x i8]* %18 to %struct.iphdr*, !dbg !140
  %20 = inttoptr i64 %12 to %struct.iphdr*, !dbg !142
  %21 = icmp ugt %struct.iphdr* %19, %20, !dbg !143
  br i1 %21, label %33, label %22, !dbg !144

; <label>:22:                                     ; preds = %17
  %23 = getelementptr inbounds [18 x i8], [18 x i8]* %3, i64 0, i64 0, !dbg !145
  call void @llvm.lifetime.start.p0i8(i64 18, i8* nonnull %23) #3, !dbg !145
  call void @llvm.dbg.declare(metadata [18 x i8]* %3, metadata !109, metadata !DIExpression()), !dbg !145
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %23, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @xdp_sock_prog.____fmt, i64 0, i64 0), i64 18, i32 1, i1 false), !dbg !145
  %24 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 1, i32 1, i64 3, !dbg !145
  %25 = load i8, i8* %24, align 1, !dbg !145, !tbaa !146
  %26 = zext i8 %25 to i32, !dbg !145
  %27 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %23, i32 18, i32 %26) #3, !dbg !145
  call void @llvm.lifetime.end.p0i8(i64 18, i8* nonnull %23) #3, !dbg !149
  %28 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i8* nonnull %4) #3, !dbg !150
  %29 = icmp eq i8* %28, null, !dbg !150
  br i1 %29, label %33, label %30, !dbg !152

; <label>:30:                                     ; preds = %22
  %31 = load i32, i32* %2, align 4, !dbg !153, !tbaa !123
  call void @llvm.dbg.value(metadata i32 %31, metadata !104, metadata !DIExpression()), !dbg !122
  %32 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 %31, i32 0) #3, !dbg !154
  br label %33, !dbg !155

; <label>:33:                                     ; preds = %30, %17, %22, %1
  %34 = phi i32 [ 1, %1 ], [ %32, %30 ], [ 1, %17 ], [ 2, %22 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #3, !dbg !156
  ret i32 %34, !dbg !156
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!87, !88, !89}
!llvm.ident = !{!90}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 9, type: !78, isLocal: false, isDefinition: true)
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
!52 = !{!0, !53, !59, !68, !73}
!53 = !DIGlobalVariableExpression(var: !54, expr: !DIExpression())
!54 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 67, type: !55, isLocal: false, isDefinition: true)
!55 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 32, elements: !57)
!56 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!57 = !{!58}
!58 = !DISubrange(count: 4)
!59 = !DIGlobalVariableExpression(var: !60, expr: !DIExpression())
!60 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !61, line: 38, type: !62, isLocal: true, isDefinition: true)
!61 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/ubuntu/Hooker/capture")
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DISubroutineType(types: !64)
!64 = !{!65, !66, !65, null}
!65 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !56)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !61, line: 20, type: !70, isLocal: true, isDefinition: true)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = !DISubroutineType(types: !72)
!72 = !{!14, !14, !14}
!73 = !DIGlobalVariableExpression(var: !74, expr: !DIExpression())
!74 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !61, line: 57, type: !75, isLocal: true, isDefinition: true)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DISubroutineType(types: !77)
!77 = !{!65, !14, !65, !65}
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !61, line: 210, size: 224, elements: !79)
!79 = !{!80, !81, !82, !83, !84, !85, !86}
!80 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !78, file: !61, line: 211, baseType: !50, size: 32)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !78, file: !61, line: 212, baseType: !50, size: 32, offset: 32)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !78, file: !61, line: 213, baseType: !50, size: 32, offset: 64)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !78, file: !61, line: 214, baseType: !50, size: 32, offset: 96)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !78, file: !61, line: 215, baseType: !50, size: 32, offset: 128)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !78, file: !61, line: 216, baseType: !50, size: 32, offset: 160)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !78, file: !61, line: 217, baseType: !50, size: 32, offset: 192)
!87 = !{i32 2, !"Dwarf Version", i32 4}
!88 = !{i32 2, !"Debug Info Version", i32 3}
!89 = !{i32 1, !"wchar_size", i32 4}
!90 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!91 = distinct !DISubprogram(name: "xdp_sock_prog", scope: !3, file: !3, line: 32, type: !92, isLocal: false, isDefinition: true, scopeLine: 33, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !102)
!92 = !DISubroutineType(types: !93)
!93 = !{!65, !94}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !95, size: 64)
!95 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !96)
!96 = !{!97, !98, !99, !100, !101}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !95, file: !6, line: 2857, baseType: !49, size: 32)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !95, file: !6, line: 2858, baseType: !49, size: 32, offset: 32)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !95, file: !6, line: 2859, baseType: !49, size: 32, offset: 64)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !95, file: !6, line: 2861, baseType: !49, size: 32, offset: 96)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !95, file: !6, line: 2862, baseType: !49, size: 32, offset: 128)
!102 = !{!103, !104, !105, !106, !107, !108, !109}
!103 = !DILocalVariable(name: "ctx", arg: 1, scope: !91, file: !3, line: 32, type: !94)
!104 = !DILocalVariable(name: "index", scope: !91, file: !3, line: 34, type: !65)
!105 = !DILocalVariable(name: "data", scope: !91, file: !3, line: 48, type: !14)
!106 = !DILocalVariable(name: "data_end", scope: !91, file: !3, line: 49, type: !14)
!107 = !DILocalVariable(name: "eth", scope: !91, file: !3, line: 51, type: !16)
!108 = !DILocalVariable(name: "iph", scope: !91, file: !3, line: 55, type: !32)
!109 = !DILocalVariable(name: "____fmt", scope: !110, file: !3, line: 59, type: !111)
!110 = distinct !DILexicalBlock(scope: !91, file: !3, line: 59, column: 9)
!111 = !DICompositeType(tag: DW_TAG_array_type, baseType: !56, size: 144, elements: !112)
!112 = !{!113}
!113 = !DISubrange(count: 18)
!114 = !DILocation(line: 32, column: 34, scope: !91)
!115 = !DILocation(line: 34, column: 9, scope: !91)
!116 = !DILocation(line: 34, column: 26, scope: !91)
!117 = !{!118, !119, i64 16}
!118 = !{!"xdp_md", !119, i64 0, !119, i64 4, !119, i64 8, !119, i64 12, !119, i64 16}
!119 = !{!"int", !120, i64 0}
!120 = !{!"omnipotent char", !121, i64 0}
!121 = !{!"Simple C/C++ TBAA"}
!122 = !DILocation(line: 34, column: 13, scope: !91)
!123 = !{!119, !119, i64 0}
!124 = !DILocation(line: 48, column: 41, scope: !91)
!125 = !{!118, !119, i64 0}
!126 = !DILocation(line: 48, column: 30, scope: !91)
!127 = !DILocation(line: 48, column: 15, scope: !91)
!128 = !DILocation(line: 49, column: 45, scope: !91)
!129 = !{!118, !119, i64 4}
!130 = !DILocation(line: 49, column: 34, scope: !91)
!131 = !DILocation(line: 49, column: 15, scope: !91)
!132 = !DILocation(line: 51, column: 30, scope: !91)
!133 = !DILocation(line: 51, column: 24, scope: !91)
!134 = !DILocation(line: 52, column: 16, scope: !135)
!135 = distinct !DILexicalBlock(scope: !91, file: !3, line: 52, column: 12)
!136 = !DILocation(line: 52, column: 22, scope: !135)
!137 = !DILocation(line: 52, column: 20, scope: !135)
!138 = !DILocation(line: 52, column: 12, scope: !91)
!139 = !DILocation(line: 55, column: 23, scope: !91)
!140 = !DILocation(line: 56, column: 16, scope: !141)
!141 = distinct !DILexicalBlock(scope: !91, file: !3, line: 56, column: 12)
!142 = !DILocation(line: 56, column: 22, scope: !141)
!143 = !DILocation(line: 56, column: 20, scope: !141)
!144 = !DILocation(line: 56, column: 12, scope: !91)
!145 = !DILocation(line: 59, column: 9, scope: !110)
!146 = !{!147, !120, i64 9}
!147 = !{!"iphdr", !120, i64 0, !120, i64 0, !120, i64 1, !148, i64 2, !148, i64 4, !148, i64 6, !120, i64 8, !120, i64 9, !148, i64 10, !119, i64 12, !119, i64 16}
!148 = !{!"short", !120, i64 0}
!149 = !DILocation(line: 59, column: 9, scope: !91)
!150 = !DILocation(line: 61, column: 13, scope: !151)
!151 = distinct !DILexicalBlock(scope: !91, file: !3, line: 61, column: 13)
!152 = !DILocation(line: 61, column: 13, scope: !91)
!153 = !DILocation(line: 62, column: 48, scope: !151)
!154 = !DILocation(line: 62, column: 20, scope: !151)
!155 = !DILocation(line: 62, column: 13, scope: !151)
!156 = !DILocation(line: 65, column: 1, scope: !91)
