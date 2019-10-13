; ModuleID = 'redir1_skmsg.c'
source_filename = "redir1_skmsg.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.sk_msg_md = type { %union.anon, %union.anon.0, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32 }
%union.anon = type { i8* }
%union.anon.0 = type { i8* }
%struct.sock_key = type { i32, i32, i32, i32 }

@sock_key_map = global %struct.bpf_map_def { i32 2, i32 4, i32 16, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@hooker_map = global %struct.bpf_map_def { i32 18, i32 16, i32 4, i32 20, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !11
@redirector_skmsg.____fmt = private unnamed_addr constant [15 x i8] c"hooker -> app\0A\00", align 1
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !25
@llvm.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* bitcast (i32 (%struct.sk_msg_md*)* @redirector_skmsg to i8*), i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define i32 @redirector_skmsg(%struct.sk_msg_md*) #0 section "sk_msg" !dbg !54 {
  %2 = alloca %struct.sock_key, align 4
  %3 = alloca [15 x i8], align 1
  %4 = alloca i32, align 4
  %5 = alloca %struct.sock_key, align 4
  call void @llvm.dbg.value(metadata %struct.sk_msg_md* %0, metadata !80, metadata !DIExpression()), !dbg !104
  call void @llvm.dbg.value(metadata i64 1, metadata !81, metadata !DIExpression()), !dbg !105
  %6 = bitcast %struct.sock_key* %2 to i8*, !dbg !106
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %6) #3, !dbg !106
  call void @llvm.memset.p0i8.i64(i8* nonnull %6, i8 0, i64 16, i32 4, i1 false), !dbg !107
  %7 = getelementptr inbounds %struct.sk_msg_md, %struct.sk_msg_md* %0, i64 0, i32 8, !dbg !108
  %8 = load i32, i32* %7, align 8, !dbg !108, !tbaa !109
  call void @llvm.dbg.value(metadata i32 %8, metadata !84, metadata !DIExpression()), !dbg !114
  switch i32 %8, label %22 [
    i32 10002, label %9
    i32 9092, label %19
  ], !dbg !115

; <label>:9:                                      ; preds = %1
  %10 = getelementptr inbounds [15 x i8], [15 x i8]* %3, i64 0, i64 0, !dbg !116
  call void @llvm.lifetime.start.p0i8(i64 15, i8* nonnull %10) #3, !dbg !116
  call void @llvm.dbg.declare(metadata [15 x i8]* %3, metadata !94, metadata !DIExpression()), !dbg !116
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %10, i8* getelementptr inbounds ([15 x i8], [15 x i8]* @redirector_skmsg.____fmt, i64 0, i64 0), i64 15, i32 1, i1 false), !dbg !116
  %11 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %10, i32 15) #3, !dbg !116
  call void @llvm.lifetime.end.p0i8(i64 15, i8* nonnull %10) #3, !dbg !117
  call void @llvm.dbg.value(metadata i32 0, metadata !100, metadata !DIExpression()), !dbg !118
  store i32 0, i32* %4, align 4, !dbg !118, !tbaa !119
  %12 = bitcast %struct.sock_key* %5 to i8*, !dbg !120
  call void @llvm.memset.p0i8.i64(i8* nonnull %12, i8 0, i64 16, i32 4, i1 false), !dbg !120
  %13 = bitcast i32* %4 to i8*, !dbg !121
  %14 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @sock_key_map to i8*), i8* nonnull %13) #3, !dbg !122
  call void @llvm.dbg.value(metadata i8* %14, metadata !101, metadata !DIExpression()), !dbg !123
  %15 = icmp eq i8* %14, null, !dbg !124
  br i1 %15, label %22, label %16, !dbg !126

; <label>:16:                                     ; preds = %9
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %12, i8* nonnull %14, i64 16, i32 4, i1 false), !dbg !127, !tbaa.struct !128
  %17 = bitcast %struct.sk_msg_md* %0 to i8*, !dbg !129
  %18 = call i32 inttoptr (i64 71 to i32 (i8*, i8*, i8*, i32)*)(i8* %17, i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* nonnull %12, i32 1) #3, !dbg !130
  br label %22, !dbg !131

; <label>:19:                                     ; preds = %1
  %20 = bitcast %struct.sk_msg_md* %0 to i8*, !dbg !132
  %21 = call i32 inttoptr (i64 71 to i32 (i8*, i8*, i8*, i32)*)(i8* %20, i8* bitcast (%struct.bpf_map_def* @hooker_map to i8*), i8* nonnull %6, i32 1) #3, !dbg !133
  br label %22, !dbg !134

; <label>:22:                                     ; preds = %16, %19, %1, %9
  %23 = phi i32 [ 0, %9 ], [ 1, %1 ], [ 1, %19 ], [ 1, %16 ]
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %6) #3, !dbg !135
  ret i32 %23, !dbg !135
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i32, i1) #2

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
!llvm.module.flags = !{!50, !51, !52}
!llvm.ident = !{!53}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "sock_key_map", scope: !2, file: !13, line: 14, type: !14, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, globals: !10)
!3 = !DIFile(filename: "redir1_skmsg.c", directory: "/home/ubuntu/hooker/hooker")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "sk_action", file: !6, line: 2865, size: 32, elements: !7)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/ubuntu/hooker/hooker")
!7 = !{!8, !9}
!8 = !DIEnumerator(name: "SK_DROP", value: 0)
!9 = !DIEnumerator(name: "SK_PASS", value: 1)
!10 = !{!0, !11, !25, !31, !39, !45}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "hooker_map", scope: !2, file: !13, line: 22, type: !14, isLocal: false, isDefinition: true)
!13 = !DIFile(filename: "./../lib/maps.h", directory: "/home/ubuntu/hooker/hooker")
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !15, line: 210, size: 224, elements: !16)
!15 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/ubuntu/hooker/hooker")
!16 = !{!17, !19, !20, !21, !22, !23, !24}
!17 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !14, file: !15, line: 211, baseType: !18, size: 32)
!18 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !14, file: !15, line: 212, baseType: !18, size: 32, offset: 32)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !14, file: !15, line: 213, baseType: !18, size: 32, offset: 64)
!21 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !14, file: !15, line: 214, baseType: !18, size: 32, offset: 96)
!22 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !14, file: !15, line: 215, baseType: !18, size: 32, offset: 128)
!23 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !14, file: !15, line: 216, baseType: !18, size: 32, offset: 160)
!24 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !14, file: !15, line: 217, baseType: !18, size: 32, offset: 192)
!25 = !DIGlobalVariableExpression(var: !26, expr: !DIExpression())
!26 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 77, type: !27, isLocal: false, isDefinition: true)
!27 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 32, elements: !29)
!28 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!29 = !{!30}
!30 = !DISubrange(count: 4)
!31 = !DIGlobalVariableExpression(var: !32, expr: !DIExpression())
!32 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !15, line: 38, type: !33, isLocal: true, isDefinition: true)
!33 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !34, size: 64)
!34 = !DISubroutineType(types: !35)
!35 = !{!36, !37, !36, null}
!36 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!37 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!38 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !28)
!39 = !DIGlobalVariableExpression(var: !40, expr: !DIExpression())
!40 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !15, line: 20, type: !41, isLocal: true, isDefinition: true)
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = !DISubroutineType(types: !43)
!43 = !{!44, !44, !44}
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!45 = !DIGlobalVariableExpression(var: !46, expr: !DIExpression())
!46 = distinct !DIGlobalVariable(name: "bpf_msg_redirect_hash", scope: !2, file: !15, line: 113, type: !47, isLocal: true, isDefinition: true)
!47 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!48 = !DISubroutineType(types: !49)
!49 = !{!36, !44, !44, !44, !36}
!50 = !{i32 2, !"Dwarf Version", i32 4}
!51 = !{i32 2, !"Debug Info Version", i32 3}
!52 = !{i32 1, !"wchar_size", i32 4}
!53 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!54 = distinct !DISubprogram(name: "redirector_skmsg", scope: !3, file: !3, line: 34, type: !55, isLocal: false, isDefinition: true, scopeLine: 35, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !79)
!55 = !DISubroutineType(types: !56)
!56 = !{!36, !57}
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "sk_msg_md", file: !6, line: 2873, size: 576, elements: !59)
!59 = !{!60, !64, !68, !71, !72, !73, !75, !76, !77, !78}
!60 = !DIDerivedType(tag: DW_TAG_member, scope: !58, file: !6, line: 2874, baseType: !61, size: 64, align: 64)
!61 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !58, file: !6, line: 2874, size: 64, align: 64, elements: !62)
!62 = !{!63}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !61, file: !6, line: 2874, baseType: !44, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, scope: !58, file: !6, line: 2875, baseType: !65, size: 64, align: 64, offset: 64)
!65 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !58, file: !6, line: 2875, size: 64, align: 64, elements: !66)
!66 = !{!67}
!67 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !65, file: !6, line: 2875, baseType: !44, size: 64)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !58, file: !6, line: 2877, baseType: !69, size: 32, offset: 128)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !70, line: 27, baseType: !18)
!70 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/hooker/hooker")
!71 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !58, file: !6, line: 2878, baseType: !69, size: 32, offset: 160)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !58, file: !6, line: 2879, baseType: !69, size: 32, offset: 192)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !58, file: !6, line: 2880, baseType: !74, size: 128, offset: 224)
!74 = !DICompositeType(tag: DW_TAG_array_type, baseType: !69, size: 128, elements: !29)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !58, file: !6, line: 2881, baseType: !74, size: 128, offset: 352)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !58, file: !6, line: 2882, baseType: !69, size: 32, offset: 480)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !58, file: !6, line: 2883, baseType: !69, size: 32, offset: 512)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "size", scope: !58, file: !6, line: 2884, baseType: !69, size: 32, offset: 544)
!79 = !{!80, !81, !84, !85, !94, !100, !101, !103}
!80 = !DILocalVariable(name: "msg", arg: 1, scope: !54, file: !3, line: 34, type: !57)
!81 = !DILocalVariable(name: "flags", scope: !54, file: !3, line: 36, type: !82)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !70, line: 31, baseType: !83)
!83 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!84 = !DILocalVariable(name: "lport", scope: !54, file: !3, line: 37, type: !69)
!85 = !DILocalVariable(name: "hsock_key", scope: !54, file: !3, line: 38, type: !86)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "sock_key_t", file: !87, line: 24, baseType: !88)
!87 = !DIFile(filename: "./../lib/config.h", directory: "/home/ubuntu/hooker/hooker")
!88 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "sock_key", file: !87, line: 25, size: 128, elements: !89)
!89 = !{!90, !91, !92, !93}
!90 = !DIDerivedType(tag: DW_TAG_member, name: "sip4", scope: !88, file: !87, line: 27, baseType: !69, size: 32)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "dip4", scope: !88, file: !87, line: 28, baseType: !69, size: 32, offset: 32)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !88, file: !87, line: 29, baseType: !69, size: 32, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !88, file: !87, line: 30, baseType: !69, size: 32, offset: 96)
!94 = !DILocalVariable(name: "____fmt", scope: !95, file: !3, line: 46, type: !97)
!95 = distinct !DILexicalBlock(scope: !96, file: !3, line: 46, column: 17)
!96 = distinct !DILexicalBlock(scope: !54, file: !3, line: 42, column: 22)
!97 = !DICompositeType(tag: DW_TAG_array_type, baseType: !28, size: 120, elements: !98)
!98 = !{!99}
!99 = !DISubrange(count: 15)
!100 = !DILocalVariable(name: "key", scope: !96, file: !3, line: 49, type: !36)
!101 = !DILocalVariable(name: "value", scope: !96, file: !3, line: 50, type: !102)
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!103 = !DILocalVariable(name: "c_skey", scope: !96, file: !3, line: 51, type: !86)
!104 = !DILocation(line: 34, column: 40, scope: !54)
!105 = !DILocation(line: 36, column: 15, scope: !54)
!106 = !DILocation(line: 38, column: 9, scope: !54)
!107 = !DILocation(line: 38, column: 20, scope: !54)
!108 = !DILocation(line: 40, column: 22, scope: !54)
!109 = !{!110, !113, i64 64}
!110 = !{!"sk_msg_md", !111, i64 0, !111, i64 8, !113, i64 16, !113, i64 20, !113, i64 24, !111, i64 28, !111, i64 44, !113, i64 60, !113, i64 64, !113, i64 68}
!111 = !{!"omnipotent char", !112, i64 0}
!112 = !{!"Simple C/C++ TBAA"}
!113 = !{!"int", !111, i64 0}
!114 = !DILocation(line: 37, column: 15, scope: !54)
!115 = !DILocation(line: 42, column: 9, scope: !54)
!116 = !DILocation(line: 46, column: 17, scope: !95)
!117 = !DILocation(line: 46, column: 17, scope: !96)
!118 = !DILocation(line: 49, column: 21, scope: !96)
!119 = !{!113, !113, i64 0}
!120 = !DILocation(line: 51, column: 28, scope: !96)
!121 = !DILocation(line: 52, column: 60, scope: !96)
!122 = !DILocation(line: 52, column: 25, scope: !96)
!123 = !DILocation(line: 50, column: 29, scope: !96)
!124 = !DILocation(line: 53, column: 21, scope: !125)
!125 = distinct !DILexicalBlock(scope: !96, file: !3, line: 53, column: 20)
!126 = !DILocation(line: 53, column: 20, scope: !96)
!127 = !DILocation(line: 55, column: 26, scope: !96)
!128 = !{i64 0, i64 4, !119, i64 4, i64 4, !119, i64 8, i64 4, !119, i64 12, i64 4, !119}
!129 = !DILocation(line: 58, column: 39, scope: !96)
!130 = !DILocation(line: 58, column: 17, scope: !96)
!131 = !DILocation(line: 59, column: 17, scope: !96)
!132 = !DILocation(line: 64, column: 39, scope: !96)
!133 = !DILocation(line: 64, column: 17, scope: !96)
!134 = !DILocation(line: 65, column: 17, scope: !96)
!135 = !DILocation(line: 74, column: 1, scope: !54)
