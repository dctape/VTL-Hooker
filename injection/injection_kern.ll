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
%struct.vtlhdr = type { i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@DEBUGS_MAP = global %struct.bpf_elf_map { i32 2, i32 4, i32 1, i32 1, i32 0, i32 0, i32 2 }, section "maps", align 4, !dbg !0
@_tf_tc_egress.____fmt = private unnamed_addr constant [31 x i8] c"[START]: packet processing...\0A\00", align 1
@_tf_tc_egress.____fmt.1 = private unnamed_addr constant [30 x i8] c"No VTL packet, ip_proto = %d\0A\00", align 1
@_tf_tc_egress.____fmt.2 = private unnamed_addr constant [31 x i8] c"Error calling skb adjust room\0A\00", align 1
@_tf_tc_egress.____fmt.3 = private unnamed_addr constant [26 x i8] c"Storing VTL header value\0A\00", align 1
@_license = global [4 x i8] c"GPL\00", section "license", align 1, !dbg !49
@llvm.used = appending global [3 x i8*] [i8* bitcast (%struct.bpf_elf_map* @DEBUGS_MAP to i8*), i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.__sk_buff*)* @_tf_tc_egress to i8*)], section "llvm.metadata"

; Function Attrs: alwaysinline nounwind
define zeroext i1 @is_debug() local_unnamed_addr #0 !dbg !94 {
  %1 = alloca i32, align 4
  %2 = bitcast i32* %1 to i8*, !dbg !100
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %2) #4, !dbg !100
  call void @llvm.dbg.value(metadata i32 0, metadata !98, metadata !DIExpression()), !dbg !101
  store i32 0, i32* %1, align 4, !dbg !101, !tbaa !102
  %3 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_elf_map* @DEBUGS_MAP to i8*), i8* nonnull %2) #4, !dbg !106
  call void @llvm.dbg.value(metadata i8* %3, metadata !99, metadata !DIExpression()), !dbg !107
  %4 = icmp eq i8* %3, null, !dbg !108
  br i1 %4, label %8, label %5, !dbg !110

; <label>:5:                                      ; preds = %0
  %6 = load i8, i8* %3, align 1, !dbg !111, !tbaa !112, !range !114
  %7 = icmp ne i8 %6, 0, !dbg !111
  br label %8, !dbg !115

; <label>:8:                                      ; preds = %0, %5
  %9 = phi i1 [ %7, %5 ], [ false, %0 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %2) #4, !dbg !116
  ret i1 %9, !dbg !116
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind
define i32 @_tf_tc_egress(%struct.__sk_buff*) #3 section "tf_tc_egress" !dbg !117 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca [31 x i8], align 1
  %6 = alloca [30 x i8], align 1
  %7 = alloca [31 x i8], align 1
  %8 = alloca [26 x i8], align 1
  %9 = alloca %struct.vtlhdr, align 4
  call void @llvm.dbg.value(metadata %struct.__sk_buff* %0, metadata !209, metadata !DIExpression()), !dbg !251
  %10 = bitcast i32* %4 to i8*, !dbg !252
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %10) #4, !dbg !252
  call void @llvm.dbg.value(metadata i32 0, metadata !98, metadata !DIExpression()) #4, !dbg !254
  store i32 0, i32* %4, align 4, !dbg !254, !tbaa !102
  %11 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_elf_map* @DEBUGS_MAP to i8*), i8* nonnull %10) #4, !dbg !255
  call void @llvm.dbg.value(metadata i8* %11, metadata !99, metadata !DIExpression()) #4, !dbg !256
  %12 = icmp eq i8* %11, null, !dbg !257
  br i1 %12, label %13, label %14, !dbg !258

; <label>:13:                                     ; preds = %1
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %10) #4, !dbg !259
  br label %20, !dbg !260

; <label>:14:                                     ; preds = %1
  %15 = load i8, i8* %11, align 1, !dbg !261, !tbaa !112, !range !114
  %16 = icmp eq i8 %15, 0, !dbg !261
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %10) #4, !dbg !259
  br i1 %16, label %20, label %17, !dbg !260, !prof !262

; <label>:17:                                     ; preds = %14
  %18 = getelementptr inbounds [31 x i8], [31 x i8]* %5, i64 0, i64 0, !dbg !263
  call void @llvm.lifetime.start.p0i8(i64 31, i8* nonnull %18) #4, !dbg !263
  call void @llvm.dbg.declare(metadata [31 x i8]* %5, metadata !210, metadata !DIExpression()), !dbg !263
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %18, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @_tf_tc_egress.____fmt, i64 0, i64 0), i64 31, i32 1, i1 false), !dbg !263
  %19 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %18, i32 31) #4, !dbg !263
  call void @llvm.lifetime.end.p0i8(i64 31, i8* nonnull %18) #4, !dbg !264
  br label %20, !dbg !263

; <label>:20:                                     ; preds = %14, %13, %17
  %21 = getelementptr inbounds %struct.__sk_buff, %struct.__sk_buff* %0, i64 0, i32 15, !dbg !265
  %22 = load i32, i32* %21, align 4, !dbg !265, !tbaa !266
  %23 = zext i32 %22 to i64, !dbg !269
  call void @llvm.dbg.value(metadata i64 %23, metadata !217, metadata !DIExpression()), !dbg !270
  %24 = getelementptr inbounds %struct.__sk_buff, %struct.__sk_buff* %0, i64 0, i32 16, !dbg !271
  %25 = load i32, i32* %24, align 8, !dbg !271, !tbaa !272
  %26 = zext i32 %25 to i64, !dbg !273
  %27 = inttoptr i64 %26 to i8*, !dbg !274
  call void @llvm.dbg.value(metadata i8* %27, metadata !218, metadata !DIExpression()), !dbg !275
  %28 = inttoptr i64 %23 to %struct.ethhdr*, !dbg !276
  call void @llvm.dbg.value(metadata %struct.ethhdr* %28, metadata !219, metadata !DIExpression()), !dbg !277
  %29 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 1, i32 0, i64 0, !dbg !278
  %30 = icmp ugt i8* %29, %27, !dbg !280
  %31 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 1, i32 0, i64 20, !dbg !281
  %32 = icmp ugt i8* %31, %27, !dbg !283
  %33 = or i1 %30, %32, !dbg !284
  call void @llvm.dbg.value(metadata i8* %29, metadata !220, metadata !DIExpression()), !dbg !285
  br i1 %33, label %78, label %34, !dbg !284

; <label>:34:                                     ; preds = %20
  %35 = load i8, i8* %29, align 4, !dbg !286
  %36 = shl i8 %35, 2, !dbg !287
  %37 = and i8 %36, 60, !dbg !287
  %38 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %28, i64 1, i32 0, i64 9, !dbg !288
  %39 = load i8, i8* %38, align 1, !dbg !288, !tbaa !289
  %40 = icmp eq i8 %39, -3, !dbg !292
  br i1 %40, label %52, label %41, !dbg !293

; <label>:41:                                     ; preds = %34
  %42 = bitcast i32* %3 to i8*, !dbg !294
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %42) #4, !dbg !294
  call void @llvm.dbg.value(metadata i32 0, metadata !98, metadata !DIExpression()) #4, !dbg !296
  store i32 0, i32* %3, align 4, !dbg !296, !tbaa !102
  %43 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_elf_map* @DEBUGS_MAP to i8*), i8* nonnull %42) #4, !dbg !297
  call void @llvm.dbg.value(metadata i8* %43, metadata !99, metadata !DIExpression()) #4, !dbg !298
  %44 = icmp eq i8* %43, null, !dbg !299
  br i1 %44, label %45, label %46, !dbg !300

; <label>:45:                                     ; preds = %41
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %42) #4, !dbg !301
  br label %78, !dbg !302

; <label>:46:                                     ; preds = %41
  %47 = load i8, i8* %43, align 1, !dbg !303, !tbaa !112, !range !114
  %48 = icmp eq i8 %47, 0, !dbg !303
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %42) #4, !dbg !301
  br i1 %48, label %78, label %49, !dbg !302, !prof !262

; <label>:49:                                     ; preds = %46
  %50 = getelementptr inbounds [30 x i8], [30 x i8]* %6, i64 0, i64 0, !dbg !304
  call void @llvm.lifetime.start.p0i8(i64 30, i8* nonnull %50) #4, !dbg !304
  call void @llvm.dbg.declare(metadata [30 x i8]* %6, metadata !222, metadata !DIExpression()), !dbg !304
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %50, i8* getelementptr inbounds ([30 x i8], [30 x i8]* @_tf_tc_egress.____fmt.1, i64 0, i64 0), i64 30, i32 1, i1 false), !dbg !304
  %51 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %50, i32 30) #4, !dbg !304
  call void @llvm.lifetime.end.p0i8(i64 30, i8* nonnull %50) #4, !dbg !305
  br label %78, !dbg !304

; <label>:52:                                     ; preds = %34
  call void @llvm.dbg.value(metadata i32 4, metadata !231, metadata !DIExpression()), !dbg !306
  %53 = bitcast %struct.__sk_buff* %0 to i8*, !dbg !307
  %54 = call i32 inttoptr (i64 50 to i32 (i8*, i32, i32, i64)*)(i8* %53, i32 4, i32 0, i64 0) #4, !dbg !308
  call void @llvm.dbg.value(metadata i32 %54, metadata !232, metadata !DIExpression()), !dbg !309
  %55 = icmp eq i32 %54, 0, !dbg !310
  %56 = bitcast i32* %2 to i8*, !dbg !311
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %56) #4, !dbg !311
  call void @llvm.dbg.value(metadata i32 0, metadata !98, metadata !DIExpression()) #4, !dbg !313
  store i32 0, i32* %2, align 4, !dbg !313, !tbaa !102
  %57 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_elf_map* @DEBUGS_MAP to i8*), i8* nonnull %56) #4, !dbg !314
  call void @llvm.dbg.value(metadata i8* %57, metadata !99, metadata !DIExpression()) #4, !dbg !315
  %58 = icmp eq i8* %57, null, !dbg !316
  br i1 %58, label %62, label %59, !dbg !317

; <label>:59:                                     ; preds = %52
  %60 = load i8, i8* %57, align 1, !dbg !318, !tbaa !112, !range !114
  %61 = icmp ne i8 %60, 0, !dbg !318
  br label %62, !dbg !319

; <label>:62:                                     ; preds = %52, %59
  %63 = phi i1 [ %61, %59 ], [ false, %52 ]
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %56) #4, !dbg !320
  br i1 %55, label %68, label %64, !dbg !321

; <label>:64:                                     ; preds = %62
  br i1 %63, label %65, label %78, !dbg !322

; <label>:65:                                     ; preds = %64
  %66 = getelementptr inbounds [31 x i8], [31 x i8]* %7, i64 0, i64 0, !dbg !323
  call void @llvm.lifetime.start.p0i8(i64 31, i8* nonnull %66) #4, !dbg !323
  call void @llvm.dbg.declare(metadata [31 x i8]* %7, metadata !233, metadata !DIExpression()), !dbg !323
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %66, i8* getelementptr inbounds ([31 x i8], [31 x i8]* @_tf_tc_egress.____fmt.2, i64 0, i64 0), i64 31, i32 1, i1 false), !dbg !323
  %67 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %66, i32 31) #4, !dbg !323
  call void @llvm.lifetime.end.p0i8(i64 31, i8* nonnull %66) #4, !dbg !324
  br label %78, !dbg !323

; <label>:68:                                     ; preds = %62
  br i1 %63, label %69, label %72, !dbg !325

; <label>:69:                                     ; preds = %68
  %70 = getelementptr inbounds [26 x i8], [26 x i8]* %8, i64 0, i64 0, !dbg !326
  call void @llvm.lifetime.start.p0i8(i64 26, i8* nonnull %70) #4, !dbg !326
  call void @llvm.dbg.declare(metadata [26 x i8]* %8, metadata !239, metadata !DIExpression()), !dbg !326
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %70, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @_tf_tc_egress.____fmt.3, i64 0, i64 0), i64 26, i32 1, i1 false), !dbg !326
  %71 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %70, i32 26) #4, !dbg !326
  call void @llvm.lifetime.end.p0i8(i64 26, i8* nonnull %70) #4, !dbg !327
  br label %72, !dbg !326

; <label>:72:                                     ; preds = %69, %68
  %73 = bitcast %struct.vtlhdr* %9 to i8*, !dbg !328
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %73) #4, !dbg !328
  %74 = getelementptr inbounds %struct.vtlhdr, %struct.vtlhdr* %9, i64 0, i32 0, !dbg !329
  store i32 20, i32* %74, align 4, !dbg !329
  %75 = add nuw nsw i8 %37, 14, !dbg !330
  %76 = zext i8 %75 to i32, !dbg !331
  %77 = call i32 inttoptr (i64 9 to i32 (i8*, i32, i8*, i32, i32)*)(i8* %53, i32 %76, i8* nonnull %73, i32 4, i32 1) #4, !dbg !332
  call void @llvm.dbg.value(metadata i32 %77, metadata !232, metadata !DIExpression()), !dbg !309
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %73) #4, !dbg !333
  br label %78

; <label>:78:                                     ; preds = %46, %45, %72, %65, %64, %49, %20
  ret i32 0, !dbg !333
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #1

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { alwaysinline nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!90, !91, !92}
!llvm.ident = !{!93}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "DEBUGS_MAP", scope: !2, file: !3, line: 28, type: !80, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !48)
!3 = !DIFile(filename: "injection_kern.c", directory: "/home/ubuntu/hooker/injection")
!4 = !{}
!5 = !{!6, !8, !9, !10, !26, !46, !47}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !12, line: 159, size: 112, elements: !13)
!12 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "/home/ubuntu/hooker/injection")
!13 = !{!14, !19, !20}
!14 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !11, file: !12, line: 160, baseType: !15, size: 48)
!15 = !DICompositeType(tag: DW_TAG_array_type, baseType: !16, size: 48, elements: !17)
!16 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!17 = !{!18}
!18 = !DISubrange(count: 6)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !11, file: !12, line: 161, baseType: !15, size: 48, offset: 48)
!20 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !11, file: !12, line: 162, baseType: !21, size: 16, offset: 96)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !22, line: 25, baseType: !23)
!22 = !DIFile(filename: "/usr/include/linux/types.h", directory: "/home/ubuntu/hooker/injection")
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !24, line: 24, baseType: !25)
!24 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "/home/ubuntu/hooker/injection")
!25 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!26 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !27, size: 64)
!27 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !28, line: 86, size: 160, elements: !29)
!28 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "/home/ubuntu/hooker/injection")
!29 = !{!30, !32, !33, !34, !35, !36, !37, !38, !39, !41, !45}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !27, file: !28, line: 88, baseType: !31, size: 4, flags: DIFlagBitField, extraData: i64 0)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !24, line: 21, baseType: !16)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !27, file: !28, line: 89, baseType: !31, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!33 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !27, file: !28, line: 96, baseType: !31, size: 8, offset: 8)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !27, file: !28, line: 97, baseType: !21, size: 16, offset: 16)
!35 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !27, file: !28, line: 98, baseType: !21, size: 16, offset: 32)
!36 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !27, file: !28, line: 99, baseType: !21, size: 16, offset: 48)
!37 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !27, file: !28, line: 100, baseType: !31, size: 8, offset: 64)
!38 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !27, file: !28, line: 101, baseType: !31, size: 8, offset: 72)
!39 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !27, file: !28, line: 102, baseType: !40, size: 16, offset: 80)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !22, line: 31, baseType: !23)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !27, file: !28, line: 103, baseType: !42, size: 32, offset: 96)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !22, line: 27, baseType: !43)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !24, line: 27, baseType: !44)
!44 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!45 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !27, file: !28, line: 104, baseType: !42, size: 32, offset: 128)
!46 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!47 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!48 = !{!0, !49, !55, !61, !68, !75}
!49 = !DIGlobalVariableExpression(var: !50, expr: !DIExpression())
!50 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 135, type: !51, isLocal: false, isDefinition: true)
!51 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 32, elements: !53)
!52 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!53 = !{!54}
!54 = !DISubrange(count: 4)
!55 = !DIGlobalVariableExpression(var: !56, expr: !DIExpression())
!56 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !57, line: 20, type: !58, isLocal: true, isDefinition: true)
!57 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/ubuntu/hooker/injection")
!58 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!59 = !DISubroutineType(types: !60)
!60 = !{!8, !8, !8}
!61 = !DIGlobalVariableExpression(var: !62, expr: !DIExpression())
!62 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !57, line: 38, type: !63, isLocal: true, isDefinition: true)
!63 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !64, size: 64)
!64 = !DISubroutineType(types: !65)
!65 = !{!47, !66, !47, null}
!66 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !67, size: 64)
!67 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !52)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "bpf_skb_adjust_room", scope: !2, file: !57, line: 274, type: !70, isLocal: true, isDefinition: true)
!70 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !71, size: 64)
!71 = !DISubroutineType(types: !72)
!72 = !{!47, !8, !73, !43, !74}
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "__s32", file: !24, line: 26, baseType: !47)
!74 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression())
!76 = distinct !DIGlobalVariable(name: "bpf_skb_store_bytes", scope: !2, file: !57, line: 233, type: !77, isLocal: true, isDefinition: true)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!78 = !DISubroutineType(types: !79)
!79 = !{!47, !8, !47, !8, !47, !47}
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_elf_map", file: !81, line: 18, size: 224, elements: !82)
!81 = !DIFile(filename: "../headers/tc_util.h", directory: "/home/ubuntu/hooker/injection")
!82 = !{!83, !84, !85, !86, !87, !88, !89}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !80, file: !81, line: 23, baseType: !43, size: 32)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "size_key", scope: !80, file: !81, line: 24, baseType: !43, size: 32, offset: 32)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "size_value", scope: !80, file: !81, line: 25, baseType: !43, size: 32, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "max_elem", scope: !80, file: !81, line: 26, baseType: !43, size: 32, offset: 96)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "flags", scope: !80, file: !81, line: 30, baseType: !43, size: 32, offset: 128)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !80, file: !81, line: 31, baseType: !43, size: 32, offset: 160)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "pinning", scope: !80, file: !81, line: 40, baseType: !43, size: 32, offset: 192)
!90 = !{i32 2, !"Dwarf Version", i32 4}
!91 = !{i32 2, !"Debug Info Version", i32 3}
!92 = !{i32 1, !"wchar_size", i32 4}
!93 = !{!"clang version 6.0.0-1ubuntu2 (tags/RELEASE_600/final)"}
!94 = distinct !DISubprogram(name: "is_debug", scope: !3, file: !3, line: 38, type: !95, isLocal: false, isDefinition: true, scopeLine: 38, isOptimized: true, unit: !2, variables: !97)
!95 = !DISubroutineType(types: !96)
!96 = !{!7}
!97 = !{!98, !99}
!98 = !DILocalVariable(name: "index", scope: !94, file: !3, line: 40, type: !47)
!99 = !DILocalVariable(name: "value", scope: !94, file: !3, line: 41, type: !6)
!100 = !DILocation(line: 40, column: 5, scope: !94)
!101 = !DILocation(line: 40, column: 9, scope: !94)
!102 = !{!103, !103, i64 0}
!103 = !{!"int", !104, i64 0}
!104 = !{!"omnipotent char", !105, i64 0}
!105 = !{!"Simple C/C++ TBAA"}
!106 = !DILocation(line: 41, column: 27, scope: !94)
!107 = !DILocation(line: 41, column: 11, scope: !94)
!108 = !DILocation(line: 42, column: 9, scope: !109)
!109 = distinct !DILexicalBlock(scope: !94, file: !3, line: 42, column: 8)
!110 = !DILocation(line: 42, column: 8, scope: !94)
!111 = !DILocation(line: 46, column: 12, scope: !94)
!112 = !{!113, !113, i64 0}
!113 = !{!"_Bool", !104, i64 0}
!114 = !{i8 0, i8 2}
!115 = !DILocation(line: 46, column: 5, scope: !94)
!116 = !DILocation(line: 47, column: 1, scope: !94)
!117 = distinct !DISubprogram(name: "_tf_tc_egress", scope: !3, file: !3, line: 78, type: !118, isLocal: false, isDefinition: true, scopeLine: 79, flags: DIFlagPrototyped, isOptimized: true, unit: !2, variables: !208)
!118 = !DISubroutineType(types: !119)
!119 = !{!47, !120}
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !121, size: 64)
!121 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__sk_buff", file: !122, line: 2677, size: 1408, elements: !123)
!122 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/ubuntu/hooker/injection")
!123 = !{!124, !125, !126, !127, !128, !129, !130, !131, !132, !133, !134, !135, !136, !140, !141, !142, !143, !144, !145, !146, !147, !148, !150, !151, !152, !153, !154, !184, !186, !187, !188}
!124 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !121, file: !122, line: 2678, baseType: !43, size: 32)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "pkt_type", scope: !121, file: !122, line: 2679, baseType: !43, size: 32, offset: 32)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !121, file: !122, line: 2680, baseType: !43, size: 32, offset: 64)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "queue_mapping", scope: !121, file: !122, line: 2681, baseType: !43, size: 32, offset: 96)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !121, file: !122, line: 2682, baseType: !43, size: 32, offset: 128)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_present", scope: !121, file: !122, line: 2683, baseType: !43, size: 32, offset: 160)
!130 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_tci", scope: !121, file: !122, line: 2684, baseType: !43, size: 32, offset: 192)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "vlan_proto", scope: !121, file: !122, line: 2685, baseType: !43, size: 32, offset: 224)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !121, file: !122, line: 2686, baseType: !43, size: 32, offset: 256)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !121, file: !122, line: 2687, baseType: !43, size: 32, offset: 288)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !121, file: !122, line: 2688, baseType: !43, size: 32, offset: 320)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "tc_index", scope: !121, file: !122, line: 2689, baseType: !43, size: 32, offset: 352)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "cb", scope: !121, file: !122, line: 2690, baseType: !137, size: 160, offset: 384)
!137 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 160, elements: !138)
!138 = !{!139}
!139 = !DISubrange(count: 5)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "hash", scope: !121, file: !122, line: 2691, baseType: !43, size: 32, offset: 544)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "tc_classid", scope: !121, file: !122, line: 2692, baseType: !43, size: 32, offset: 576)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !121, file: !122, line: 2693, baseType: !43, size: 32, offset: 608)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !121, file: !122, line: 2694, baseType: !43, size: 32, offset: 640)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "napi_id", scope: !121, file: !122, line: 2695, baseType: !43, size: 32, offset: 672)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !121, file: !122, line: 2698, baseType: !43, size: 32, offset: 704)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip4", scope: !121, file: !122, line: 2699, baseType: !43, size: 32, offset: 736)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip4", scope: !121, file: !122, line: 2700, baseType: !43, size: 32, offset: 768)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "remote_ip6", scope: !121, file: !122, line: 2701, baseType: !149, size: 128, offset: 800)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !43, size: 128, elements: !53)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "local_ip6", scope: !121, file: !122, line: 2702, baseType: !149, size: 128, offset: 928)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "remote_port", scope: !121, file: !122, line: 2703, baseType: !43, size: 32, offset: 1056)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "local_port", scope: !121, file: !122, line: 2704, baseType: !43, size: 32, offset: 1088)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !121, file: !122, line: 2707, baseType: !43, size: 32, offset: 1120)
!154 = !DIDerivedType(tag: DW_TAG_member, scope: !121, file: !122, line: 2708, baseType: !155, size: 64, align: 64, offset: 1152)
!155 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !121, file: !122, line: 2708, size: 64, align: 64, elements: !156)
!156 = !{!157}
!157 = !DIDerivedType(tag: DW_TAG_member, name: "flow_keys", scope: !155, file: !122, line: 2708, baseType: !158, size: 64)
!158 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !159, size: 64)
!159 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_flow_keys", file: !122, line: 3237, size: 384, elements: !160)
!160 = !{!161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171}
!161 = !DIDerivedType(tag: DW_TAG_member, name: "nhoff", scope: !159, file: !122, line: 3238, baseType: !23, size: 16)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "thoff", scope: !159, file: !122, line: 3239, baseType: !23, size: 16, offset: 16)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "addr_proto", scope: !159, file: !122, line: 3240, baseType: !23, size: 16, offset: 32)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "is_frag", scope: !159, file: !122, line: 3241, baseType: !31, size: 8, offset: 48)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "is_first_frag", scope: !159, file: !122, line: 3242, baseType: !31, size: 8, offset: 56)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "is_encap", scope: !159, file: !122, line: 3243, baseType: !31, size: 8, offset: 64)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "ip_proto", scope: !159, file: !122, line: 3244, baseType: !31, size: 8, offset: 72)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "n_proto", scope: !159, file: !122, line: 3245, baseType: !21, size: 16, offset: 80)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !159, file: !122, line: 3246, baseType: !21, size: 16, offset: 96)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !159, file: !122, line: 3247, baseType: !21, size: 16, offset: 112)
!171 = !DIDerivedType(tag: DW_TAG_member, scope: !159, file: !122, line: 3248, baseType: !172, size: 256, offset: 128)
!172 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !159, file: !122, line: 3248, size: 256, elements: !173)
!173 = !{!174, !179}
!174 = !DIDerivedType(tag: DW_TAG_member, scope: !172, file: !122, line: 3249, baseType: !175, size: 64)
!175 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !172, file: !122, line: 3249, size: 64, elements: !176)
!176 = !{!177, !178}
!177 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !175, file: !122, line: 3250, baseType: !42, size: 32)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !175, file: !122, line: 3251, baseType: !42, size: 32, offset: 32)
!179 = !DIDerivedType(tag: DW_TAG_member, scope: !172, file: !122, line: 3253, baseType: !180, size: 256)
!180 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !172, file: !122, line: 3253, size: 256, elements: !181)
!181 = !{!182, !183}
!182 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !180, file: !122, line: 3254, baseType: !149, size: 128)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !180, file: !122, line: 3255, baseType: !149, size: 128, offset: 128)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "tstamp", scope: !121, file: !122, line: 2709, baseType: !185, size: 64, offset: 1216)
!185 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !24, line: 31, baseType: !74)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "wire_len", scope: !121, file: !122, line: 2710, baseType: !43, size: 32, offset: 1280)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "gso_segs", scope: !121, file: !122, line: 2711, baseType: !43, size: 32, offset: 1312)
!188 = !DIDerivedType(tag: DW_TAG_member, scope: !121, file: !122, line: 2712, baseType: !189, size: 64, align: 64, offset: 1344)
!189 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !121, file: !122, line: 2712, size: 64, align: 64, elements: !190)
!190 = !{!191}
!191 = !DIDerivedType(tag: DW_TAG_member, name: "sk", scope: !189, file: !122, line: 2712, baseType: !192, size: 64)
!192 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !193, size: 64)
!193 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_sock", file: !122, line: 2765, size: 608, elements: !194)
!194 = !{!195, !196, !197, !198, !199, !200, !201, !202, !203, !204, !205, !206, !207}
!195 = !DIDerivedType(tag: DW_TAG_member, name: "bound_dev_if", scope: !193, file: !122, line: 2766, baseType: !43, size: 32)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !193, file: !122, line: 2767, baseType: !43, size: 32, offset: 32)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !193, file: !122, line: 2768, baseType: !43, size: 32, offset: 64)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !193, file: !122, line: 2769, baseType: !43, size: 32, offset: 96)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "mark", scope: !193, file: !122, line: 2770, baseType: !43, size: 32, offset: 128)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !193, file: !122, line: 2771, baseType: !43, size: 32, offset: 160)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip4", scope: !193, file: !122, line: 2773, baseType: !43, size: 32, offset: 192)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "src_ip6", scope: !193, file: !122, line: 2774, baseType: !149, size: 128, offset: 224)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "src_port", scope: !193, file: !122, line: 2775, baseType: !43, size: 32, offset: 352)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "dst_port", scope: !193, file: !122, line: 2776, baseType: !43, size: 32, offset: 384)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip4", scope: !193, file: !122, line: 2777, baseType: !43, size: 32, offset: 416)
!206 = !DIDerivedType(tag: DW_TAG_member, name: "dst_ip6", scope: !193, file: !122, line: 2778, baseType: !149, size: 128, offset: 448)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "state", scope: !193, file: !122, line: 2779, baseType: !43, size: 32, offset: 576)
!208 = !{!209, !210, !217, !218, !219, !220, !221, !222, !231, !232, !233, !239, !246, !250}
!209 = !DILocalVariable(name: "skb", arg: 1, scope: !117, file: !3, line: 78, type: !120)
!210 = !DILocalVariable(name: "____fmt", scope: !211, file: !3, line: 81, type: !214)
!211 = distinct !DILexicalBlock(scope: !212, file: !3, line: 81, column: 9)
!212 = distinct !DILexicalBlock(scope: !213, file: !3, line: 81, column: 9)
!213 = distinct !DILexicalBlock(scope: !117, file: !3, line: 81, column: 9)
!214 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 248, elements: !215)
!215 = !{!216}
!216 = !DISubrange(count: 31)
!217 = !DILocalVariable(name: "data", scope: !117, file: !3, line: 85, type: !8)
!218 = !DILocalVariable(name: "data_end", scope: !117, file: !3, line: 86, type: !8)
!219 = !DILocalVariable(name: "eth", scope: !117, file: !3, line: 88, type: !10)
!220 = !DILocalVariable(name: "iph", scope: !117, file: !3, line: 97, type: !26)
!221 = !DILocalVariable(name: "iph_len", scope: !117, file: !3, line: 101, type: !44)
!222 = !DILocalVariable(name: "____fmt", scope: !223, file: !3, line: 107, type: !228)
!223 = distinct !DILexicalBlock(scope: !224, file: !3, line: 107, column: 17)
!224 = distinct !DILexicalBlock(scope: !225, file: !3, line: 107, column: 17)
!225 = distinct !DILexicalBlock(scope: !226, file: !3, line: 107, column: 17)
!226 = distinct !DILexicalBlock(scope: !227, file: !3, line: 105, column: 41)
!227 = distinct !DILexicalBlock(scope: !117, file: !3, line: 105, column: 12)
!228 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 240, elements: !229)
!229 = !{!230}
!230 = !DISubrange(count: 30)
!231 = !DILocalVariable(name: "padlen", scope: !117, file: !3, line: 112, type: !47)
!232 = !DILocalVariable(name: "ret", scope: !117, file: !3, line: 115, type: !47)
!233 = !DILocalVariable(name: "____fmt", scope: !234, file: !3, line: 117, type: !214)
!234 = distinct !DILexicalBlock(scope: !235, file: !3, line: 117, column: 17)
!235 = distinct !DILexicalBlock(scope: !236, file: !3, line: 117, column: 17)
!236 = distinct !DILexicalBlock(scope: !237, file: !3, line: 117, column: 17)
!237 = distinct !DILexicalBlock(scope: !238, file: !3, line: 116, column: 17)
!238 = distinct !DILexicalBlock(scope: !117, file: !3, line: 116, column: 12)
!239 = !DILocalVariable(name: "____fmt", scope: !240, file: !3, line: 121, type: !243)
!240 = distinct !DILexicalBlock(scope: !241, file: !3, line: 121, column: 9)
!241 = distinct !DILexicalBlock(scope: !242, file: !3, line: 121, column: 9)
!242 = distinct !DILexicalBlock(scope: !117, file: !3, line: 121, column: 9)
!243 = !DICompositeType(tag: DW_TAG_array_type, baseType: !52, size: 208, elements: !244)
!244 = !{!245}
!245 = !DISubrange(count: 26)
!246 = !DILocalVariable(name: "vtlh", scope: !117, file: !3, line: 123, type: !247)
!247 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vtlhdr", file: !3, line: 13, size: 32, elements: !248)
!248 = !{!249}
!249 = !DIDerivedType(tag: DW_TAG_member, name: "ctrl_sum", scope: !247, file: !3, line: 15, baseType: !47, size: 32)
!250 = !DILocalVariable(name: "offset", scope: !117, file: !3, line: 128, type: !46)
!251 = !DILocation(line: 78, column: 37, scope: !117)
!252 = !DILocation(line: 40, column: 5, scope: !94, inlinedAt: !253)
!253 = distinct !DILocation(line: 81, column: 9, scope: !212)
!254 = !DILocation(line: 40, column: 9, scope: !94, inlinedAt: !253)
!255 = !DILocation(line: 41, column: 27, scope: !94, inlinedAt: !253)
!256 = !DILocation(line: 41, column: 11, scope: !94, inlinedAt: !253)
!257 = !DILocation(line: 42, column: 9, scope: !109, inlinedAt: !253)
!258 = !DILocation(line: 42, column: 8, scope: !94, inlinedAt: !253)
!259 = !DILocation(line: 47, column: 1, scope: !94, inlinedAt: !253)
!260 = !DILocation(line: 81, column: 9, scope: !213)
!261 = !DILocation(line: 46, column: 12, scope: !94, inlinedAt: !253)
!262 = !{!"branch_weights", i32 2000, i32 1}
!263 = !DILocation(line: 81, column: 9, scope: !211)
!264 = !DILocation(line: 81, column: 9, scope: !212)
!265 = !DILocation(line: 85, column: 41, scope: !117)
!266 = !{!267, !103, i64 76}
!267 = !{!"__sk_buff", !103, i64 0, !103, i64 4, !103, i64 8, !103, i64 12, !103, i64 16, !103, i64 20, !103, i64 24, !103, i64 28, !103, i64 32, !103, i64 36, !103, i64 40, !103, i64 44, !104, i64 48, !103, i64 68, !103, i64 72, !103, i64 76, !103, i64 80, !103, i64 84, !103, i64 88, !103, i64 92, !103, i64 96, !104, i64 100, !104, i64 116, !103, i64 132, !103, i64 136, !103, i64 140, !104, i64 144, !268, i64 152, !103, i64 160, !103, i64 164, !104, i64 168}
!268 = !{!"long long", !104, i64 0}
!269 = !DILocation(line: 85, column: 30, scope: !117)
!270 = !DILocation(line: 85, column: 15, scope: !117)
!271 = !DILocation(line: 86, column: 45, scope: !117)
!272 = !{!267, !103, i64 80}
!273 = !DILocation(line: 86, column: 34, scope: !117)
!274 = !DILocation(line: 86, column: 26, scope: !117)
!275 = !DILocation(line: 86, column: 15, scope: !117)
!276 = !DILocation(line: 88, column: 30, scope: !117)
!277 = !DILocation(line: 88, column: 24, scope: !117)
!278 = !DILocation(line: 93, column: 12, scope: !279)
!279 = distinct !DILexicalBlock(scope: !117, file: !3, line: 93, column: 12)
!280 = !DILocation(line: 93, column: 30, scope: !279)
!281 = !DILocation(line: 98, column: 25, scope: !282)
!282 = distinct !DILexicalBlock(scope: !117, file: !3, line: 98, column: 12)
!283 = !DILocation(line: 98, column: 30, scope: !282)
!284 = !DILocation(line: 93, column: 12, scope: !117)
!285 = !DILocation(line: 97, column: 23, scope: !117)
!286 = !DILocation(line: 101, column: 37, scope: !117)
!287 = !DILocation(line: 101, column: 41, scope: !117)
!288 = !DILocation(line: 105, column: 17, scope: !227)
!289 = !{!290, !104, i64 9}
!290 = !{!"iphdr", !104, i64 0, !104, i64 0, !104, i64 1, !291, i64 2, !291, i64 4, !291, i64 6, !104, i64 8, !104, i64 9, !291, i64 10, !103, i64 12, !103, i64 16}
!291 = !{!"short", !104, i64 0}
!292 = !DILocation(line: 105, column: 26, scope: !227)
!293 = !DILocation(line: 105, column: 12, scope: !117)
!294 = !DILocation(line: 40, column: 5, scope: !94, inlinedAt: !295)
!295 = distinct !DILocation(line: 107, column: 17, scope: !224)
!296 = !DILocation(line: 40, column: 9, scope: !94, inlinedAt: !295)
!297 = !DILocation(line: 41, column: 27, scope: !94, inlinedAt: !295)
!298 = !DILocation(line: 41, column: 11, scope: !94, inlinedAt: !295)
!299 = !DILocation(line: 42, column: 9, scope: !109, inlinedAt: !295)
!300 = !DILocation(line: 42, column: 8, scope: !94, inlinedAt: !295)
!301 = !DILocation(line: 47, column: 1, scope: !94, inlinedAt: !295)
!302 = !DILocation(line: 107, column: 17, scope: !225)
!303 = !DILocation(line: 46, column: 12, scope: !94, inlinedAt: !295)
!304 = !DILocation(line: 107, column: 17, scope: !223)
!305 = !DILocation(line: 107, column: 17, scope: !224)
!306 = !DILocation(line: 112, column: 13, scope: !117)
!307 = !DILocation(line: 115, column: 39, scope: !117)
!308 = !DILocation(line: 115, column: 19, scope: !117)
!309 = !DILocation(line: 115, column: 13, scope: !117)
!310 = !DILocation(line: 116, column: 12, scope: !238)
!311 = !DILocation(line: 40, column: 5, scope: !94, inlinedAt: !312)
!312 = distinct !DILocation(line: 0, scope: !241)
!313 = !DILocation(line: 40, column: 9, scope: !94, inlinedAt: !312)
!314 = !DILocation(line: 41, column: 27, scope: !94, inlinedAt: !312)
!315 = !DILocation(line: 41, column: 11, scope: !94, inlinedAt: !312)
!316 = !DILocation(line: 42, column: 9, scope: !109, inlinedAt: !312)
!317 = !DILocation(line: 42, column: 8, scope: !94, inlinedAt: !312)
!318 = !DILocation(line: 46, column: 12, scope: !94, inlinedAt: !312)
!319 = !DILocation(line: 46, column: 5, scope: !94, inlinedAt: !312)
!320 = !DILocation(line: 47, column: 1, scope: !94, inlinedAt: !312)
!321 = !DILocation(line: 116, column: 12, scope: !117)
!322 = !DILocation(line: 117, column: 17, scope: !236)
!323 = !DILocation(line: 117, column: 17, scope: !234)
!324 = !DILocation(line: 117, column: 17, scope: !235)
!325 = !DILocation(line: 121, column: 9, scope: !242)
!326 = !DILocation(line: 121, column: 9, scope: !240)
!327 = !DILocation(line: 121, column: 9, scope: !241)
!328 = !DILocation(line: 123, column: 9, scope: !117)
!329 = !DILocation(line: 123, column: 23, scope: !117)
!330 = !DILocation(line: 128, column: 54, scope: !117)
!331 = !DILocation(line: 129, column: 40, scope: !117)
!332 = !DILocation(line: 129, column: 15, scope: !117)
!333 = !DILocation(line: 133, column: 1, scope: !117)
