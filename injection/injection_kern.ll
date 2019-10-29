; ModuleID = 'injection_kern.c'
source_filename = "injection_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_elf_map = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.__sk_buff = type { i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, [5 x i32], i32, i32, i32, i32, i32, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32, %union.anon, i64, i32, i32, %union.anon.2 }
%union.anon = type { %struct.bpf_flow_keys* }
%struct.bpf_flow_keys = type { i16, i16, i16, i8, i8, i8, i8, i16, i16, i16, %union.anon.0 }
%union.anon.0 = type { %struct.anon.1 }
%struct.anon.1 = type { [4 x i32], [4 x i32] }
%union.anon.2 = type { %struct.bpf_sock* }
%struct.bpf_sock = type { i32, i32, i32, i32, i32, i32, i32, [4 x i32], i32, i32, i32, [4 x i32], i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }
%struct.vtlhdr = type { i16 }

@DEBUGS_MAP = global %struct.bpf_elf_map { i32 2, i32 4, i32 1, i32 1, i32 0, i32 0, i32 2 }, section "maps", align 4, !dbg !0
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !54
@llvm.used = appending global [3 x i8*] [i8* bitcast (%struct.bpf_elf_map* @DEBUGS_MAP to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.__sk_buff*)* @_tf_tc_egress to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @_tf_tc_egress(%struct.__sk_buff* nocapture readonly) #0 section "tf_tc_egress" !dbg !74 {
  call void @llvm.dbg.value(metadata %struct.__sk_buff* %0, metadata !168, metadata !DIExpression()), !dbg !174
  %2 = getelementptr inbounds %struct.__sk_buff, %struct.__sk_buff* %0, i64 0, i32 15, !dbg !175
  %3 = load i32, i32* %2, align 4, !dbg !175, !tbaa !176
  %4 = zext i32 %3 to i64, !dbg !182
  call void @llvm.dbg.value(metadata i64 %4, metadata !169, metadata !DIExpression()), !dbg !183
  %5 = getelementptr inbounds %struct.__sk_buff, %struct.__sk_buff* %0, i64 0, i32 16, !dbg !184
  %6 = load i32, i32* %5, align 8, !dbg !184, !tbaa !185
  %7 = zext i32 %6 to i64, !dbg !186
  call void @llvm.dbg.value(metadata i64 %7, metadata !170, metadata !DIExpression()), !dbg !187
  %8 = inttoptr i64 %4 to %struct.ethhdr*, !dbg !188
  call void @llvm.dbg.value(metadata %struct.ethhdr* %8, metadata !171, metadata !DIExpression()), !dbg !189
  %9 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %8, i64 1, !dbg !190
  %10 = inttoptr i64 %7 to %struct.ethhdr*, !dbg !192
  %11 = icmp ugt %struct.ethhdr* %9, %10, !dbg !193
  br i1 %11, label %28, label %12, !dbg !194

; <label>:12:                                     ; preds = %1
  call void @llvm.dbg.value(metadata %struct.ethhdr* %9, metadata !172, metadata !DIExpression()), !dbg !195
  %13 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %8, i64 2, i32 1, !dbg !196
  %14 = bitcast [6 x i8]* %13 to %struct.iphdr*, !dbg !196
  %15 = inttoptr i64 %7 to %struct.iphdr*, !dbg !198
  %16 = icmp ugt %struct.iphdr* %14, %15, !dbg !199
  br i1 %16, label %28, label %17, !dbg !200

; <label>:17:                                     ; preds = %12
  %18 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %8, i64 1, i32 1, i64 3, !dbg !201
  %19 = load i8, i8* %18, align 1, !dbg !201, !tbaa !203
  %20 = icmp eq i8 %19, -56, !dbg !206
  br i1 %20, label %21, label %28, !dbg !207

; <label>:21:                                     ; preds = %17
  call void @llvm.dbg.value(metadata [6 x i8]* %13, metadata !173, metadata !DIExpression()), !dbg !208
  %22 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %8, i64 2, i32 1, i64 2, !dbg !209
  %23 = bitcast i8* %22 to %struct.vtlhdr*, !dbg !209
  %24 = inttoptr i64 %7 to %struct.vtlhdr*, !dbg !211
  %25 = icmp ugt %struct.vtlhdr* %23, %24, !dbg !212
  br i1 %25, label %28, label %26, !dbg !213

; <label>:26:                                     ; preds = %21
  %27 = bitcast [6 x i8]* %13 to i16*, !dbg !214
  store i16 30, i16* %27, align 2, !dbg !215, !tbaa !216
  br label %28, !dbg !218

; <label>:28:                                     ; preds = %12, %17, %21, %26, %1
  ret i32 0, !dbg !219
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!70, !71, !72}
!llvm.ident = !{!73}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "DEBUGS_MAP", scope: !2, file: !3, line: 37, type: !60, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !53)
!3 = !DIFile(filename: "injection_kern.c", directory: "/home/ubuntu/Hooker/injection")
!4 = !{}
!5 = !{!6, !7, !8, !24, !44}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !10, line: 159, size: 112, elements: !11)
!10 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "/home/ubuntu/Hooker/injection")
!11 = !{!12, !17, !18}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !9, file: !10, line: 160, baseType: !13, size: 48)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 48, elements: !15)
!14 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!15 = !{!16}
!16 = !DISubrange(count: 6)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !9, file: !10, line: 161, baseType: !13, size: 48, offset: 48)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !9, file: !10, line: 162, baseType: !19, size: 16, offset: 96)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !20, line: 25, baseType: !21)
!20 = !DIFile(filename: "/usr/include/linux/types.h", directory: "/home/ubuntu/Hooker/injection")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !22, line: 24, baseType: !23)
!22 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/Hooker/injection")
!23 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !26, line: 86, size: 160, elements: !27)
!26 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "/home/ubuntu/Hooker/injection")
!27 = !{!28, !30, !31, !32, !33, !34, !35, !36, !37, !39, !43}
!28 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !25, file: !26, line: 88, baseType: !29, size: 4, flags: DIFlagBitField, extraData: i64 0)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !22, line: 21, baseType: !14)
!30 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !25, file: !26, line: 89, baseType: !29, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!31 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !25, file: !26, line: 96, baseType: !29, size: 8, offset: 8)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !25, file: !26, line: 97, baseType: !19, size: 16, offset: 16)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !25, file: !26, line: 98, baseType: !19, size: 16, offset: 32)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !25, file: !26, line: 99, baseType: !19, size: 16, offset: 48)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !25, file: !26, line: 100, baseType: !29, size: 8, offset: 64)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !25, file: !26, line: 101, baseType: !29, size: 8, offset: 72)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !25, file: !26, line: 102, baseType: !38, size: 16, offset: 80)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !20, line: 31, baseType: !21)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !25, file: !26, line: 103, baseType: !40, size: 32, offset: 96)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !20, line: 27, baseType: !41)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !22, line: 27, baseType: !42)
!42 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !25, file: !26, line: 104, baseType: !40, size: 32, offset: 128)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vtlhdr", file: !46, line: 11, size: 16, elements: !47)
!46 = !DIFile(filename: "./../lib/vtl_util.h", directory: "/home/ubuntu/Hooker/injection")
!47 = !{!48}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "checksum", scope: !45, file: !46, line: 13, baseType: !49, size: 16)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !50, line: 25, baseType: !51)
!50 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "/home/ubuntu/Hooker/injection")
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !52, line: 39, baseType: !23)
!52 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "/home/ubuntu/Hooker/injection")
!53 = !{!0, !54}
!54 = !DIGlobalVariableExpression(var: !55, expr: !DIExpression())
!55 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 152, type: !56, isLocal: false, isDefinition: true)
!56 = !DICompositeType(tag: DW_TAG_array_type, baseType: !57, size: 32, elements: !58)
!57 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!58 = !{!59}
!59 = !DISubrange(count: 4)
!60 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_elf_map", file: !61, line: 18, size: 224, elements: !62)
!61 = !DIFile(filename: "../headers/tc_bpf_util.h", directory: "/home/ubuntu/Hooker/injection")
!62 = !{!63, !64, !65, !66, !67, !68, !69}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !60, file: !61, line: 23, baseType: !41, size: 32)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "size_key", scope: !60, file: !61, line: 24, baseType: !41, size: 32, offset: 32)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "size_value", scope: !60, file: !61, line: 25, baseType: !41, size: 32, offset: 64)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "max_elem", scope: !60, file: !61, line: 26, baseType: !41, size: 32, offset: 96)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !60, file: !61, line: 30, baseType: !41, size: 32, offset: 128)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !60, file: !61, line: 31, baseType: !41, size: 32, offset: 160)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "pinning", scope: !60, file: !61, line: 40, baseType: !41, size: 32, offset: 192)
!70 = !{i32 2, !"Dwarf Version", i32 4}
!71 = !{i32 2, !"Debug Info Version", i32 3}
!72 = !{i32 1, !"wchar_size", i32 4}
!73 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!74 = distinct !DISubprogram(name: "_tf_tc_egress", scope: !3, file: !3, line: 74, type: !75, isLocal: false, isDefinition: true, scopeLine: 75, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !167)
!75 = !DISubroutineType(types: !76)
!76 = !{!77, !78}
!77 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !79, size: 64)
!79 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sk_buff", file: !80, line: 2677, size: 1408, elements: !81)
!80 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/ubuntu/Hooker/injection")
!81 = !{!82, !83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !98, !99, !100, !101, !102, !103, !104, !105, !106, !108, !109, !110, !111, !112, !142, !145, !146, !147}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !79, file: !80, line: 2678, baseType: !41, size: 32)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_type", scope: !79, file: !80, line: 2679, baseType: !41, size: 32, offset: 32)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !79, file: !80, line: 2680, baseType: !41, size: 32, offset: 64)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "queue_mapping", scope: !79, file: !80, line: 2681, baseType: !41, size: 32, offset: 96)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !79, file: !80, line: 2682, baseType: !41, size: 32, offset: 128)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_present", scope: !79, file: !80, line: 2683, baseType: !41, size: 32, offset: 160)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_tci", scope: !79, file: !80, line: 2684, baseType: !41, size: 32, offset: 192)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_proto", scope: !79, file: !80, line: 2685, baseType: !41, size: 32, offset: 224)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !79, file: !80, line: 2686, baseType: !41, size: 32, offset: 256)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !79, file: !80, line: 2687, baseType: !41, size: 32, offset: 288)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !79, file: !80, line: 2688, baseType: !41, size: 32, offset: 320)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "tc_index", scope: !79, file: !80, line: 2689, baseType: !41, size: 32, offset: 352)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "cb", scope: !79, file: !80, line: 2690, baseType: !95, size: 160, offset: 384)
!95 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 160, elements: !96)
!96 = !{!97}
!97 = !DISubrange(count: 5)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "hash", scope: !79, file: !80, line: 2691, baseType: !41, size: 32, offset: 544)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "tc_classid", scope: !79, file: !80, line: 2692, baseType: !41, size: 32, offset: 576)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !79, file: !80, line: 2693, baseType: !41, size: 32, offset: 608)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !79, file: !80, line: 2694, baseType: !41, size: 32, offset: 640)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "napi_id", scope: !79, file: !80, line: 2695, baseType: !41, size: 32, offset: 672)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !79, file: !80, line: 2698, baseType: !41, size: 32, offset: 704)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !79, file: !80, line: 2699, baseType: !41, size: 32, offset: 736)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !79, file: !80, line: 2700, baseType: !41, size: 32, offset: 768)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !79, file: !80, line: 2701, baseType: !107, size: 128, offset: 800)
!107 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 128, elements: !58)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !79, file: !80, line: 2702, baseType: !107, size: 128, offset: 928)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !79, file: !80, line: 2703, baseType: !41, size: 32, offset: 1056)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !79, file: !80, line: 2704, baseType: !41, size: 32, offset: 1088)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !79, file: !80, line: 2707, baseType: !41, size: 32, offset: 1120)
!112 = !DIDerivedType(tag: DW_TAG_member, scope: !79, file: !80, line: 2708, baseType: !113, size: 64, align: 64, offset: 1152)
!113 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !79, file: !80, line: 2708, size: 64, align: 64, elements: !114)
!114 = !{!115}
!115 = !DIDerivedType(tag: DW_TAG_member, name: "flow_keys", scope: !113, file: !80, line: 2708, baseType: !116, size: 64)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_flow_keys", file: !80, line: 3237, size: 384, elements: !118)
!118 = !{!119, !120, !121, !122, !123, !124, !125, !126, !127, !128, !129}
!119 = !DIDerivedType(tag: DW_TAG_member, name: "nhoff", scope: !117, file: !80, line: 3238, baseType: !21, size: 16)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "thoff", scope: !117, file: !80, line: 3239, baseType: !21, size: 16, offset: 16)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "addr_proto", scope: !117, file: !80, line: 3240, baseType: !21, size: 16, offset: 32)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "is_frag", scope: !117, file: !80, line: 3241, baseType: !29, size: 8, offset: 48)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "is_first_frag", scope: !117, file: !80, line: 3242, baseType: !29, size: 8, offset: 56)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "is_encap", scope: !117, file: !80, line: 3243, baseType: !29, size: 8, offset: 64)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !117, file: !80, line: 3244, baseType: !29, size: 8, offset: 72)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "n_proto", scope: !117, file: !80, line: 3245, baseType: !19, size: 16, offset: 80)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !117, file: !80, line: 3246, baseType: !19, size: 16, offset: 96)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !117, file: !80, line: 3247, baseType: !19, size: 16, offset: 112)
!129 = !DIDerivedType(tag: DW_TAG_member, scope: !117, file: !80, line: 3248, baseType: !130, size: 256, offset: 128)
!130 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !117, file: !80, line: 3248, size: 256, elements: !131)
!131 = !{!132, !137}
!132 = !DIDerivedType(tag: DW_TAG_member, scope: !130, file: !80, line: 3249, baseType: !133, size: 64)
!133 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !130, file: !80, line: 3249, size: 64, elements: !134)
!134 = !{!135, !136}
!135 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !133, file: !80, line: 3250, baseType: !40, size: 32)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !133, file: !80, line: 3251, baseType: !40, size: 32, offset: 32)
!137 = !DIDerivedType(tag: DW_TAG_member, scope: !130, file: !80, line: 3253, baseType: !138, size: 256)
!138 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !130, file: !80, line: 3253, size: 256, elements: !139)
!139 = !{!140, !141}
!140 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !138, file: !80, line: 3254, baseType: !107, size: 128)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !138, file: !80, line: 3255, baseType: !107, size: 128, offset: 128)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp", scope: !79, file: !80, line: 2709, baseType: !143, size: 64, offset: 1216)
!143 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !22, line: 31, baseType: !144)
!144 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "wire_len", scope: !79, file: !80, line: 2710, baseType: !41, size: 32, offset: 1280)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "gso_segs", scope: !79, file: !80, line: 2711, baseType: !41, size: 32, offset: 1312)
!147 = !DIDerivedType(tag: DW_TAG_member, scope: !79, file: !80, line: 2712, baseType: !148, size: 64, align: 64, offset: 1344)
!148 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !79, file: !80, line: 2712, size: 64, align: 64, elements: !149)
!149 = !{!150}
!150 = !DIDerivedType(tag: DW_TAG_member, name: "sk", scope: !148, file: !80, line: 2712, baseType: !151, size: 64)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !152, size: 64)
!152 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock", file: !80, line: 2765, size: 608, elements: !153)
!153 = !{!154, !155, !156, !157, !158, !159, !160, !161, !162, !163, !164, !165, !166}
!154 = !DIDerivedType(tag: DW_TAG_member, name: "bound_dev_if", scope: !152, file: !80, line: 2766, baseType: !41, size: 32)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !152, file: !80, line: 2767, baseType: !41, size: 32, offset: 32)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !152, file: !80, line: 2768, baseType: !41, size: 32, offset: 64)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !152, file: !80, line: 2769, baseType: !41, size: 32, offset: 96)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !152, file: !80, line: 2770, baseType: !41, size: 32, offset: 128)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !152, file: !80, line: 2771, baseType: !41, size: 32, offset: 160)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip4", scope: !152, file: !80, line: 2773, baseType: !41, size: 32, offset: 192)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip6", scope: !152, file: !80, line: 2774, baseType: !107, size: 128, offset: 224)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "src_port", scope: !152, file: !80, line: 2775, baseType: !41, size: 32, offset: 352)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "dst_port", scope: !152, file: !80, line: 2776, baseType: !41, size: 32, offset: 384)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip4", scope: !152, file: !80, line: 2777, baseType: !41, size: 32, offset: 416)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip6", scope: !152, file: !80, line: 2778, baseType: !107, size: 128, offset: 448)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !152, file: !80, line: 2779, baseType: !41, size: 32, offset: 576)
!167 = !{!168, !169, !170, !171, !172, !173}
!168 = !DILocalVariable(name: "skb", arg: 1, scope: !74, file: !3, line: 74, type: !78)
!169 = !DILocalVariable(name: "data", scope: !74, file: !3, line: 128, type: !6)
!170 = !DILocalVariable(name: "data_end", scope: !74, file: !3, line: 129, type: !6)
!171 = !DILocalVariable(name: "eth", scope: !74, file: !3, line: 131, type: !8)
!172 = !DILocalVariable(name: "iph", scope: !74, file: !3, line: 135, type: !24)
!173 = !DILocalVariable(name: "vtlh", scope: !74, file: !3, line: 143, type: !44)
!174 = !DILocation(line: 74, column: 37, scope: !74)
!175 = !DILocation(line: 128, column: 34, scope: !74)
!176 = !{!177, !178, i64 76}
!177 = !{!"__sk_buff", !178, i64 0, !178, i64 4, !178, i64 8, !178, i64 12, !178, i64 16, !178, i64 20, !178, i64 24, !178, i64 28, !178, i64 32, !178, i64 36, !178, i64 40, !178, i64 44, !179, i64 48, !178, i64 68, !178, i64 72, !178, i64 76, !178, i64 80, !178, i64 84, !178, i64 88, !178, i64 92, !178, i64 96, !179, i64 100, !179, i64 116, !178, i64 132, !178, i64 136, !178, i64 140, !179, i64 144, !181, i64 152, !178, i64 160, !178, i64 164, !179, i64 168}
!178 = !{!"int", !179, i64 0}
!179 = !{!"omnipotent char", !180, i64 0}
!180 = !{!"Simple C/C++ TBAA"}
!181 = !{!"long long", !179, i64 0}
!182 = !DILocation(line: 128, column: 23, scope: !74)
!183 = !DILocation(line: 128, column: 8, scope: !74)
!184 = !DILocation(line: 129, column: 45, scope: !74)
!185 = !{!177, !178, i64 80}
!186 = !DILocation(line: 129, column: 34, scope: !74)
!187 = !DILocation(line: 129, column: 15, scope: !74)
!188 = !DILocation(line: 131, column: 23, scope: !74)
!189 = !DILocation(line: 131, column: 17, scope: !74)
!190 = !DILocation(line: 132, column: 16, scope: !191)
!191 = distinct !DILexicalBlock(scope: !74, file: !3, line: 132, column: 12)
!192 = !DILocation(line: 132, column: 22, scope: !191)
!193 = !DILocation(line: 132, column: 20, scope: !191)
!194 = !DILocation(line: 132, column: 12, scope: !74)
!195 = !DILocation(line: 135, column: 23, scope: !74)
!196 = !DILocation(line: 136, column: 16, scope: !197)
!197 = distinct !DILexicalBlock(scope: !74, file: !3, line: 136, column: 12)
!198 = !DILocation(line: 136, column: 22, scope: !197)
!199 = !DILocation(line: 136, column: 20, scope: !197)
!200 = !DILocation(line: 136, column: 12, scope: !74)
!201 = !DILocation(line: 139, column: 10, scope: !202)
!202 = distinct !DILexicalBlock(scope: !74, file: !3, line: 139, column: 5)
!203 = !{!204, !179, i64 9}
!204 = !{!"iphdr", !179, i64 0, !179, i64 0, !179, i64 1, !205, i64 2, !205, i64 4, !205, i64 6, !179, i64 8, !179, i64 9, !205, i64 10, !178, i64 12, !178, i64 16}
!205 = !{!"short", !179, i64 0}
!206 = !DILocation(line: 139, column: 19, scope: !202)
!207 = !DILocation(line: 139, column: 5, scope: !74)
!208 = !DILocation(line: 143, column: 17, scope: !74)
!209 = !DILocation(line: 144, column: 10, scope: !210)
!210 = distinct !DILexicalBlock(scope: !74, file: !3, line: 144, column: 5)
!211 = !DILocation(line: 144, column: 16, scope: !210)
!212 = !DILocation(line: 144, column: 14, scope: !210)
!213 = !DILocation(line: 144, column: 5, scope: !74)
!214 = !DILocation(line: 147, column: 8, scope: !74)
!215 = !DILocation(line: 147, column: 17, scope: !74)
!216 = !{!217, !205, i64 0}
!217 = !{!"vtlhdr", !205, i64 0}
!218 = !DILocation(line: 149, column: 9, scope: !74)
!219 = !DILocation(line: 150, column: 1, scope: !74)
