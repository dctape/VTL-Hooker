; ModuleID = 'tc_kern.c'
source_filename = "tc_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_elf_map = type { i32, i32, i32, i32, i32, i32, i32, i32, i32 }
%struct.__sk_buff = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [5 x i32], i32, i32, i32, i32, i32, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32, %union.anon, i64, i32, i32, %union.anon.2 }
%union.anon = type { %struct.bpf_flow_keys* }
%struct.bpf_flow_keys = type { i16, i16, i16, i8, i8, i8, i8, i16, i16, i16, %union.anon.0 }
%union.anon.0 = type { %struct.anon.1 }
%struct.anon.1 = type { [4 x i32], [4 x i32] }
%union.anon.2 = type { %struct.bpf_sock* }
%struct.bpf_sock = type { i32, i32, i32, i32, i32, i32, i32, [4 x i32], i32, i32, i32, [4 x i32], i32 }

@map_shared = global %struct.bpf_elf_map { i32 2, i32 4, i32 12, i32 2, i32 0, i32 0, i32 2, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !6
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_elf_map* @map_shared to i8*), i8* bitcast (i32 (%struct.__sk_buff*)* @tc_count_prog to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @tc_count_prog(%struct.__sk_buff* nocapture readnone) #0 section "tc_count" !dbg !37 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.__sk_buff* %0, metadata !138, metadata !DIExpression()), !dbg !147
  %3 = bitcast i32* %2 to i8*, !dbg !148
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3) #3, !dbg !148
  call void @llvm.dbg.value(metadata i32 0, metadata !139, metadata !DIExpression()), !dbg !149
  store i32 0, i32* %2, align 4, !dbg !149, !tbaa !150
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_elf_map* @map_shared to i8*), i8* nonnull %3) #3, !dbg !154
  call void @llvm.dbg.value(metadata i8* %4, metadata !140, metadata !DIExpression()), !dbg !155
  %5 = icmp eq i8* %4, null, !dbg !156
  br i1 %5, label %16, label %6, !dbg !158

; <label>:6:                                      ; preds = %1
  %7 = getelementptr inbounds i8, i8* %4, i64 4, !dbg !159
  %8 = bitcast i8* %7 to i32*, !dbg !159
  %9 = load i32, i32* %8, align 4, !dbg !159, !tbaa !160
  %10 = add nsw i32 %9, 1, !dbg !162
  store i32 %10, i32* %8, align 4, !dbg !163, !tbaa !160
  %11 = bitcast i8* %4 to i32*, !dbg !164
  %12 = load i32, i32* %11, align 4, !dbg !164, !tbaa !165
  %13 = add nsw i32 %12, %10, !dbg !166
  %14 = getelementptr inbounds i8, i8* %4, i64 8, !dbg !167
  %15 = bitcast i8* %14 to i32*, !dbg !167
  store i32 %13, i32* %15, align 4, !dbg !168, !tbaa !169
  br label %16, !dbg !170

; <label>:16:                                     ; preds = %1, %6
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3) #3, !dbg !171
  ret i32 0, !dbg !171
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
!llvm.module.flags = !{!33, !34, !35}
!llvm.ident = !{!36}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "map_shared", scope: !2, file: !3, line: 50, type: !19, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !5)
!3 = !DIFile(filename: "tc_kern.c", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!4 = !{}
!5 = !{!0, !6, !12}
!6 = !DIGlobalVariableExpression(var: !7, expr: !DIExpression())
!7 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 74, type: !8, isLocal: false, isDefinition: true)
!8 = !DICompositeType(tag: DW_TAG_array_type, baseType: !9, size: 32, elements: !10)
!9 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!10 = !{!11}
!11 = !DISubrange(count: 4)
!12 = !DIGlobalVariableExpression(var: !13, expr: !DIExpression())
!13 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !14, line: 20, type: !15, isLocal: true, isDefinition: true)
!14 = !DIFile(filename: "./include/bpf/bpf_helpers.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DISubroutineType(types: !17)
!17 = !{!18, !18, !18}
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!19 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_elf_map", file: !3, line: 18, size: 288, elements: !20)
!20 = !{!21, !25, !26, !27, !28, !29, !30, !31, !32}
!21 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !19, file: !3, line: 19, baseType: !22, size: 32)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !23, line: 27, baseType: !24)
!23 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!24 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!25 = !DIDerivedType(tag: DW_TAG_member, name: "size_key", scope: !19, file: !3, line: 20, baseType: !22, size: 32, offset: 32)
!26 = !DIDerivedType(tag: DW_TAG_member, name: "size_value", scope: !19, file: !3, line: 21, baseType: !22, size: 32, offset: 64)
!27 = !DIDerivedType(tag: DW_TAG_member, name: "max_elem", scope: !19, file: !3, line: 22, baseType: !22, size: 32, offset: 96)
!28 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !19, file: !3, line: 23, baseType: !22, size: 32, offset: 128)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !19, file: !3, line: 24, baseType: !22, size: 32, offset: 160)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "pinning", scope: !19, file: !3, line: 25, baseType: !22, size: 32, offset: 192)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "inner_id", scope: !19, file: !3, line: 26, baseType: !22, size: 32, offset: 224)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "inner_idx", scope: !19, file: !3, line: 27, baseType: !22, size: 32, offset: 256)
!33 = !{i32 2, !"Dwarf Version", i32 4}
!34 = !{i32 2, !"Debug Info Version", i32 3}
!35 = !{i32 1, !"wchar_size", i32 4}
!36 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!37 = distinct !DISubprogram(name: "tc_count_prog", scope: !3, file: !3, line: 60, type: !38, isLocal: false, isDefinition: true, scopeLine: 61, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !137)
!38 = !DISubroutineType(types: !39)
!39 = !{!40, !41}
!40 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sk_buff", file: !43, line: 2677, size: 1408, elements: !44)
!43 = !DIFile(filename: "./include/linux/bpf.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!44 = !{!45, !46, !47, !48, !49, !50, !51, !52, !53, !54, !55, !56, !57, !61, !62, !63, !64, !65, !66, !67, !68, !69, !71, !72, !73, !74, !75, !112, !115, !116, !117}
!45 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !42, file: !43, line: 2678, baseType: !22, size: 32)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_type", scope: !42, file: !43, line: 2679, baseType: !22, size: 32, offset: 32)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !42, file: !43, line: 2680, baseType: !22, size: 32, offset: 64)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "queue_mapping", scope: !42, file: !43, line: 2681, baseType: !22, size: 32, offset: 96)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !42, file: !43, line: 2682, baseType: !22, size: 32, offset: 128)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_present", scope: !42, file: !43, line: 2683, baseType: !22, size: 32, offset: 160)
!51 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_tci", scope: !42, file: !43, line: 2684, baseType: !22, size: 32, offset: 192)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_proto", scope: !42, file: !43, line: 2685, baseType: !22, size: 32, offset: 224)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !42, file: !43, line: 2686, baseType: !22, size: 32, offset: 256)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !42, file: !43, line: 2687, baseType: !22, size: 32, offset: 288)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !42, file: !43, line: 2688, baseType: !22, size: 32, offset: 320)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "tc_index", scope: !42, file: !43, line: 2689, baseType: !22, size: 32, offset: 352)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "cb", scope: !42, file: !43, line: 2690, baseType: !58, size: 160, offset: 384)
!58 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 160, elements: !59)
!59 = !{!60}
!60 = !DISubrange(count: 5)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "hash", scope: !42, file: !43, line: 2691, baseType: !22, size: 32, offset: 544)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "tc_classid", scope: !42, file: !43, line: 2692, baseType: !22, size: 32, offset: 576)
!63 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !42, file: !43, line: 2693, baseType: !22, size: 32, offset: 608)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !42, file: !43, line: 2694, baseType: !22, size: 32, offset: 640)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "napi_id", scope: !42, file: !43, line: 2695, baseType: !22, size: 32, offset: 672)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !42, file: !43, line: 2698, baseType: !22, size: 32, offset: 704)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !42, file: !43, line: 2699, baseType: !22, size: 32, offset: 736)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !42, file: !43, line: 2700, baseType: !22, size: 32, offset: 768)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !42, file: !43, line: 2701, baseType: !70, size: 128, offset: 800)
!70 = !DICompositeType(tag: DW_TAG_array_type, baseType: !22, size: 128, elements: !10)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !42, file: !43, line: 2702, baseType: !70, size: 128, offset: 928)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !42, file: !43, line: 2703, baseType: !22, size: 32, offset: 1056)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !42, file: !43, line: 2704, baseType: !22, size: 32, offset: 1088)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !42, file: !43, line: 2707, baseType: !22, size: 32, offset: 1120)
!75 = !DIDerivedType(tag: DW_TAG_member, scope: !42, file: !43, line: 2708, baseType: !76, size: 64, align: 64, offset: 1152)
!76 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !42, file: !43, line: 2708, size: 64, align: 64, elements: !77)
!77 = !{!78}
!78 = !DIDerivedType(tag: DW_TAG_member, name: "flow_keys", scope: !76, file: !43, line: 2708, baseType: !79, size: 64)
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_flow_keys", file: !43, line: 3237, size: 384, elements: !81)
!81 = !{!82, !85, !86, !87, !90, !91, !92, !93, !96, !97, !98}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "nhoff", scope: !80, file: !43, line: 3238, baseType: !83, size: 16)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !23, line: 24, baseType: !84)
!84 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "thoff", scope: !80, file: !43, line: 3239, baseType: !83, size: 16, offset: 16)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "addr_proto", scope: !80, file: !43, line: 3240, baseType: !83, size: 16, offset: 32)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "is_frag", scope: !80, file: !43, line: 3241, baseType: !88, size: 8, offset: 48)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !23, line: 21, baseType: !89)
!89 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "is_first_frag", scope: !80, file: !43, line: 3242, baseType: !88, size: 8, offset: 56)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "is_encap", scope: !80, file: !43, line: 3243, baseType: !88, size: 8, offset: 64)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !80, file: !43, line: 3244, baseType: !88, size: 8, offset: 72)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "n_proto", scope: !80, file: !43, line: 3245, baseType: !94, size: 16, offset: 80)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !95, line: 25, baseType: !83)
!95 = !DIFile(filename: "/usr/include/linux/types.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!96 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !80, file: !43, line: 3246, baseType: !94, size: 16, offset: 96)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !80, file: !43, line: 3247, baseType: !94, size: 16, offset: 112)
!98 = !DIDerivedType(tag: DW_TAG_member, scope: !80, file: !43, line: 3248, baseType: !99, size: 256, offset: 128)
!99 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !80, file: !43, line: 3248, size: 256, elements: !100)
!100 = !{!101, !107}
!101 = !DIDerivedType(tag: DW_TAG_member, scope: !99, file: !43, line: 3249, baseType: !102, size: 64)
!102 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !99, file: !43, line: 3249, size: 64, elements: !103)
!103 = !{!104, !106}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !102, file: !43, line: 3250, baseType: !105, size: 32)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !95, line: 27, baseType: !22)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !102, file: !43, line: 3251, baseType: !105, size: 32, offset: 32)
!107 = !DIDerivedType(tag: DW_TAG_member, scope: !99, file: !43, line: 3253, baseType: !108, size: 256)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !99, file: !43, line: 3253, size: 256, elements: !109)
!109 = !{!110, !111}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !108, file: !43, line: 3254, baseType: !70, size: 128)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !108, file: !43, line: 3255, baseType: !70, size: 128, offset: 128)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp", scope: !42, file: !43, line: 2709, baseType: !113, size: 64, offset: 1216)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !23, line: 31, baseType: !114)
!114 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "wire_len", scope: !42, file: !43, line: 2710, baseType: !22, size: 32, offset: 1280)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "gso_segs", scope: !42, file: !43, line: 2711, baseType: !22, size: 32, offset: 1312)
!117 = !DIDerivedType(tag: DW_TAG_member, scope: !42, file: !43, line: 2712, baseType: !118, size: 64, align: 64, offset: 1344)
!118 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !42, file: !43, line: 2712, size: 64, align: 64, elements: !119)
!119 = !{!120}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "sk", scope: !118, file: !43, line: 2712, baseType: !121, size: 64)
!121 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !122, size: 64)
!122 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock", file: !43, line: 2765, size: 608, elements: !123)
!123 = !{!124, !125, !126, !127, !128, !129, !130, !131, !132, !133, !134, !135, !136}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "bound_dev_if", scope: !122, file: !43, line: 2766, baseType: !22, size: 32)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !122, file: !43, line: 2767, baseType: !22, size: 32, offset: 32)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !122, file: !43, line: 2768, baseType: !22, size: 32, offset: 64)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !122, file: !43, line: 2769, baseType: !22, size: 32, offset: 96)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !122, file: !43, line: 2770, baseType: !22, size: 32, offset: 128)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !122, file: !43, line: 2771, baseType: !22, size: 32, offset: 160)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip4", scope: !122, file: !43, line: 2773, baseType: !22, size: 32, offset: 192)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip6", scope: !122, file: !43, line: 2774, baseType: !70, size: 128, offset: 224)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "src_port", scope: !122, file: !43, line: 2775, baseType: !22, size: 32, offset: 352)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "dst_port", scope: !122, file: !43, line: 2776, baseType: !22, size: 32, offset: 384)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip4", scope: !122, file: !43, line: 2777, baseType: !22, size: 32, offset: 416)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip6", scope: !122, file: !43, line: 2778, baseType: !70, size: 128, offset: 448)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !122, file: !43, line: 2779, baseType: !22, size: 32, offset: 576)
!137 = !{!138, !139, !140}
!138 = !DILocalVariable(name: "skb", arg: 1, scope: !37, file: !3, line: 60, type: !41)
!139 = !DILocalVariable(name: "key", scope: !37, file: !3, line: 63, type: !40)
!140 = !DILocalVariable(name: "cnt", scope: !37, file: !3, line: 64, type: !141)
!141 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !142, size: 64)
!142 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_count", file: !3, line: 7, size: 96, elements: !143)
!143 = !{!144, !145, !146}
!144 = !DIDerivedType(tag: DW_TAG_member, name: "xdp_cnt", scope: !142, file: !3, line: 9, baseType: !40, size: 32)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "tc_cnt", scope: !142, file: !3, line: 10, baseType: !40, size: 32, offset: 32)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "tot_cnt", scope: !142, file: !3, line: 11, baseType: !40, size: 32, offset: 64)
!147 = !DILocation(line: 60, column: 37, scope: !37)
!148 = !DILocation(line: 63, column: 9, scope: !37)
!149 = !DILocation(line: 63, column: 13, scope: !37)
!150 = !{!151, !151, i64 0}
!151 = !{!"int", !152, i64 0}
!152 = !{!"omnipotent char", !153, i64 0}
!153 = !{!"Simple C/C++ TBAA"}
!154 = !DILocation(line: 65, column: 15, scope: !37)
!155 = !DILocation(line: 64, column: 27, scope: !37)
!156 = !DILocation(line: 66, column: 14, scope: !157)
!157 = distinct !DILexicalBlock(scope: !37, file: !3, line: 66, column: 13)
!158 = !DILocation(line: 66, column: 13, scope: !37)
!159 = !DILocation(line: 68, column: 28, scope: !37)
!160 = !{!161, !151, i64 4}
!161 = !{!"bpf_count", !151, i64 0, !151, i64 4, !151, i64 8}
!162 = !DILocation(line: 68, column: 35, scope: !37)
!163 = !DILocation(line: 68, column: 21, scope: !37)
!164 = !DILocation(line: 69, column: 29, scope: !37)
!165 = !{!161, !151, i64 0}
!166 = !DILocation(line: 69, column: 37, scope: !37)
!167 = !DILocation(line: 69, column: 14, scope: !37)
!168 = !DILocation(line: 69, column: 22, scope: !37)
!169 = !{!161, !151, i64 8}
!170 = !DILocation(line: 71, column: 9, scope: !37)
!171 = !DILocation(line: 72, column: 1, scope: !37)
