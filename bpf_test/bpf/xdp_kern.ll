; ModuleID = 'xdp_kern.c'
source_filename = "xdp_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xdp_map = global %struct.bpf_map_def { i32 12, i32 4, i32 4, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !14
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_count_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @xdp_count_prog(%struct.xdp_md* nocapture readnone) #0 section "xdp_count" !dbg !41 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !56, metadata !DIExpression()), !dbg !67
  %3 = bitcast i32* %2 to i8*, !dbg !68
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !68
  call void @llvm.dbg.value(metadata i32 0, metadata !57, metadata !DIExpression()), !dbg !69
  store i32 0, i32* %2, align 4, !dbg !69, !tbaa !70
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_map to i8*), i8* nonnull %3) #3, !dbg !74
  call void @llvm.dbg.value(metadata i8* %4, metadata !58, metadata !DIExpression()), !dbg !75
  %5 = icmp eq i8* %4, null, !dbg !76
  br i1 %5, label %13, label %6, !dbg !78

; <label>:6:                                      ; preds = %1
  %7 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* nonnull %4, i8* nonnull %3) #3, !dbg !79
  call void @llvm.dbg.value(metadata i8* %7, metadata !60, metadata !DIExpression()), !dbg !80
  %8 = icmp eq i8* %7, null, !dbg !81
  br i1 %8, label %13, label %9, !dbg !83

; <label>:9:                                      ; preds = %6
  %10 = bitcast i8* %7 to i32*, !dbg !84
  %11 = load i32, i32* %10, align 4, !dbg !84, !tbaa !85
  %12 = add nsw i32 %11, 1, !dbg !87
  store i32 %12, i32* %10, align 4, !dbg !88, !tbaa !85
  br label %13, !dbg !89

; <label>:13:                                     ; preds = %6, %1, %9
  %14 = phi i32 [ 2, %9 ], [ 0, %1 ], [ 0, %6 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !90
  ret i32 %14, !dbg !90
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
!llvm.module.flags = !{!37, !38, !39}
!llvm.ident = !{!40}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_map", scope: !2, file: !3, line: 12, type: !27, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !13)
!3 = !DIFile(filename: "xdp_kern.c", directory: "/home/ubuntu/bpf_test/bpf")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, size: 32, elements: !7)
!6 = !DIFile(filename: "./include/linux/bpf.h", directory: "/home/ubuntu/bpf_test/bpf")
!7 = !{!8, !9, !10, !11, !12}
!8 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!9 = !DIEnumerator(name: "XDP_DROP", value: 1)
!10 = !DIEnumerator(name: "XDP_PASS", value: 2)
!11 = !DIEnumerator(name: "XDP_TX", value: 3)
!12 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!13 = !{!0, !14, !20}
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 42, type: !16, isLocal: false, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 32, elements: !18)
!17 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!18 = !{!19}
!19 = !DISubrange(count: 4)
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !22, line: 20, type: !23, isLocal: true, isDefinition: true)
!22 = !DIFile(filename: "./include/bpf/bpf_helpers.h", directory: "/home/ubuntu/bpf_test/bpf")
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DISubroutineType(types: !25)
!25 = !{!26, !26, !26}
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !22, line: 210, size: 224, elements: !28)
!28 = !{!29, !31, !32, !33, !34, !35, !36}
!29 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !27, file: !22, line: 211, baseType: !30, size: 32)
!30 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !27, file: !22, line: 212, baseType: !30, size: 32, offset: 32)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !27, file: !22, line: 213, baseType: !30, size: 32, offset: 64)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !27, file: !22, line: 214, baseType: !30, size: 32, offset: 96)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !27, file: !22, line: 215, baseType: !30, size: 32, offset: 128)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !27, file: !22, line: 216, baseType: !30, size: 32, offset: 160)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !27, file: !22, line: 217, baseType: !30, size: 32, offset: 192)
!37 = !{i32 2, !"Dwarf Version", i32 4}
!38 = !{i32 2, !"Debug Info Version", i32 3}
!39 = !{i32 1, !"wchar_size", i32 4}
!40 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!41 = distinct !DISubprogram(name: "xdp_count_prog", scope: !3, file: !3, line: 21, type: !42, isLocal: false, isDefinition: true, scopeLine: 22, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !55)
!42 = !DISubroutineType(types: !43)
!43 = !{!44, !45}
!44 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !47)
!47 = !{!48, !51, !52, !53, !54}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !46, file: !6, line: 2857, baseType: !49, size: 32)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !50, line: 27, baseType: !30)
!50 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/bpf_test/bpf")
!51 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !46, file: !6, line: 2858, baseType: !49, size: 32, offset: 32)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !46, file: !6, line: 2859, baseType: !49, size: 32, offset: 64)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !46, file: !6, line: 2861, baseType: !49, size: 32, offset: 96)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !46, file: !6, line: 2862, baseType: !49, size: 32, offset: 128)
!55 = !{!56, !57, !58, !60}
!56 = !DILocalVariable(name: "ctx", arg: 1, scope: !41, file: !3, line: 21, type: !45)
!57 = !DILocalVariable(name: "key", scope: !41, file: !3, line: 23, type: !44)
!58 = !DILocalVariable(name: "shared_map", scope: !41, file: !3, line: 24, type: !59)
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!60 = !DILocalVariable(name: "cnt", scope: !41, file: !3, line: 26, type: !61)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_cnt", file: !3, line: 4, size: 96, elements: !63)
!63 = !{!64, !65, !66}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "xdp_cnt", scope: !62, file: !3, line: 6, baseType: !44, size: 32)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "tc_cnt", scope: !62, file: !3, line: 7, baseType: !44, size: 32, offset: 32)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "tot_cnt", scope: !62, file: !3, line: 8, baseType: !44, size: 32, offset: 64)
!67 = !DILocation(line: 21, column: 35, scope: !41)
!68 = !DILocation(line: 23, column: 9, scope: !41)
!69 = !DILocation(line: 23, column: 13, scope: !41)
!70 = !{!71, !71, i64 0}
!71 = !{!"int", !72, i64 0}
!72 = !{!"omnipotent char", !73, i64 0}
!73 = !{!"Simple C/C++ TBAA"}
!74 = !DILocation(line: 29, column: 22, scope: !41)
!75 = !DILocation(line: 24, column: 14, scope: !41)
!76 = !DILocation(line: 30, column: 14, scope: !77)
!77 = distinct !DILexicalBlock(scope: !41, file: !3, line: 30, column: 13)
!78 = !DILocation(line: 30, column: 13, scope: !41)
!79 = !DILocation(line: 33, column: 15, scope: !41)
!80 = !DILocation(line: 26, column: 25, scope: !41)
!81 = !DILocation(line: 34, column: 14, scope: !82)
!82 = distinct !DILexicalBlock(scope: !41, file: !3, line: 34, column: 13)
!83 = !DILocation(line: 34, column: 13, scope: !41)
!84 = !DILocation(line: 36, column: 29, scope: !41)
!85 = !{!86, !71, i64 0}
!86 = !{!"bpf_cnt", !71, i64 0, !71, i64 4, !71, i64 8}
!87 = !DILocation(line: 36, column: 37, scope: !41)
!88 = !DILocation(line: 36, column: 22, scope: !41)
!89 = !DILocation(line: 38, column: 9, scope: !41)
!90 = !DILocation(line: 40, column: 1, scope: !41)
