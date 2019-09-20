; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.hdr_cursor = type { i8* }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.vlan_hdr = type { i16, i16 }
%struct.ipv6hdr = type { i8, [3 x i8], i16, i8, i8, %struct.in6_addr, %struct.in6_addr }
%struct.in6_addr = type { %union.anon }
%union.anon = type { [4 x i32] }
%struct.icmp6hdr = type { i8, i8, i16, %union.anon.0 }
%union.anon.0 = type { [1 x i32] }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }
%struct.icmphdr = type { i8, i8, i16, %union.anon.1 }
%union.anon.1 = type { i32 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !50
@llvm.used = appending global [5 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_parser_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_port_rewrite_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_vlan_swap_func to i8*)], section "llvm.metadata"

; Function Attrs: norecurse nounwind readnone
define dso_local i32 @xdp_port_rewrite_func(%struct.xdp_md* nocapture readnone) #0 section "xdp_port_rewrite" !dbg !76 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !90, metadata !DIExpression()), !dbg !91
  ret i32 2, !dbg !92
}

; Function Attrs: nounwind readonly
define dso_local i32 @xdp_vlan_swap_func(%struct.xdp_md* nocapture readonly) #1 section "xdp_vlan_swap" !dbg !93 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !95, metadata !DIExpression()), !dbg !118
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !98, metadata !DIExpression(DW_OP_deref)), !dbg !119
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !120, metadata !DIExpression()), !dbg !139
  call void @llvm.dbg.value(metadata i32 14, metadata !130, metadata !DIExpression()), !dbg !141
  ret i32 2, !dbg !142
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
define dso_local i32 @xdp_parser_func(%struct.xdp_md* nocapture readonly) #3 section "xdp_packet_parser" !dbg !146 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !148, metadata !DIExpression()), !dbg !277
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !278
  %4 = load i32, i32* %3, align 4, !dbg !278, !tbaa !279
  %5 = zext i32 %4 to i64, !dbg !284
  %6 = inttoptr i64 %5 to i8*, !dbg !285
  call void @llvm.dbg.value(metadata i8* %6, metadata !149, metadata !DIExpression()), !dbg !286
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !287
  %8 = load i32, i32* %7, align 4, !dbg !287, !tbaa !288
  %9 = zext i32 %8 to i64, !dbg !289
  %10 = inttoptr i64 %9 to i8*, !dbg !290
  call void @llvm.dbg.value(metadata i8* %10, metadata !150, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.value(metadata i32 2, metadata !151, metadata !DIExpression()), !dbg !292
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !152, metadata !DIExpression(DW_OP_deref)), !dbg !293
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !154, metadata !DIExpression(DW_OP_deref)), !dbg !294
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !120, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.value(metadata i8* %6, metadata !127, metadata !DIExpression()), !dbg !297
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !128, metadata !DIExpression()), !dbg !298
  call void @llvm.dbg.value(metadata i32 14, metadata !130, metadata !DIExpression()), !dbg !299
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !300
  %12 = icmp ugt i8* %11, %6, !dbg !302
  br i1 %12, label %107, label %13, !dbg !303

; <label>:13:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !129, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.value(metadata i8* %11, metadata !131, metadata !DIExpression()), !dbg !305
  %14 = getelementptr inbounds i8, i8* %10, i64 12, !dbg !306
  %15 = bitcast i8* %14 to i16*, !dbg !306
  call void @llvm.dbg.value(metadata i16* %15, metadata !137, metadata !DIExpression(DW_OP_deref)), !dbg !307
  call void @llvm.dbg.value(metadata i32 0, metadata !138, metadata !DIExpression()), !dbg !308
  %16 = load i16, i16* %15, align 1, !dbg !309, !tbaa !310
  call void @llvm.dbg.value(metadata i16 %16, metadata !137, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata i8* %11, metadata !131, metadata !DIExpression()), !dbg !305
  %17 = inttoptr i64 %5 to %struct.vlan_hdr*
  call void @llvm.dbg.value(metadata i32 0, metadata !138, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.value(metadata i8* %11, metadata !131, metadata !DIExpression()), !dbg !305
  switch i16 %16, label %50 [
    i16 -22392, label %18
    i16 129, label %18
  ], !dbg !312

; <label>:18:                                     ; preds = %13, %13
  %19 = getelementptr inbounds i8, i8* %10, i64 18, !dbg !313
  %20 = bitcast i8* %19 to %struct.vlan_hdr*, !dbg !313
  %21 = icmp ugt %struct.vlan_hdr* %20, %17, !dbg !315
  br i1 %21, label %50, label %22, !dbg !316

; <label>:22:                                     ; preds = %18
  %23 = getelementptr inbounds i8, i8* %10, i64 16, !dbg !317
  %24 = bitcast i8* %23 to i16*, !dbg !317
  call void @llvm.dbg.value(metadata i16* %24, metadata !137, metadata !DIExpression(DW_OP_deref)), !dbg !307
  %25 = load i16, i16* %24, align 1, !dbg !309, !tbaa !310
  call void @llvm.dbg.value(metadata i32 1, metadata !138, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.value(metadata i16 %25, metadata !137, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %20, metadata !131, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata i32 1, metadata !138, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %20, metadata !131, metadata !DIExpression()), !dbg !305
  switch i16 %25, label %50 [
    i16 -22392, label %26
    i16 129, label %26
  ], !dbg !312

; <label>:26:                                     ; preds = %22, %22
  %27 = getelementptr inbounds i8, i8* %10, i64 22, !dbg !313
  %28 = bitcast i8* %27 to %struct.vlan_hdr*, !dbg !313
  %29 = icmp ugt %struct.vlan_hdr* %28, %17, !dbg !315
  br i1 %29, label %50, label %30, !dbg !316

; <label>:30:                                     ; preds = %26
  %31 = getelementptr inbounds i8, i8* %10, i64 20, !dbg !317
  %32 = bitcast i8* %31 to i16*, !dbg !317
  call void @llvm.dbg.value(metadata i16* %32, metadata !137, metadata !DIExpression(DW_OP_deref)), !dbg !307
  %33 = load i16, i16* %32, align 1, !dbg !309, !tbaa !310
  call void @llvm.dbg.value(metadata i32 2, metadata !138, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.value(metadata i16 %33, metadata !137, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %28, metadata !131, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata i32 2, metadata !138, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %28, metadata !131, metadata !DIExpression()), !dbg !305
  switch i16 %33, label %50 [
    i16 -22392, label %34
    i16 129, label %34
  ], !dbg !312

; <label>:34:                                     ; preds = %30, %30
  %35 = getelementptr inbounds i8, i8* %10, i64 26, !dbg !313
  %36 = bitcast i8* %35 to %struct.vlan_hdr*, !dbg !313
  %37 = icmp ugt %struct.vlan_hdr* %36, %17, !dbg !315
  br i1 %37, label %50, label %38, !dbg !316

; <label>:38:                                     ; preds = %34
  %39 = getelementptr inbounds i8, i8* %10, i64 24, !dbg !317
  %40 = bitcast i8* %39 to i16*, !dbg !317
  call void @llvm.dbg.value(metadata i16* %40, metadata !137, metadata !DIExpression(DW_OP_deref)), !dbg !307
  %41 = load i16, i16* %40, align 1, !dbg !309, !tbaa !310
  call void @llvm.dbg.value(metadata i32 3, metadata !138, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.value(metadata i16 %41, metadata !137, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %36, metadata !131, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata i32 3, metadata !138, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %36, metadata !131, metadata !DIExpression()), !dbg !305
  switch i16 %41, label %50 [
    i16 -22392, label %42
    i16 129, label %42
  ], !dbg !312

; <label>:42:                                     ; preds = %38, %38
  %43 = getelementptr inbounds i8, i8* %10, i64 30, !dbg !313
  %44 = bitcast i8* %43 to %struct.vlan_hdr*, !dbg !313
  %45 = icmp ugt %struct.vlan_hdr* %44, %17, !dbg !315
  br i1 %45, label %50, label %46, !dbg !316

; <label>:46:                                     ; preds = %42
  %47 = getelementptr inbounds i8, i8* %10, i64 28, !dbg !317
  %48 = bitcast i8* %47 to i16*, !dbg !317
  call void @llvm.dbg.value(metadata i16* %48, metadata !137, metadata !DIExpression(DW_OP_deref)), !dbg !307
  %49 = load i16, i16* %48, align 1, !dbg !309, !tbaa !310
  call void @llvm.dbg.value(metadata i32 4, metadata !138, metadata !DIExpression()), !dbg !308
  call void @llvm.dbg.value(metadata i16 %49, metadata !137, metadata !DIExpression()), !dbg !307
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %44, metadata !131, metadata !DIExpression()), !dbg !305
  br label %50

; <label>:50:                                     ; preds = %13, %18, %22, %26, %30, %34, %38, %42, %46
  %51 = phi i8* [ %11, %13 ], [ %11, %18 ], [ %19, %22 ], [ %19, %26 ], [ %27, %30 ], [ %27, %34 ], [ %35, %38 ], [ %35, %42 ], [ %43, %46 ], !dbg !309
  %52 = phi i16 [ %16, %13 ], [ %16, %18 ], [ %25, %22 ], [ %25, %26 ], [ %33, %30 ], [ %33, %34 ], [ %41, %38 ], [ %41, %42 ], [ %49, %46 ], !dbg !309
  call void @llvm.dbg.value(metadata i16 %52, metadata !153, metadata !DIExpression(DW_OP_dup, DW_OP_constu, 15, DW_OP_shr, DW_OP_lit0, DW_OP_not, DW_OP_mul, DW_OP_or, DW_OP_stack_value)), !dbg !318
  switch i16 %52, label %107 [
    i16 -8826, label %53
    i16 8, label %77
  ], !dbg !319

; <label>:53:                                     ; preds = %50
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !152, metadata !DIExpression(DW_OP_deref)), !dbg !293
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !320, metadata !DIExpression()), !dbg !329
  call void @llvm.dbg.value(metadata i8* %6, metadata !326, metadata !DIExpression()), !dbg !331
  %54 = getelementptr inbounds i8, i8* %51, i64 40, !dbg !332
  %55 = bitcast i8* %54 to %struct.ipv6hdr*, !dbg !332
  %56 = inttoptr i64 %5 to %struct.ipv6hdr*, !dbg !334
  %57 = icmp ugt %struct.ipv6hdr* %55, %56, !dbg !335
  br i1 %57, label %107, label %58, !dbg !336

; <label>:58:                                     ; preds = %53
  call void @llvm.dbg.value(metadata i8* %51, metadata !328, metadata !DIExpression()), !dbg !337
  %59 = getelementptr inbounds i8, i8* %51, i64 6, !dbg !338
  %60 = load i8, i8* %59, align 2, !dbg !338, !tbaa !339
  %61 = icmp eq i8 %60, 58, !dbg !342
  br i1 %61, label %62, label %107, !dbg !344

; <label>:62:                                     ; preds = %58
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !152, metadata !DIExpression(DW_OP_deref)), !dbg !293
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !345, metadata !DIExpression()), !dbg !354
  call void @llvm.dbg.value(metadata i8* %6, metadata !351, metadata !DIExpression()), !dbg !356
  call void @llvm.dbg.value(metadata i8* %54, metadata !353, metadata !DIExpression()), !dbg !357
  %63 = getelementptr inbounds i8, i8* %51, i64 48, !dbg !358
  %64 = bitcast i8* %63 to %struct.icmp6hdr*, !dbg !358
  %65 = inttoptr i64 %5 to %struct.icmp6hdr*, !dbg !360
  %66 = icmp ugt %struct.icmp6hdr* %64, %65, !dbg !361
  br i1 %66, label %107, label %67, !dbg !362

; <label>:67:                                     ; preds = %62
  %68 = load i8, i8* %54, align 4, !dbg !363, !tbaa !364
  %69 = icmp eq i8 %68, -128, !dbg !366
  br i1 %69, label %70, label %107, !dbg !368

; <label>:70:                                     ; preds = %67
  call void @llvm.dbg.value(metadata i8* %54, metadata !191, metadata !DIExpression()), !dbg !369
  %71 = getelementptr inbounds i8, i8* %51, i64 46, !dbg !370
  %72 = bitcast i8* %71 to i16*, !dbg !370
  %73 = load i16, i16* %72, align 2, !dbg !370, !tbaa !372
  %74 = and i16 %73, 256, !dbg !373
  %75 = icmp eq i16 %74, 0, !dbg !374
  %76 = select i1 %75, i32 1, i32 2, !dbg !375
  br label %107, !dbg !375

; <label>:77:                                     ; preds = %50
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !152, metadata !DIExpression(DW_OP_deref)), !dbg !293
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !236, metadata !DIExpression(DW_OP_deref)), !dbg !376
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !377, metadata !DIExpression()), !dbg !387
  call void @llvm.dbg.value(metadata i8* %6, metadata !383, metadata !DIExpression()), !dbg !389
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !384, metadata !DIExpression()), !dbg !390
  call void @llvm.dbg.value(metadata i8* %51, metadata !385, metadata !DIExpression()), !dbg !391
  %78 = getelementptr inbounds i8, i8* %51, i64 20, !dbg !392
  %79 = icmp ugt i8* %78, %6, !dbg !394
  br i1 %79, label %107, label %80, !dbg !395

; <label>:80:                                     ; preds = %77
  %81 = load i8, i8* %51, align 4, !dbg !396
  %82 = shl i8 %81, 2, !dbg !397
  %83 = and i8 %82, 60, !dbg !397
  %84 = zext i8 %83 to i64, !dbg !398
  call void @llvm.dbg.value(metadata i64 %84, metadata !386, metadata !DIExpression()), !dbg !400
  %85 = getelementptr i8, i8* %51, i64 %84, !dbg !398
  %86 = icmp ugt i8* %85, %6, !dbg !401
  br i1 %86, label %107, label %87, !dbg !402

; <label>:87:                                     ; preds = %80
  %88 = getelementptr inbounds i8, i8* %51, i64 9, !dbg !403
  %89 = load i8, i8* %88, align 1, !dbg !403, !tbaa !404
  %90 = icmp eq i8 %89, 1, !dbg !406
  br i1 %90, label %91, label %107, !dbg !408

; <label>:91:                                     ; preds = %87
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !152, metadata !DIExpression(DW_OP_deref)), !dbg !293
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !409, metadata !DIExpression()), !dbg !418
  call void @llvm.dbg.value(metadata i8* %6, metadata !415, metadata !DIExpression()), !dbg !420
  call void @llvm.dbg.value(metadata i8* %85, metadata !417, metadata !DIExpression()), !dbg !421
  %92 = getelementptr inbounds i8, i8* %85, i64 8, !dbg !422
  %93 = bitcast i8* %92 to %struct.icmphdr*, !dbg !422
  %94 = inttoptr i64 %5 to %struct.icmphdr*, !dbg !424
  %95 = icmp ugt %struct.icmphdr* %93, %94, !dbg !425
  br i1 %95, label %107, label %96, !dbg !426

; <label>:96:                                     ; preds = %91
  %97 = load i8, i8* %85, align 4, !dbg !427, !tbaa !428
  %98 = icmp eq i8 %97, 8, !dbg !430
  br i1 %98, label %99, label %107, !dbg !432

; <label>:99:                                     ; preds = %96
  call void @llvm.dbg.value(metadata i8* %85, metadata !254, metadata !DIExpression()), !dbg !433
  %100 = getelementptr inbounds i8, i8* %85, i64 4, !dbg !434
  %101 = getelementptr inbounds i8, i8* %100, i64 2, !dbg !434
  %102 = bitcast i8* %101 to i16*, !dbg !434
  %103 = load i16, i16* %102, align 2, !dbg !434, !tbaa !372
  %104 = and i16 %103, 256, !dbg !436
  %105 = icmp eq i16 %104, 0, !dbg !437
  %106 = select i1 %105, i32 1, i32 2, !dbg !438
  br label %107, !dbg !438

; <label>:107:                                    ; preds = %91, %80, %77, %62, %53, %1, %87, %96, %99, %58, %67, %70, %50
  %108 = phi i32 [ 2, %50 ], [ 2, %58 ], [ 2, %67 ], [ %76, %70 ], [ 2, %87 ], [ 2, %96 ], [ %106, %99 ], [ 2, %1 ], [ 2, %53 ], [ 2, %62 ], [ 2, %77 ], [ 2, %80 ], [ 2, %91 ], !dbg !292
  call void @llvm.dbg.value(metadata i32 %108, metadata !151, metadata !DIExpression()), !dbg !292
  %109 = bitcast i32* %2 to i8*, !dbg !439
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %109), !dbg !439
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !444, metadata !DIExpression()) #5, !dbg !439
  call void @llvm.dbg.value(metadata i32 %108, metadata !445, metadata !DIExpression()) #5, !dbg !456
  store i32 %108, i32* %2, align 4, !tbaa !457
  %110 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %109) #5, !dbg !458
  %111 = icmp eq i8* %110, null, !dbg !459
  br i1 %111, label %125, label %112, !dbg !461

; <label>:112:                                    ; preds = %107
  call void @llvm.dbg.value(metadata i8* %110, metadata !446, metadata !DIExpression()) #5, !dbg !462
  %113 = bitcast i8* %110 to i64*, !dbg !463
  %114 = load i64, i64* %113, align 8, !dbg !464, !tbaa !465
  %115 = add i64 %114, 1, !dbg !464
  store i64 %115, i64* %113, align 8, !dbg !464, !tbaa !465
  %116 = load i32, i32* %3, align 4, !dbg !468, !tbaa !279
  %117 = load i32, i32* %7, align 4, !dbg !469, !tbaa !288
  %118 = sub i32 %116, %117, !dbg !470
  %119 = zext i32 %118 to i64, !dbg !471
  %120 = getelementptr inbounds i8, i8* %110, i64 8, !dbg !472
  %121 = bitcast i8* %120 to i64*, !dbg !472
  %122 = load i64, i64* %121, align 8, !dbg !473, !tbaa !474
  %123 = add i64 %122, %119, !dbg !473
  store i64 %123, i64* %121, align 8, !dbg !473, !tbaa !474
  %124 = load i32, i32* %2, align 4, !dbg !475, !tbaa !457
  call void @llvm.dbg.value(metadata i32 %124, metadata !445, metadata !DIExpression()) #5, !dbg !456
  br label %125, !dbg !476

; <label>:125:                                    ; preds = %107, %112
  %126 = phi i32 [ %124, %112 ], [ 0, %107 ], !dbg !477
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %109), !dbg !478
  ret i32 %126, !dbg !479
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #4

attributes #0 = { norecurse nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind readnone speculatable }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!72, !73, !74}
!llvm.ident = !{!75}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !62, line: 16, type: !63, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !43, globals: !49, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/fedora/xdp-tutorial/packet02-rewriting")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/fedora/xdp-tutorial/packet02-rewriting")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 28, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42}
!17 = !DIEnumerator(name: "IPPROTO_IP", value: 0, isUnsigned: true)
!18 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1, isUnsigned: true)
!19 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2, isUnsigned: true)
!20 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4, isUnsigned: true)
!21 = !DIEnumerator(name: "IPPROTO_TCP", value: 6, isUnsigned: true)
!22 = !DIEnumerator(name: "IPPROTO_EGP", value: 8, isUnsigned: true)
!23 = !DIEnumerator(name: "IPPROTO_PUP", value: 12, isUnsigned: true)
!24 = !DIEnumerator(name: "IPPROTO_UDP", value: 17, isUnsigned: true)
!25 = !DIEnumerator(name: "IPPROTO_IDP", value: 22, isUnsigned: true)
!26 = !DIEnumerator(name: "IPPROTO_TP", value: 29, isUnsigned: true)
!27 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33, isUnsigned: true)
!28 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41, isUnsigned: true)
!29 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46, isUnsigned: true)
!30 = !DIEnumerator(name: "IPPROTO_GRE", value: 47, isUnsigned: true)
!31 = !DIEnumerator(name: "IPPROTO_ESP", value: 50, isUnsigned: true)
!32 = !DIEnumerator(name: "IPPROTO_AH", value: 51, isUnsigned: true)
!33 = !DIEnumerator(name: "IPPROTO_MTP", value: 92, isUnsigned: true)
!34 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94, isUnsigned: true)
!35 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98, isUnsigned: true)
!36 = !DIEnumerator(name: "IPPROTO_PIM", value: 103, isUnsigned: true)
!37 = !DIEnumerator(name: "IPPROTO_COMP", value: 108, isUnsigned: true)
!38 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132, isUnsigned: true)
!39 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136, isUnsigned: true)
!40 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137, isUnsigned: true)
!41 = !DIEnumerator(name: "IPPROTO_RAW", value: 255, isUnsigned: true)
!42 = !DIEnumerator(name: "IPPROTO_MAX", value: 256, isUnsigned: true)
!43 = !{!44, !45, !46}
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!45 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !47, line: 24, baseType: !48)
!47 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!48 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!49 = !{!0, !50, !56}
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 153, type: !52, isLocal: false, isDefinition: true)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !53, size: 32, elements: !54)
!53 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!54 = !{!55}
!55 = !DISubrange(count: 4)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !58, line: 20, type: !59, isLocal: true, isDefinition: true)
!58 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/fedora/xdp-tutorial/packet02-rewriting")
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!60 = !DISubroutineType(types: !61)
!61 = !{!44, !44, !44}
!62 = !DIFile(filename: "./../common/xdp_stats_kern.h", directory: "/home/fedora/xdp-tutorial/packet02-rewriting")
!63 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !58, line: 210, size: 224, elements: !64)
!64 = !{!65, !66, !67, !68, !69, !70, !71}
!65 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !63, file: !58, line: 211, baseType: !7, size: 32)
!66 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !63, file: !58, line: 212, baseType: !7, size: 32, offset: 32)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !63, file: !58, line: 213, baseType: !7, size: 32, offset: 64)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !63, file: !58, line: 214, baseType: !7, size: 32, offset: 96)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !63, file: !58, line: 215, baseType: !7, size: 32, offset: 128)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !63, file: !58, line: 216, baseType: !7, size: 32, offset: 160)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !63, file: !58, line: 217, baseType: !7, size: 32, offset: 192)
!72 = !{i32 2, !"Dwarf Version", i32 4}
!73 = !{i32 2, !"Debug Info Version", i32 3}
!74 = !{i32 1, !"wchar_size", i32 4}
!75 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!76 = distinct !DISubprogram(name: "xdp_port_rewrite_func", scope: !3, file: !3, line: 58, type: !77, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !89)
!77 = !DISubroutineType(types: !78)
!78 = !{!79, !80}
!79 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !82)
!82 = !{!83, !85, !86, !87, !88}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !81, file: !6, line: 2857, baseType: !84, size: 32)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !81, file: !6, line: 2858, baseType: !84, size: 32, offset: 32)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !81, file: !6, line: 2859, baseType: !84, size: 32, offset: 64)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !81, file: !6, line: 2861, baseType: !84, size: 32, offset: 96)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !81, file: !6, line: 2862, baseType: !84, size: 32, offset: 128)
!89 = !{!90}
!90 = !DILocalVariable(name: "ctx", arg: 1, scope: !76, file: !3, line: 58, type: !80)
!91 = !DILocation(line: 58, column: 42, scope: !76)
!92 = !DILocation(line: 60, column: 2, scope: !76)
!93 = distinct !DISubprogram(name: "xdp_vlan_swap_func", scope: !3, file: !3, line: 67, type: !77, scopeLine: 68, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !94)
!94 = !{!95, !96, !97, !98, !103, !104}
!95 = !DILocalVariable(name: "ctx", arg: 1, scope: !93, file: !3, line: 67, type: !80)
!96 = !DILocalVariable(name: "data_end", scope: !93, file: !3, line: 69, type: !44)
!97 = !DILocalVariable(name: "data", scope: !93, file: !3, line: 70, type: !44)
!98 = !DILocalVariable(name: "nh", scope: !93, file: !3, line: 73, type: !99)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !100, line: 33, size: 64, elements: !101)
!100 = !DIFile(filename: "./../common/parsing_helpers.h", directory: "/home/fedora/xdp-tutorial/packet02-rewriting")
!101 = !{!102}
!102 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !99, file: !100, line: 34, baseType: !44, size: 64)
!103 = !DILocalVariable(name: "nh_type", scope: !93, file: !3, line: 74, type: !79)
!104 = !DILocalVariable(name: "eth", scope: !93, file: !3, line: 77, type: !105)
!105 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !106, size: 64)
!106 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !107, line: 161, size: 112, elements: !108)
!107 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!108 = !{!109, !114, !115}
!109 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !106, file: !107, line: 162, baseType: !110, size: 48)
!110 = !DICompositeType(tag: DW_TAG_array_type, baseType: !111, size: 48, elements: !112)
!111 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!112 = !{!113}
!113 = !DISubrange(count: 6)
!114 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !106, file: !107, line: 163, baseType: !110, size: 48, offset: 48)
!115 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !106, file: !107, line: 164, baseType: !116, size: 16, offset: 96)
!116 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !117, line: 25, baseType: !46)
!117 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!118 = !DILocation(line: 67, column: 39, scope: !93)
!119 = !DILocation(line: 73, column: 20, scope: !93)
!120 = !DILocalVariable(name: "nh", arg: 1, scope: !121, file: !100, line: 73, type: !124)
!121 = distinct !DISubprogram(name: "parse_ethhdr", scope: !100, file: !100, line: 73, type: !122, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !126)
!122 = !DISubroutineType(types: !123)
!123 = !{!79, !124, !44, !125}
!124 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !105, size: 64)
!126 = !{!120, !127, !128, !129, !130, !131, !137, !138}
!127 = !DILocalVariable(name: "data_end", arg: 2, scope: !121, file: !100, line: 73, type: !44)
!128 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !121, file: !100, line: 74, type: !125)
!129 = !DILocalVariable(name: "eth", scope: !121, file: !100, line: 76, type: !105)
!130 = !DILocalVariable(name: "hdrsize", scope: !121, file: !100, line: 77, type: !79)
!131 = !DILocalVariable(name: "vlh", scope: !121, file: !100, line: 78, type: !132)
!132 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !133, size: 64)
!133 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !100, line: 42, size: 32, elements: !134)
!134 = !{!135, !136}
!135 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !133, file: !100, line: 43, baseType: !116, size: 16)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !133, file: !100, line: 44, baseType: !116, size: 16, offset: 16)
!137 = !DILocalVariable(name: "h_proto", scope: !121, file: !100, line: 79, type: !46)
!138 = !DILocalVariable(name: "i", scope: !121, file: !100, line: 80, type: !79)
!139 = !DILocation(line: 73, column: 60, scope: !121, inlinedAt: !140)
!140 = distinct !DILocation(line: 78, column: 12, scope: !93)
!141 = !DILocation(line: 77, column: 6, scope: !121, inlinedAt: !140)
!142 = !DILocation(line: 101, column: 7, scope: !143, inlinedAt: !140)
!143 = distinct !DILexicalBlock(scope: !144, file: !100, line: 97, column: 39)
!144 = distinct !DILexicalBlock(scope: !145, file: !100, line: 97, column: 2)
!145 = distinct !DILexicalBlock(scope: !121, file: !100, line: 97, column: 2)
!146 = distinct !DISubprogram(name: "xdp_parser_func", scope: !3, file: !3, line: 95, type: !77, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !147)
!147 = !{!148, !149, !150, !151, !152, !153, !154, !155, !191, !236, !254}
!148 = !DILocalVariable(name: "ctx", arg: 1, scope: !146, file: !3, line: 95, type: !80)
!149 = !DILocalVariable(name: "data_end", scope: !146, file: !3, line: 97, type: !44)
!150 = !DILocalVariable(name: "data", scope: !146, file: !3, line: 98, type: !44)
!151 = !DILocalVariable(name: "action", scope: !146, file: !3, line: 104, type: !84)
!152 = !DILocalVariable(name: "nh", scope: !146, file: !3, line: 107, type: !99)
!153 = !DILocalVariable(name: "nh_type", scope: !146, file: !3, line: 108, type: !79)
!154 = !DILocalVariable(name: "eth", scope: !146, file: !3, line: 111, type: !105)
!155 = !DILocalVariable(name: "ip6h", scope: !156, file: !3, line: 120, type: !158)
!156 = distinct !DILexicalBlock(scope: !157, file: !3, line: 119, column: 40)
!157 = distinct !DILexicalBlock(scope: !146, file: !3, line: 119, column: 6)
!158 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !159, size: 64)
!159 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !160, line: 116, size: 320, elements: !161)
!160 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "")
!161 = !{!162, !164, !165, !169, !170, !171, !172, !190}
!162 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !159, file: !160, line: 118, baseType: !163, size: 4, flags: DIFlagBitField, extraData: i64 0)
!163 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !47, line: 21, baseType: !111)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !159, file: !160, line: 119, baseType: !163, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !159, file: !160, line: 126, baseType: !166, size: 24, offset: 8)
!166 = !DICompositeType(tag: DW_TAG_array_type, baseType: !163, size: 24, elements: !167)
!167 = !{!168}
!168 = !DISubrange(count: 3)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !159, file: !160, line: 128, baseType: !116, size: 16, offset: 32)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !159, file: !160, line: 129, baseType: !163, size: 8, offset: 48)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !159, file: !160, line: 130, baseType: !163, size: 8, offset: 56)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !159, file: !160, line: 132, baseType: !173, size: 128, offset: 64)
!173 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !174, line: 33, size: 128, elements: !175)
!174 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "")
!175 = !{!176}
!176 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !173, file: !174, line: 40, baseType: !177, size: 128)
!177 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !173, file: !174, line: 34, size: 128, elements: !178)
!178 = !{!179, !183, !187}
!179 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !177, file: !174, line: 35, baseType: !180, size: 128)
!180 = !DICompositeType(tag: DW_TAG_array_type, baseType: !163, size: 128, elements: !181)
!181 = !{!182}
!182 = !DISubrange(count: 16)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !177, file: !174, line: 37, baseType: !184, size: 128)
!184 = !DICompositeType(tag: DW_TAG_array_type, baseType: !116, size: 128, elements: !185)
!185 = !{!186}
!186 = !DISubrange(count: 8)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !177, file: !174, line: 38, baseType: !188, size: 128)
!188 = !DICompositeType(tag: DW_TAG_array_type, baseType: !189, size: 128, elements: !54)
!189 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !117, line: 27, baseType: !84)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !159, file: !160, line: 133, baseType: !173, size: 128, offset: 192)
!191 = !DILocalVariable(name: "icmp6h", scope: !156, file: !3, line: 121, type: !192)
!192 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !193, size: 64)
!193 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmp6hdr", file: !194, line: 8, size: 64, elements: !195)
!194 = !DIFile(filename: "/usr/include/linux/icmpv6.h", directory: "")
!195 = !{!196, !197, !198, !200}
!196 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_type", scope: !193, file: !194, line: 10, baseType: !163, size: 8)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_code", scope: !193, file: !194, line: 11, baseType: !163, size: 8, offset: 8)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_cksum", scope: !193, file: !194, line: 12, baseType: !199, size: 16, offset: 16)
!199 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !117, line: 31, baseType: !46)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "icmp6_dataun", scope: !193, file: !194, line: 63, baseType: !201, size: 32, offset: 32)
!201 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !193, file: !194, line: 15, size: 32, elements: !202)
!202 = !{!203, !207, !211, !213, !218, !226}
!203 = !DIDerivedType(tag: DW_TAG_member, name: "un_data32", scope: !201, file: !194, line: 16, baseType: !204, size: 32)
!204 = !DICompositeType(tag: DW_TAG_array_type, baseType: !189, size: 32, elements: !205)
!205 = !{!206}
!206 = !DISubrange(count: 1)
!207 = !DIDerivedType(tag: DW_TAG_member, name: "un_data16", scope: !201, file: !194, line: 17, baseType: !208, size: 32)
!208 = !DICompositeType(tag: DW_TAG_array_type, baseType: !116, size: 32, elements: !209)
!209 = !{!210}
!210 = !DISubrange(count: 2)
!211 = !DIDerivedType(tag: DW_TAG_member, name: "un_data8", scope: !201, file: !194, line: 18, baseType: !212, size: 32)
!212 = !DICompositeType(tag: DW_TAG_array_type, baseType: !163, size: 32, elements: !54)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "u_echo", scope: !201, file: !194, line: 23, baseType: !214, size: 32)
!214 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_echo", file: !194, line: 20, size: 32, elements: !215)
!215 = !{!216, !217}
!216 = !DIDerivedType(tag: DW_TAG_member, name: "identifier", scope: !214, file: !194, line: 21, baseType: !116, size: 16)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "sequence", scope: !214, file: !194, line: 22, baseType: !116, size: 16, offset: 16)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "u_nd_advt", scope: !201, file: !194, line: 40, baseType: !219, size: 32)
!219 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_nd_advt", file: !194, line: 25, size: 32, elements: !220)
!220 = !{!221, !222, !223, !224, !225}
!221 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !219, file: !194, line: 27, baseType: !84, size: 5, flags: DIFlagBitField, extraData: i64 0)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "override", scope: !219, file: !194, line: 28, baseType: !84, size: 1, offset: 5, flags: DIFlagBitField, extraData: i64 0)
!223 = !DIDerivedType(tag: DW_TAG_member, name: "solicited", scope: !219, file: !194, line: 29, baseType: !84, size: 1, offset: 6, flags: DIFlagBitField, extraData: i64 0)
!224 = !DIDerivedType(tag: DW_TAG_member, name: "router", scope: !219, file: !194, line: 30, baseType: !84, size: 1, offset: 7, flags: DIFlagBitField, extraData: i64 0)
!225 = !DIDerivedType(tag: DW_TAG_member, name: "reserved2", scope: !219, file: !194, line: 31, baseType: !84, size: 24, offset: 8, flags: DIFlagBitField, extraData: i64 0)
!226 = !DIDerivedType(tag: DW_TAG_member, name: "u_nd_ra", scope: !201, file: !194, line: 61, baseType: !227, size: 32)
!227 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmpv6_nd_ra", file: !194, line: 42, size: 32, elements: !228)
!228 = !{!229, !230, !231, !232, !233, !234, !235}
!229 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !227, file: !194, line: 43, baseType: !163, size: 8)
!230 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !227, file: !194, line: 45, baseType: !163, size: 3, offset: 8, flags: DIFlagBitField, extraData: i64 8)
!231 = !DIDerivedType(tag: DW_TAG_member, name: "router_pref", scope: !227, file: !194, line: 46, baseType: !163, size: 2, offset: 11, flags: DIFlagBitField, extraData: i64 8)
!232 = !DIDerivedType(tag: DW_TAG_member, name: "home_agent", scope: !227, file: !194, line: 47, baseType: !163, size: 1, offset: 13, flags: DIFlagBitField, extraData: i64 8)
!233 = !DIDerivedType(tag: DW_TAG_member, name: "other", scope: !227, file: !194, line: 48, baseType: !163, size: 1, offset: 14, flags: DIFlagBitField, extraData: i64 8)
!234 = !DIDerivedType(tag: DW_TAG_member, name: "managed", scope: !227, file: !194, line: 49, baseType: !163, size: 1, offset: 15, flags: DIFlagBitField, extraData: i64 8)
!235 = !DIDerivedType(tag: DW_TAG_member, name: "rt_lifetime", scope: !227, file: !194, line: 60, baseType: !116, size: 16, offset: 16)
!236 = !DILocalVariable(name: "iph", scope: !237, file: !3, line: 135, type: !239)
!237 = distinct !DILexicalBlock(scope: !238, file: !3, line: 134, column: 45)
!238 = distinct !DILexicalBlock(scope: !157, file: !3, line: 134, column: 13)
!239 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !240, size: 64)
!240 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !241, line: 86, size: 160, elements: !242)
!241 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "")
!242 = !{!243, !244, !245, !246, !247, !248, !249, !250, !251, !252, !253}
!243 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !240, file: !241, line: 88, baseType: !163, size: 4, flags: DIFlagBitField, extraData: i64 0)
!244 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !240, file: !241, line: 89, baseType: !163, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!245 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !240, file: !241, line: 96, baseType: !163, size: 8, offset: 8)
!246 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !240, file: !241, line: 97, baseType: !116, size: 16, offset: 16)
!247 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !240, file: !241, line: 98, baseType: !116, size: 16, offset: 32)
!248 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !240, file: !241, line: 99, baseType: !116, size: 16, offset: 48)
!249 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !240, file: !241, line: 100, baseType: !163, size: 8, offset: 64)
!250 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !240, file: !241, line: 101, baseType: !163, size: 8, offset: 72)
!251 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !240, file: !241, line: 102, baseType: !199, size: 16, offset: 80)
!252 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !240, file: !241, line: 103, baseType: !189, size: 32, offset: 96)
!253 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !240, file: !241, line: 104, baseType: !189, size: 32, offset: 128)
!254 = !DILocalVariable(name: "icmph", scope: !237, file: !3, line: 136, type: !255)
!255 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !256, size: 64)
!256 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmphdr", file: !257, line: 69, size: 64, elements: !258)
!257 = !DIFile(filename: "/usr/include/linux/icmp.h", directory: "")
!258 = !{!259, !260, !261, !262}
!259 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !256, file: !257, line: 70, baseType: !163, size: 8)
!260 = !DIDerivedType(tag: DW_TAG_member, name: "code", scope: !256, file: !257, line: 71, baseType: !163, size: 8, offset: 8)
!261 = !DIDerivedType(tag: DW_TAG_member, name: "checksum", scope: !256, file: !257, line: 72, baseType: !199, size: 16, offset: 16)
!262 = !DIDerivedType(tag: DW_TAG_member, name: "un", scope: !256, file: !257, line: 84, baseType: !263, size: 32, offset: 32)
!263 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !256, file: !257, line: 73, size: 32, elements: !264)
!264 = !{!265, !270, !271, !276}
!265 = !DIDerivedType(tag: DW_TAG_member, name: "echo", scope: !263, file: !257, line: 77, baseType: !266, size: 32)
!266 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !263, file: !257, line: 74, size: 32, elements: !267)
!267 = !{!268, !269}
!268 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !266, file: !257, line: 75, baseType: !116, size: 16)
!269 = !DIDerivedType(tag: DW_TAG_member, name: "sequence", scope: !266, file: !257, line: 76, baseType: !116, size: 16, offset: 16)
!270 = !DIDerivedType(tag: DW_TAG_member, name: "gateway", scope: !263, file: !257, line: 78, baseType: !189, size: 32)
!271 = !DIDerivedType(tag: DW_TAG_member, name: "frag", scope: !263, file: !257, line: 82, baseType: !272, size: 32)
!272 = distinct !DICompositeType(tag: DW_TAG_structure_type, scope: !263, file: !257, line: 79, size: 32, elements: !273)
!273 = !{!274, !275}
!274 = !DIDerivedType(tag: DW_TAG_member, name: "__unused", scope: !272, file: !257, line: 80, baseType: !116, size: 16)
!275 = !DIDerivedType(tag: DW_TAG_member, name: "mtu", scope: !272, file: !257, line: 81, baseType: !116, size: 16, offset: 16)
!276 = !DIDerivedType(tag: DW_TAG_member, name: "reserved", scope: !263, file: !257, line: 83, baseType: !212, size: 32)
!277 = !DILocation(line: 95, column: 37, scope: !146)
!278 = !DILocation(line: 97, column: 38, scope: !146)
!279 = !{!280, !281, i64 4}
!280 = !{!"xdp_md", !281, i64 0, !281, i64 4, !281, i64 8, !281, i64 12, !281, i64 16}
!281 = !{!"int", !282, i64 0}
!282 = !{!"omnipotent char", !283, i64 0}
!283 = !{!"Simple C/C++ TBAA"}
!284 = !DILocation(line: 97, column: 27, scope: !146)
!285 = !DILocation(line: 97, column: 19, scope: !146)
!286 = !DILocation(line: 97, column: 8, scope: !146)
!287 = !DILocation(line: 98, column: 34, scope: !146)
!288 = !{!280, !281, i64 0}
!289 = !DILocation(line: 98, column: 23, scope: !146)
!290 = !DILocation(line: 98, column: 15, scope: !146)
!291 = !DILocation(line: 98, column: 8, scope: !146)
!292 = !DILocation(line: 104, column: 8, scope: !146)
!293 = !DILocation(line: 107, column: 20, scope: !146)
!294 = !DILocation(line: 111, column: 17, scope: !146)
!295 = !DILocation(line: 73, column: 60, scope: !121, inlinedAt: !296)
!296 = distinct !DILocation(line: 117, column: 12, scope: !146)
!297 = !DILocation(line: 73, column: 70, scope: !121, inlinedAt: !296)
!298 = !DILocation(line: 74, column: 22, scope: !121, inlinedAt: !296)
!299 = !DILocation(line: 77, column: 6, scope: !121, inlinedAt: !296)
!300 = !DILocation(line: 85, column: 14, scope: !301, inlinedAt: !296)
!301 = distinct !DILexicalBlock(scope: !121, file: !100, line: 85, column: 6)
!302 = !DILocation(line: 85, column: 24, scope: !301, inlinedAt: !296)
!303 = !DILocation(line: 85, column: 6, scope: !121, inlinedAt: !296)
!304 = !DILocation(line: 76, column: 17, scope: !121, inlinedAt: !296)
!305 = !DILocation(line: 78, column: 19, scope: !121, inlinedAt: !296)
!306 = !DILocation(line: 91, column: 17, scope: !121, inlinedAt: !296)
!307 = !DILocation(line: 79, column: 8, scope: !121, inlinedAt: !296)
!308 = !DILocation(line: 80, column: 6, scope: !121, inlinedAt: !296)
!309 = !DILocation(line: 0, scope: !121, inlinedAt: !296)
!310 = !{!311, !311, i64 0}
!311 = !{!"short", !282, i64 0}
!312 = !DILocation(line: 98, column: 7, scope: !143, inlinedAt: !296)
!313 = !DILocation(line: 101, column: 11, scope: !314, inlinedAt: !296)
!314 = distinct !DILexicalBlock(scope: !143, file: !100, line: 101, column: 7)
!315 = !DILocation(line: 101, column: 15, scope: !314, inlinedAt: !296)
!316 = !DILocation(line: 101, column: 7, scope: !143, inlinedAt: !296)
!317 = !DILocation(line: 104, column: 18, scope: !143, inlinedAt: !296)
!318 = !DILocation(line: 108, column: 6, scope: !146)
!319 = !DILocation(line: 119, column: 6, scope: !146)
!320 = !DILocalVariable(name: "nh", arg: 1, scope: !321, file: !100, line: 112, type: !124)
!321 = distinct !DISubprogram(name: "parse_ip6hdr", scope: !100, file: !100, line: 112, type: !322, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !325)
!322 = !DISubroutineType(types: !323)
!323 = !{!79, !124, !44, !324}
!324 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !158, size: 64)
!325 = !{!320, !326, !327, !328}
!326 = !DILocalVariable(name: "data_end", arg: 2, scope: !321, file: !100, line: 113, type: !44)
!327 = !DILocalVariable(name: "ip6hdr", arg: 3, scope: !321, file: !100, line: 114, type: !324)
!328 = !DILocalVariable(name: "ip6h", scope: !321, file: !100, line: 116, type: !158)
!329 = !DILocation(line: 112, column: 60, scope: !321, inlinedAt: !330)
!330 = distinct !DILocation(line: 123, column: 13, scope: !156)
!331 = !DILocation(line: 113, column: 12, scope: !321, inlinedAt: !330)
!332 = !DILocation(line: 122, column: 11, scope: !333, inlinedAt: !330)
!333 = distinct !DILexicalBlock(scope: !321, file: !100, line: 122, column: 6)
!334 = !DILocation(line: 122, column: 17, scope: !333, inlinedAt: !330)
!335 = !DILocation(line: 122, column: 15, scope: !333, inlinedAt: !330)
!336 = !DILocation(line: 122, column: 6, scope: !321, inlinedAt: !330)
!337 = !DILocation(line: 116, column: 18, scope: !321, inlinedAt: !330)
!338 = !DILocation(line: 128, column: 15, scope: !321, inlinedAt: !330)
!339 = !{!340, !282, i64 6}
!340 = !{!"ipv6hdr", !282, i64 0, !282, i64 0, !282, i64 1, !311, i64 4, !282, i64 6, !282, i64 7, !341, i64 8, !341, i64 24}
!341 = !{!"in6_addr", !282, i64 0}
!342 = !DILocation(line: 124, column: 15, scope: !343)
!343 = distinct !DILexicalBlock(scope: !156, file: !3, line: 124, column: 7)
!344 = !DILocation(line: 124, column: 7, scope: !156)
!345 = !DILocalVariable(name: "nh", arg: 1, scope: !346, file: !100, line: 153, type: !124)
!346 = distinct !DISubprogram(name: "parse_icmp6hdr", scope: !100, file: !100, line: 153, type: !347, scopeLine: 156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !350)
!347 = !DISubroutineType(types: !348)
!348 = !{!79, !124, !44, !349}
!349 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !192, size: 64)
!350 = !{!345, !351, !352, !353}
!351 = !DILocalVariable(name: "data_end", arg: 2, scope: !346, file: !100, line: 154, type: !44)
!352 = !DILocalVariable(name: "icmp6hdr", arg: 3, scope: !346, file: !100, line: 155, type: !349)
!353 = !DILocalVariable(name: "icmp6h", scope: !346, file: !100, line: 157, type: !192)
!354 = !DILocation(line: 153, column: 62, scope: !346, inlinedAt: !355)
!355 = distinct !DILocation(line: 127, column: 13, scope: !156)
!356 = !DILocation(line: 154, column: 14, scope: !346, inlinedAt: !355)
!357 = !DILocation(line: 157, column: 19, scope: !346, inlinedAt: !355)
!358 = !DILocation(line: 159, column: 13, scope: !359, inlinedAt: !355)
!359 = distinct !DILexicalBlock(scope: !346, file: !100, line: 159, column: 6)
!360 = !DILocation(line: 159, column: 19, scope: !359, inlinedAt: !355)
!361 = !DILocation(line: 159, column: 17, scope: !359, inlinedAt: !355)
!362 = !DILocation(line: 159, column: 6, scope: !346, inlinedAt: !355)
!363 = !DILocation(line: 165, column: 17, scope: !346, inlinedAt: !355)
!364 = !{!365, !282, i64 0}
!365 = !{!"icmp6hdr", !282, i64 0, !282, i64 1, !311, i64 2, !282, i64 4}
!366 = !DILocation(line: 128, column: 15, scope: !367)
!367 = distinct !DILexicalBlock(scope: !156, file: !3, line: 128, column: 7)
!368 = !DILocation(line: 128, column: 7, scope: !156)
!369 = !DILocation(line: 121, column: 20, scope: !156)
!370 = !DILocation(line: 131, column: 7, scope: !371)
!371 = distinct !DILexicalBlock(scope: !156, file: !3, line: 131, column: 7)
!372 = !{!282, !282, i64 0}
!373 = !DILocation(line: 131, column: 41, scope: !371)
!374 = !DILocation(line: 131, column: 45, scope: !371)
!375 = !DILocation(line: 131, column: 7, scope: !156)
!376 = !DILocation(line: 135, column: 17, scope: !237)
!377 = !DILocalVariable(name: "nh", arg: 1, scope: !378, file: !100, line: 131, type: !124)
!378 = distinct !DISubprogram(name: "parse_iphdr", scope: !100, file: !100, line: 131, type: !379, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !382)
!379 = !DISubroutineType(types: !380)
!380 = !{!79, !124, !44, !381}
!381 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !239, size: 64)
!382 = !{!377, !383, !384, !385, !386}
!383 = !DILocalVariable(name: "data_end", arg: 2, scope: !378, file: !100, line: 132, type: !44)
!384 = !DILocalVariable(name: "iphdr", arg: 3, scope: !378, file: !100, line: 133, type: !381)
!385 = !DILocalVariable(name: "iph", scope: !378, file: !100, line: 135, type: !239)
!386 = !DILocalVariable(name: "hdrsize", scope: !378, file: !100, line: 136, type: !79)
!387 = !DILocation(line: 131, column: 59, scope: !378, inlinedAt: !388)
!388 = distinct !DILocation(line: 138, column: 13, scope: !237)
!389 = !DILocation(line: 132, column: 18, scope: !378, inlinedAt: !388)
!390 = !DILocation(line: 133, column: 27, scope: !378, inlinedAt: !388)
!391 = !DILocation(line: 135, column: 16, scope: !378, inlinedAt: !388)
!392 = !DILocation(line: 138, column: 10, scope: !393, inlinedAt: !388)
!393 = distinct !DILexicalBlock(scope: !378, file: !100, line: 138, column: 6)
!394 = !DILocation(line: 138, column: 14, scope: !393, inlinedAt: !388)
!395 = !DILocation(line: 138, column: 6, scope: !378, inlinedAt: !388)
!396 = !DILocation(line: 141, column: 17, scope: !378, inlinedAt: !388)
!397 = !DILocation(line: 141, column: 21, scope: !378, inlinedAt: !388)
!398 = !DILocation(line: 144, column: 14, scope: !399, inlinedAt: !388)
!399 = distinct !DILexicalBlock(scope: !378, file: !100, line: 144, column: 6)
!400 = !DILocation(line: 136, column: 6, scope: !378, inlinedAt: !388)
!401 = !DILocation(line: 144, column: 24, scope: !399, inlinedAt: !388)
!402 = !DILocation(line: 144, column: 6, scope: !378, inlinedAt: !388)
!403 = !DILocation(line: 150, column: 14, scope: !378, inlinedAt: !388)
!404 = !{!405, !282, i64 9}
!405 = !{!"iphdr", !282, i64 0, !282, i64 0, !282, i64 1, !311, i64 2, !311, i64 4, !311, i64 6, !282, i64 8, !282, i64 9, !311, i64 10, !281, i64 12, !281, i64 16}
!406 = !DILocation(line: 139, column: 15, scope: !407)
!407 = distinct !DILexicalBlock(scope: !237, file: !3, line: 139, column: 7)
!408 = !DILocation(line: 139, column: 7, scope: !237)
!409 = !DILocalVariable(name: "nh", arg: 1, scope: !410, file: !100, line: 168, type: !124)
!410 = distinct !DISubprogram(name: "parse_icmphdr", scope: !100, file: !100, line: 168, type: !411, scopeLine: 171, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !414)
!411 = !DISubroutineType(types: !412)
!412 = !{!79, !124, !44, !413}
!413 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !255, size: 64)
!414 = !{!409, !415, !416, !417}
!415 = !DILocalVariable(name: "data_end", arg: 2, scope: !410, file: !100, line: 169, type: !44)
!416 = !DILocalVariable(name: "icmphdr", arg: 3, scope: !410, file: !100, line: 170, type: !413)
!417 = !DILocalVariable(name: "icmph", scope: !410, file: !100, line: 172, type: !255)
!418 = !DILocation(line: 168, column: 61, scope: !410, inlinedAt: !419)
!419 = distinct !DILocation(line: 142, column: 13, scope: !237)
!420 = !DILocation(line: 169, column: 13, scope: !410, inlinedAt: !419)
!421 = !DILocation(line: 172, column: 18, scope: !410, inlinedAt: !419)
!422 = !DILocation(line: 174, column: 12, scope: !423, inlinedAt: !419)
!423 = distinct !DILexicalBlock(scope: !410, file: !100, line: 174, column: 6)
!424 = !DILocation(line: 174, column: 18, scope: !423, inlinedAt: !419)
!425 = !DILocation(line: 174, column: 16, scope: !423, inlinedAt: !419)
!426 = !DILocation(line: 174, column: 6, scope: !410, inlinedAt: !419)
!427 = !DILocation(line: 180, column: 16, scope: !410, inlinedAt: !419)
!428 = !{!429, !282, i64 0}
!429 = !{!"icmphdr", !282, i64 0, !282, i64 1, !311, i64 2, !282, i64 4}
!430 = !DILocation(line: 143, column: 15, scope: !431)
!431 = distinct !DILexicalBlock(scope: !237, file: !3, line: 143, column: 7)
!432 = !DILocation(line: 143, column: 7, scope: !237)
!433 = !DILocation(line: 136, column: 19, scope: !237)
!434 = !DILocation(line: 146, column: 7, scope: !435)
!435 = distinct !DILexicalBlock(scope: !237, file: !3, line: 146, column: 7)
!436 = !DILocation(line: 146, column: 42, scope: !435)
!437 = !DILocation(line: 146, column: 46, scope: !435)
!438 = !DILocation(line: 146, column: 7, scope: !237)
!439 = !DILocation(line: 24, column: 46, scope: !440, inlinedAt: !455)
!440 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !62, file: !62, line: 24, type: !441, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !443)
!441 = !DISubroutineType(types: !442)
!442 = !{!84, !80, !84}
!443 = !{!444, !445, !446}
!444 = !DILocalVariable(name: "ctx", arg: 1, scope: !440, file: !62, line: 24, type: !80)
!445 = !DILocalVariable(name: "action", arg: 2, scope: !440, file: !62, line: 24, type: !84)
!446 = !DILocalVariable(name: "rec", scope: !440, file: !62, line: 30, type: !447)
!447 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !448, size: 64)
!448 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !449, line: 10, size: 128, elements: !450)
!449 = !DIFile(filename: "./../common/xdp_stats_kern_user.h", directory: "/home/fedora/xdp-tutorial/packet02-rewriting")
!450 = !{!451, !454}
!451 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !448, file: !449, line: 11, baseType: !452, size: 64)
!452 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !453)
!453 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!454 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !448, file: !449, line: 12, baseType: !452, size: 64, offset: 64)
!455 = distinct !DILocation(line: 150, column: 9, scope: !146)
!456 = !DILocation(line: 24, column: 57, scope: !440, inlinedAt: !455)
!457 = !{!281, !281, i64 0}
!458 = !DILocation(line: 30, column: 24, scope: !440, inlinedAt: !455)
!459 = !DILocation(line: 31, column: 7, scope: !460, inlinedAt: !455)
!460 = distinct !DILexicalBlock(scope: !440, file: !62, line: 31, column: 6)
!461 = !DILocation(line: 31, column: 6, scope: !440, inlinedAt: !455)
!462 = !DILocation(line: 30, column: 18, scope: !440, inlinedAt: !455)
!463 = !DILocation(line: 38, column: 7, scope: !440, inlinedAt: !455)
!464 = !DILocation(line: 38, column: 17, scope: !440, inlinedAt: !455)
!465 = !{!466, !467, i64 0}
!466 = !{!"datarec", !467, i64 0, !467, i64 8}
!467 = !{!"long long", !282, i64 0}
!468 = !DILocation(line: 39, column: 25, scope: !440, inlinedAt: !455)
!469 = !DILocation(line: 39, column: 41, scope: !440, inlinedAt: !455)
!470 = !DILocation(line: 39, column: 34, scope: !440, inlinedAt: !455)
!471 = !DILocation(line: 39, column: 19, scope: !440, inlinedAt: !455)
!472 = !DILocation(line: 39, column: 7, scope: !440, inlinedAt: !455)
!473 = !DILocation(line: 39, column: 16, scope: !440, inlinedAt: !455)
!474 = !{!466, !467, i64 8}
!475 = !DILocation(line: 41, column: 9, scope: !440, inlinedAt: !455)
!476 = !DILocation(line: 41, column: 2, scope: !440, inlinedAt: !455)
!477 = !DILocation(line: 0, scope: !440, inlinedAt: !455)
!478 = !DILocation(line: 42, column: 1, scope: !440, inlinedAt: !455)
!479 = !DILocation(line: 151, column: 1, scope: !146)
