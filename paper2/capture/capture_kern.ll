; ModuleID = 'capture_kern.c'
source_filename = "capture_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }

@xsks_map = global %struct.bpf_map_def { i32 17, i32 4, i32 4, i32 64, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !14
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_sock_prog to i8*), i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @xdp_sock_prog(%struct.xdp_md* nocapture readonly) #0 section "xdp_sock" !dbg !47 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !61, metadata !DIExpression()), !dbg !63
  %3 = bitcast i32* %2 to i8*, !dbg !64
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !64
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 4, !dbg !65
  %5 = load i32, i32* %4, align 4, !dbg !65, !tbaa !66
  call void @llvm.dbg.value(metadata i32 %5, metadata !62, metadata !DIExpression()), !dbg !71
  store i32 %5, i32* %2, align 4, !dbg !71, !tbaa !72
  %6 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i8* nonnull %3) #3, !dbg !73
  %7 = icmp eq i8* %6, null, !dbg !73
  br i1 %7, label %11, label %8, !dbg !75

; <label>:8:                                      ; preds = %1
  %9 = load i32, i32* %2, align 4, !dbg !76, !tbaa !72
  call void @llvm.dbg.value(metadata i32 %9, metadata !62, metadata !DIExpression()), !dbg !71
  %10 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @xsks_map to i8*), i32 %9, i32 0) #3, !dbg !77
  br label %11, !dbg !78

; <label>:11:                                     ; preds = %1, %8
  %12 = phi i32 [ %10, %8 ], [ 2, %1 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !79
  ret i32 %12, !dbg !79
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
!llvm.module.flags = !{!43, !44, !45}
!llvm.ident = !{!46}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xsks_map", scope: !2, file: !3, line: 10, type: !33, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !13)
!3 = !DIFile(filename: "capture_kern.c", directory: "/home/hooker/Hooker/paper2/capture")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, size: 32, elements: !7)
!6 = !DIFile(filename: "./../../headers/linux/bpf.h", directory: "/home/hooker/Hooker/paper2/capture")
!7 = !{!8, !9, !10, !11, !12}
!8 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!9 = !DIEnumerator(name: "XDP_DROP", value: 1)
!10 = !DIEnumerator(name: "XDP_PASS", value: 2)
!11 = !DIEnumerator(name: "XDP_TX", value: 3)
!12 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!13 = !{!0, !14, !20, !27}
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 46, type: !16, isLocal: false, isDefinition: true)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 32, elements: !18)
!17 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!18 = !{!19}
!19 = !DISubrange(count: 4)
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !22, line: 20, type: !23, isLocal: true, isDefinition: true)
!22 = !DIFile(filename: "./../../headers/bpf_helpers.h", directory: "/home/hooker/Hooker/paper2/capture")
!23 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!24 = !DISubroutineType(types: !25)
!25 = !{!26, !26, !26}
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!27 = !DIGlobalVariableExpression(var: !28, expr: !DIExpression())
!28 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !22, line: 57, type: !29, isLocal: true, isDefinition: true)
!29 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !30, size: 64)
!30 = !DISubroutineType(types: !31)
!31 = !{!32, !26, !32, !32}
!32 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!33 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !22, line: 210, size: 224, elements: !34)
!34 = !{!35, !37, !38, !39, !40, !41, !42}
!35 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !33, file: !22, line: 211, baseType: !36, size: 32)
!36 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !33, file: !22, line: 212, baseType: !36, size: 32, offset: 32)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !33, file: !22, line: 213, baseType: !36, size: 32, offset: 64)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !33, file: !22, line: 214, baseType: !36, size: 32, offset: 96)
!40 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !33, file: !22, line: 215, baseType: !36, size: 32, offset: 128)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !33, file: !22, line: 216, baseType: !36, size: 32, offset: 160)
!42 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !33, file: !22, line: 217, baseType: !36, size: 32, offset: 192)
!43 = !{i32 2, !"Dwarf Version", i32 4}
!44 = !{i32 2, !"Debug Info Version", i32 3}
!45 = !{i32 1, !"wchar_size", i32 4}
!46 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!47 = distinct !DISubprogram(name: "xdp_sock_prog", scope: !3, file: !3, line: 25, type: !48, isLocal: false, isDefinition: true, scopeLine: 26, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !60)
!48 = !DISubroutineType(types: !49)
!49 = !{!32, !50}
!50 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !52)
!52 = !{!53, !56, !57, !58, !59}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !51, file: !6, line: 2857, baseType: !54, size: 32)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !55, line: 27, baseType: !36)
!55 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/hooker/Hooker/paper2/capture")
!56 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !51, file: !6, line: 2858, baseType: !54, size: 32, offset: 32)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !51, file: !6, line: 2859, baseType: !54, size: 32, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !51, file: !6, line: 2861, baseType: !54, size: 32, offset: 96)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !51, file: !6, line: 2862, baseType: !54, size: 32, offset: 128)
!60 = !{!61, !62}
!61 = !DILocalVariable(name: "ctx", arg: 1, scope: !47, file: !3, line: 25, type: !50)
!62 = !DILocalVariable(name: "index", scope: !47, file: !3, line: 27, type: !32)
!63 = !DILocation(line: 25, column: 34, scope: !47)
!64 = !DILocation(line: 27, column: 5, scope: !47)
!65 = !DILocation(line: 27, column: 22, scope: !47)
!66 = !{!67, !68, i64 16}
!67 = !{!"xdp_md", !68, i64 0, !68, i64 4, !68, i64 8, !68, i64 12, !68, i64 16}
!68 = !{!"int", !69, i64 0}
!69 = !{!"omnipotent char", !70, i64 0}
!70 = !{!"Simple C/C++ TBAA"}
!71 = !DILocation(line: 27, column: 9, scope: !47)
!72 = !{!68, !68, i64 0}
!73 = !DILocation(line: 40, column: 9, scope: !74)
!74 = distinct !DILexicalBlock(scope: !47, file: !3, line: 40, column: 9)
!75 = !DILocation(line: 40, column: 9, scope: !47)
!76 = !DILocation(line: 41, column: 44, scope: !74)
!77 = !DILocation(line: 41, column: 16, scope: !74)
!78 = !DILocation(line: 41, column: 9, scope: !74)
!79 = !DILocation(line: 44, column: 1, scope: !47)
