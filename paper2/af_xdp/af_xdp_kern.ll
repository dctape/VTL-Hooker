; ModuleID = 'af_xdp_kern.c'
source_filename = "af_xdp_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xsks_map = global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@xdp_stats_map = global %struct.bpf_map_def { i32 6, i32 4, i32 4, i32 64, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !14
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !27
@llvm.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_sock_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @xdp_sock_prog(%struct.xdp_md* nocapture readonly) #0 section "xdp_sock" !dbg !49 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !63, metadata !DIExpression()), !dbg !67
  %3 = bitcast i32* %2 to i8*, !dbg !68
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !68
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !69
  %5 = load i32, i32* %4, align 4, !dbg !69, !tbaa !70
  call void @llvm.dbg.value(metadata i32 %5, metadata !64, metadata !DIExpression()), !dbg !75
  store i32 %5, i32* %2, align 4, !dbg !75, !tbaa !76
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %3) #3, !dbg !77
  %7 = bitcast i8* %6 to i32*, !dbg !77
  call void @llvm.dbg.value(metadata i32* %7, metadata !65, metadata !DIExpression()), !dbg !78
  %8 = icmp eq i8* %6, null, !dbg !79
  br i1 %8, label %14, label %9, !dbg !81

; <label>:9:                                      ; preds = %1
  %10 = load i32, i32* %7, align 4, !dbg !82, !tbaa !76
  %11 = add i32 %10, 1, !dbg !82
  store i32 %11, i32* %7, align 4, !dbg !82, !tbaa !76
  %12 = and i32 %10, 1, !dbg !85
  %13 = icmp eq i32 %12, 0, !dbg !85
  br i1 %13, label %14, label %20, !dbg !86

; <label>:14:                                     ; preds = %9, %1
  %15 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i8* nonnull %3) #3, !dbg !87
  %16 = icmp eq i8* %15, null, !dbg !87
  br i1 %16, label %20, label %17, !dbg !89

; <label>:17:                                     ; preds = %14
  %18 = load i32, i32* %2, align 4, !dbg !90, !tbaa !76
  call void @llvm.dbg.value(metadata i32 %18, metadata !64, metadata !DIExpression()), !dbg !75
  %19 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 %18, i32 0) #3, !dbg !91
  br label %20, !dbg !92

; <label>:20:                                     ; preds = %14, %9, %17
  %21 = phi i32 [ %19, %17 ], [ 2, %9 ], [ 2, %14 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !93
  ret i32 %21, !dbg !93
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
!llvm.module.flags = !{!45, !46, !47}
!llvm.ident = !{!48}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 7, type: !16, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !13)
!3 = !DIFile(filename: "af_xdp_kern.c", directory: "/home/ubuntu/hooker/paper2")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, size: 32, elements: !7)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/ubuntu/hooker/paper2")
!7 = !{!8, !9, !10, !11, !12}
!8 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!9 = !DIEnumerator(name: "XDP_DROP", value: 1)
!10 = !DIEnumerator(name: "XDP_PASS", value: 2)
!11 = !DIEnumerator(name: "XDP_TX", value: 3)
!12 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!13 = !{!0, !14, !27, !33, !39}
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !3, line: 14, type: !16, isLocal: false, isDefinition: true)
!16 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !17, line: 210, size: 224, elements: !18)
!17 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/ubuntu/hooker/paper2")
!18 = !{!19, !21, !22, !23, !24, !25, !26}
!19 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !16, file: !17, line: 211, baseType: !20, size: 32)
!20 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !16, file: !17, line: 212, baseType: !20, size: 32, offset: 32)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !16, file: !17, line: 213, baseType: !20, size: 32, offset: 64)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !16, file: !17, line: 214, baseType: !20, size: 32, offset: 96)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !16, file: !17, line: 215, baseType: !20, size: 32, offset: 128)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !16, file: !17, line: 216, baseType: !20, size: 32, offset: 160)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !16, file: !17, line: 217, baseType: !20, size: 32, offset: 192)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 43, type: !29, isLocal: false, isDefinition: true)
!29 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 32, elements: !31)
!30 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!31 = !{!32}
!32 = !DISubrange(count: 4)
!33 = !DIGlobalVariableExpression(var: !34, expr: !DIExpression())
!34 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !17, line: 20, type: !35, isLocal: true, isDefinition: true)
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !36, size: 64)
!36 = !DISubroutineType(types: !37)
!37 = !{!38, !38, !38}
!38 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !17, line: 57, type: !41, isLocal: true, isDefinition: true)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DISubroutineType(types: !43)
!43 = !{!44, !38, !44, !44}
!44 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!45 = !{i32 2, !"Dwarf Version", i32 4}
!46 = !{i32 2, !"Debug Info Version", i32 3}
!47 = !{i32 1, !"wchar_size", i32 4}
!48 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!49 = distinct !DISubprogram(name: "xdp_sock_prog", scope: !3, file: !3, line: 22, type: !50, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !62)
!50 = !DISubroutineType(types: !51)
!51 = !{!44, !52}
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !53, size: 64)
!53 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !54)
!54 = !{!55, !58, !59, !60, !61}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !53, file: !6, line: 2857, baseType: !56, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !57, line: 27, baseType: !20)
!57 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/hooker/paper2")
!58 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !53, file: !6, line: 2858, baseType: !56, size: 32, offset: 32)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !53, file: !6, line: 2859, baseType: !56, size: 32, offset: 64)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !53, file: !6, line: 2861, baseType: !56, size: 32, offset: 96)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !53, file: !6, line: 2862, baseType: !56, size: 32, offset: 128)
!62 = !{!63, !64, !65}
!63 = !DILocalVariable(name: "ctx", arg: 1, scope: !49, file: !3, line: 22, type: !52)
!64 = !DILocalVariable(name: "index", scope: !49, file: !3, line: 24, type: !44)
!65 = !DILocalVariable(name: "pkt_count", scope: !49, file: !3, line: 25, type: !66)
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!67 = !DILocation(line: 22, column: 34, scope: !49)
!68 = !DILocation(line: 24, column: 5, scope: !49)
!69 = !DILocation(line: 24, column: 22, scope: !49)
!70 = !{!71, !72, i64 16}
!71 = !{!"xdp_md", !72, i64 0, !72, i64 4, !72, i64 8, !72, i64 12, !72, i64 16}
!72 = !{!"int", !73, i64 0}
!73 = !{!"omnipotent char", !74, i64 0}
!74 = !{!"Simple C/C++ TBAA"}
!75 = !DILocation(line: 24, column: 9, scope: !49)
!76 = !{!72, !72, i64 0}
!77 = !DILocation(line: 27, column: 17, scope: !49)
!78 = !DILocation(line: 25, column: 12, scope: !49)
!79 = !DILocation(line: 28, column: 9, scope: !80)
!80 = distinct !DILexicalBlock(scope: !49, file: !3, line: 28, column: 9)
!81 = !DILocation(line: 28, column: 9, scope: !49)
!82 = !DILocation(line: 31, column: 25, scope: !83)
!83 = distinct !DILexicalBlock(scope: !84, file: !3, line: 31, column: 13)
!84 = distinct !DILexicalBlock(scope: !80, file: !3, line: 28, column: 20)
!85 = !DILocation(line: 31, column: 28, scope: !83)
!86 = !DILocation(line: 31, column: 13, scope: !84)
!87 = !DILocation(line: 37, column: 9, scope: !88)
!88 = distinct !DILexicalBlock(scope: !49, file: !3, line: 37, column: 9)
!89 = !DILocation(line: 37, column: 9, scope: !49)
!90 = !DILocation(line: 38, column: 44, scope: !88)
!91 = !DILocation(line: 38, column: 16, scope: !88)
!92 = !DILocation(line: 38, column: 9, scope: !88)
!93 = !DILocation(line: 41, column: 1, scope: !49)
