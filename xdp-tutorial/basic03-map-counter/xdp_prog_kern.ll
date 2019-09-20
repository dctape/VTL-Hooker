; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 2, i32 4, i32 8, i32 5, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !15
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_stats1_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_stats1_func(%struct.xdp_md* nocapture readnone) #0 section "xdp_stats1" !dbg !41 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !56, metadata !DIExpression()), !dbg !66
  %3 = bitcast i32* %2 to i8*, !dbg !67
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !67
  call void @llvm.dbg.value(metadata i32 2, metadata !65, metadata !DIExpression()), !dbg !68
  store i32 2, i32* %2, align 4, !dbg !68, !tbaa !69
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %3) #3, !dbg !73
  %5 = icmp eq i8* %4, null, !dbg !74
  br i1 %5, label %9, label %6, !dbg !76

; <label>:6:                                      ; preds = %1
  call void @llvm.dbg.value(metadata i8* %4, metadata !57, metadata !DIExpression()), !dbg !77
  %7 = bitcast i8* %4 to i64*, !dbg !78
  %8 = atomicrmw add i64* %7, i64 1 seq_cst, !dbg !78
  br label %9, !dbg !79

; <label>:9:                                      ; preds = %1, %6
  %10 = phi i32 [ 2, %6 ], [ 0, %1 ], !dbg !80
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !81
  ret i32 %10, !dbg !81
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
!llvm.module.flags = !{!37, !38, !39}
!llvm.ident = !{!40}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !3, line: 11, type: !28, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !14, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/fedora/xdp-tutorial/basic03-map-counter")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/fedora/xdp-tutorial/basic03-map-counter")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !{!0, !15, !21}
!15 = !DIGlobalVariableExpression(var: !16, expr: !DIExpression())
!16 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 56, type: !17, isLocal: false, isDefinition: true)
!17 = !DICompositeType(tag: DW_TAG_array_type, baseType: !18, size: 32, elements: !19)
!18 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!19 = !{!20}
!20 = !DISubrange(count: 4)
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !23, line: 20, type: !24, isLocal: true, isDefinition: true)
!23 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/fedora/xdp-tutorial/basic03-map-counter")
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DISubroutineType(types: !26)
!26 = !{!27, !27, !27}
!27 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !23, line: 210, size: 224, elements: !29)
!29 = !{!30, !31, !32, !33, !34, !35, !36}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !28, file: !23, line: 211, baseType: !7, size: 32)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !28, file: !23, line: 212, baseType: !7, size: 32, offset: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !28, file: !23, line: 213, baseType: !7, size: 32, offset: 64)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !28, file: !23, line: 214, baseType: !7, size: 32, offset: 96)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !28, file: !23, line: 215, baseType: !7, size: 32, offset: 128)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !28, file: !23, line: 216, baseType: !7, size: 32, offset: 160)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !28, file: !23, line: 217, baseType: !7, size: 32, offset: 192)
!37 = !{i32 2, !"Dwarf Version", i32 4}
!38 = !{i32 2, !"Debug Info Version", i32 3}
!39 = !{i32 1, !"wchar_size", i32 4}
!40 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!41 = distinct !DISubprogram(name: "xdp_stats1_func", scope: !3, file: !3, line: 26, type: !42, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !55)
!42 = !DISubroutineType(types: !43)
!43 = !{!44, !45}
!44 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !47)
!47 = !{!48, !51, !52, !53, !54}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !46, file: !6, line: 2857, baseType: !49, size: 32)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !50, line: 27, baseType: !7)
!50 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!51 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !46, file: !6, line: 2858, baseType: !49, size: 32, offset: 32)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !46, file: !6, line: 2859, baseType: !49, size: 32, offset: 64)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !46, file: !6, line: 2861, baseType: !49, size: 32, offset: 96)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !46, file: !6, line: 2862, baseType: !49, size: 32, offset: 128)
!55 = !{!56, !57, !65}
!56 = !DILocalVariable(name: "ctx", arg: 1, scope: !41, file: !3, line: 26, type: !45)
!57 = !DILocalVariable(name: "rec", scope: !41, file: !3, line: 30, type: !58)
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !60, line: 8, size: 64, elements: !61)
!60 = !DIFile(filename: "./common_kern_user.h", directory: "/home/fedora/xdp-tutorial/basic03-map-counter")
!61 = !{!62}
!62 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !59, file: !60, line: 9, baseType: !63, size: 64)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !50, line: 31, baseType: !64)
!64 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!65 = !DILocalVariable(name: "key", scope: !41, file: !3, line: 31, type: !49)
!66 = !DILocation(line: 26, column: 37, scope: !41)
!67 = !DILocation(line: 31, column: 2, scope: !41)
!68 = !DILocation(line: 31, column: 8, scope: !41)
!69 = !{!70, !70, i64 0}
!70 = !{!"int", !71, i64 0}
!71 = !{!"omnipotent char", !72, i64 0}
!72 = !{!"Simple C/C++ TBAA"}
!73 = !DILocation(line: 34, column: 8, scope: !41)
!74 = !DILocation(line: 39, column: 7, scope: !75)
!75 = distinct !DILexicalBlock(scope: !41, file: !3, line: 39, column: 6)
!76 = !DILocation(line: 39, column: 6, scope: !41)
!77 = !DILocation(line: 30, column: 18, scope: !41)
!78 = !DILocation(line: 45, column: 2, scope: !41)
!79 = !DILocation(line: 53, column: 2, scope: !41)
!80 = !DILocation(line: 0, scope: !41)
!81 = !DILocation(line: 54, column: 1, scope: !41)
