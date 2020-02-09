; ModuleID = 'tail_call_kern.c'
source_filename = "tail_call_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@jmp_table1 = global %struct.bpf_map_def { i32 3, i32 4, i32 4, i32 100, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@jmp_table2 = global %struct.bpf_map_def { i32 3, i32 4, i32 4, i32 100, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !17
@xdp_prog.____fmt = private unnamed_addr constant [25 x i8] c"XDP: point d'entr\C3\A9e %d\0A\00", align 1
@xdp_prog.____fmt.1 = private unnamed_addr constant [48 x i8] c"XDP: jmp_table empty, bpf_tail_call \22failed\22 !\0A\00", align 1
@xdp_tail_call_1.____fmt = private unnamed_addr constant [37 x i8] c"XDP: tail call succeed (xdp_1) id=1\0A\00", align 1
@xdp_tail_call_2.____fmt = private unnamed_addr constant [45 x i8] c"XDP: tail call succeed (xdp_5) id=5 hash=%u\0A\00", align 1
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !30
@llvm.used = appending global [6 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @jmp_table1 to i8*), i8* bitcast (%struct.bpf_map_def* @jmp_table2 to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prog to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_tail_call_1 to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_tail_call_2 to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @xdp_prog(%struct.xdp_md*) #0 section "xdp_entry_point" !dbg !53 {
  %2 = alloca [25 x i8], align 1
  %3 = alloca [48 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !67, metadata !DIExpression()), !dbg !96
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !97
  %5 = load i32, i32* %4, align 4, !dbg !97, !tbaa !98
  %6 = zext i32 %5 to i64, !dbg !103
  call void @llvm.dbg.value(metadata i64 %6, metadata !68, metadata !DIExpression()), !dbg !104
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !105
  %8 = load i32, i32* %7, align 4, !dbg !105, !tbaa !106
  %9 = zext i32 %8 to i64, !dbg !107
  call void @llvm.dbg.value(metadata i64 %9, metadata !69, metadata !DIExpression()), !dbg !108
  %10 = inttoptr i64 %9 to %struct.ethhdr*, !dbg !109
  call void @llvm.dbg.value(metadata %struct.ethhdr* %10, metadata !70, metadata !DIExpression()), !dbg !110
  %11 = getelementptr inbounds [25 x i8], [25 x i8]* %2, i64 0, i64 0, !dbg !111
  call void @llvm.lifetime.start.p0i8(i64 25, i8* nonnull %11) #3, !dbg !111
  call void @llvm.dbg.declare(metadata [25 x i8]* %2, metadata !86, metadata !DIExpression()), !dbg !111
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %11, i8* getelementptr inbounds ([25 x i8], [25 x i8]* @xdp_prog.____fmt, i64 0, i64 0), i64 25, i32 1, i1 false), !dbg !111
  %12 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %11, i32 25, i32 0) #3, !dbg !111
  call void @llvm.lifetime.end.p0i8(i64 25, i8* nonnull %11) #3, !dbg !112
  %13 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %10, i64 1, !dbg !113
  %14 = inttoptr i64 %6 to %struct.ethhdr*, !dbg !115
  %15 = icmp ugt %struct.ethhdr* %13, %14, !dbg !116
  br i1 %15, label %20, label %16, !dbg !117

; <label>:16:                                     ; preds = %1
  %17 = bitcast %struct.xdp_md* %0 to i8*, !dbg !118
  call void inttoptr (i64 12 to void (i8*, i8*, i32)*)(i8* %17, i8* bitcast (%struct.bpf_map_def* @jmp_table1 to i8*), i32 1) #3, !dbg !119
  %18 = getelementptr inbounds [48 x i8], [48 x i8]* %3, i64 0, i64 0, !dbg !120
  call void @llvm.lifetime.start.p0i8(i64 48, i8* nonnull %18) #3, !dbg !120
  call void @llvm.dbg.declare(metadata [48 x i8]* %3, metadata !91, metadata !DIExpression()), !dbg !120
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %18, i8* getelementptr inbounds ([48 x i8], [48 x i8]* @xdp_prog.____fmt.1, i64 0, i64 0), i64 48, i32 1, i1 false), !dbg !120
  %19 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %18, i32 48) #3, !dbg !120
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %18) #3, !dbg !121
  br label %20, !dbg !122

; <label>:20:                                     ; preds = %1, %16
  %21 = phi i32 [ 2, %16 ], [ 0, %1 ]
  ret i32 %21, !dbg !123
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
define i32 @xdp_tail_call_1(%struct.xdp_md*) #0 section "xdp_1" !dbg !124 {
  %2 = alloca [37 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !126, metadata !DIExpression()), !dbg !132
  %3 = getelementptr inbounds [37 x i8], [37 x i8]* %2, i64 0, i64 0, !dbg !133
  call void @llvm.lifetime.start.p0i8(i64 37, i8* nonnull %3) #3, !dbg !133
  call void @llvm.dbg.declare(metadata [37 x i8]* %2, metadata !127, metadata !DIExpression()), !dbg !133
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %3, i8* getelementptr inbounds ([37 x i8], [37 x i8]* @xdp_tail_call_1.____fmt, i64 0, i64 0), i64 37, i32 1, i1 false), !dbg !133
  %4 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %3, i32 37) #3, !dbg !133
  call void @llvm.lifetime.end.p0i8(i64 37, i8* nonnull %3) #3, !dbg !134
  %5 = bitcast %struct.xdp_md* %0 to i8*, !dbg !135
  call void inttoptr (i64 12 to void (i8*, i8*, i32)*)(i8* %5, i8* bitcast (%struct.bpf_map_def* @jmp_table1 to i8*), i32 5) #3, !dbg !136
  ret i32 2, !dbg !137
}

; Function Attrs: nounwind
define i32 @xdp_tail_call_2(%struct.xdp_md* nocapture readnone) #0 section "xdp_5" !dbg !138 {
  %2 = alloca i32, align 4
  %3 = alloca [45 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !140, metadata !DIExpression()), !dbg !148
  %4 = bitcast i32* %2 to i8*, !dbg !149
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4), !dbg !149
  call void @llvm.dbg.value(metadata i32 0, metadata !141, metadata !DIExpression()), !dbg !150
  store volatile i32 0, i32* %2, align 4, !dbg !150
  %5 = getelementptr inbounds [45 x i8], [45 x i8]* %3, i64 0, i64 0, !dbg !151
  call void @llvm.lifetime.start.p0i8(i64 45, i8* nonnull %5) #3, !dbg !151
  call void @llvm.dbg.declare(metadata [45 x i8]* %3, metadata !143, metadata !DIExpression()), !dbg !151
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %5, i8* getelementptr inbounds ([45 x i8], [45 x i8]* @xdp_tail_call_2.____fmt, i64 0, i64 0), i64 45, i32 1, i1 false), !dbg !151
  %6 = load volatile i32, i32* %2, align 4, !dbg !151
  call void @llvm.dbg.value(metadata i32 %6, metadata !141, metadata !DIExpression()), !dbg !150
  %7 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %5, i32 45, i32 %6) #3, !dbg !151
  call void @llvm.lifetime.end.p0i8(i64 45, i8* nonnull %5) #3, !dbg !152
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4), !dbg !153
  ret i32 2, !dbg !154
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!49, !50, !51}
!llvm.ident = !{!52}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "jmp_table1", scope: !2, file: !3, line: 20, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !16)
!3 = !DIFile(filename: "tail_call_kern.c", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, size: 32, elements: !7)
!6 = !DIFile(filename: "./include/linux/bpf.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!7 = !{!8, !9, !10, !11, !12}
!8 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!9 = !DIEnumerator(name: "XDP_DROP", value: 1)
!10 = !DIEnumerator(name: "XDP_PASS", value: 2)
!11 = !DIEnumerator(name: "XDP_TX", value: 3)
!12 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!13 = !{!14, !15}
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!15 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!16 = !{!0, !17, !30, !36, !44}
!17 = !DIGlobalVariableExpression(var: !18, expr: !DIExpression())
!18 = distinct !DIGlobalVariable(name: "jmp_table2", scope: !2, file: !3, line: 27, type: !19, isLocal: false, isDefinition: true)
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !20, line: 210, size: 224, elements: !21)
!20 = !DIFile(filename: "./include/bpf/bpf_helpers.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!21 = !{!22, !24, !25, !26, !27, !28, !29}
!22 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !19, file: !20, line: 211, baseType: !23, size: 32)
!23 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !19, file: !20, line: 212, baseType: !23, size: 32, offset: 32)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !19, file: !20, line: 213, baseType: !23, size: 32, offset: 64)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !19, file: !20, line: 214, baseType: !23, size: 32, offset: 96)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !19, file: !20, line: 215, baseType: !23, size: 32, offset: 128)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !19, file: !20, line: 216, baseType: !23, size: 32, offset: 160)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !19, file: !20, line: 217, baseType: !23, size: 32, offset: 192)
!30 = !DIGlobalVariableExpression(var: !31, expr: !DIExpression())
!31 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 97, type: !32, isLocal: false, isDefinition: true)
!32 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 32, elements: !34)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{!35}
!35 = !DISubrange(count: 4)
!36 = !DIGlobalVariableExpression(var: !37, expr: !DIExpression())
!37 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !20, line: 38, type: !38, isLocal: true, isDefinition: true)
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!39 = !DISubroutineType(types: !40)
!40 = !{!41, !42, !41, null}
!41 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!44 = !DIGlobalVariableExpression(var: !45, expr: !DIExpression())
!45 = distinct !DIGlobalVariable(name: "bpf_tail_call", scope: !2, file: !20, line: 40, type: !46, isLocal: true, isDefinition: true)
!46 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !47, size: 64)
!47 = !DISubroutineType(types: !48)
!48 = !{null, !14, !14, !41}
!49 = !{i32 2, !"Dwarf Version", i32 4}
!50 = !{i32 2, !"Debug Info Version", i32 3}
!51 = !{i32 1, !"wchar_size", i32 4}
!52 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!53 = distinct !DISubprogram(name: "xdp_prog", scope: !3, file: !3, line: 37, type: !54, isLocal: false, isDefinition: true, scopeLine: 38, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !66)
!54 = !DISubroutineType(types: !55)
!55 = !{!41, !56}
!56 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !57, size: 64)
!57 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !58)
!58 = !{!59, !62, !63, !64, !65}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !57, file: !6, line: 2857, baseType: !60, size: 32)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !61, line: 27, baseType: !23)
!61 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!62 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !57, file: !6, line: 2858, baseType: !60, size: 32, offset: 32)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !57, file: !6, line: 2859, baseType: !60, size: 32, offset: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !57, file: !6, line: 2861, baseType: !60, size: 32, offset: 96)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !57, file: !6, line: 2862, baseType: !60, size: 32, offset: 128)
!66 = !{!67, !68, !69, !70, !86, !91}
!67 = !DILocalVariable(name: "ctx", arg: 1, scope: !53, file: !3, line: 37, type: !56)
!68 = !DILocalVariable(name: "data_end", scope: !53, file: !3, line: 39, type: !14)
!69 = !DILocalVariable(name: "data", scope: !53, file: !3, line: 40, type: !14)
!70 = !DILocalVariable(name: "eth", scope: !53, file: !3, line: 41, type: !71)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !73, line: 163, size: 112, elements: !74)
!73 = !DIFile(filename: "./include/linux/if_ether.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!74 = !{!75, !80, !81}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !72, file: !73, line: 164, baseType: !76, size: 48)
!76 = !DICompositeType(tag: DW_TAG_array_type, baseType: !77, size: 48, elements: !78)
!77 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!78 = !{!79}
!79 = !DISubrange(count: 6)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !72, file: !73, line: 165, baseType: !76, size: 48, offset: 48)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !72, file: !73, line: 166, baseType: !82, size: 16, offset: 96)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !83, line: 25, baseType: !84)
!83 = !DIFile(filename: "/usr/include/linux/types.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !61, line: 24, baseType: !85)
!85 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!86 = !DILocalVariable(name: "____fmt", scope: !87, file: !3, line: 43, type: !88)
!87 = distinct !DILexicalBlock(scope: !53, file: !3, line: 43, column: 8)
!88 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 200, elements: !89)
!89 = !{!90}
!90 = !DISubrange(count: 25)
!91 = !DILocalVariable(name: "____fmt", scope: !92, file: !3, line: 54, type: !93)
!92 = distinct !DILexicalBlock(scope: !53, file: !3, line: 54, column: 2)
!93 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 384, elements: !94)
!94 = !{!95}
!95 = !DISubrange(count: 48)
!96 = !DILocation(line: 37, column: 29, scope: !53)
!97 = !DILocation(line: 39, column: 45, scope: !53)
!98 = !{!99, !100, i64 4}
!99 = !{!"xdp_md", !100, i64 0, !100, i64 4, !100, i64 8, !100, i64 12, !100, i64 16}
!100 = !{!"int", !101, i64 0}
!101 = !{!"omnipotent char", !102, i64 0}
!102 = !{!"Simple C/C++ TBAA"}
!103 = !DILocation(line: 39, column: 34, scope: !53)
!104 = !DILocation(line: 39, column: 15, scope: !53)
!105 = !DILocation(line: 40, column: 41, scope: !53)
!106 = !{!99, !100, i64 0}
!107 = !DILocation(line: 40, column: 30, scope: !53)
!108 = !DILocation(line: 40, column: 15, scope: !53)
!109 = !DILocation(line: 41, column: 30, scope: !53)
!110 = !DILocation(line: 41, column: 24, scope: !53)
!111 = !DILocation(line: 43, column: 8, scope: !87)
!112 = !DILocation(line: 43, column: 8, scope: !53)
!113 = !DILocation(line: 46, column: 10, scope: !114)
!114 = distinct !DILexicalBlock(scope: !53, file: !3, line: 46, column: 6)
!115 = !DILocation(line: 46, column: 16, scope: !114)
!116 = !DILocation(line: 46, column: 14, scope: !114)
!117 = !DILocation(line: 46, column: 6, scope: !53)
!118 = !DILocation(line: 49, column: 16, scope: !53)
!119 = !DILocation(line: 49, column: 2, scope: !53)
!120 = !DILocation(line: 54, column: 2, scope: !92)
!121 = !DILocation(line: 54, column: 2, scope: !53)
!122 = !DILocation(line: 55, column: 2, scope: !53)
!123 = !DILocation(line: 57, column: 1, scope: !53)
!124 = distinct !DISubprogram(name: "xdp_tail_call_1", scope: !3, file: !3, line: 67, type: !54, isLocal: false, isDefinition: true, scopeLine: 68, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !125)
!125 = !{!126, !127}
!126 = !DILocalVariable(name: "ctx", arg: 1, scope: !124, file: !3, line: 67, type: !56)
!127 = !DILocalVariable(name: "____fmt", scope: !128, file: !3, line: 73, type: !129)
!128 = distinct !DILexicalBlock(scope: !124, file: !3, line: 73, column: 2)
!129 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 296, elements: !130)
!130 = !{!131}
!131 = !DISubrange(count: 37)
!132 = !DILocation(line: 67, column: 37, scope: !124)
!133 = !DILocation(line: 73, column: 2, scope: !128)
!134 = !DILocation(line: 73, column: 2, scope: !124)
!135 = !DILocation(line: 75, column: 16, scope: !124)
!136 = !DILocation(line: 75, column: 2, scope: !124)
!137 = !DILocation(line: 77, column: 2, scope: !124)
!138 = distinct !DISubprogram(name: "xdp_tail_call_2", scope: !3, file: !3, line: 82, type: !54, isLocal: false, isDefinition: true, scopeLine: 83, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !139)
!139 = !{!140, !141, !143}
!140 = !DILocalVariable(name: "ctx", arg: 1, scope: !138, file: !3, line: 82, type: !56)
!141 = !DILocalVariable(name: "hash", scope: !138, file: !3, line: 87, type: !142)
!142 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !60)
!143 = !DILocalVariable(name: "____fmt", scope: !144, file: !3, line: 91, type: !145)
!144 = distinct !DILexicalBlock(scope: !138, file: !3, line: 91, column: 2)
!145 = !DICompositeType(tag: DW_TAG_array_type, baseType: !33, size: 360, elements: !146)
!146 = !{!147}
!147 = !DISubrange(count: 45)
!148 = !DILocation(line: 82, column: 37, scope: !138)
!149 = !DILocation(line: 87, column: 2, scope: !138)
!150 = !DILocation(line: 87, column: 17, scope: !138)
!151 = !DILocation(line: 91, column: 2, scope: !144)
!152 = !DILocation(line: 91, column: 2, scope: !138)
!153 = !DILocation(line: 95, column: 1, scope: !138)
!154 = !DILocation(line: 94, column: 2, scope: !138)
