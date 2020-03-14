; ModuleID = 'bpf_arqin.c'
source_filename = "bpf_arqin.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.S = type { i16, i16 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }

@my_map = global %struct.bpf_map_def { i32 4, i32 4, i32 4, i32 128, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@xdp_arqin_prog.____fmt = private unnamed_addr constant [30 x i8] c"perf_event_output failed: %d\0A\00", align 1
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !55
@_version = global i32 266002, section "version", align 4, !dbg !61
@llvm.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32* @_version to i8*), i8* bitcast (%struct.bpf_map_def* @my_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_arqin_prog to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @xdp_arqin_prog(%struct.xdp_md*) #0 section "xdp_arqin" !dbg !90 {
  %2 = alloca %struct.S, align 2
  %3 = alloca [30 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !102, metadata !DIExpression()), !dbg !121
  %4 = bitcast %struct.S* %2 to i8*, !dbg !122
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %4) #3, !dbg !122
  %5 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !123
  %6 = load i32, i32* %5, align 4, !dbg !123, !tbaa !124
  %7 = zext i32 %6 to i64, !dbg !129
  call void @llvm.dbg.value(metadata i64 %7, metadata !108, metadata !DIExpression()), !dbg !130
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !131
  %9 = load i32, i32* %8, align 4, !dbg !131, !tbaa !132
  %10 = zext i32 %9 to i64, !dbg !133
  call void @llvm.dbg.value(metadata i64 %10, metadata !109, metadata !DIExpression()), !dbg !134
  %11 = inttoptr i64 %10 to %struct.ethhdr*, !dbg !135
  call void @llvm.dbg.value(metadata %struct.ethhdr* %11, metadata !110, metadata !DIExpression()), !dbg !136
  %12 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 1, !dbg !137
  %13 = inttoptr i64 %7 to %struct.ethhdr*, !dbg !139
  %14 = icmp ugt %struct.ethhdr* %12, %13, !dbg !140
  br i1 %14, label %38, label %15, !dbg !141

; <label>:15:                                     ; preds = %1
  call void @llvm.dbg.value(metadata %struct.ethhdr* %12, metadata !111, metadata !DIExpression()), !dbg !142
  %16 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 2, i32 1, !dbg !143
  %17 = bitcast [6 x i8]* %16 to %struct.iphdr*, !dbg !143
  %18 = inttoptr i64 %7 to %struct.iphdr*, !dbg !145
  %19 = icmp ugt %struct.iphdr* %17, %18, !dbg !146
  br i1 %19, label %38, label %20, !dbg !147

; <label>:20:                                     ; preds = %15
  %21 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 1, i32 1, i64 3, !dbg !148
  %22 = load i8, i8* %21, align 1, !dbg !148, !tbaa !150
  %23 = icmp eq i8 %22, -56, !dbg !153
  br i1 %23, label %24, label %38, !dbg !154

; <label>:24:                                     ; preds = %20
  call void @llvm.dbg.value(metadata i64 4294967295, metadata !112, metadata !DIExpression()), !dbg !155
  %25 = getelementptr inbounds %struct.S, %struct.S* %2, i64 0, i32 0, !dbg !156
  store i16 -8531, i16* %25, align 2, !dbg !157, !tbaa !158
  %26 = sub nsw i64 %7, %10, !dbg !160
  %27 = trunc i64 %26 to i16, !dbg !161
  %28 = getelementptr inbounds %struct.S, %struct.S* %2, i64 0, i32 1, !dbg !162
  store i16 %27, i16* %28, align 2, !dbg !163, !tbaa !164
  %29 = shl i64 %26, 32, !dbg !165
  %30 = and i64 %29, 281470681743360, !dbg !165
  %31 = or i64 %30, 4294967295, !dbg !166
  call void @llvm.dbg.value(metadata i64 %31, metadata !112, metadata !DIExpression()), !dbg !155
  %32 = bitcast %struct.xdp_md* %0 to i8*, !dbg !167
  %33 = call i32 inttoptr (i64 25 to i32 (i8*, i8*, i64, i8*, i32)*)(i8* %32, i8* bitcast (%struct.bpf_map_def* @my_map to i8*), i64 %31, i8* nonnull %4, i32 4) #3, !dbg !168
  call void @llvm.dbg.value(metadata i32 %33, metadata !114, metadata !DIExpression()), !dbg !169
  %34 = icmp eq i32 %33, 0, !dbg !170
  br i1 %34, label %38, label %35, !dbg !171

; <label>:35:                                     ; preds = %24
  %36 = getelementptr inbounds [30 x i8], [30 x i8]* %3, i64 0, i64 0, !dbg !172
  call void @llvm.lifetime.start.p0i8(i64 30, i8* nonnull %36) #3, !dbg !172
  call void @llvm.dbg.declare(metadata [30 x i8]* %3, metadata !115, metadata !DIExpression()), !dbg !172
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %36, i8* getelementptr inbounds ([30 x i8], [30 x i8]* @xdp_arqin_prog.____fmt, i64 0, i64 0), i64 30, i32 1, i1 false), !dbg !172
  %37 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %36, i32 30, i32 %33) #3, !dbg !172
  call void @llvm.lifetime.end.p0i8(i64 30, i8* nonnull %36) #3, !dbg !173
  br label %38, !dbg !173

; <label>:38:                                     ; preds = %15, %20, %24, %35, %1
  %39 = phi i32 [ 2, %1 ], [ 2, %15 ], [ 2, %20 ], [ 1, %24 ], [ 1, %35 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %4) #3, !dbg !174
  ret i32 %39, !dbg !174
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
!llvm.module.flags = !{!86, !87, !88}
!llvm.ident = !{!89}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "my_map", scope: !2, file: !3, line: 27, type: !77, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !13, globals: !54)
!3 = !DIFile(filename: "bpf_arqin.c", directory: "/home/ubuntu/Hooker/src/bpf")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 3112, size: 32, elements: !7)
!6 = !DIFile(filename: "./include/linux/bpf.h", directory: "/home/ubuntu/Hooker/src/bpf")
!7 = !{!8, !9, !10, !11, !12}
!8 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!9 = !DIEnumerator(name: "XDP_DROP", value: 1)
!10 = !DIEnumerator(name: "XDP_PASS", value: 2)
!11 = !DIEnumerator(name: "XDP_TX", value: 3)
!12 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!13 = !{!14, !15, !16, !32, !29, !52}
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
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !30, line: 31, baseType: !53)
!53 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!54 = !{!0, !55, !61, !63, !70}
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 94, type: !57, isLocal: false, isDefinition: true)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 32, elements: !59)
!58 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!59 = !{!60}
!60 = !DISubrange(count: 4)
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "_version", scope: !2, file: !3, line: 95, type: !49, isLocal: false, isDefinition: true)
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "bpf_perf_event_output", scope: !2, file: !65, line: 72, type: !66, isLocal: true, isDefinition: true)
!65 = !DIFile(filename: "./include/bpf/bpf_helpers.h", directory: "/home/ubuntu/Hooker/src/bpf")
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DISubroutineType(types: !68)
!68 = !{!69, !14, !14, !53, !14, !69}
!69 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !65, line: 51, type: !72, isLocal: true, isDefinition: true)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = !DISubroutineType(types: !74)
!74 = !{!69, !75, !69, null}
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !58)
!77 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !65, line: 259, size: 224, elements: !78)
!78 = !{!79, !80, !81, !82, !83, !84, !85}
!79 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !77, file: !65, line: 260, baseType: !50, size: 32)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !77, file: !65, line: 261, baseType: !50, size: 32, offset: 32)
!81 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !77, file: !65, line: 262, baseType: !50, size: 32, offset: 64)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !77, file: !65, line: 263, baseType: !50, size: 32, offset: 96)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !77, file: !65, line: 264, baseType: !50, size: 32, offset: 128)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !77, file: !65, line: 265, baseType: !50, size: 32, offset: 160)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !77, file: !65, line: 266, baseType: !50, size: 32, offset: 192)
!86 = !{i32 2, !"Dwarf Version", i32 4}
!87 = !{i32 2, !"Debug Info Version", i32 3}
!88 = !{i32 1, !"wchar_size", i32 4}
!89 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!90 = distinct !DISubprogram(name: "xdp_arqin_prog", scope: !3, file: !3, line: 36, type: !91, isLocal: false, isDefinition: true, scopeLine: 37, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !101)
!91 = !DISubroutineType(types: !92)
!92 = !{!69, !93}
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!94 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 3123, size: 160, elements: !95)
!95 = !{!96, !97, !98, !99, !100}
!96 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !94, file: !6, line: 3124, baseType: !49, size: 32)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !94, file: !6, line: 3125, baseType: !49, size: 32, offset: 32)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !94, file: !6, line: 3126, baseType: !49, size: 32, offset: 64)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !94, file: !6, line: 3128, baseType: !49, size: 32, offset: 96)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !94, file: !6, line: 3129, baseType: !49, size: 32, offset: 128)
!101 = !{!102, !103, !108, !109, !110, !111, !112, !113, !114, !115}
!102 = !DILocalVariable(name: "ctx", arg: 1, scope: !90, file: !3, line: 36, type: !93)
!103 = !DILocalVariable(name: "metadata", scope: !90, file: !3, line: 49, type: !104)
!104 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "S", scope: !90, file: !3, line: 46, size: 32, elements: !105)
!105 = !{!106, !107}
!106 = !DIDerivedType(tag: DW_TAG_member, name: "cookie", scope: !104, file: !3, line: 47, baseType: !29, size: 16)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_len", scope: !104, file: !3, line: 48, baseType: !29, size: 16, offset: 16)
!108 = !DILocalVariable(name: "data_end", scope: !90, file: !3, line: 51, type: !14)
!109 = !DILocalVariable(name: "data", scope: !90, file: !3, line: 52, type: !14)
!110 = !DILocalVariable(name: "eth", scope: !90, file: !3, line: 53, type: !16)
!111 = !DILocalVariable(name: "iph", scope: !90, file: !3, line: 57, type: !32)
!112 = !DILocalVariable(name: "flags", scope: !90, file: !3, line: 75, type: !52)
!113 = !DILocalVariable(name: "sample_size", scope: !90, file: !3, line: 76, type: !29)
!114 = !DILocalVariable(name: "ret", scope: !90, file: !3, line: 77, type: !69)
!115 = !DILocalVariable(name: "____fmt", scope: !116, file: !3, line: 89, type: !118)
!116 = distinct !DILexicalBlock(scope: !117, file: !3, line: 89, column: 3)
!117 = distinct !DILexicalBlock(scope: !90, file: !3, line: 88, column: 6)
!118 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 240, elements: !119)
!119 = !{!120}
!120 = !DISubrange(count: 30)
!121 = !DILocation(line: 36, column: 35, scope: !90)
!122 = !DILocation(line: 46, column: 2, scope: !90)
!123 = !DILocation(line: 51, column: 38, scope: !90)
!124 = !{!125, !126, i64 4}
!125 = !{!"xdp_md", !126, i64 0, !126, i64 4, !126, i64 8, !126, i64 12, !126, i64 16}
!126 = !{!"int", !127, i64 0}
!127 = !{!"omnipotent char", !128, i64 0}
!128 = !{!"Simple C/C++ TBAA"}
!129 = !DILocation(line: 51, column: 27, scope: !90)
!130 = !DILocation(line: 51, column: 8, scope: !90)
!131 = !DILocation(line: 52, column: 34, scope: !90)
!132 = !{!125, !126, i64 0}
!133 = !DILocation(line: 52, column: 23, scope: !90)
!134 = !DILocation(line: 52, column: 8, scope: !90)
!135 = !DILocation(line: 53, column: 23, scope: !90)
!136 = !DILocation(line: 53, column: 17, scope: !90)
!137 = !DILocation(line: 54, column: 10, scope: !138)
!138 = distinct !DILexicalBlock(scope: !90, file: !3, line: 54, column: 6)
!139 = !DILocation(line: 54, column: 16, scope: !138)
!140 = !DILocation(line: 54, column: 14, scope: !138)
!141 = !DILocation(line: 54, column: 6, scope: !90)
!142 = !DILocation(line: 57, column: 16, scope: !90)
!143 = !DILocation(line: 58, column: 10, scope: !144)
!144 = distinct !DILexicalBlock(scope: !90, file: !3, line: 58, column: 6)
!145 = !DILocation(line: 58, column: 16, scope: !144)
!146 = !DILocation(line: 58, column: 14, scope: !144)
!147 = !DILocation(line: 58, column: 6, scope: !90)
!148 = !DILocation(line: 61, column: 11, scope: !149)
!149 = distinct !DILexicalBlock(scope: !90, file: !3, line: 61, column: 6)
!150 = !{!151, !127, i64 9}
!151 = !{!"iphdr", !127, i64 0, !127, i64 0, !127, i64 1, !152, i64 2, !152, i64 4, !152, i64 6, !127, i64 8, !127, i64 9, !152, i64 10, !126, i64 12, !126, i64 16}
!152 = !{!"short", !127, i64 0}
!153 = !DILocation(line: 61, column: 20, scope: !149)
!154 = !DILocation(line: 61, column: 6, scope: !90)
!155 = !DILocation(line: 75, column: 8, scope: !90)
!156 = !DILocation(line: 79, column: 11, scope: !90)
!157 = !DILocation(line: 79, column: 18, scope: !90)
!158 = !{!159, !152, i64 0}
!159 = !{!"S", !152, i64 0, !152, i64 2}
!160 = !DILocation(line: 80, column: 38, scope: !90)
!161 = !DILocation(line: 80, column: 21, scope: !90)
!162 = !DILocation(line: 80, column: 11, scope: !90)
!163 = !DILocation(line: 80, column: 19, scope: !90)
!164 = !{!159, !152, i64 2}
!165 = !DILocation(line: 83, column: 42, scope: !90)
!166 = !DILocation(line: 83, column: 15, scope: !90)
!167 = !DILocation(line: 86, column: 30, scope: !90)
!168 = !DILocation(line: 86, column: 8, scope: !90)
!169 = !DILocation(line: 77, column: 6, scope: !90)
!170 = !DILocation(line: 88, column: 6, scope: !117)
!171 = !DILocation(line: 88, column: 6, scope: !90)
!172 = !DILocation(line: 89, column: 3, scope: !116)
!173 = !DILocation(line: 89, column: 3, scope: !117)
!174 = !DILocation(line: 92, column: 1, scope: !90)
