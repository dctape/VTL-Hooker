; ModuleID = 'xdp_ack_kern.c'
source_filename = "xdp_ack_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.S = type { i16, i16 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }
%struct.icmphdr = type { i8, i8, i16, %union.anon }
%union.anon = type { i32 }

@my_map = global %struct.bpf_map_def { i32 4, i32 4, i32 4, i32 128, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@xdp_ack_prog.____fmt = private unnamed_addr constant [30 x i8] c"perf_event_output failed: %d\0A\00", align 1
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !110
@_version = global i32 266002, section "version", align 4, !dbg !114
@llvm.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32* @_version to i8*), i8* bitcast (%struct.bpf_map_def* @my_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_ack_prog to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @xdp_ack_prog(%struct.xdp_md*) #0 section "xdp_ack" !dbg !147 {
  %2 = alloca [6 x i8], align 1
  call void @llvm.dbg.declare(metadata [6 x i8]* %2, metadata !181, metadata !DIExpression()), !dbg !188
  %3 = alloca %struct.S, align 2
  %4 = alloca [30 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !159, metadata !DIExpression()), !dbg !190
  %5 = bitcast %struct.S* %3 to i8*, !dbg !191
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %5) #3, !dbg !191
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !192
  %7 = load i32, i32* %6, align 4, !dbg !192, !tbaa !193
  %8 = zext i32 %7 to i64, !dbg !198
  call void @llvm.dbg.value(metadata i64 %8, metadata !165, metadata !DIExpression()), !dbg !199
  %9 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !200
  %10 = load i32, i32* %9, align 4, !dbg !200, !tbaa !201
  %11 = zext i32 %10 to i64, !dbg !202
  call void @llvm.dbg.value(metadata i64 %11, metadata !166, metadata !DIExpression()), !dbg !203
  %12 = inttoptr i64 %11 to %struct.ethhdr*, !dbg !204
  call void @llvm.dbg.value(metadata %struct.ethhdr* %12, metadata !167, metadata !DIExpression()), !dbg !205
  %13 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 1, !dbg !206
  %14 = inttoptr i64 %8 to %struct.ethhdr*, !dbg !208
  %15 = icmp ugt %struct.ethhdr* %13, %14, !dbg !209
  br i1 %15, label %59, label %16, !dbg !210

; <label>:16:                                     ; preds = %1
  call void @llvm.dbg.value(metadata %struct.ethhdr* %13, metadata !168, metadata !DIExpression()), !dbg !211
  %17 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 2, i32 1, !dbg !212
  %18 = bitcast [6 x i8]* %17 to %struct.iphdr*, !dbg !212
  %19 = inttoptr i64 %8 to %struct.iphdr*, !dbg !214
  %20 = icmp ugt %struct.iphdr* %18, %19, !dbg !215
  br i1 %20, label %59, label %21, !dbg !216

; <label>:21:                                     ; preds = %16
  %22 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 1, i32 1, i64 3, !dbg !217
  %23 = load i8, i8* %22, align 1, !dbg !217, !tbaa !219
  %24 = icmp eq i8 %23, 1, !dbg !222
  br i1 %24, label %25, label %59, !dbg !223

; <label>:25:                                     ; preds = %21
  call void @llvm.dbg.value(metadata [6 x i8]* %17, metadata !169, metadata !DIExpression()), !dbg !224
  %26 = getelementptr inbounds [6 x i8], [6 x i8]* %17, i64 1, i64 2, !dbg !225
  %27 = bitcast i8* %26 to %struct.icmphdr*, !dbg !225
  %28 = inttoptr i64 %8 to %struct.icmphdr*, !dbg !227
  %29 = icmp ugt %struct.icmphdr* %27, %28, !dbg !228
  br i1 %29, label %59, label %30, !dbg !229

; <label>:30:                                     ; preds = %25
  call void @llvm.dbg.value(metadata i64 4294967295, metadata !170, metadata !DIExpression()), !dbg !230
  %31 = getelementptr inbounds %struct.S, %struct.S* %3, i64 0, i32 0, !dbg !231
  store i16 -8531, i16* %31, align 2, !dbg !232, !tbaa !233
  %32 = sub nsw i64 %8, %11, !dbg !235
  %33 = trunc i64 %32 to i16, !dbg !236
  %34 = getelementptr inbounds %struct.S, %struct.S* %3, i64 0, i32 1, !dbg !237
  store i16 %33, i16* %34, align 2, !dbg !238, !tbaa !239
  %35 = shl i64 %32, 32, !dbg !240
  %36 = and i64 %35, 281470681743360, !dbg !240
  %37 = or i64 %36, 4294967295, !dbg !241
  call void @llvm.dbg.value(metadata i64 %37, metadata !170, metadata !DIExpression()), !dbg !230
  %38 = bitcast %struct.xdp_md* %0 to i8*, !dbg !242
  %39 = call i32 inttoptr (i64 25 to i32 (i8*, i8*, i64, i8*, i32)*)(i8* %38, i8* bitcast (%struct.bpf_map_def* @my_map to i8*), i64 %37, i8* nonnull %5, i32 4) #3, !dbg !243
  call void @llvm.dbg.value(metadata i32 %39, metadata !172, metadata !DIExpression()), !dbg !244
  %40 = icmp eq i32 %39, 0, !dbg !245
  br i1 %40, label %44, label %41, !dbg !246

; <label>:41:                                     ; preds = %30
  %42 = getelementptr inbounds [30 x i8], [30 x i8]* %4, i64 0, i64 0, !dbg !247
  call void @llvm.lifetime.start.p0i8(i64 30, i8* nonnull %42) #3, !dbg !247
  call void @llvm.dbg.declare(metadata [30 x i8]* %4, metadata !173, metadata !DIExpression()), !dbg !247
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %42, i8* getelementptr inbounds ([30 x i8], [30 x i8]* @xdp_ack_prog.____fmt, i64 0, i64 0), i64 30, i32 1, i1 false), !dbg !247
  %43 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %42, i32 30, i32 %39) #3, !dbg !247
  call void @llvm.lifetime.end.p0i8(i64 30, i8* nonnull %42) #3, !dbg !248
  br label %44, !dbg !248

; <label>:44:                                     ; preds = %30, %41
  call void @llvm.dbg.value(metadata %struct.ethhdr* %12, metadata !186, metadata !DIExpression()) #3, !dbg !249
  %45 = getelementptr inbounds [6 x i8], [6 x i8]* %2, i64 0, i64 0, !dbg !250
  call void @llvm.lifetime.start.p0i8(i64 6, i8* nonnull %45), !dbg !250
  %46 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 0, i32 1, i64 0, !dbg !251
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %45, i8* nonnull %46, i64 6, i32 1, i1 false) #3, !dbg !251
  %47 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 0, i32 0, i64 0, !dbg !252
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %46, i8* %47, i64 6, i32 1, i1 false) #3, !dbg !252
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %47, i8* nonnull %45, i64 6, i32 1, i1 false) #3, !dbg !253
  call void @llvm.lifetime.end.p0i8(i64 6, i8* nonnull %45), !dbg !254
  call void @llvm.dbg.value(metadata %struct.ethhdr* %13, metadata !255, metadata !DIExpression()), !dbg !261
  %48 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 1, i32 2, !dbg !263
  %49 = bitcast i16* %48 to i32*, !dbg !263
  %50 = load i32, i32* %49, align 4, !dbg !263, !tbaa !264
  call void @llvm.dbg.value(metadata i32 %50, metadata !260, metadata !DIExpression()), !dbg !265
  %51 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %12, i64 2, i32 0, i64 2, !dbg !266
  %52 = bitcast i8* %51 to i32*, !dbg !266
  %53 = load i32, i32* %52, align 4, !dbg !266, !tbaa !267
  store i32 %53, i32* %49, align 4, !dbg !268, !tbaa !264
  store i32 %50, i32* %52, align 4, !dbg !269, !tbaa !267
  %54 = getelementptr inbounds [6 x i8], [6 x i8]* %17, i64 0, i64 0, !dbg !270
  store i8 0, i8* %54, align 4, !dbg !271, !tbaa !272
  call void @llvm.dbg.value(metadata i32 3, metadata !179, metadata !DIExpression()), !dbg !274
  %55 = ptrtoint i8* %26 to i64, !dbg !275
  %56 = trunc i64 %55 to i32, !dbg !275
  call void @llvm.dbg.value(metadata i32 %56, metadata !180, metadata !DIExpression()), !dbg !276
  %57 = sub nsw i32 0, %56, !dbg !277
  %58 = call i32 inttoptr (i64 65 to i32 (i8*, i32)*)(i8* %38, i32 %57) #3, !dbg !279
  br label %59

; <label>:59:                                     ; preds = %16, %21, %25, %44, %1
  %60 = phi i32 [ 2, %1 ], [ 2, %16 ], [ 2, %21 ], [ 3, %44 ], [ 2, %25 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %5) #3, !dbg !280
  ret i32 %60, !dbg !280
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
!llvm.module.flags = !{!143, !144, !145}
!llvm.ident = !{!146}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "my_map", scope: !2, file: !3, line: 25, type: !134, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !42, globals: !109)
!3 = !DIFile(filename: "xdp_ack_kern.c", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!4 = !{!5, !13}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, size: 32, elements: !7)
!6 = !DIFile(filename: "./include/linux/bpf.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!7 = !{!8, !9, !10, !11, !12}
!8 = !DIEnumerator(name: "XDP_ABORTED", value: 0)
!9 = !DIEnumerator(name: "XDP_DROP", value: 1)
!10 = !DIEnumerator(name: "XDP_PASS", value: 2)
!11 = !DIEnumerator(name: "XDP_TX", value: 3)
!12 = !DIEnumerator(name: "XDP_REDIRECT", value: 4)
!13 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !14, line: 40, size: 32, elements: !15)
!14 = !DIFile(filename: "/usr/include/netinet/in.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!15 = !{!16, !17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41}
!16 = !DIEnumerator(name: "IPPROTO_IP", value: 0)
!17 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1)
!18 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2)
!19 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4)
!20 = !DIEnumerator(name: "IPPROTO_TCP", value: 6)
!21 = !DIEnumerator(name: "IPPROTO_EGP", value: 8)
!22 = !DIEnumerator(name: "IPPROTO_PUP", value: 12)
!23 = !DIEnumerator(name: "IPPROTO_UDP", value: 17)
!24 = !DIEnumerator(name: "IPPROTO_IDP", value: 22)
!25 = !DIEnumerator(name: "IPPROTO_TP", value: 29)
!26 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33)
!27 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41)
!28 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46)
!29 = !DIEnumerator(name: "IPPROTO_GRE", value: 47)
!30 = !DIEnumerator(name: "IPPROTO_ESP", value: 50)
!31 = !DIEnumerator(name: "IPPROTO_AH", value: 51)
!32 = !DIEnumerator(name: "IPPROTO_MTP", value: 92)
!33 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94)
!34 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98)
!35 = !DIEnumerator(name: "IPPROTO_PIM", value: 103)
!36 = !DIEnumerator(name: "IPPROTO_COMP", value: 108)
!37 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132)
!38 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136)
!39 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137)
!40 = !DIEnumerator(name: "IPPROTO_RAW", value: 255)
!41 = !DIEnumerator(name: "IPPROTO_MAX", value: 256)
!42 = !{!43, !44, !45, !61, !81, !58, !106, !108}
!43 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!44 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !47, line: 163, size: 112, elements: !48)
!47 = !DIFile(filename: "./include/linux/if_ether.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!48 = !{!49, !54, !55}
!49 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !46, file: !47, line: 164, baseType: !50, size: 48)
!50 = !DICompositeType(tag: DW_TAG_array_type, baseType: !51, size: 48, elements: !52)
!51 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!52 = !{!53}
!53 = !DISubrange(count: 6)
!54 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !46, file: !47, line: 165, baseType: !50, size: 48, offset: 48)
!55 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !46, file: !47, line: 166, baseType: !56, size: 16, offset: 96)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !57, line: 25, baseType: !58)
!57 = !DIFile(filename: "/usr/include/linux/types.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !59, line: 24, baseType: !60)
!59 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!60 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!61 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !62, size: 64)
!62 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !63, line: 86, size: 160, elements: !64)
!63 = !DIFile(filename: "./include/linux/ip.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!64 = !{!65, !67, !68, !69, !70, !71, !72, !73, !74, !76, !80}
!65 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !62, file: !63, line: 88, baseType: !66, size: 4, flags: DIFlagBitField, extraData: i64 0)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !59, line: 21, baseType: !51)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !62, file: !63, line: 89, baseType: !66, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !62, file: !63, line: 96, baseType: !66, size: 8, offset: 8)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !62, file: !63, line: 97, baseType: !56, size: 16, offset: 16)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !62, file: !63, line: 98, baseType: !56, size: 16, offset: 32)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !62, file: !63, line: 99, baseType: !56, size: 16, offset: 48)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !62, file: !63, line: 100, baseType: !66, size: 8, offset: 64)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !62, file: !63, line: 101, baseType: !66, size: 8, offset: 72)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !62, file: !63, line: 102, baseType: !75, size: 16, offset: 80)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !57, line: 31, baseType: !58)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !62, file: !63, line: 103, baseType: !77, size: 32, offset: 96)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !57, line: 27, baseType: !78)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !59, line: 27, baseType: !79)
!79 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!80 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !62, file: !63, line: 104, baseType: !77, size: 32, offset: 128)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmphdr", file: !83, line: 69, size: 64, elements: !84)
!83 = !DIFile(filename: "/usr/include/linux/icmp.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!84 = !{!85, !86, !87, !88}
!85 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !82, file: !83, line: 70, baseType: !66, size: 8)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "code", scope: !82, file: !83, line: 71, baseType: !66, size: 8, offset: 8)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "checksum", scope: !82, file: !83, line: 72, baseType: !75, size: 16, offset: 16)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "un", scope: !82, file: !83, line: 84, baseType: !89, size: 32, offset: 32)
!89 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !82, file: !83, line: 73, size: 32, elements: !90)
!90 = !{!91, !96, !97, !102}
!91 = !DIDerivedType(tag: DW_TAG_member, name: "echo", scope: !89, file: !83, line: 77, baseType: !92, size: 32)
!92 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !89, file: !83, line: 74, size: 32, elements: !93)
!93 = !{!94, !95}
!94 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !92, file: !83, line: 75, baseType: !56, size: 16)
!95 = !DIDerivedType(tag: DW_TAG_member, name: "sequence", scope: !92, file: !83, line: 76, baseType: !56, size: 16, offset: 16)
!96 = !DIDerivedType(tag: DW_TAG_member, name: "gateway", scope: !89, file: !83, line: 78, baseType: !77, size: 32)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "frag", scope: !89, file: !83, line: 82, baseType: !98, size: 32)
!98 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !89, file: !83, line: 79, size: 32, elements: !99)
!99 = !{!100, !101}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !98, file: !83, line: 80, baseType: !56, size: 16)
!101 = !DIDerivedType(tag: DW_TAG_member, name: "mtu", scope: !98, file: !83, line: 81, baseType: !56, size: 16, offset: 16)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !89, file: !83, line: 83, baseType: !103, size: 32)
!103 = !DICompositeType(tag: DW_TAG_array_type, baseType: !66, size: 32, elements: !104)
!104 = !{!105}
!105 = !DISubrange(count: 4)
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !59, line: 31, baseType: !107)
!107 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!108 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!109 = !{!0, !110, !114, !116, !122, !129}
!110 = !DIGlobalVariableExpression(var: !111, expr: !DIExpression())
!111 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 126, type: !112, isLocal: false, isDefinition: true)
!112 = !DICompositeType(tag: DW_TAG_array_type, baseType: !113, size: 32, elements: !104)
!113 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!114 = !DIGlobalVariableExpression(var: !115, expr: !DIExpression())
!115 = distinct !DIGlobalVariable(name: "_version", scope: !2, file: !3, line: 127, type: !78, isLocal: false, isDefinition: true)
!116 = !DIGlobalVariableExpression(var: !117, expr: !DIExpression())
!117 = distinct !DIGlobalVariable(name: "bpf_perf_event_output", scope: !2, file: !118, line: 59, type: !119, isLocal: true, isDefinition: true)
!118 = !DIFile(filename: "./include/bpf/bpf_helpers.h", directory: "/home/ubuntu/Hooker/bpf_test/bpf")
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !120, size: 64)
!120 = !DISubroutineType(types: !121)
!121 = !{!108, !43, !43, !107, !43, !108}
!122 = !DIGlobalVariableExpression(var: !123, expr: !DIExpression())
!123 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !118, line: 38, type: !124, isLocal: true, isDefinition: true)
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!125 = !DISubroutineType(types: !126)
!126 = !{!108, !127, !108, null}
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !113)
!129 = !DIGlobalVariableExpression(var: !130, expr: !DIExpression())
!130 = distinct !DIGlobalVariable(name: "bpf_xdp_adjust_tail", scope: !2, file: !118, line: 128, type: !131, isLocal: true, isDefinition: true)
!131 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !132, size: 64)
!132 = !DISubroutineType(types: !133)
!133 = !{!108, !43, !108}
!134 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !118, line: 210, size: 224, elements: !135)
!135 = !{!136, !137, !138, !139, !140, !141, !142}
!136 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !134, file: !118, line: 211, baseType: !79, size: 32)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !134, file: !118, line: 212, baseType: !79, size: 32, offset: 32)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !134, file: !118, line: 213, baseType: !79, size: 32, offset: 64)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !134, file: !118, line: 214, baseType: !79, size: 32, offset: 96)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !134, file: !118, line: 215, baseType: !79, size: 32, offset: 128)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !134, file: !118, line: 216, baseType: !79, size: 32, offset: 160)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !134, file: !118, line: 217, baseType: !79, size: 32, offset: 192)
!143 = !{i32 2, !"Dwarf Version", i32 4}
!144 = !{i32 2, !"Debug Info Version", i32 3}
!145 = !{i32 1, !"wchar_size", i32 4}
!146 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!147 = distinct !DISubprogram(name: "xdp_ack_prog", scope: !3, file: !3, line: 56, type: !148, isLocal: false, isDefinition: true, scopeLine: 57, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !158)
!148 = !DISubroutineType(types: !149)
!149 = !{!108, !150}
!150 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !151, size: 64)
!151 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !152)
!152 = !{!153, !154, !155, !156, !157}
!153 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !151, file: !6, line: 2857, baseType: !78, size: 32)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !151, file: !6, line: 2858, baseType: !78, size: 32, offset: 32)
!155 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !151, file: !6, line: 2859, baseType: !78, size: 32, offset: 64)
!156 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !151, file: !6, line: 2861, baseType: !78, size: 32, offset: 96)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !151, file: !6, line: 2862, baseType: !78, size: 32, offset: 128)
!158 = !{!159, !160, !165, !166, !167, !168, !169, !170, !171, !172, !173, !179, !180}
!159 = !DILocalVariable(name: "ctx", arg: 1, scope: !147, file: !3, line: 56, type: !150)
!160 = !DILocalVariable(name: "metadata", scope: !147, file: !3, line: 62, type: !161)
!161 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "S", scope: !147, file: !3, line: 59, size: 32, elements: !162)
!162 = !{!163, !164}
!163 = !DIDerivedType(tag: DW_TAG_member, name: "cookie", scope: !161, file: !3, line: 60, baseType: !58, size: 16)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_len", scope: !161, file: !3, line: 61, baseType: !58, size: 16, offset: 16)
!165 = !DILocalVariable(name: "data_end", scope: !147, file: !3, line: 64, type: !43)
!166 = !DILocalVariable(name: "data", scope: !147, file: !3, line: 65, type: !43)
!167 = !DILocalVariable(name: "eth", scope: !147, file: !3, line: 66, type: !45)
!168 = !DILocalVariable(name: "iph", scope: !147, file: !3, line: 70, type: !61)
!169 = !DILocalVariable(name: "icmph", scope: !147, file: !3, line: 76, type: !81)
!170 = !DILocalVariable(name: "flags", scope: !147, file: !3, line: 90, type: !106)
!171 = !DILocalVariable(name: "sample_size", scope: !147, file: !3, line: 91, type: !58)
!172 = !DILocalVariable(name: "ret", scope: !147, file: !3, line: 92, type: !108)
!173 = !DILocalVariable(name: "____fmt", scope: !174, file: !3, line: 104, type: !176)
!174 = distinct !DILexicalBlock(scope: !175, file: !3, line: 104, column: 3)
!175 = distinct !DILexicalBlock(scope: !147, file: !3, line: 103, column: 6)
!176 = !DICompositeType(tag: DW_TAG_array_type, baseType: !113, size: 240, elements: !177)
!177 = !{!178}
!178 = !DISubrange(count: 30)
!179 = !DILocalVariable(name: "action", scope: !147, file: !3, line: 114, type: !78)
!180 = !DILocalVariable(name: "offset", scope: !147, file: !3, line: 119, type: !108)
!181 = !DILocalVariable(name: "h_tmp", scope: !182, file: !3, line: 37, type: !187)
!182 = distinct !DISubprogram(name: "swap_src_dst_mac", scope: !3, file: !3, line: 35, type: !183, isLocal: true, isDefinition: true, scopeLine: 36, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !185)
!183 = !DISubroutineType(types: !184)
!184 = !{null, !45}
!185 = !{!186, !181}
!186 = !DILocalVariable(name: "eth", arg: 1, scope: !182, file: !3, line: 35, type: !45)
!187 = !DICompositeType(tag: DW_TAG_array_type, baseType: !66, size: 48, elements: !52)
!188 = !DILocation(line: 37, column: 7, scope: !182, inlinedAt: !189)
!189 = distinct !DILocation(line: 107, column: 2, scope: !147)
!190 = !DILocation(line: 56, column: 33, scope: !147)
!191 = !DILocation(line: 59, column: 2, scope: !147)
!192 = !DILocation(line: 64, column: 38, scope: !147)
!193 = !{!194, !195, i64 4}
!194 = !{!"xdp_md", !195, i64 0, !195, i64 4, !195, i64 8, !195, i64 12, !195, i64 16}
!195 = !{!"int", !196, i64 0}
!196 = !{!"omnipotent char", !197, i64 0}
!197 = !{!"Simple C/C++ TBAA"}
!198 = !DILocation(line: 64, column: 27, scope: !147)
!199 = !DILocation(line: 64, column: 8, scope: !147)
!200 = !DILocation(line: 65, column: 34, scope: !147)
!201 = !{!194, !195, i64 0}
!202 = !DILocation(line: 65, column: 23, scope: !147)
!203 = !DILocation(line: 65, column: 8, scope: !147)
!204 = !DILocation(line: 66, column: 23, scope: !147)
!205 = !DILocation(line: 66, column: 17, scope: !147)
!206 = !DILocation(line: 67, column: 10, scope: !207)
!207 = distinct !DILexicalBlock(scope: !147, file: !3, line: 67, column: 6)
!208 = !DILocation(line: 67, column: 16, scope: !207)
!209 = !DILocation(line: 67, column: 14, scope: !207)
!210 = !DILocation(line: 67, column: 6, scope: !147)
!211 = !DILocation(line: 70, column: 16, scope: !147)
!212 = !DILocation(line: 71, column: 10, scope: !213)
!213 = distinct !DILexicalBlock(scope: !147, file: !3, line: 71, column: 6)
!214 = !DILocation(line: 71, column: 16, scope: !213)
!215 = !DILocation(line: 71, column: 14, scope: !213)
!216 = !DILocation(line: 71, column: 6, scope: !147)
!217 = !DILocation(line: 73, column: 11, scope: !218)
!218 = distinct !DILexicalBlock(scope: !147, file: !3, line: 73, column: 6)
!219 = !{!220, !196, i64 9}
!220 = !{!"iphdr", !196, i64 0, !196, i64 0, !196, i64 1, !221, i64 2, !221, i64 4, !221, i64 6, !196, i64 8, !196, i64 9, !221, i64 10, !195, i64 12, !195, i64 16}
!221 = !{!"short", !196, i64 0}
!222 = !DILocation(line: 73, column: 20, scope: !218)
!223 = !DILocation(line: 73, column: 6, scope: !147)
!224 = !DILocation(line: 76, column: 18, scope: !147)
!225 = !DILocation(line: 77, column: 12, scope: !226)
!226 = distinct !DILexicalBlock(scope: !147, file: !3, line: 77, column: 6)
!227 = !DILocation(line: 77, column: 18, scope: !226)
!228 = !DILocation(line: 77, column: 16, scope: !226)
!229 = !DILocation(line: 77, column: 6, scope: !147)
!230 = !DILocation(line: 90, column: 8, scope: !147)
!231 = !DILocation(line: 94, column: 11, scope: !147)
!232 = !DILocation(line: 94, column: 18, scope: !147)
!233 = !{!234, !221, i64 0}
!234 = !{!"S", !221, i64 0, !221, i64 2}
!235 = !DILocation(line: 95, column: 38, scope: !147)
!236 = !DILocation(line: 95, column: 21, scope: !147)
!237 = !DILocation(line: 95, column: 11, scope: !147)
!238 = !DILocation(line: 95, column: 19, scope: !147)
!239 = !{!234, !221, i64 2}
!240 = !DILocation(line: 98, column: 42, scope: !147)
!241 = !DILocation(line: 98, column: 15, scope: !147)
!242 = !DILocation(line: 101, column: 30, scope: !147)
!243 = !DILocation(line: 101, column: 8, scope: !147)
!244 = !DILocation(line: 92, column: 6, scope: !147)
!245 = !DILocation(line: 103, column: 6, scope: !175)
!246 = !DILocation(line: 103, column: 6, scope: !147)
!247 = !DILocation(line: 104, column: 3, scope: !174)
!248 = !DILocation(line: 104, column: 3, scope: !175)
!249 = !DILocation(line: 35, column: 61, scope: !182, inlinedAt: !189)
!250 = !DILocation(line: 37, column: 2, scope: !182, inlinedAt: !189)
!251 = !DILocation(line: 39, column: 2, scope: !182, inlinedAt: !189)
!252 = !DILocation(line: 40, column: 2, scope: !182, inlinedAt: !189)
!253 = !DILocation(line: 41, column: 2, scope: !182, inlinedAt: !189)
!254 = !DILocation(line: 42, column: 1, scope: !182, inlinedAt: !189)
!255 = !DILocalVariable(name: "iphdr", arg: 1, scope: !256, file: !3, line: 47, type: !61)
!256 = distinct !DISubprogram(name: "swap_src_dst_ipv4", scope: !3, file: !3, line: 47, type: !257, isLocal: true, isDefinition: true, scopeLine: 48, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !259)
!257 = !DISubroutineType(types: !258)
!258 = !{null, !61}
!259 = !{!255, !260}
!260 = !DILocalVariable(name: "tmp", scope: !256, file: !3, line: 49, type: !77)
!261 = !DILocation(line: 47, column: 61, scope: !256, inlinedAt: !262)
!262 = distinct !DILocation(line: 108, column: 2, scope: !147)
!263 = !DILocation(line: 49, column: 22, scope: !256, inlinedAt: !262)
!264 = !{!220, !195, i64 12}
!265 = !DILocation(line: 49, column: 9, scope: !256, inlinedAt: !262)
!266 = !DILocation(line: 51, column: 24, scope: !256, inlinedAt: !262)
!267 = !{!220, !195, i64 16}
!268 = !DILocation(line: 51, column: 15, scope: !256, inlinedAt: !262)
!269 = !DILocation(line: 52, column: 15, scope: !256, inlinedAt: !262)
!270 = !DILocation(line: 111, column: 9, scope: !147)
!271 = !DILocation(line: 111, column: 14, scope: !147)
!272 = !{!273, !196, i64 0}
!273 = !{!"icmphdr", !196, i64 0, !196, i64 1, !221, i64 2, !196, i64 4}
!274 = !DILocation(line: 114, column: 8, scope: !147)
!275 = !DILocation(line: 119, column: 15, scope: !147)
!276 = !DILocation(line: 119, column: 6, scope: !147)
!277 = !DILocation(line: 120, column: 33, scope: !278)
!278 = distinct !DILexicalBlock(scope: !147, file: !3, line: 120, column: 6)
!279 = !DILocation(line: 120, column: 6, scope: !278)
!280 = !DILocation(line: 124, column: 1, scope: !147)
