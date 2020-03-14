; ModuleID = 'bpf_tc.c'
source_filename = "bpf_tc.c"
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
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !55
@llvm.used = appending global [3 x i8*] [i8* bitcast (%struct.bpf_elf_map* @DEBUGS_MAP to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.__sk_buff*)* @_tf_tc_egress to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @_tf_tc_egress(%struct.__sk_buff* nocapture readonly) #0 section "tf_tc_egress" !dbg !75 {
  call void @llvm.dbg.value(metadata %struct.__sk_buff* %0, metadata !169, metadata !DIExpression()), !dbg !175
  %2 = getelementptr inbounds %struct.__sk_buff, %struct.__sk_buff* %0, i64 0, i32 15, !dbg !176
  %3 = load i32, i32* %2, align 4, !dbg !176, !tbaa !177
  %4 = zext i32 %3 to i64, !dbg !183
  call void @llvm.dbg.value(metadata i64 %4, metadata !170, metadata !DIExpression()), !dbg !184
  %5 = getelementptr inbounds %struct.__sk_buff, %struct.__sk_buff* %0, i64 0, i32 16, !dbg !185
  %6 = load i32, i32* %5, align 8, !dbg !185, !tbaa !186
  %7 = zext i32 %6 to i64, !dbg !187
  call void @llvm.dbg.value(metadata i64 %7, metadata !171, metadata !DIExpression()), !dbg !188
  %8 = inttoptr i64 %4 to %struct.ethhdr*, !dbg !189
  call void @llvm.dbg.value(metadata %struct.ethhdr* %8, metadata !172, metadata !DIExpression()), !dbg !190
  %9 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %8, i64 1, !dbg !191
  %10 = inttoptr i64 %7 to %struct.ethhdr*, !dbg !193
  %11 = icmp ugt %struct.ethhdr* %9, %10, !dbg !194
  br i1 %11, label %28, label %12, !dbg !195

; <label>:12:                                     ; preds = %1
  call void @llvm.dbg.value(metadata %struct.ethhdr* %9, metadata !173, metadata !DIExpression()), !dbg !196
  %13 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %8, i64 2, i32 1, !dbg !197
  %14 = bitcast [6 x i8]* %13 to %struct.iphdr*, !dbg !197
  %15 = inttoptr i64 %7 to %struct.iphdr*, !dbg !199
  %16 = icmp ugt %struct.iphdr* %14, %15, !dbg !200
  br i1 %16, label %28, label %17, !dbg !201

; <label>:17:                                     ; preds = %12
  %18 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %8, i64 1, i32 1, i64 3, !dbg !202
  %19 = load i8, i8* %18, align 1, !dbg !202, !tbaa !204
  %20 = icmp eq i8 %19, -56, !dbg !207
  br i1 %20, label %21, label %28, !dbg !208

; <label>:21:                                     ; preds = %17
  call void @llvm.dbg.value(metadata [6 x i8]* %13, metadata !174, metadata !DIExpression()), !dbg !209
  %22 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %8, i64 2, i32 1, i64 2, !dbg !210
  %23 = bitcast i8* %22 to %struct.vtlhdr*, !dbg !210
  %24 = inttoptr i64 %7 to %struct.vtlhdr*, !dbg !212
  %25 = icmp ugt %struct.vtlhdr* %23, %24, !dbg !213
  br i1 %25, label %28, label %26, !dbg !214

; <label>:26:                                     ; preds = %21
  %27 = bitcast [6 x i8]* %13 to i16*, !dbg !215
  store i16 30, i16* %27, align 2, !dbg !216, !tbaa !217
  br label %28, !dbg !219

; <label>:28:                                     ; preds = %12, %17, %21, %26, %1
  ret i32 0, !dbg !220
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!71, !72, !73}
!llvm.ident = !{!74}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "DEBUGS_MAP", scope: !2, file: !3, line: 38, type: !61, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !54)
!3 = !DIFile(filename: "bpf_tc.c", directory: "/home/ubuntu/Hooker/src/bpf")
!4 = !{}
!5 = !{!6, !7, !8, !24, !44}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!7 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !10, line: 163, size: 112, elements: !11)
!10 = !DIFile(filename: "./include/linux/if_ether.h", directory: "/home/ubuntu/Hooker/src/bpf")
!11 = !{!12, !17, !18}
!12 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !9, file: !10, line: 164, baseType: !13, size: 48)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, size: 48, elements: !15)
!14 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!15 = !{!16}
!16 = !DISubrange(count: 6)
!17 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !9, file: !10, line: 165, baseType: !13, size: 48, offset: 48)
!18 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !9, file: !10, line: 166, baseType: !19, size: 16, offset: 96)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !20, line: 25, baseType: !21)
!20 = !DIFile(filename: "/usr/include/linux/types.h", directory: "/home/ubuntu/Hooker/src/bpf")
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !22, line: 24, baseType: !23)
!22 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/Hooker/src/bpf")
!23 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !26, line: 86, size: 160, elements: !27)
!26 = !DIFile(filename: "./include/linux/ip.h", directory: "/home/ubuntu/Hooker/src/bpf")
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
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "vtlhdr_t", file: !46, line: 13, baseType: !47)
!46 = !DIFile(filename: "./../../include/vtl_kern.h", directory: "/home/ubuntu/Hooker/src/bpf")
!47 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vtlhdr", file: !46, line: 14, size: 16, elements: !48)
!48 = !{!49}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "checksum", scope: !47, file: !46, line: 17, baseType: !50, size: 16)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !51, line: 25, baseType: !52)
!51 = !DIFile(filename: "/usr/include/bits/stdint-uintn.h", directory: "/home/ubuntu/Hooker/src/bpf")
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !53, line: 39, baseType: !23)
!53 = !DIFile(filename: "/usr/include/bits/types.h", directory: "/home/ubuntu/Hooker/src/bpf")
!54 = !{!0, !55}
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 153, type: !57, isLocal: false, isDefinition: true)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 32, elements: !59)
!58 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!59 = !{!60}
!60 = !DISubrange(count: 4)
!61 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_elf_map", file: !62, line: 18, size: 224, elements: !63)
!62 = !DIFile(filename: "./include/bpf/tc_bpf_util.h", directory: "/home/ubuntu/Hooker/src/bpf")
!63 = !{!64, !65, !66, !67, !68, !69, !70}
!64 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !61, file: !62, line: 23, baseType: !41, size: 32)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "size_key", scope: !61, file: !62, line: 24, baseType: !41, size: 32, offset: 32)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "size_value", scope: !61, file: !62, line: 25, baseType: !41, size: 32, offset: 64)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "max_elem", scope: !61, file: !62, line: 26, baseType: !41, size: 32, offset: 96)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !61, file: !62, line: 30, baseType: !41, size: 32, offset: 128)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !61, file: !62, line: 31, baseType: !41, size: 32, offset: 160)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "pinning", scope: !61, file: !62, line: 40, baseType: !41, size: 32, offset: 192)
!71 = !{i32 2, !"Dwarf Version", i32 4}
!72 = !{i32 2, !"Debug Info Version", i32 3}
!73 = !{i32 1, !"wchar_size", i32 4}
!74 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!75 = distinct !DISubprogram(name: "_tf_tc_egress", scope: !3, file: !3, line: 75, type: !76, isLocal: false, isDefinition: true, scopeLine: 76, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !168)
!76 = !DISubroutineType(types: !77)
!77 = !{!78, !79}
!78 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sk_buff", file: !81, line: 2934, size: 1408, elements: !82)
!81 = !DIFile(filename: "./include/linux/bpf.h", directory: "/home/ubuntu/Hooker/src/bpf")
!82 = !{!83, !84, !85, !86, !87, !88, !89, !90, !91, !92, !93, !94, !95, !99, !100, !101, !102, !103, !104, !105, !106, !107, !109, !110, !111, !112, !113, !143, !146, !147, !148}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !80, file: !81, line: 2935, baseType: !41, size: 32)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_type", scope: !80, file: !81, line: 2936, baseType: !41, size: 32, offset: 32)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !80, file: !81, line: 2937, baseType: !41, size: 32, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "queue_mapping", scope: !80, file: !81, line: 2938, baseType: !41, size: 32, offset: 96)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !80, file: !81, line: 2939, baseType: !41, size: 32, offset: 128)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_present", scope: !80, file: !81, line: 2940, baseType: !41, size: 32, offset: 160)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_tci", scope: !80, file: !81, line: 2941, baseType: !41, size: 32, offset: 192)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_proto", scope: !80, file: !81, line: 2942, baseType: !41, size: 32, offset: 224)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !80, file: !81, line: 2943, baseType: !41, size: 32, offset: 256)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !80, file: !81, line: 2944, baseType: !41, size: 32, offset: 288)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !80, file: !81, line: 2945, baseType: !41, size: 32, offset: 320)
!94 = !DIDerivedType(tag: DW_TAG_member, name: "tc_index", scope: !80, file: !81, line: 2946, baseType: !41, size: 32, offset: 352)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "cb", scope: !80, file: !81, line: 2947, baseType: !96, size: 160, offset: 384)
!96 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 160, elements: !97)
!97 = !{!98}
!98 = !DISubrange(count: 5)
!99 = !DIDerivedType(tag: DW_TAG_member, name: "hash", scope: !80, file: !81, line: 2948, baseType: !41, size: 32, offset: 544)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "tc_classid", scope: !80, file: !81, line: 2949, baseType: !41, size: 32, offset: 576)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !80, file: !81, line: 2950, baseType: !41, size: 32, offset: 608)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !80, file: !81, line: 2951, baseType: !41, size: 32, offset: 640)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "napi_id", scope: !80, file: !81, line: 2952, baseType: !41, size: 32, offset: 672)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !80, file: !81, line: 2955, baseType: !41, size: 32, offset: 704)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !80, file: !81, line: 2956, baseType: !41, size: 32, offset: 736)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !80, file: !81, line: 2957, baseType: !41, size: 32, offset: 768)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !80, file: !81, line: 2958, baseType: !108, size: 128, offset: 800)
!108 = !DICompositeType(tag: DW_TAG_array_type, baseType: !41, size: 128, elements: !59)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !80, file: !81, line: 2959, baseType: !108, size: 128, offset: 928)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !80, file: !81, line: 2960, baseType: !41, size: 32, offset: 1056)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !80, file: !81, line: 2961, baseType: !41, size: 32, offset: 1088)
!112 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !80, file: !81, line: 2964, baseType: !41, size: 32, offset: 1120)
!113 = !DIDerivedType(tag: DW_TAG_member, scope: !80, file: !81, line: 2965, baseType: !114, size: 64, align: 64, offset: 1152)
!114 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !80, file: !81, line: 2965, size: 64, align: 64, elements: !115)
!115 = !{!116}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "flow_keys", scope: !114, file: !81, line: 2965, baseType: !117, size: 64)
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_flow_keys", file: !81, line: 3510, size: 384, elements: !119)
!119 = !{!120, !121, !122, !123, !124, !125, !126, !127, !128, !129, !130}
!120 = !DIDerivedType(tag: DW_TAG_member, name: "nhoff", scope: !118, file: !81, line: 3511, baseType: !21, size: 16)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "thoff", scope: !118, file: !81, line: 3512, baseType: !21, size: 16, offset: 16)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "addr_proto", scope: !118, file: !81, line: 3513, baseType: !21, size: 16, offset: 32)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "is_frag", scope: !118, file: !81, line: 3514, baseType: !29, size: 8, offset: 48)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "is_first_frag", scope: !118, file: !81, line: 3515, baseType: !29, size: 8, offset: 56)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "is_encap", scope: !118, file: !81, line: 3516, baseType: !29, size: 8, offset: 64)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !118, file: !81, line: 3517, baseType: !29, size: 8, offset: 72)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "n_proto", scope: !118, file: !81, line: 3518, baseType: !19, size: 16, offset: 80)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !118, file: !81, line: 3519, baseType: !19, size: 16, offset: 96)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !118, file: !81, line: 3520, baseType: !19, size: 16, offset: 112)
!130 = !DIDerivedType(tag: DW_TAG_member, scope: !118, file: !81, line: 3521, baseType: !131, size: 256, offset: 128)
!131 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !118, file: !81, line: 3521, size: 256, elements: !132)
!132 = !{!133, !138}
!133 = !DIDerivedType(tag: DW_TAG_member, scope: !131, file: !81, line: 3522, baseType: !134, size: 64)
!134 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !131, file: !81, line: 3522, size: 64, elements: !135)
!135 = !{!136, !137}
!136 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !134, file: !81, line: 3523, baseType: !40, size: 32)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !134, file: !81, line: 3524, baseType: !40, size: 32, offset: 32)
!138 = !DIDerivedType(tag: DW_TAG_member, scope: !131, file: !81, line: 3526, baseType: !139, size: 256)
!139 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !131, file: !81, line: 3526, size: 256, elements: !140)
!140 = !{!141, !142}
!141 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !139, file: !81, line: 3527, baseType: !108, size: 128)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !139, file: !81, line: 3528, baseType: !108, size: 128, offset: 128)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp", scope: !80, file: !81, line: 2966, baseType: !144, size: 64, offset: 1216)
!144 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !22, line: 31, baseType: !145)
!145 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "wire_len", scope: !80, file: !81, line: 2967, baseType: !41, size: 32, offset: 1280)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "gso_segs", scope: !80, file: !81, line: 2968, baseType: !41, size: 32, offset: 1312)
!148 = !DIDerivedType(tag: DW_TAG_member, scope: !80, file: !81, line: 2969, baseType: !149, size: 64, align: 64, offset: 1344)
!149 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !80, file: !81, line: 2969, size: 64, align: 64, elements: !150)
!150 = !{!151}
!151 = !DIDerivedType(tag: DW_TAG_member, name: "sk", scope: !149, file: !81, line: 2969, baseType: !152, size: 64)
!152 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !153, size: 64)
!153 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock", file: !81, line: 3022, size: 608, elements: !154)
!154 = !{!155, !156, !157, !158, !159, !160, !161, !162, !163, !164, !165, !166, !167}
!155 = !DIDerivedType(tag: DW_TAG_member, name: "bound_dev_if", scope: !153, file: !81, line: 3023, baseType: !41, size: 32)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !153, file: !81, line: 3024, baseType: !41, size: 32, offset: 32)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !153, file: !81, line: 3025, baseType: !41, size: 32, offset: 64)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !153, file: !81, line: 3026, baseType: !41, size: 32, offset: 96)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !153, file: !81, line: 3027, baseType: !41, size: 32, offset: 128)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !153, file: !81, line: 3028, baseType: !41, size: 32, offset: 160)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip4", scope: !153, file: !81, line: 3030, baseType: !41, size: 32, offset: 192)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip6", scope: !153, file: !81, line: 3031, baseType: !108, size: 128, offset: 224)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "src_port", scope: !153, file: !81, line: 3032, baseType: !41, size: 32, offset: 352)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "dst_port", scope: !153, file: !81, line: 3033, baseType: !41, size: 32, offset: 384)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip4", scope: !153, file: !81, line: 3034, baseType: !41, size: 32, offset: 416)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip6", scope: !153, file: !81, line: 3035, baseType: !108, size: 128, offset: 448)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !153, file: !81, line: 3036, baseType: !41, size: 32, offset: 576)
!168 = !{!169, !170, !171, !172, !173, !174}
!169 = !DILocalVariable(name: "skb", arg: 1, scope: !75, file: !3, line: 75, type: !79)
!170 = !DILocalVariable(name: "data", scope: !75, file: !3, line: 129, type: !6)
!171 = !DILocalVariable(name: "data_end", scope: !75, file: !3, line: 130, type: !6)
!172 = !DILocalVariable(name: "eth", scope: !75, file: !3, line: 132, type: !8)
!173 = !DILocalVariable(name: "iph", scope: !75, file: !3, line: 136, type: !24)
!174 = !DILocalVariable(name: "vtlh", scope: !75, file: !3, line: 144, type: !44)
!175 = !DILocation(line: 75, column: 37, scope: !75)
!176 = !DILocation(line: 129, column: 34, scope: !75)
!177 = !{!178, !179, i64 76}
!178 = !{!"__sk_buff", !179, i64 0, !179, i64 4, !179, i64 8, !179, i64 12, !179, i64 16, !179, i64 20, !179, i64 24, !179, i64 28, !179, i64 32, !179, i64 36, !179, i64 40, !179, i64 44, !180, i64 48, !179, i64 68, !179, i64 72, !179, i64 76, !179, i64 80, !179, i64 84, !179, i64 88, !179, i64 92, !179, i64 96, !180, i64 100, !180, i64 116, !179, i64 132, !179, i64 136, !179, i64 140, !180, i64 144, !182, i64 152, !179, i64 160, !179, i64 164, !180, i64 168}
!179 = !{!"int", !180, i64 0}
!180 = !{!"omnipotent char", !181, i64 0}
!181 = !{!"Simple C/C++ TBAA"}
!182 = !{!"long long", !180, i64 0}
!183 = !DILocation(line: 129, column: 23, scope: !75)
!184 = !DILocation(line: 129, column: 8, scope: !75)
!185 = !DILocation(line: 130, column: 45, scope: !75)
!186 = !{!178, !179, i64 80}
!187 = !DILocation(line: 130, column: 34, scope: !75)
!188 = !DILocation(line: 130, column: 15, scope: !75)
!189 = !DILocation(line: 132, column: 23, scope: !75)
!190 = !DILocation(line: 132, column: 17, scope: !75)
!191 = !DILocation(line: 133, column: 16, scope: !192)
!192 = distinct !DILexicalBlock(scope: !75, file: !3, line: 133, column: 12)
!193 = !DILocation(line: 133, column: 22, scope: !192)
!194 = !DILocation(line: 133, column: 20, scope: !192)
!195 = !DILocation(line: 133, column: 12, scope: !75)
!196 = !DILocation(line: 136, column: 23, scope: !75)
!197 = !DILocation(line: 137, column: 16, scope: !198)
!198 = distinct !DILexicalBlock(scope: !75, file: !3, line: 137, column: 12)
!199 = !DILocation(line: 137, column: 22, scope: !198)
!200 = !DILocation(line: 137, column: 20, scope: !198)
!201 = !DILocation(line: 137, column: 12, scope: !75)
!202 = !DILocation(line: 140, column: 10, scope: !203)
!203 = distinct !DILexicalBlock(scope: !75, file: !3, line: 140, column: 5)
!204 = !{!205, !180, i64 9}
!205 = !{!"iphdr", !180, i64 0, !180, i64 0, !180, i64 1, !206, i64 2, !206, i64 4, !206, i64 6, !180, i64 8, !180, i64 9, !206, i64 10, !179, i64 12, !179, i64 16}
!206 = !{!"short", !180, i64 0}
!207 = !DILocation(line: 140, column: 19, scope: !203)
!208 = !DILocation(line: 140, column: 5, scope: !75)
!209 = !DILocation(line: 144, column: 12, scope: !75)
!210 = !DILocation(line: 145, column: 10, scope: !211)
!211 = distinct !DILexicalBlock(scope: !75, file: !3, line: 145, column: 5)
!212 = !DILocation(line: 145, column: 16, scope: !211)
!213 = !DILocation(line: 145, column: 14, scope: !211)
!214 = !DILocation(line: 145, column: 5, scope: !75)
!215 = !DILocation(line: 148, column: 8, scope: !75)
!216 = !DILocation(line: 148, column: 17, scope: !75)
!217 = !{!218, !206, i64 0}
!218 = !{!"vtlhdr", !206, i64 0}
!219 = !DILocation(line: 150, column: 9, scope: !75)
!220 = !DILocation(line: 151, column: 1, scope: !75)
