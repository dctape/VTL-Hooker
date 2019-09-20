; ModuleID = 'xdp_prog_kern_03.c'
source_filename = "xdp_prog_kern_03.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.hdr_cursor = type { i8* }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.vlan_hdr = type { i16, i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }
%struct.ipv6hdr = type { i8, [3 x i8], i16, i8, i8, %struct.in6_addr, %struct.in6_addr }
%struct.in6_addr = type { %union.anon }
%union.anon = type { [4 x i32] }
%struct.icmphdr_common = type { i8, i8, i16 }
%struct.bpf_fib_lookup = type { i8, i8, i16, i16, i16, i32, %union.anon.0, %union.anon.1, %union.anon.2, i16, i16, [6 x i8], [6 x i8] }
%union.anon.0 = type { i32 }
%union.anon.1 = type { [4 x i32] }
%union.anon.2 = type { [4 x i32] }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@tx_port = dso_local global %struct.bpf_map_def { i32 14, i32 4, i32 4, i32 256, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !76
@redirect_params = dso_local global %struct.bpf_map_def { i32 1, i32 6, i32 6, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !88
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !90
@llvm.used = appending global [9 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @redirect_params to i8*), i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_icmp_echo_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_pass_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_redirect_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_redirect_map_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_router_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_icmp_echo_func(%struct.xdp_md* nocapture readonly) #0 section "xdp_icmp_echo" !dbg !158 {
  %2 = alloca [4 x i32], align 4
  call void @llvm.dbg.declare(metadata [4 x i32]* %2, metadata !234, metadata !DIExpression()), !dbg !241
  %3 = alloca [6 x i8], align 1
  call void @llvm.dbg.declare(metadata [6 x i8]* %3, metadata !246, metadata !DIExpression()), !dbg !252
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !170, metadata !DIExpression()), !dbg !254
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !255
  %7 = load i32, i32* %6, align 4, !dbg !255, !tbaa !256
  %8 = zext i32 %7 to i64, !dbg !261
  %9 = inttoptr i64 %8 to i8*, !dbg !262
  call void @llvm.dbg.value(metadata i8* %9, metadata !171, metadata !DIExpression()), !dbg !263
  %10 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !264
  %11 = load i32, i32* %10, align 4, !dbg !264, !tbaa !265
  %12 = zext i32 %11 to i64, !dbg !266
  %13 = inttoptr i64 %12 to i8*, !dbg !267
  call void @llvm.dbg.value(metadata i8* %13, metadata !172, metadata !DIExpression()), !dbg !268
  %14 = bitcast i32* %5 to i8*, !dbg !269
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %14) #4, !dbg !269
  call void @llvm.dbg.value(metadata i32 2, metadata !233, metadata !DIExpression()), !dbg !270
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !173, metadata !DIExpression(DW_OP_deref)), !dbg !271
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !272, metadata !DIExpression()), !dbg !291
  call void @llvm.dbg.value(metadata i8* %9, metadata !279, metadata !DIExpression()), !dbg !293
  call void @llvm.dbg.value(metadata i32 14, metadata !282, metadata !DIExpression()), !dbg !294
  %15 = getelementptr i8, i8* %13, i64 14, !dbg !295
  %16 = icmp ugt i8* %15, %9, !dbg !297
  br i1 %16, label %129, label %17, !dbg !298

; <label>:17:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %13, metadata !281, metadata !DIExpression()), !dbg !299
  %18 = inttoptr i64 %12 to %struct.ethhdr*, !dbg !300
  call void @llvm.dbg.value(metadata i8* %15, metadata !283, metadata !DIExpression()), !dbg !301
  %19 = getelementptr inbounds i8, i8* %13, i64 12, !dbg !302
  %20 = bitcast i8* %19 to i16*, !dbg !302
  call void @llvm.dbg.value(metadata i16* %20, metadata !289, metadata !DIExpression(DW_OP_deref)), !dbg !303
  call void @llvm.dbg.value(metadata i32 0, metadata !290, metadata !DIExpression()), !dbg !304
  %21 = load i16, i16* %20, align 1, !dbg !305, !tbaa !306
  call void @llvm.dbg.value(metadata i16 %21, metadata !289, metadata !DIExpression()), !dbg !303
  call void @llvm.dbg.value(metadata i8* %15, metadata !283, metadata !DIExpression()), !dbg !301
  %22 = inttoptr i64 %8 to %struct.vlan_hdr*
  call void @llvm.dbg.value(metadata i32 0, metadata !290, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.value(metadata i8* %15, metadata !283, metadata !DIExpression()), !dbg !301
  switch i16 %21, label %55 [
    i16 -22392, label %23
    i16 129, label %23
  ], !dbg !308

; <label>:23:                                     ; preds = %17, %17
  %24 = getelementptr inbounds i8, i8* %13, i64 18, !dbg !312
  %25 = bitcast i8* %24 to %struct.vlan_hdr*, !dbg !312
  %26 = icmp ugt %struct.vlan_hdr* %25, %22, !dbg !314
  br i1 %26, label %55, label %27, !dbg !315

; <label>:27:                                     ; preds = %23
  %28 = getelementptr inbounds i8, i8* %13, i64 16, !dbg !316
  %29 = bitcast i8* %28 to i16*, !dbg !316
  call void @llvm.dbg.value(metadata i16* %29, metadata !289, metadata !DIExpression(DW_OP_deref)), !dbg !303
  %30 = load i16, i16* %29, align 1, !dbg !305, !tbaa !306
  call void @llvm.dbg.value(metadata i32 1, metadata !290, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.value(metadata i16 %30, metadata !289, metadata !DIExpression()), !dbg !303
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %25, metadata !283, metadata !DIExpression()), !dbg !301
  call void @llvm.dbg.value(metadata i32 1, metadata !290, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %25, metadata !283, metadata !DIExpression()), !dbg !301
  switch i16 %30, label %55 [
    i16 -22392, label %31
    i16 129, label %31
  ], !dbg !308

; <label>:31:                                     ; preds = %27, %27
  %32 = getelementptr inbounds i8, i8* %13, i64 22, !dbg !312
  %33 = bitcast i8* %32 to %struct.vlan_hdr*, !dbg !312
  %34 = icmp ugt %struct.vlan_hdr* %33, %22, !dbg !314
  br i1 %34, label %55, label %35, !dbg !315

; <label>:35:                                     ; preds = %31
  %36 = getelementptr inbounds i8, i8* %13, i64 20, !dbg !316
  %37 = bitcast i8* %36 to i16*, !dbg !316
  call void @llvm.dbg.value(metadata i16* %37, metadata !289, metadata !DIExpression(DW_OP_deref)), !dbg !303
  %38 = load i16, i16* %37, align 1, !dbg !305, !tbaa !306
  call void @llvm.dbg.value(metadata i32 2, metadata !290, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.value(metadata i16 %38, metadata !289, metadata !DIExpression()), !dbg !303
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %33, metadata !283, metadata !DIExpression()), !dbg !301
  call void @llvm.dbg.value(metadata i32 2, metadata !290, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %33, metadata !283, metadata !DIExpression()), !dbg !301
  switch i16 %38, label %55 [
    i16 -22392, label %39
    i16 129, label %39
  ], !dbg !308

; <label>:39:                                     ; preds = %35, %35
  %40 = getelementptr inbounds i8, i8* %13, i64 26, !dbg !312
  %41 = bitcast i8* %40 to %struct.vlan_hdr*, !dbg !312
  %42 = icmp ugt %struct.vlan_hdr* %41, %22, !dbg !314
  br i1 %42, label %55, label %43, !dbg !315

; <label>:43:                                     ; preds = %39
  %44 = getelementptr inbounds i8, i8* %13, i64 24, !dbg !316
  %45 = bitcast i8* %44 to i16*, !dbg !316
  call void @llvm.dbg.value(metadata i16* %45, metadata !289, metadata !DIExpression(DW_OP_deref)), !dbg !303
  %46 = load i16, i16* %45, align 1, !dbg !305, !tbaa !306
  call void @llvm.dbg.value(metadata i32 3, metadata !290, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.value(metadata i16 %46, metadata !289, metadata !DIExpression()), !dbg !303
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %41, metadata !283, metadata !DIExpression()), !dbg !301
  call void @llvm.dbg.value(metadata i32 3, metadata !290, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %41, metadata !283, metadata !DIExpression()), !dbg !301
  switch i16 %46, label %55 [
    i16 -22392, label %47
    i16 129, label %47
  ], !dbg !308

; <label>:47:                                     ; preds = %43, %43
  %48 = getelementptr inbounds i8, i8* %13, i64 30, !dbg !312
  %49 = bitcast i8* %48 to %struct.vlan_hdr*, !dbg !312
  %50 = icmp ugt %struct.vlan_hdr* %49, %22, !dbg !314
  br i1 %50, label %55, label %51, !dbg !315

; <label>:51:                                     ; preds = %47
  %52 = getelementptr inbounds i8, i8* %13, i64 28, !dbg !316
  %53 = bitcast i8* %52 to i16*, !dbg !316
  call void @llvm.dbg.value(metadata i16* %53, metadata !289, metadata !DIExpression(DW_OP_deref)), !dbg !303
  %54 = load i16, i16* %53, align 1, !dbg !305, !tbaa !306
  call void @llvm.dbg.value(metadata i32 4, metadata !290, metadata !DIExpression()), !dbg !304
  call void @llvm.dbg.value(metadata i16 %54, metadata !289, metadata !DIExpression()), !dbg !303
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %49, metadata !283, metadata !DIExpression()), !dbg !301
  br label %55

; <label>:55:                                     ; preds = %17, %23, %27, %31, %35, %39, %43, %47, %51
  %56 = phi i8* [ %15, %17 ], [ %15, %23 ], [ %24, %27 ], [ %24, %31 ], [ %32, %35 ], [ %32, %39 ], [ %40, %43 ], [ %40, %47 ], [ %48, %51 ], !dbg !305
  %57 = phi i16 [ %21, %17 ], [ %21, %23 ], [ %30, %27 ], [ %30, %31 ], [ %38, %35 ], [ %38, %39 ], [ %46, %43 ], [ %46, %47 ], [ %54, %51 ], !dbg !305
  call void @llvm.dbg.value(metadata i16 %57, metadata !187, metadata !DIExpression(DW_OP_dup, DW_OP_constu, 15, DW_OP_shr, DW_OP_lit0, DW_OP_not, DW_OP_mul, DW_OP_or, DW_OP_stack_value)), !dbg !317
  switch i16 %57, label %129 [
    i16 8, label %58
    i16 -8826, label %73
  ], !dbg !318

; <label>:58:                                     ; preds = %55
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !173, metadata !DIExpression(DW_OP_deref)), !dbg !271
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !319, metadata !DIExpression()), !dbg !329
  call void @llvm.dbg.value(metadata i8* %9, metadata !325, metadata !DIExpression()), !dbg !333
  call void @llvm.dbg.value(metadata i8* %56, metadata !327, metadata !DIExpression()), !dbg !334
  %59 = getelementptr inbounds i8, i8* %56, i64 20, !dbg !335
  %60 = icmp ugt i8* %59, %9, !dbg !337
  br i1 %60, label %129, label %61, !dbg !338

; <label>:61:                                     ; preds = %58
  %62 = load i8, i8* %56, align 4, !dbg !339
  %63 = shl i8 %62, 2, !dbg !340
  %64 = and i8 %63, 60, !dbg !340
  %65 = zext i8 %64 to i64, !dbg !341
  call void @llvm.dbg.value(metadata i64 %65, metadata !328, metadata !DIExpression()), !dbg !343
  %66 = getelementptr i8, i8* %56, i64 %65, !dbg !341
  %67 = icmp ugt i8* %66, %9, !dbg !344
  br i1 %67, label %129, label %68, !dbg !345

; <label>:68:                                     ; preds = %61
  %69 = bitcast i8* %56 to %struct.iphdr*, !dbg !346
  %70 = getelementptr inbounds i8, i8* %56, i64 9, !dbg !347
  %71 = load i8, i8* %70, align 1, !dbg !347, !tbaa !348
  %72 = icmp eq i8 %71, 1, !dbg !350
  br i1 %72, label %83, label %129, !dbg !352

; <label>:73:                                     ; preds = %55
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !173, metadata !DIExpression(DW_OP_deref)), !dbg !271
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !353, metadata !DIExpression()), !dbg !362
  call void @llvm.dbg.value(metadata i8* %9, metadata !359, metadata !DIExpression()), !dbg !366
  %74 = getelementptr inbounds i8, i8* %56, i64 40, !dbg !367
  %75 = bitcast i8* %74 to %struct.ipv6hdr*, !dbg !367
  %76 = inttoptr i64 %8 to %struct.ipv6hdr*, !dbg !369
  %77 = icmp ugt %struct.ipv6hdr* %75, %76, !dbg !370
  br i1 %77, label %129, label %78, !dbg !371

; <label>:78:                                     ; preds = %73
  %79 = bitcast i8* %56 to %struct.ipv6hdr*, !dbg !372
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %79, metadata !361, metadata !DIExpression()), !dbg !373
  %80 = getelementptr inbounds i8, i8* %56, i64 6, !dbg !374
  %81 = load i8, i8* %80, align 2, !dbg !374, !tbaa !375
  %82 = icmp eq i8 %81, 58, !dbg !378
  br i1 %82, label %83, label %129, !dbg !380

; <label>:83:                                     ; preds = %68, %78
  %84 = phi i1 [ true, %68 ], [ false, %78 ]
  %85 = phi i32 [ 8, %68 ], [ 56710, %78 ]
  %86 = phi i8* [ %66, %68 ], [ %74, %78 ], !dbg !381
  %87 = phi %struct.iphdr* [ %69, %68 ], [ undef, %78 ]
  %88 = phi %struct.ipv6hdr* [ undef, %68 ], [ %79, %78 ]
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !173, metadata !DIExpression(DW_OP_deref)), !dbg !271
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !382, metadata !DIExpression()), !dbg !391
  call void @llvm.dbg.value(metadata i8* %9, metadata !388, metadata !DIExpression()), !dbg !393
  call void @llvm.dbg.value(metadata i8* %86, metadata !390, metadata !DIExpression()), !dbg !394
  %89 = getelementptr inbounds i8, i8* %86, i64 4, !dbg !395
  %90 = bitcast i8* %89 to %struct.icmphdr_common*, !dbg !395
  %91 = inttoptr i64 %8 to %struct.icmphdr_common*, !dbg !397
  %92 = icmp ugt %struct.icmphdr_common* %90, %91, !dbg !398
  br i1 %92, label %129, label %93, !dbg !399

; <label>:93:                                     ; preds = %83
  %94 = load i8, i8* %86, align 2, !dbg !400, !tbaa !401
  %95 = icmp eq i8 %94, 8, !dbg !403
  %96 = and i1 %84, %95, !dbg !404
  br i1 %96, label %97, label %102, !dbg !404

; <label>:97:                                     ; preds = %93
  call void @llvm.dbg.value(metadata %struct.iphdr* %87, metadata !190, metadata !DIExpression()), !dbg !405
  call void @llvm.dbg.value(metadata %struct.iphdr* %87, metadata !406, metadata !DIExpression()), !dbg !412
  %98 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %87, i64 0, i32 8, !dbg !415
  %99 = load i32, i32* %98, align 4, !dbg !415, !tbaa !416
  call void @llvm.dbg.value(metadata i32 %99, metadata !411, metadata !DIExpression()), !dbg !417
  %100 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %87, i64 0, i32 9, !dbg !418
  %101 = load i32, i32* %100, align 4, !dbg !418, !tbaa !419
  store i32 %101, i32* %98, align 4, !dbg !420, !tbaa !416
  store i32 %99, i32* %100, align 4, !dbg !421, !tbaa !419
  call void @llvm.dbg.value(metadata i16 0, metadata !223, metadata !DIExpression()), !dbg !422
  br label %112, !dbg !423

; <label>:102:                                    ; preds = %93
  %103 = icmp eq i32 %85, 56710, !dbg !424
  %104 = icmp eq i8 %94, -128, !dbg !425
  %105 = and i1 %103, %104, !dbg !426
  br i1 %105, label %106, label %129, !dbg !426

; <label>:106:                                    ; preds = %102
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %88, metadata !207, metadata !DIExpression()), !dbg !427
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %88, metadata !240, metadata !DIExpression()) #4, !dbg !428
  %107 = bitcast [4 x i32]* %2 to i8*, !dbg !429
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %107), !dbg !429
  %108 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %88, i64 0, i32 5, !dbg !430
  %109 = bitcast %struct.in6_addr* %108 to i8*, !dbg !430
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %107, i8* nonnull align 4 %109, i64 16, i1 false) #4, !dbg !430
  %110 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %88, i64 0, i32 6, !dbg !431
  %111 = bitcast %struct.in6_addr* %110 to i8*, !dbg !431
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %109, i8* nonnull align 4 %111, i64 16, i1 false) #4, !dbg !431, !tbaa.struct !432
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %111, i8* nonnull align 4 %107, i64 16, i1 false) #4, !dbg !434
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %107), !dbg !435
  call void @llvm.dbg.value(metadata i16 129, metadata !223, metadata !DIExpression()), !dbg !422
  br label %112

; <label>:112:                                    ; preds = %106, %97
  %113 = phi i8 [ 0, %97 ], [ -127, %106 ]
  call void @llvm.dbg.value(metadata i16 undef, metadata !223, metadata !DIExpression()), !dbg !422
  call void @llvm.dbg.value(metadata %struct.ethhdr* %18, metadata !178, metadata !DIExpression()), !dbg !436
  call void @llvm.dbg.value(metadata %struct.ethhdr* %18, metadata !251, metadata !DIExpression()) #4, !dbg !437
  %114 = getelementptr inbounds [6 x i8], [6 x i8]* %3, i64 0, i64 0, !dbg !438
  call void @llvm.lifetime.start.p0i8(i64 6, i8* nonnull %114), !dbg !438
  %115 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %18, i64 0, i32 1, i64 0, !dbg !439
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 %114, i8* nonnull align 1 %115, i64 6, i1 false) #4, !dbg !439
  %116 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %18, i64 0, i32 0, i64 0, !dbg !440
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 %115, i8* align 1 %116, i64 6, i1 false) #4, !dbg !440
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %116, i8* nonnull align 1 %114, i64 6, i1 false) #4, !dbg !441
  call void @llvm.lifetime.end.p0i8(i64 6, i8* nonnull %114), !dbg !442
  call void @llvm.dbg.value(metadata i8* %86, metadata !225, metadata !DIExpression()), !dbg !443
  %117 = getelementptr inbounds i8, i8* %86, i64 2, !dbg !444
  %118 = bitcast i8* %117 to i16*, !dbg !444
  %119 = load i16, i16* %118, align 2, !dbg !444, !tbaa !445
  call void @llvm.dbg.value(metadata i16 %119, metadata !224, metadata !DIExpression()), !dbg !446
  store i16 0, i16* %118, align 2, !dbg !447, !tbaa !445
  %120 = bitcast i8* %86 to i32*, !dbg !448
  %121 = load i32, i32* %120, align 2, !dbg !449
  store i32 %121, i32* %5, align 4, !dbg !449
  call void @llvm.dbg.value(metadata i32* %120, metadata !225, metadata !DIExpression()), !dbg !443
  store i8 %113, i8* %86, align 2, !dbg !450, !tbaa !401
  %122 = xor i16 %119, -1, !dbg !451
  call void @llvm.dbg.value(metadata i8* %86, metadata !225, metadata !DIExpression()), !dbg !443
  call void @llvm.dbg.value(metadata i32* %5, metadata !232, metadata !DIExpression(DW_OP_deref)), !dbg !452
  call void @llvm.dbg.value(metadata i16 %122, metadata !453, metadata !DIExpression()) #4, !dbg !462
  call void @llvm.dbg.value(metadata i8* %86, metadata !458, metadata !DIExpression()) #4, !dbg !464
  call void @llvm.dbg.value(metadata i32* %5, metadata !459, metadata !DIExpression()) #4, !dbg !465
  call void @llvm.dbg.value(metadata i32 4, metadata !461, metadata !DIExpression()) #4, !dbg !466
  %123 = zext i16 %122 to i32, !dbg !467
  %124 = call i32 inttoptr (i64 28 to i32 (i8*, i32, i8*, i32, i32)*)(i8* nonnull %14, i32 4, i8* nonnull %86, i32 4, i32 %123) #4, !dbg !468
  call void @llvm.dbg.value(metadata i32 %124, metadata !460, metadata !DIExpression()) #4, !dbg !469
  call void @llvm.dbg.value(metadata i32 %124, metadata !470, metadata !DIExpression()) #4, !dbg !475
  %125 = lshr i32 %124, 16, !dbg !477
  %126 = add i32 %125, %124, !dbg !478
  %127 = trunc i32 %126 to i16, !dbg !479
  %128 = xor i16 %127, -1, !dbg !479
  call void @llvm.dbg.value(metadata i8* %86, metadata !225, metadata !DIExpression()), !dbg !443
  store i16 %128, i16* %118, align 2, !dbg !480, !tbaa !445
  call void @llvm.dbg.value(metadata i32 3, metadata !233, metadata !DIExpression()), !dbg !270
  br label %129, !dbg !481

; <label>:129:                                    ; preds = %55, %83, %73, %61, %58, %1, %68, %78, %102, %112
  %130 = phi i32 [ 2, %68 ], [ 3, %112 ], [ 2, %102 ], [ 2, %78 ], [ 2, %1 ], [ 2, %58 ], [ 2, %61 ], [ 2, %73 ], [ 2, %83 ], [ 2, %55 ], !dbg !482
  call void @llvm.dbg.value(metadata i32 %130, metadata !233, metadata !DIExpression()), !dbg !270
  %131 = bitcast i32* %4 to i8*, !dbg !483
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %131), !dbg !483
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !488, metadata !DIExpression()) #4, !dbg !483
  call void @llvm.dbg.value(metadata i32 %130, metadata !489, metadata !DIExpression()) #4, !dbg !500
  store i32 %130, i32* %4, align 4, !tbaa !501
  %132 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %131) #4, !dbg !502
  %133 = icmp eq i8* %132, null, !dbg !503
  br i1 %133, label %147, label %134, !dbg !505

; <label>:134:                                    ; preds = %129
  call void @llvm.dbg.value(metadata i8* %132, metadata !490, metadata !DIExpression()) #4, !dbg !506
  %135 = bitcast i8* %132 to i64*, !dbg !507
  %136 = load i64, i64* %135, align 8, !dbg !508, !tbaa !509
  %137 = add i64 %136, 1, !dbg !508
  store i64 %137, i64* %135, align 8, !dbg !508, !tbaa !509
  %138 = load i32, i32* %6, align 4, !dbg !512, !tbaa !256
  %139 = load i32, i32* %10, align 4, !dbg !513, !tbaa !265
  %140 = sub i32 %138, %139, !dbg !514
  %141 = zext i32 %140 to i64, !dbg !515
  %142 = getelementptr inbounds i8, i8* %132, i64 8, !dbg !516
  %143 = bitcast i8* %142 to i64*, !dbg !516
  %144 = load i64, i64* %143, align 8, !dbg !517, !tbaa !518
  %145 = add i64 %144, %141, !dbg !517
  store i64 %145, i64* %143, align 8, !dbg !517, !tbaa !518
  %146 = load i32, i32* %4, align 4, !dbg !519, !tbaa !501
  call void @llvm.dbg.value(metadata i32 %146, metadata !489, metadata !DIExpression()) #4, !dbg !500
  br label %147, !dbg !520

; <label>:147:                                    ; preds = %129, %134
  %148 = phi i32 [ %146, %134 ], [ 0, %129 ], !dbg !521
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %131), !dbg !522
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %14) #4, !dbg !523
  ret i32 %148, !dbg !524
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind
define dso_local i32 @xdp_redirect_func(%struct.xdp_md* nocapture readonly) #0 section "xdp_redirect" !dbg !525 {
  %2 = alloca i32, align 4
  %3 = alloca [6 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !527, metadata !DIExpression()), !dbg !536
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !537
  %5 = load i32, i32* %4, align 4, !dbg !537, !tbaa !256
  %6 = zext i32 %5 to i64, !dbg !538
  %7 = inttoptr i64 %6 to i8*, !dbg !539
  call void @llvm.dbg.value(metadata i8* %7, metadata !528, metadata !DIExpression()), !dbg !540
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !541
  %9 = load i32, i32* %8, align 4, !dbg !541, !tbaa !265
  %10 = zext i32 %9 to i64, !dbg !542
  %11 = inttoptr i64 %10 to i8*, !dbg !543
  call void @llvm.dbg.value(metadata i8* %11, metadata !529, metadata !DIExpression()), !dbg !544
  call void @llvm.dbg.value(metadata i32 2, metadata !533, metadata !DIExpression()), !dbg !545
  %12 = getelementptr inbounds [6 x i8], [6 x i8]* %3, i64 0, i64 0, !dbg !546
  call void @llvm.lifetime.start.p0i8(i64 6, i8* nonnull %12), !dbg !546
  call void @llvm.dbg.declare(metadata [6 x i8]* %3, metadata !534, metadata !DIExpression()), !dbg !547
  call void @llvm.memset.p0i8.i64(i8* nonnull align 1 %12, i8 0, i64 6, i1 false), !dbg !547
  call void @llvm.dbg.value(metadata i32 0, metadata !535, metadata !DIExpression()), !dbg !548
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !530, metadata !DIExpression(DW_OP_deref)), !dbg !549
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !272, metadata !DIExpression()), !dbg !550
  call void @llvm.dbg.value(metadata i8* %7, metadata !279, metadata !DIExpression()), !dbg !552
  call void @llvm.dbg.value(metadata i32 14, metadata !282, metadata !DIExpression()), !dbg !553
  %13 = getelementptr i8, i8* %11, i64 14, !dbg !554
  %14 = icmp ugt i8* %13, %7, !dbg !555
  br i1 %14, label %21, label %15, !dbg !556

; <label>:15:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %11, metadata !281, metadata !DIExpression()), !dbg !557
  %16 = inttoptr i64 %10 to %struct.ethhdr*, !dbg !558
  call void @llvm.dbg.value(metadata i8* %13, metadata !283, metadata !DIExpression()), !dbg !559
  call void @llvm.dbg.value(metadata i8* %11, metadata !289, metadata !DIExpression(DW_OP_plus_uconst, 12, DW_OP_deref, DW_OP_stack_value)), !dbg !560
  call void @llvm.dbg.value(metadata i32 0, metadata !290, metadata !DIExpression()), !dbg !561
  call void @llvm.dbg.value(metadata i8* %13, metadata !283, metadata !DIExpression()), !dbg !559
  call void @llvm.dbg.value(metadata i32 0, metadata !290, metadata !DIExpression()), !dbg !561
  call void @llvm.dbg.value(metadata i8* %13, metadata !283, metadata !DIExpression()), !dbg !559
  call void @llvm.dbg.value(metadata %struct.ethhdr* %16, metadata !531, metadata !DIExpression()), !dbg !562
  %17 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 0, i64 0, !dbg !563
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %17, i8* nonnull align 1 %12, i64 6, i1 false), !dbg !563
  %18 = tail call i32 inttoptr (i64 23 to i32 (i32, i32)*)(i32 0, i32 0) #4, !dbg !564
  call void @llvm.dbg.value(metadata i32 %18, metadata !533, metadata !DIExpression()), !dbg !545
  call void @llvm.dbg.value(metadata i32 %18, metadata !533, metadata !DIExpression()), !dbg !545
  %19 = bitcast i32* %2 to i8*, !dbg !565
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %19), !dbg !565
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !488, metadata !DIExpression()) #4, !dbg !565
  call void @llvm.dbg.value(metadata i32 %18, metadata !489, metadata !DIExpression()) #4, !dbg !567
  store i32 %18, i32* %2, align 4, !tbaa !501
  %20 = icmp ugt i32 %18, 4, !dbg !568
  br i1 %20, label %40, label %23, !dbg !570

; <label>:21:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i32 %18, metadata !533, metadata !DIExpression()), !dbg !545
  %22 = bitcast i32* %2 to i8*, !dbg !565
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %22), !dbg !565
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !488, metadata !DIExpression()) #4, !dbg !565
  call void @llvm.dbg.value(metadata i32 %18, metadata !489, metadata !DIExpression()) #4, !dbg !567
  store i32 2, i32* %2, align 4, !tbaa !501
  br label %23, !dbg !570

; <label>:23:                                     ; preds = %21, %15
  %24 = phi i8* [ %22, %21 ], [ %19, %15 ]
  %25 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %24) #4, !dbg !571
  %26 = icmp eq i8* %25, null, !dbg !572
  br i1 %26, label %40, label %27, !dbg !573

; <label>:27:                                     ; preds = %23
  call void @llvm.dbg.value(metadata i8* %25, metadata !490, metadata !DIExpression()) #4, !dbg !574
  %28 = bitcast i8* %25 to i64*, !dbg !575
  %29 = load i64, i64* %28, align 8, !dbg !576, !tbaa !509
  %30 = add i64 %29, 1, !dbg !576
  store i64 %30, i64* %28, align 8, !dbg !576, !tbaa !509
  %31 = load i32, i32* %4, align 4, !dbg !577, !tbaa !256
  %32 = load i32, i32* %8, align 4, !dbg !578, !tbaa !265
  %33 = sub i32 %31, %32, !dbg !579
  %34 = zext i32 %33 to i64, !dbg !580
  %35 = getelementptr inbounds i8, i8* %25, i64 8, !dbg !581
  %36 = bitcast i8* %35 to i64*, !dbg !581
  %37 = load i64, i64* %36, align 8, !dbg !582, !tbaa !518
  %38 = add i64 %37, %34, !dbg !582
  store i64 %38, i64* %36, align 8, !dbg !582, !tbaa !518
  %39 = load i32, i32* %2, align 4, !dbg !583, !tbaa !501
  call void @llvm.dbg.value(metadata i32 %39, metadata !489, metadata !DIExpression()) #4, !dbg !567
  br label %40, !dbg !584

; <label>:40:                                     ; preds = %15, %23, %27
  %41 = phi i8* [ %19, %15 ], [ %24, %27 ], [ %24, %23 ]
  %42 = phi i32 [ 0, %15 ], [ %39, %27 ], [ 0, %23 ], !dbg !585
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %41), !dbg !586
  call void @llvm.lifetime.end.p0i8(i64 6, i8* nonnull %12), !dbg !587
  ret i32 %42, !dbg !588
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #2

; Function Attrs: nounwind
define dso_local i32 @xdp_redirect_map_func(%struct.xdp_md* nocapture readonly) #0 section "xdp_redirect_map" !dbg !589 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !591, metadata !DIExpression()), !dbg !600
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !601
  %4 = load i32, i32* %3, align 4, !dbg !601, !tbaa !256
  %5 = zext i32 %4 to i64, !dbg !602
  %6 = inttoptr i64 %5 to i8*, !dbg !603
  call void @llvm.dbg.value(metadata i8* %6, metadata !592, metadata !DIExpression()), !dbg !604
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !605
  %8 = load i32, i32* %7, align 4, !dbg !605, !tbaa !265
  %9 = zext i32 %8 to i64, !dbg !606
  %10 = inttoptr i64 %9 to i8*, !dbg !607
  call void @llvm.dbg.value(metadata i8* %10, metadata !593, metadata !DIExpression()), !dbg !608
  call void @llvm.dbg.value(metadata i32 2, metadata !597, metadata !DIExpression()), !dbg !609
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !594, metadata !DIExpression(DW_OP_deref)), !dbg !610
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !272, metadata !DIExpression()), !dbg !611
  call void @llvm.dbg.value(metadata i8* %6, metadata !279, metadata !DIExpression()), !dbg !613
  call void @llvm.dbg.value(metadata i32 14, metadata !282, metadata !DIExpression()), !dbg !614
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !615
  %12 = icmp ugt i8* %11, %6, !dbg !616
  br i1 %12, label %18, label %13, !dbg !617

; <label>:13:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !281, metadata !DIExpression()), !dbg !618
  %14 = inttoptr i64 %9 to %struct.ethhdr*, !dbg !619
  call void @llvm.dbg.value(metadata i8* %11, metadata !283, metadata !DIExpression()), !dbg !620
  call void @llvm.dbg.value(metadata i8* %10, metadata !289, metadata !DIExpression(DW_OP_plus_uconst, 12, DW_OP_deref, DW_OP_stack_value)), !dbg !621
  call void @llvm.dbg.value(metadata i32 0, metadata !290, metadata !DIExpression()), !dbg !622
  call void @llvm.dbg.value(metadata i8* %11, metadata !283, metadata !DIExpression()), !dbg !620
  call void @llvm.dbg.value(metadata i32 0, metadata !290, metadata !DIExpression()), !dbg !622
  call void @llvm.dbg.value(metadata i8* %11, metadata !283, metadata !DIExpression()), !dbg !620
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !595, metadata !DIExpression()), !dbg !623
  %15 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 1, i64 0, !dbg !624
  %16 = tail call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_params to i8*), i8* nonnull %15) #4, !dbg !625
  call void @llvm.dbg.value(metadata i8* %16, metadata !598, metadata !DIExpression()), !dbg !626
  %17 = icmp eq i8* %16, null, !dbg !627
  br i1 %17, label %18, label %20, !dbg !629

; <label>:18:                                     ; preds = %13, %1
  call void @llvm.dbg.value(metadata i32 %22, metadata !597, metadata !DIExpression()), !dbg !609
  %19 = bitcast i32* %2 to i8*, !dbg !630
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %19), !dbg !630
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !488, metadata !DIExpression()) #4, !dbg !630
  call void @llvm.dbg.value(metadata i32 %22, metadata !489, metadata !DIExpression()) #4, !dbg !632
  store i32 2, i32* %2, align 4, !tbaa !501
  br label %25, !dbg !633

; <label>:20:                                     ; preds = %13
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !595, metadata !DIExpression()), !dbg !623
  %21 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 0, !dbg !634
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %21, i8* nonnull align 1 %16, i64 6, i1 false), !dbg !634
  %22 = tail call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i32 0, i32 0) #4, !dbg !635
  call void @llvm.dbg.value(metadata i32 %22, metadata !597, metadata !DIExpression()), !dbg !609
  call void @llvm.dbg.value(metadata i32 %22, metadata !597, metadata !DIExpression()), !dbg !609
  %23 = bitcast i32* %2 to i8*, !dbg !630
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %23), !dbg !630
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !488, metadata !DIExpression()) #4, !dbg !630
  call void @llvm.dbg.value(metadata i32 %22, metadata !489, metadata !DIExpression()) #4, !dbg !632
  store i32 %22, i32* %2, align 4, !tbaa !501
  %24 = icmp ugt i32 %22, 4, !dbg !636
  br i1 %24, label %42, label %25, !dbg !633

; <label>:25:                                     ; preds = %18, %20
  %26 = phi i8* [ %19, %18 ], [ %23, %20 ]
  %27 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %26) #4, !dbg !637
  %28 = icmp eq i8* %27, null, !dbg !638
  br i1 %28, label %42, label %29, !dbg !639

; <label>:29:                                     ; preds = %25
  call void @llvm.dbg.value(metadata i8* %27, metadata !490, metadata !DIExpression()) #4, !dbg !640
  %30 = bitcast i8* %27 to i64*, !dbg !641
  %31 = load i64, i64* %30, align 8, !dbg !642, !tbaa !509
  %32 = add i64 %31, 1, !dbg !642
  store i64 %32, i64* %30, align 8, !dbg !642, !tbaa !509
  %33 = load i32, i32* %3, align 4, !dbg !643, !tbaa !256
  %34 = load i32, i32* %7, align 4, !dbg !644, !tbaa !265
  %35 = sub i32 %33, %34, !dbg !645
  %36 = zext i32 %35 to i64, !dbg !646
  %37 = getelementptr inbounds i8, i8* %27, i64 8, !dbg !647
  %38 = bitcast i8* %37 to i64*, !dbg !647
  %39 = load i64, i64* %38, align 8, !dbg !648, !tbaa !518
  %40 = add i64 %39, %36, !dbg !648
  store i64 %40, i64* %38, align 8, !dbg !648, !tbaa !518
  %41 = load i32, i32* %2, align 4, !dbg !649, !tbaa !501
  call void @llvm.dbg.value(metadata i32 %41, metadata !489, metadata !DIExpression()) #4, !dbg !632
  br label %42, !dbg !650

; <label>:42:                                     ; preds = %20, %25, %29
  %43 = phi i8* [ %23, %20 ], [ %26, %29 ], [ %26, %25 ]
  %44 = phi i32 [ 0, %20 ], [ %41, %29 ], [ 0, %25 ], !dbg !651
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %43), !dbg !652
  ret i32 %44, !dbg !653
}

; Function Attrs: nounwind
define dso_local i32 @xdp_router_func(%struct.xdp_md*) #0 section "xdp_router" !dbg !654 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.bpf_fib_lookup, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !656, metadata !DIExpression()), !dbg !672
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !673
  %5 = load i32, i32* %4, align 4, !dbg !673, !tbaa !256
  %6 = zext i32 %5 to i64, !dbg !674
  %7 = inttoptr i64 %6 to i8*, !dbg !675
  call void @llvm.dbg.value(metadata i8* %7, metadata !657, metadata !DIExpression()), !dbg !676
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !677
  %9 = load i32, i32* %8, align 4, !dbg !677, !tbaa !265
  %10 = zext i32 %9 to i64, !dbg !678
  %11 = inttoptr i64 %10 to i8*, !dbg !679
  call void @llvm.dbg.value(metadata i8* %11, metadata !658, metadata !DIExpression()), !dbg !680
  %12 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 0, !dbg !681
  call void @llvm.lifetime.start.p0i8(i64 64, i8* nonnull %12) #4, !dbg !681
  call void @llvm.memset.p0i8.i64(i8* nonnull align 4 %12, i8 0, i64 64, i1 false), !dbg !682
  %13 = inttoptr i64 %10 to %struct.ethhdr*, !dbg !683
  call void @llvm.dbg.value(metadata %struct.ethhdr* %13, metadata !660, metadata !DIExpression()), !dbg !684
  call void @llvm.dbg.value(metadata i32 2, metadata !666, metadata !DIExpression()), !dbg !685
  call void @llvm.dbg.value(metadata i64 14, metadata !664, metadata !DIExpression()), !dbg !686
  %14 = getelementptr i8, i8* %11, i64 14, !dbg !687
  %15 = icmp ugt i8* %14, %7, !dbg !689
  br i1 %15, label %112, label %16, !dbg !690

; <label>:16:                                     ; preds = %1
  %17 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 2, !dbg !691
  %18 = load i16, i16* %17, align 1, !dbg !691, !tbaa !692
  call void @llvm.dbg.value(metadata i16 %18, metadata !663, metadata !DIExpression()), !dbg !694
  %19 = icmp eq i16 %18, 8, !dbg !695
  br i1 %19, label %20, label %53, !dbg !696

; <label>:20:                                     ; preds = %16
  %21 = bitcast i8* %14 to %struct.iphdr*, !dbg !697
  call void @llvm.dbg.value(metadata %struct.iphdr* %21, metadata !662, metadata !DIExpression()), !dbg !699
  %22 = getelementptr inbounds i8, i8* %11, i64 34, !dbg !700
  %23 = bitcast i8* %22 to %struct.iphdr*, !dbg !700
  %24 = inttoptr i64 %6 to %struct.iphdr*, !dbg !702
  %25 = icmp ugt %struct.iphdr* %23, %24, !dbg !703
  br i1 %25, label %112, label %26, !dbg !704

; <label>:26:                                     ; preds = %20
  %27 = getelementptr inbounds i8, i8* %11, i64 22, !dbg !705
  %28 = load i8, i8* %27, align 4, !dbg !705, !tbaa !707
  %29 = icmp ult i8 %28, 2, !dbg !708
  br i1 %29, label %112, label %30, !dbg !709

; <label>:30:                                     ; preds = %26
  store i8 2, i8* %12, align 4, !dbg !710, !tbaa !711
  %31 = getelementptr inbounds i8, i8* %11, i64 15, !dbg !713
  %32 = load i8, i8* %31, align 1, !dbg !713, !tbaa !714
  %33 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 6, !dbg !715
  %34 = bitcast %union.anon.0* %33 to i8*, !dbg !715
  store i8 %32, i8* %34, align 4, !dbg !716, !tbaa !433
  %35 = getelementptr inbounds i8, i8* %11, i64 23, !dbg !717
  %36 = load i8, i8* %35, align 1, !dbg !717, !tbaa !348
  %37 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 1, !dbg !718
  store i8 %36, i8* %37, align 1, !dbg !719, !tbaa !720
  %38 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 2, !dbg !721
  store i16 0, i16* %38, align 2, !dbg !722, !tbaa !723
  %39 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 3, !dbg !724
  store i16 0, i16* %39, align 4, !dbg !725, !tbaa !726
  %40 = getelementptr inbounds i8, i8* %11, i64 16, !dbg !727
  %41 = bitcast i8* %40 to i16*, !dbg !727
  %42 = load i16, i16* %41, align 2, !dbg !727, !tbaa !728
  %43 = tail call i16 @llvm.bswap.i16(i16 %42)
  %44 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 4, !dbg !729
  store i16 %43, i16* %44, align 2, !dbg !730, !tbaa !731
  %45 = getelementptr inbounds i8, i8* %11, i64 26, !dbg !732
  %46 = bitcast i8* %45 to i32*, !dbg !732
  %47 = load i32, i32* %46, align 4, !dbg !732, !tbaa !416
  %48 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 7, i32 0, i64 0, !dbg !733
  store i32 %47, i32* %48, align 4, !dbg !734, !tbaa !433
  %49 = getelementptr inbounds i8, i8* %11, i64 30, !dbg !735
  %50 = bitcast i8* %49 to i32*, !dbg !735
  %51 = load i32, i32* %50, align 4, !dbg !735, !tbaa !419
  %52 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 8, i32 0, i64 0, !dbg !736
  store i32 %51, i32* %52, align 4, !dbg !737, !tbaa !433
  br label %86, !dbg !738

; <label>:53:                                     ; preds = %16
  %54 = icmp eq i16 %18, -8826, !dbg !739
  br i1 %54, label %55, label %112, !dbg !740

; <label>:55:                                     ; preds = %53
  %56 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 7, i32 0, i64 0, !dbg !741
  call void @llvm.dbg.value(metadata i32* %56, metadata !667, metadata !DIExpression()), !dbg !742
  %57 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 8, i32 0, i64 0, !dbg !743
  call void @llvm.dbg.value(metadata i32* %57, metadata !671, metadata !DIExpression()), !dbg !744
  %58 = bitcast i8* %14 to %struct.ipv6hdr*, !dbg !745
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %58, metadata !661, metadata !DIExpression()), !dbg !746
  %59 = getelementptr inbounds i8, i8* %11, i64 54, !dbg !747
  %60 = bitcast i8* %59 to %struct.ipv6hdr*, !dbg !747
  %61 = inttoptr i64 %6 to %struct.ipv6hdr*, !dbg !749
  %62 = icmp ugt %struct.ipv6hdr* %60, %61, !dbg !750
  br i1 %62, label %112, label %63, !dbg !751

; <label>:63:                                     ; preds = %55
  %64 = getelementptr inbounds i8, i8* %11, i64 21, !dbg !752
  %65 = load i8, i8* %64, align 1, !dbg !752, !tbaa !754
  %66 = icmp ult i8 %65, 2, !dbg !755
  br i1 %66, label %112, label %67, !dbg !756

; <label>:67:                                     ; preds = %63
  store i8 10, i8* %12, align 4, !dbg !757, !tbaa !711
  %68 = bitcast i8* %14 to i32*, !dbg !758
  %69 = load i32, i32* %68, align 4, !dbg !758, !tbaa !501
  %70 = and i32 %69, -241, !dbg !759
  %71 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 6, i32 0, !dbg !760
  store i32 %70, i32* %71, align 4, !dbg !761, !tbaa !433
  %72 = getelementptr inbounds i8, i8* %11, i64 20, !dbg !762
  %73 = load i8, i8* %72, align 2, !dbg !762, !tbaa !375
  %74 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 1, !dbg !763
  store i8 %73, i8* %74, align 1, !dbg !764, !tbaa !720
  %75 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 2, !dbg !765
  store i16 0, i16* %75, align 2, !dbg !766, !tbaa !723
  %76 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 3, !dbg !767
  store i16 0, i16* %76, align 4, !dbg !768, !tbaa !726
  %77 = getelementptr inbounds i8, i8* %11, i64 18, !dbg !769
  %78 = bitcast i8* %77 to i16*, !dbg !769
  %79 = load i16, i16* %78, align 4, !dbg !769, !tbaa !770
  %80 = tail call i16 @llvm.bswap.i16(i16 %79)
  %81 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 4, !dbg !771
  store i16 %80, i16* %81, align 2, !dbg !772, !tbaa !731
  %82 = getelementptr inbounds i8, i8* %11, i64 22, !dbg !773
  %83 = bitcast i32* %56 to i8*, !dbg !773
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %83, i8* nonnull align 4 %82, i64 16, i1 false), !dbg !773, !tbaa.struct !432
  %84 = getelementptr inbounds i8, i8* %11, i64 38, !dbg !774
  %85 = bitcast i32* %57 to i8*, !dbg !774
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 4 %85, i8* nonnull align 4 %84, i64 16, i1 false), !dbg !774, !tbaa.struct !432
  call void @llvm.dbg.value(metadata i32 2, metadata !666, metadata !DIExpression()), !dbg !685
  br label %86

; <label>:86:                                     ; preds = %67, %30
  %87 = phi %struct.iphdr* [ %21, %30 ], [ undef, %67 ]
  %88 = phi %struct.ipv6hdr* [ undef, %30 ], [ %58, %67 ]
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %88, metadata !661, metadata !DIExpression()), !dbg !746
  call void @llvm.dbg.value(metadata i32 2, metadata !666, metadata !DIExpression()), !dbg !685
  call void @llvm.dbg.value(metadata %struct.iphdr* %87, metadata !662, metadata !DIExpression()), !dbg !699
  %89 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 3, !dbg !775
  %90 = load i32, i32* %89, align 4, !dbg !775, !tbaa !776
  %91 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 5, !dbg !777
  store i32 %90, i32* %91, align 4, !dbg !778, !tbaa !779
  %92 = bitcast %struct.xdp_md* %0 to i8*, !dbg !780
  call void @llvm.dbg.value(metadata %struct.bpf_fib_lookup* %3, metadata !659, metadata !DIExpression(DW_OP_deref)), !dbg !682
  %93 = call i32 inttoptr (i64 69 to i32 (i8*, %struct.bpf_fib_lookup*, i32, i32)*)(i8* %92, %struct.bpf_fib_lookup* nonnull %3, i32 64, i32 0) #4, !dbg !781
  call void @llvm.dbg.value(metadata i32 %93, metadata !665, metadata !DIExpression()), !dbg !782
  switch i32 %93, label %112 [
    i32 0, label %94
    i32 1, label %111
    i32 2, label %111
    i32 3, label %111
  ], !dbg !783

; <label>:94:                                     ; preds = %86
  br i1 %19, label %95, label %105, !dbg !784

; <label>:95:                                     ; preds = %94
  call void @llvm.dbg.value(metadata %struct.iphdr* %87, metadata !786, metadata !DIExpression()), !dbg !792
  %96 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %87, i64 0, i32 7, !dbg !795
  %97 = load i16, i16* %96, align 2, !dbg !795, !tbaa !796
  %98 = add i16 %97, 1, !dbg !797
  %99 = icmp ugt i16 %97, -3, !dbg !798
  %100 = zext i1 %99 to i16, !dbg !798
  %101 = add i16 %98, %100, !dbg !799
  store i16 %101, i16* %96, align 2, !dbg !800, !tbaa !796
  %102 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %87, i64 0, i32 5, !dbg !801
  %103 = load i8, i8* %102, align 4, !dbg !802, !tbaa !707
  %104 = add i8 %103, -1, !dbg !802
  store i8 %104, i8* %102, align 4, !dbg !802, !tbaa !707
  br label %115, !dbg !803

; <label>:105:                                    ; preds = %94
  %106 = icmp eq i16 %18, -8826, !dbg !804
  br i1 %106, label %107, label %115, !dbg !806

; <label>:107:                                    ; preds = %105
  %108 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %88, i64 0, i32 4, !dbg !807
  %109 = load i8, i8* %108, align 1, !dbg !808, !tbaa !754
  %110 = add i8 %109, -1, !dbg !808
  store i8 %110, i8* %108, align 1, !dbg !808, !tbaa !754
  br label %115, !dbg !809

; <label>:111:                                    ; preds = %86, %86, %86
  call void @llvm.dbg.value(metadata i32 1, metadata !666, metadata !DIExpression()), !dbg !685
  br label %112, !dbg !810

; <label>:112:                                    ; preds = %26, %86, %111, %53, %1, %20, %55, %63
  %113 = phi i32 [ 1, %20 ], [ 1, %1 ], [ 2, %53 ], [ 1, %111 ], [ 2, %86 ], [ 2, %26 ], [ 2, %63 ], [ 1, %55 ]
  call void @llvm.dbg.value(metadata i32 %121, metadata !666, metadata !DIExpression()), !dbg !685
  %114 = bitcast i32* %2 to i8*, !dbg !811
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %114), !dbg !811
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !488, metadata !DIExpression()) #4, !dbg !811
  call void @llvm.dbg.value(metadata i32 %121, metadata !489, metadata !DIExpression()) #4, !dbg !813
  store i32 %113, i32* %2, align 4, !tbaa !501
  br label %124, !dbg !814

; <label>:115:                                    ; preds = %95, %107, %105
  %116 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 0, i64 0, !dbg !815
  %117 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 12, i64 0, !dbg !815
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %116, i8* nonnull align 2 %117, i64 6, i1 false), !dbg !815
  %118 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %13, i64 0, i32 1, i64 0, !dbg !816
  %119 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 11, i64 0, !dbg !816
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 %118, i8* nonnull align 4 %119, i64 6, i1 false), !dbg !816
  %120 = load i32, i32* %91, align 4, !dbg !817, !tbaa !779
  %121 = call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i32 %120, i32 0) #4, !dbg !818
  call void @llvm.dbg.value(metadata i32 %121, metadata !666, metadata !DIExpression()), !dbg !685
  call void @llvm.dbg.value(metadata i32 %121, metadata !666, metadata !DIExpression()), !dbg !685
  %122 = bitcast i32* %2 to i8*, !dbg !811
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %122), !dbg !811
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !488, metadata !DIExpression()) #4, !dbg !811
  call void @llvm.dbg.value(metadata i32 %121, metadata !489, metadata !DIExpression()) #4, !dbg !813
  store i32 %121, i32* %2, align 4, !tbaa !501
  %123 = icmp ugt i32 %121, 4, !dbg !819
  br i1 %123, label %141, label %124, !dbg !814

; <label>:124:                                    ; preds = %112, %115
  %125 = phi i8* [ %114, %112 ], [ %122, %115 ]
  %126 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %125) #4, !dbg !820
  %127 = icmp eq i8* %126, null, !dbg !821
  br i1 %127, label %141, label %128, !dbg !822

; <label>:128:                                    ; preds = %124
  call void @llvm.dbg.value(metadata i8* %126, metadata !490, metadata !DIExpression()) #4, !dbg !823
  %129 = bitcast i8* %126 to i64*, !dbg !824
  %130 = load i64, i64* %129, align 8, !dbg !825, !tbaa !509
  %131 = add i64 %130, 1, !dbg !825
  store i64 %131, i64* %129, align 8, !dbg !825, !tbaa !509
  %132 = load i32, i32* %4, align 4, !dbg !826, !tbaa !256
  %133 = load i32, i32* %8, align 4, !dbg !827, !tbaa !265
  %134 = sub i32 %132, %133, !dbg !828
  %135 = zext i32 %134 to i64, !dbg !829
  %136 = getelementptr inbounds i8, i8* %126, i64 8, !dbg !830
  %137 = bitcast i8* %136 to i64*, !dbg !830
  %138 = load i64, i64* %137, align 8, !dbg !831, !tbaa !518
  %139 = add i64 %138, %135, !dbg !831
  store i64 %139, i64* %137, align 8, !dbg !831, !tbaa !518
  %140 = load i32, i32* %2, align 4, !dbg !832, !tbaa !501
  call void @llvm.dbg.value(metadata i32 %140, metadata !489, metadata !DIExpression()) #4, !dbg !813
  br label %141, !dbg !833

; <label>:141:                                    ; preds = %115, %124, %128
  %142 = phi i8* [ %122, %115 ], [ %125, %128 ], [ %125, %124 ]
  %143 = phi i32 [ 0, %115 ], [ %140, %128 ], [ 0, %124 ], !dbg !834
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %142), !dbg !835
  call void @llvm.lifetime.end.p0i8(i64 64, i8* nonnull %12) #4, !dbg !836
  ret i32 %143, !dbg !836
}

; Function Attrs: nounwind readnone speculatable
declare i16 @llvm.bswap.i16(i16) #1

; Function Attrs: norecurse nounwind readnone
define dso_local i32 @xdp_pass_func(%struct.xdp_md* nocapture readnone) #3 section "xdp_pass" !dbg !837 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !839, metadata !DIExpression()), !dbg !840
  ret i32 2, !dbg !841
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { norecurse nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!154, !155, !156}
!llvm.ident = !{!157}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !153, line: 16, type: !78, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !43, globals: !75, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern_03.c", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
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
!43 = !{!44, !45, !46, !49, !74, !71}
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!45 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !47, line: 24, baseType: !48)
!47 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!48 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !51, line: 33, size: 128, elements: !52)
!51 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "")
!52 = !{!53}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !50, file: !51, line: 40, baseType: !54, size: 128)
!54 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !50, file: !51, line: 34, size: 128, elements: !55)
!55 = !{!56, !62, !68}
!56 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !54, file: !51, line: 35, baseType: !57, size: 128)
!57 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 128, elements: !60)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !47, line: 21, baseType: !59)
!59 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!60 = !{!61}
!61 = !DISubrange(count: 16)
!62 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !54, file: !51, line: 37, baseType: !63, size: 128)
!63 = !DICompositeType(tag: DW_TAG_array_type, baseType: !64, size: 128, elements: !66)
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !65, line: 25, baseType: !46)
!65 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!66 = !{!67}
!67 = !DISubrange(count: 8)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !54, file: !51, line: 38, baseType: !69, size: 128)
!69 = !DICompositeType(tag: DW_TAG_array_type, baseType: !70, size: 128, elements: !72)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !65, line: 27, baseType: !71)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!72 = !{!73}
!73 = !DISubrange(count: 4)
!74 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!75 = !{!0, !76, !88, !90, !94, !100, !105, !110, !115}
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(name: "tx_port", scope: !2, file: !3, line: 19, type: !78, isLocal: false, isDefinition: true)
!78 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !79, line: 210, size: 224, elements: !80)
!79 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!80 = !{!81, !82, !83, !84, !85, !86, !87}
!81 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !78, file: !79, line: 211, baseType: !7, size: 32)
!82 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !78, file: !79, line: 212, baseType: !7, size: 32, offset: 32)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !78, file: !79, line: 213, baseType: !7, size: 32, offset: 64)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !78, file: !79, line: 214, baseType: !7, size: 32, offset: 96)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !78, file: !79, line: 215, baseType: !7, size: 32, offset: 128)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !78, file: !79, line: 216, baseType: !7, size: 32, offset: 160)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !78, file: !79, line: 217, baseType: !7, size: 32, offset: 192)
!88 = !DIGlobalVariableExpression(var: !89, expr: !DIExpression())
!89 = distinct !DIGlobalVariable(name: "redirect_params", scope: !2, file: !3, line: 26, type: !78, isLocal: false, isDefinition: true)
!90 = !DIGlobalVariableExpression(var: !91, expr: !DIExpression())
!91 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 328, type: !92, isLocal: false, isDefinition: true)
!92 = !DICompositeType(tag: DW_TAG_array_type, baseType: !93, size: 32, elements: !72)
!93 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!94 = !DIGlobalVariableExpression(var: !95, expr: !DIExpression())
!95 = distinct !DIGlobalVariable(name: "bpf_csum_diff", scope: !2, file: !79, line: 239, type: !96, isLocal: true, isDefinition: true)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = !DISubroutineType(types: !98)
!98 = !{!99, !44, !99, !44, !99, !99}
!99 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!100 = !DIGlobalVariableExpression(var: !101, expr: !DIExpression())
!101 = distinct !DIGlobalVariable(name: "bpf_redirect", scope: !2, file: !79, line: 55, type: !102, isLocal: true, isDefinition: true)
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !103, size: 64)
!103 = !DISubroutineType(types: !104)
!104 = !{!99, !99, !99}
!105 = !DIGlobalVariableExpression(var: !106, expr: !DIExpression())
!106 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !79, line: 20, type: !107, isLocal: true, isDefinition: true)
!107 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !108, size: 64)
!108 = !DISubroutineType(types: !109)
!109 = !{!44, !44, !44}
!110 = !DIGlobalVariableExpression(var: !111, expr: !DIExpression())
!111 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !79, line: 57, type: !112, isLocal: true, isDefinition: true)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = !DISubroutineType(types: !114)
!114 = !{!99, !44, !99, !99}
!115 = !DIGlobalVariableExpression(var: !116, expr: !DIExpression())
!116 = distinct !DIGlobalVariable(name: "bpf_fib_lookup", scope: !2, file: !79, line: 137, type: !117, isLocal: true, isDefinition: true)
!117 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !118, size: 64)
!118 = !DISubroutineType(types: !119)
!119 = !{!99, !44, !120, !99, !71}
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !121, size: 64)
!121 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_fib_lookup", file: !6, line: 3179, size: 512, elements: !122)
!122 = !{!123, !124, !125, !126, !127, !128, !129, !135, !141, !146, !147, !148, !152}
!123 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !121, file: !6, line: 3183, baseType: !58, size: 8)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "l4_protocol", scope: !121, file: !6, line: 3186, baseType: !58, size: 8, offset: 8)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !121, file: !6, line: 3187, baseType: !64, size: 16, offset: 16)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !121, file: !6, line: 3188, baseType: !64, size: 16, offset: 32)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !121, file: !6, line: 3191, baseType: !46, size: 16, offset: 48)
!128 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !121, file: !6, line: 3196, baseType: !71, size: 32, offset: 64)
!129 = !DIDerivedType(tag: DW_TAG_member, scope: !121, file: !6, line: 3198, baseType: !130, size: 32, offset: 96)
!130 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !121, file: !6, line: 3198, size: 32, elements: !131)
!131 = !{!132, !133, !134}
!132 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !130, file: !6, line: 3200, baseType: !58, size: 8)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "flowinfo", scope: !130, file: !6, line: 3201, baseType: !70, size: 32)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "rt_metric", scope: !130, file: !6, line: 3204, baseType: !71, size: 32)
!135 = !DIDerivedType(tag: DW_TAG_member, scope: !121, file: !6, line: 3207, baseType: !136, size: 128, offset: 128)
!136 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !121, file: !6, line: 3207, size: 128, elements: !137)
!137 = !{!138, !139}
!138 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !136, file: !6, line: 3208, baseType: !70, size: 32)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !136, file: !6, line: 3209, baseType: !140, size: 128)
!140 = !DICompositeType(tag: DW_TAG_array_type, baseType: !71, size: 128, elements: !72)
!141 = !DIDerivedType(tag: DW_TAG_member, scope: !121, file: !6, line: 3216, baseType: !142, size: 128, offset: 256)
!142 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !121, file: !6, line: 3216, size: 128, elements: !143)
!143 = !{!144, !145}
!144 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !142, file: !6, line: 3217, baseType: !70, size: 32)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !142, file: !6, line: 3218, baseType: !140, size: 128)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_proto", scope: !121, file: !6, line: 3222, baseType: !64, size: 16, offset: 384)
!147 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !121, file: !6, line: 3223, baseType: !64, size: 16, offset: 400)
!148 = !DIDerivedType(tag: DW_TAG_member, name: "smac", scope: !121, file: !6, line: 3224, baseType: !149, size: 48, offset: 416)
!149 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 48, elements: !150)
!150 = !{!151}
!151 = !DISubrange(count: 6)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "dmac", scope: !121, file: !6, line: 3225, baseType: !149, size: 48, offset: 464)
!153 = !DIFile(filename: "./../common/xdp_stats_kern.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!154 = !{i32 2, !"Dwarf Version", i32 4}
!155 = !{i32 2, !"Debug Info Version", i32 3}
!156 = !{i32 1, !"wchar_size", i32 4}
!157 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!158 = distinct !DISubprogram(name: "xdp_icmp_echo_func", scope: !3, file: !3, line: 58, type: !159, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !169)
!159 = !DISubroutineType(types: !160)
!160 = !{!99, !161}
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!162 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !163)
!163 = !{!164, !165, !166, !167, !168}
!164 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !162, file: !6, line: 2857, baseType: !71, size: 32)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !162, file: !6, line: 2858, baseType: !71, size: 32, offset: 32)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !162, file: !6, line: 2859, baseType: !71, size: 32, offset: 64)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !162, file: !6, line: 2861, baseType: !71, size: 32, offset: 96)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !162, file: !6, line: 2862, baseType: !71, size: 32, offset: 128)
!169 = !{!170, !171, !172, !173, !178, !187, !188, !189, !190, !207, !223, !224, !225, !232, !233}
!170 = !DILocalVariable(name: "ctx", arg: 1, scope: !158, file: !3, line: 58, type: !161)
!171 = !DILocalVariable(name: "data_end", scope: !158, file: !3, line: 60, type: !44)
!172 = !DILocalVariable(name: "data", scope: !158, file: !3, line: 61, type: !44)
!173 = !DILocalVariable(name: "nh", scope: !158, file: !3, line: 62, type: !174)
!174 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !175, line: 33, size: 64, elements: !176)
!175 = !DIFile(filename: "./../common/parsing_helpers.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!176 = !{!177}
!177 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !174, file: !175, line: 34, baseType: !44, size: 64)
!178 = !DILocalVariable(name: "eth", scope: !158, file: !3, line: 63, type: !179)
!179 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !180, size: 64)
!180 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !181, line: 161, size: 112, elements: !182)
!181 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!182 = !{!183, !185, !186}
!183 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !180, file: !181, line: 162, baseType: !184, size: 48)
!184 = !DICompositeType(tag: DW_TAG_array_type, baseType: !59, size: 48, elements: !150)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !180, file: !181, line: 163, baseType: !184, size: 48, offset: 48)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !180, file: !181, line: 164, baseType: !64, size: 16, offset: 96)
!187 = !DILocalVariable(name: "eth_type", scope: !158, file: !3, line: 64, type: !99)
!188 = !DILocalVariable(name: "ip_type", scope: !158, file: !3, line: 65, type: !99)
!189 = !DILocalVariable(name: "icmp_type", scope: !158, file: !3, line: 66, type: !99)
!190 = !DILocalVariable(name: "iphdr", scope: !158, file: !3, line: 67, type: !191)
!191 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !192, size: 64)
!192 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !193, line: 86, size: 160, elements: !194)
!193 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "")
!194 = !{!195, !196, !197, !198, !199, !200, !201, !202, !203, !205, !206}
!195 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !192, file: !193, line: 88, baseType: !58, size: 4, flags: DIFlagBitField, extraData: i64 0)
!196 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !192, file: !193, line: 89, baseType: !58, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!197 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !192, file: !193, line: 96, baseType: !58, size: 8, offset: 8)
!198 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !192, file: !193, line: 97, baseType: !64, size: 16, offset: 16)
!199 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !192, file: !193, line: 98, baseType: !64, size: 16, offset: 32)
!200 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !192, file: !193, line: 99, baseType: !64, size: 16, offset: 48)
!201 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !192, file: !193, line: 100, baseType: !58, size: 8, offset: 64)
!202 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !192, file: !193, line: 101, baseType: !58, size: 8, offset: 72)
!203 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !192, file: !193, line: 102, baseType: !204, size: 16, offset: 80)
!204 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !65, line: 31, baseType: !46)
!205 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !192, file: !193, line: 103, baseType: !70, size: 32, offset: 96)
!206 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !192, file: !193, line: 104, baseType: !70, size: 32, offset: 128)
!207 = !DILocalVariable(name: "ipv6hdr", scope: !158, file: !3, line: 68, type: !208)
!208 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !209, size: 64)
!209 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !210, line: 116, size: 320, elements: !211)
!210 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "")
!211 = !{!212, !213, !214, !218, !219, !220, !221, !222}
!212 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !209, file: !210, line: 118, baseType: !58, size: 4, flags: DIFlagBitField, extraData: i64 0)
!213 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !209, file: !210, line: 119, baseType: !58, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!214 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !209, file: !210, line: 126, baseType: !215, size: 24, offset: 8)
!215 = !DICompositeType(tag: DW_TAG_array_type, baseType: !58, size: 24, elements: !216)
!216 = !{!217}
!217 = !DISubrange(count: 3)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !209, file: !210, line: 128, baseType: !64, size: 16, offset: 32)
!219 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !209, file: !210, line: 129, baseType: !58, size: 8, offset: 48)
!220 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !209, file: !210, line: 130, baseType: !58, size: 8, offset: 56)
!221 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !209, file: !210, line: 132, baseType: !50, size: 128, offset: 64)
!222 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !209, file: !210, line: 133, baseType: !50, size: 128, offset: 192)
!223 = !DILocalVariable(name: "echo_reply", scope: !158, file: !3, line: 69, type: !46)
!224 = !DILocalVariable(name: "old_csum", scope: !158, file: !3, line: 69, type: !46)
!225 = !DILocalVariable(name: "icmphdr", scope: !158, file: !3, line: 70, type: !226)
!226 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !227, size: 64)
!227 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmphdr_common", file: !175, line: 51, size: 32, elements: !228)
!228 = !{!229, !230, !231}
!229 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !227, file: !175, line: 52, baseType: !58, size: 8)
!230 = !DIDerivedType(tag: DW_TAG_member, name: "code", scope: !227, file: !175, line: 53, baseType: !58, size: 8, offset: 8)
!231 = !DIDerivedType(tag: DW_TAG_member, name: "cksum", scope: !227, file: !175, line: 54, baseType: !204, size: 16, offset: 16)
!232 = !DILocalVariable(name: "icmphdr_old", scope: !158, file: !3, line: 71, type: !227)
!233 = !DILocalVariable(name: "action", scope: !158, file: !3, line: 72, type: !71)
!234 = !DILocalVariable(name: "tmp", scope: !235, file: !236, line: 127, type: !50)
!235 = distinct !DISubprogram(name: "swap_src_dst_ipv6", scope: !236, file: !236, line: 125, type: !237, scopeLine: 126, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !239)
!236 = !DIFile(filename: "./../common/rewrite_helpers.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!237 = !DISubroutineType(types: !238)
!238 = !{null, !208}
!239 = !{!240, !234}
!240 = !DILocalVariable(name: "ipv6", arg: 1, scope: !235, file: !236, line: 125, type: !208)
!241 = !DILocation(line: 127, column: 18, scope: !235, inlinedAt: !242)
!242 = distinct !DILocation(line: 105, column: 3, scope: !243)
!243 = distinct !DILexicalBlock(scope: !244, file: !3, line: 103, column: 43)
!244 = distinct !DILexicalBlock(scope: !245, file: !3, line: 102, column: 13)
!245 = distinct !DILexicalBlock(scope: !158, file: !3, line: 98, column: 6)
!246 = !DILocalVariable(name: "h_tmp", scope: !247, file: !236, line: 115, type: !149)
!247 = distinct !DISubprogram(name: "swap_src_dst_mac", scope: !236, file: !236, line: 113, type: !248, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !250)
!248 = !DISubroutineType(types: !249)
!249 = !{null, !179}
!250 = !{!251, !246}
!251 = !DILocalVariable(name: "eth", arg: 1, scope: !247, file: !236, line: 113, type: !179)
!252 = !DILocation(line: 115, column: 7, scope: !247, inlinedAt: !253)
!253 = distinct !DILocation(line: 112, column: 2, scope: !158)
!254 = !DILocation(line: 58, column: 39, scope: !158)
!255 = !DILocation(line: 60, column: 38, scope: !158)
!256 = !{!257, !258, i64 4}
!257 = !{!"xdp_md", !258, i64 0, !258, i64 4, !258, i64 8, !258, i64 12, !258, i64 16}
!258 = !{!"int", !259, i64 0}
!259 = !{!"omnipotent char", !260, i64 0}
!260 = !{!"Simple C/C++ TBAA"}
!261 = !DILocation(line: 60, column: 27, scope: !158)
!262 = !DILocation(line: 60, column: 19, scope: !158)
!263 = !DILocation(line: 60, column: 8, scope: !158)
!264 = !DILocation(line: 61, column: 34, scope: !158)
!265 = !{!257, !258, i64 0}
!266 = !DILocation(line: 61, column: 23, scope: !158)
!267 = !DILocation(line: 61, column: 15, scope: !158)
!268 = !DILocation(line: 61, column: 8, scope: !158)
!269 = !DILocation(line: 71, column: 2, scope: !158)
!270 = !DILocation(line: 72, column: 8, scope: !158)
!271 = !DILocation(line: 62, column: 20, scope: !158)
!272 = !DILocalVariable(name: "nh", arg: 1, scope: !273, file: !175, line: 73, type: !276)
!273 = distinct !DISubprogram(name: "parse_ethhdr", scope: !175, file: !175, line: 73, type: !274, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !278)
!274 = !DISubroutineType(types: !275)
!275 = !{!99, !276, !44, !277}
!276 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !174, size: 64)
!277 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !179, size: 64)
!278 = !{!272, !279, !280, !281, !282, !283, !289, !290}
!279 = !DILocalVariable(name: "data_end", arg: 2, scope: !273, file: !175, line: 73, type: !44)
!280 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !273, file: !175, line: 74, type: !277)
!281 = !DILocalVariable(name: "eth", scope: !273, file: !175, line: 76, type: !179)
!282 = !DILocalVariable(name: "hdrsize", scope: !273, file: !175, line: 77, type: !99)
!283 = !DILocalVariable(name: "vlh", scope: !273, file: !175, line: 78, type: !284)
!284 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !285, size: 64)
!285 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !175, line: 42, size: 32, elements: !286)
!286 = !{!287, !288}
!287 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !285, file: !175, line: 43, baseType: !64, size: 16)
!288 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !285, file: !175, line: 44, baseType: !64, size: 16, offset: 16)
!289 = !DILocalVariable(name: "h_proto", scope: !273, file: !175, line: 79, type: !46)
!290 = !DILocalVariable(name: "i", scope: !273, file: !175, line: 80, type: !99)
!291 = !DILocation(line: 73, column: 60, scope: !273, inlinedAt: !292)
!292 = distinct !DILocation(line: 78, column: 13, scope: !158)
!293 = !DILocation(line: 73, column: 70, scope: !273, inlinedAt: !292)
!294 = !DILocation(line: 77, column: 6, scope: !273, inlinedAt: !292)
!295 = !DILocation(line: 85, column: 14, scope: !296, inlinedAt: !292)
!296 = distinct !DILexicalBlock(scope: !273, file: !175, line: 85, column: 6)
!297 = !DILocation(line: 85, column: 24, scope: !296, inlinedAt: !292)
!298 = !DILocation(line: 85, column: 6, scope: !273, inlinedAt: !292)
!299 = !DILocation(line: 76, column: 17, scope: !273, inlinedAt: !292)
!300 = !DILocation(line: 89, column: 10, scope: !273, inlinedAt: !292)
!301 = !DILocation(line: 78, column: 19, scope: !273, inlinedAt: !292)
!302 = !DILocation(line: 91, column: 17, scope: !273, inlinedAt: !292)
!303 = !DILocation(line: 79, column: 8, scope: !273, inlinedAt: !292)
!304 = !DILocation(line: 80, column: 6, scope: !273, inlinedAt: !292)
!305 = !DILocation(line: 0, scope: !273, inlinedAt: !292)
!306 = !{!307, !307, i64 0}
!307 = !{!"short", !259, i64 0}
!308 = !DILocation(line: 98, column: 7, scope: !309, inlinedAt: !292)
!309 = distinct !DILexicalBlock(scope: !310, file: !175, line: 97, column: 39)
!310 = distinct !DILexicalBlock(scope: !311, file: !175, line: 97, column: 2)
!311 = distinct !DILexicalBlock(scope: !273, file: !175, line: 97, column: 2)
!312 = !DILocation(line: 101, column: 11, scope: !313, inlinedAt: !292)
!313 = distinct !DILexicalBlock(scope: !309, file: !175, line: 101, column: 7)
!314 = !DILocation(line: 101, column: 15, scope: !313, inlinedAt: !292)
!315 = !DILocation(line: 101, column: 7, scope: !309, inlinedAt: !292)
!316 = !DILocation(line: 104, column: 18, scope: !309, inlinedAt: !292)
!317 = !DILocation(line: 64, column: 6, scope: !158)
!318 = !DILocation(line: 79, column: 6, scope: !158)
!319 = !DILocalVariable(name: "nh", arg: 1, scope: !320, file: !175, line: 131, type: !276)
!320 = distinct !DISubprogram(name: "parse_iphdr", scope: !175, file: !175, line: 131, type: !321, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !324)
!321 = !DISubroutineType(types: !322)
!322 = !{!99, !276, !44, !323}
!323 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !191, size: 64)
!324 = !{!319, !325, !326, !327, !328}
!325 = !DILocalVariable(name: "data_end", arg: 2, scope: !320, file: !175, line: 132, type: !44)
!326 = !DILocalVariable(name: "iphdr", arg: 3, scope: !320, file: !175, line: 133, type: !323)
!327 = !DILocalVariable(name: "iph", scope: !320, file: !175, line: 135, type: !191)
!328 = !DILocalVariable(name: "hdrsize", scope: !320, file: !175, line: 136, type: !99)
!329 = !DILocation(line: 131, column: 59, scope: !320, inlinedAt: !330)
!330 = distinct !DILocation(line: 80, column: 13, scope: !331)
!331 = distinct !DILexicalBlock(scope: !332, file: !3, line: 79, column: 39)
!332 = distinct !DILexicalBlock(scope: !158, file: !3, line: 79, column: 6)
!333 = !DILocation(line: 132, column: 18, scope: !320, inlinedAt: !330)
!334 = !DILocation(line: 135, column: 16, scope: !320, inlinedAt: !330)
!335 = !DILocation(line: 138, column: 10, scope: !336, inlinedAt: !330)
!336 = distinct !DILexicalBlock(scope: !320, file: !175, line: 138, column: 6)
!337 = !DILocation(line: 138, column: 14, scope: !336, inlinedAt: !330)
!338 = !DILocation(line: 138, column: 6, scope: !320, inlinedAt: !330)
!339 = !DILocation(line: 141, column: 17, scope: !320, inlinedAt: !330)
!340 = !DILocation(line: 141, column: 21, scope: !320, inlinedAt: !330)
!341 = !DILocation(line: 144, column: 14, scope: !342, inlinedAt: !330)
!342 = distinct !DILexicalBlock(scope: !320, file: !175, line: 144, column: 6)
!343 = !DILocation(line: 136, column: 6, scope: !320, inlinedAt: !330)
!344 = !DILocation(line: 144, column: 24, scope: !342, inlinedAt: !330)
!345 = !DILocation(line: 144, column: 6, scope: !320, inlinedAt: !330)
!346 = !DILocation(line: 148, column: 9, scope: !320, inlinedAt: !330)
!347 = !DILocation(line: 150, column: 14, scope: !320, inlinedAt: !330)
!348 = !{!349, !259, i64 9}
!349 = !{!"iphdr", !259, i64 0, !259, i64 0, !259, i64 1, !307, i64 2, !307, i64 4, !307, i64 6, !259, i64 8, !259, i64 9, !307, i64 10, !258, i64 12, !258, i64 16}
!350 = !DILocation(line: 81, column: 15, scope: !351)
!351 = distinct !DILexicalBlock(scope: !331, file: !3, line: 81, column: 7)
!352 = !DILocation(line: 81, column: 7, scope: !331)
!353 = !DILocalVariable(name: "nh", arg: 1, scope: !354, file: !175, line: 112, type: !276)
!354 = distinct !DISubprogram(name: "parse_ip6hdr", scope: !175, file: !175, line: 112, type: !355, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !358)
!355 = !DISubroutineType(types: !356)
!356 = !{!99, !276, !44, !357}
!357 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !208, size: 64)
!358 = !{!353, !359, !360, !361}
!359 = !DILocalVariable(name: "data_end", arg: 2, scope: !354, file: !175, line: 113, type: !44)
!360 = !DILocalVariable(name: "ip6hdr", arg: 3, scope: !354, file: !175, line: 114, type: !357)
!361 = !DILocalVariable(name: "ip6h", scope: !354, file: !175, line: 116, type: !208)
!362 = !DILocation(line: 112, column: 60, scope: !354, inlinedAt: !363)
!363 = distinct !DILocation(line: 84, column: 13, scope: !364)
!364 = distinct !DILexicalBlock(scope: !365, file: !3, line: 83, column: 48)
!365 = distinct !DILexicalBlock(scope: !332, file: !3, line: 83, column: 13)
!366 = !DILocation(line: 113, column: 12, scope: !354, inlinedAt: !363)
!367 = !DILocation(line: 122, column: 11, scope: !368, inlinedAt: !363)
!368 = distinct !DILexicalBlock(scope: !354, file: !175, line: 122, column: 6)
!369 = !DILocation(line: 122, column: 17, scope: !368, inlinedAt: !363)
!370 = !DILocation(line: 122, column: 15, scope: !368, inlinedAt: !363)
!371 = !DILocation(line: 122, column: 6, scope: !354, inlinedAt: !363)
!372 = !DILocation(line: 116, column: 29, scope: !354, inlinedAt: !363)
!373 = !DILocation(line: 116, column: 18, scope: !354, inlinedAt: !363)
!374 = !DILocation(line: 128, column: 15, scope: !354, inlinedAt: !363)
!375 = !{!376, !259, i64 6}
!376 = !{!"ipv6hdr", !259, i64 0, !259, i64 0, !259, i64 1, !307, i64 4, !259, i64 6, !259, i64 7, !377, i64 8, !377, i64 24}
!377 = !{!"in6_addr", !259, i64 0}
!378 = !DILocation(line: 85, column: 15, scope: !379)
!379 = distinct !DILexicalBlock(scope: !364, file: !3, line: 85, column: 7)
!380 = !DILocation(line: 85, column: 7, scope: !364)
!381 = !DILocation(line: 75, column: 9, scope: !158)
!382 = !DILocalVariable(name: "nh", arg: 1, scope: !383, file: !175, line: 183, type: !276)
!383 = distinct !DISubprogram(name: "parse_icmphdr_common", scope: !175, file: !175, line: 183, type: !384, scopeLine: 186, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !387)
!384 = !DISubroutineType(types: !385)
!385 = !{!99, !276, !44, !386}
!386 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !226, size: 64)
!387 = !{!382, !388, !389, !390}
!388 = !DILocalVariable(name: "data_end", arg: 2, scope: !383, file: !175, line: 184, type: !44)
!389 = !DILocalVariable(name: "icmphdr", arg: 3, scope: !383, file: !175, line: 185, type: !386)
!390 = !DILocalVariable(name: "h", scope: !383, file: !175, line: 187, type: !226)
!391 = !DILocation(line: 183, column: 68, scope: !383, inlinedAt: !392)
!392 = distinct !DILocation(line: 97, column: 14, scope: !158)
!393 = !DILocation(line: 184, column: 13, scope: !383, inlinedAt: !392)
!394 = !DILocation(line: 187, column: 25, scope: !383, inlinedAt: !392)
!395 = !DILocation(line: 189, column: 8, scope: !396, inlinedAt: !392)
!396 = distinct !DILexicalBlock(scope: !383, file: !175, line: 189, column: 6)
!397 = !DILocation(line: 189, column: 14, scope: !396, inlinedAt: !392)
!398 = !DILocation(line: 189, column: 12, scope: !396, inlinedAt: !392)
!399 = !DILocation(line: 189, column: 6, scope: !383, inlinedAt: !392)
!400 = !DILocation(line: 195, column: 12, scope: !383, inlinedAt: !392)
!401 = !{!402, !259, i64 0}
!402 = !{!"icmphdr_common", !259, i64 0, !259, i64 1, !307, i64 2}
!403 = !DILocation(line: 98, column: 51, scope: !245)
!404 = !DILocation(line: 98, column: 38, scope: !245)
!405 = !DILocation(line: 67, column: 16, scope: !158)
!406 = !DILocalVariable(name: "iphdr", arg: 1, scope: !407, file: !236, line: 136, type: !191)
!407 = distinct !DISubprogram(name: "swap_src_dst_ipv4", scope: !236, file: !236, line: 136, type: !408, scopeLine: 137, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !410)
!408 = !DISubroutineType(types: !409)
!409 = !{null, !191}
!410 = !{!406, !411}
!411 = !DILocalVariable(name: "tmp", scope: !407, file: !236, line: 138, type: !70)
!412 = !DILocation(line: 136, column: 61, scope: !407, inlinedAt: !413)
!413 = distinct !DILocation(line: 100, column: 3, scope: !414)
!414 = distinct !DILexicalBlock(scope: !245, file: !3, line: 98, column: 65)
!415 = !DILocation(line: 138, column: 22, scope: !407, inlinedAt: !413)
!416 = !{!349, !258, i64 12}
!417 = !DILocation(line: 138, column: 9, scope: !407, inlinedAt: !413)
!418 = !DILocation(line: 140, column: 24, scope: !407, inlinedAt: !413)
!419 = !{!349, !258, i64 16}
!420 = !DILocation(line: 140, column: 15, scope: !407, inlinedAt: !413)
!421 = !DILocation(line: 141, column: 15, scope: !407, inlinedAt: !413)
!422 = !DILocation(line: 69, column: 8, scope: !158)
!423 = !DILocation(line: 102, column: 2, scope: !414)
!424 = !DILocation(line: 102, column: 22, scope: !244)
!425 = !DILocation(line: 103, column: 19, scope: !244)
!426 = !DILocation(line: 103, column: 6, scope: !244)
!427 = !DILocation(line: 68, column: 18, scope: !158)
!428 = !DILocation(line: 125, column: 63, scope: !235, inlinedAt: !242)
!429 = !DILocation(line: 127, column: 2, scope: !235, inlinedAt: !242)
!430 = !DILocation(line: 127, column: 30, scope: !235, inlinedAt: !242)
!431 = !DILocation(line: 129, column: 22, scope: !235, inlinedAt: !242)
!432 = !{i64 0, i64 16, !433, i64 0, i64 16, !433, i64 0, i64 16, !433}
!433 = !{!259, !259, i64 0}
!434 = !DILocation(line: 130, column: 16, scope: !235, inlinedAt: !242)
!435 = !DILocation(line: 131, column: 1, scope: !235, inlinedAt: !242)
!436 = !DILocation(line: 63, column: 17, scope: !158)
!437 = !DILocation(line: 113, column: 61, scope: !247, inlinedAt: !253)
!438 = !DILocation(line: 115, column: 2, scope: !247, inlinedAt: !253)
!439 = !DILocation(line: 117, column: 2, scope: !247, inlinedAt: !253)
!440 = !DILocation(line: 118, column: 2, scope: !247, inlinedAt: !253)
!441 = !DILocation(line: 119, column: 2, scope: !247, inlinedAt: !253)
!442 = !DILocation(line: 120, column: 1, scope: !247, inlinedAt: !253)
!443 = !DILocation(line: 70, column: 25, scope: !158)
!444 = !DILocation(line: 116, column: 22, scope: !158)
!445 = !{!402, !307, i64 2}
!446 = !DILocation(line: 69, column: 20, scope: !158)
!447 = !DILocation(line: 117, column: 17, scope: !158)
!448 = !DILocation(line: 118, column: 17, scope: !158)
!449 = !DILocation(line: 118, column: 16, scope: !158)
!450 = !DILocation(line: 119, column: 16, scope: !158)
!451 = !DILocation(line: 120, column: 38, scope: !158)
!452 = !DILocation(line: 71, column: 24, scope: !158)
!453 = !DILocalVariable(name: "seed", arg: 1, scope: !454, file: !3, line: 46, type: !46)
!454 = distinct !DISubprogram(name: "icmp_checksum_diff", scope: !3, file: !3, line: 45, type: !455, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !457)
!455 = !DISubroutineType(types: !456)
!456 = !{!46, !46, !226, !226}
!457 = !{!453, !458, !459, !460, !461}
!458 = !DILocalVariable(name: "icmphdr_new", arg: 2, scope: !454, file: !3, line: 47, type: !226)
!459 = !DILocalVariable(name: "icmphdr_old", arg: 3, scope: !454, file: !3, line: 48, type: !226)
!460 = !DILocalVariable(name: "csum", scope: !454, file: !3, line: 50, type: !71)
!461 = !DILocalVariable(name: "size", scope: !454, file: !3, line: 50, type: !71)
!462 = !DILocation(line: 46, column: 9, scope: !454, inlinedAt: !463)
!463 = distinct !DILocation(line: 120, column: 19, scope: !158)
!464 = !DILocation(line: 47, column: 26, scope: !454, inlinedAt: !463)
!465 = !DILocation(line: 48, column: 26, scope: !454, inlinedAt: !463)
!466 = !DILocation(line: 50, column: 14, scope: !454, inlinedAt: !463)
!467 = !DILocation(line: 52, column: 61, scope: !454, inlinedAt: !463)
!468 = !DILocation(line: 52, column: 9, scope: !454, inlinedAt: !463)
!469 = !DILocation(line: 50, column: 8, scope: !454, inlinedAt: !463)
!470 = !DILocalVariable(name: "csum", arg: 1, scope: !471, file: !3, line: 33, type: !71)
!471 = distinct !DISubprogram(name: "csum_fold_helper", scope: !3, file: !3, line: 33, type: !472, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !474)
!472 = !DISubroutineType(types: !473)
!473 = !{!46, !71}
!474 = !{!470}
!475 = !DILocation(line: 33, column: 53, scope: !471, inlinedAt: !476)
!476 = distinct !DILocation(line: 53, column: 9, scope: !454, inlinedAt: !463)
!477 = !DILocation(line: 35, column: 35, scope: !471, inlinedAt: !476)
!478 = !DILocation(line: 35, column: 27, scope: !471, inlinedAt: !476)
!479 = !DILocation(line: 35, column: 9, scope: !471, inlinedAt: !476)
!480 = !DILocation(line: 120, column: 17, scope: !158)
!481 = !DILocation(line: 143, column: 2, scope: !158)
!482 = !DILocation(line: 0, scope: !158)
!483 = !DILocation(line: 24, column: 46, scope: !484, inlinedAt: !499)
!484 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !153, file: !153, line: 24, type: !485, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !487)
!485 = !DISubroutineType(types: !486)
!486 = !{!71, !161, !71}
!487 = !{!488, !489, !490}
!488 = !DILocalVariable(name: "ctx", arg: 1, scope: !484, file: !153, line: 24, type: !161)
!489 = !DILocalVariable(name: "action", arg: 2, scope: !484, file: !153, line: 24, type: !71)
!490 = !DILocalVariable(name: "rec", scope: !484, file: !153, line: 30, type: !491)
!491 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !492, size: 64)
!492 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !493, line: 10, size: 128, elements: !494)
!493 = !DIFile(filename: "./../common/xdp_stats_kern_user.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!494 = !{!495, !498}
!495 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !492, file: !493, line: 11, baseType: !496, size: 64)
!496 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !497)
!497 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!498 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !492, file: !493, line: 12, baseType: !496, size: 64, offset: 64)
!499 = distinct !DILocation(line: 146, column: 9, scope: !158)
!500 = !DILocation(line: 24, column: 57, scope: !484, inlinedAt: !499)
!501 = !{!258, !258, i64 0}
!502 = !DILocation(line: 30, column: 24, scope: !484, inlinedAt: !499)
!503 = !DILocation(line: 31, column: 7, scope: !504, inlinedAt: !499)
!504 = distinct !DILexicalBlock(scope: !484, file: !153, line: 31, column: 6)
!505 = !DILocation(line: 31, column: 6, scope: !484, inlinedAt: !499)
!506 = !DILocation(line: 30, column: 18, scope: !484, inlinedAt: !499)
!507 = !DILocation(line: 38, column: 7, scope: !484, inlinedAt: !499)
!508 = !DILocation(line: 38, column: 17, scope: !484, inlinedAt: !499)
!509 = !{!510, !511, i64 0}
!510 = !{!"datarec", !511, i64 0, !511, i64 8}
!511 = !{!"long long", !259, i64 0}
!512 = !DILocation(line: 39, column: 25, scope: !484, inlinedAt: !499)
!513 = !DILocation(line: 39, column: 41, scope: !484, inlinedAt: !499)
!514 = !DILocation(line: 39, column: 34, scope: !484, inlinedAt: !499)
!515 = !DILocation(line: 39, column: 19, scope: !484, inlinedAt: !499)
!516 = !DILocation(line: 39, column: 7, scope: !484, inlinedAt: !499)
!517 = !DILocation(line: 39, column: 16, scope: !484, inlinedAt: !499)
!518 = !{!510, !511, i64 8}
!519 = !DILocation(line: 41, column: 9, scope: !484, inlinedAt: !499)
!520 = !DILocation(line: 41, column: 2, scope: !484, inlinedAt: !499)
!521 = !DILocation(line: 0, scope: !484, inlinedAt: !499)
!522 = !DILocation(line: 42, column: 1, scope: !484, inlinedAt: !499)
!523 = !DILocation(line: 147, column: 1, scope: !158)
!524 = !DILocation(line: 146, column: 2, scope: !158)
!525 = distinct !DISubprogram(name: "xdp_redirect_func", scope: !3, file: !3, line: 151, type: !159, scopeLine: 152, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !526)
!526 = !{!527, !528, !529, !530, !531, !532, !533, !534, !535}
!527 = !DILocalVariable(name: "ctx", arg: 1, scope: !525, file: !3, line: 151, type: !161)
!528 = !DILocalVariable(name: "data_end", scope: !525, file: !3, line: 153, type: !44)
!529 = !DILocalVariable(name: "data", scope: !525, file: !3, line: 154, type: !44)
!530 = !DILocalVariable(name: "nh", scope: !525, file: !3, line: 155, type: !174)
!531 = !DILocalVariable(name: "eth", scope: !525, file: !3, line: 156, type: !179)
!532 = !DILocalVariable(name: "eth_type", scope: !525, file: !3, line: 157, type: !99)
!533 = !DILocalVariable(name: "action", scope: !525, file: !3, line: 158, type: !99)
!534 = !DILocalVariable(name: "dst", scope: !525, file: !3, line: 159, type: !184)
!535 = !DILocalVariable(name: "ifindex", scope: !525, file: !3, line: 160, type: !7)
!536 = !DILocation(line: 151, column: 38, scope: !525)
!537 = !DILocation(line: 153, column: 38, scope: !525)
!538 = !DILocation(line: 153, column: 27, scope: !525)
!539 = !DILocation(line: 153, column: 19, scope: !525)
!540 = !DILocation(line: 153, column: 8, scope: !525)
!541 = !DILocation(line: 154, column: 34, scope: !525)
!542 = !DILocation(line: 154, column: 23, scope: !525)
!543 = !DILocation(line: 154, column: 15, scope: !525)
!544 = !DILocation(line: 154, column: 8, scope: !525)
!545 = !DILocation(line: 158, column: 6, scope: !525)
!546 = !DILocation(line: 159, column: 2, scope: !525)
!547 = !DILocation(line: 159, column: 16, scope: !525)
!548 = !DILocation(line: 160, column: 11, scope: !525)
!549 = !DILocation(line: 155, column: 20, scope: !525)
!550 = !DILocation(line: 73, column: 60, scope: !273, inlinedAt: !551)
!551 = distinct !DILocation(line: 166, column: 13, scope: !525)
!552 = !DILocation(line: 73, column: 70, scope: !273, inlinedAt: !551)
!553 = !DILocation(line: 77, column: 6, scope: !273, inlinedAt: !551)
!554 = !DILocation(line: 85, column: 14, scope: !296, inlinedAt: !551)
!555 = !DILocation(line: 85, column: 24, scope: !296, inlinedAt: !551)
!556 = !DILocation(line: 85, column: 6, scope: !273, inlinedAt: !551)
!557 = !DILocation(line: 76, column: 17, scope: !273, inlinedAt: !551)
!558 = !DILocation(line: 89, column: 10, scope: !273, inlinedAt: !551)
!559 = !DILocation(line: 78, column: 19, scope: !273, inlinedAt: !551)
!560 = !DILocation(line: 79, column: 8, scope: !273, inlinedAt: !551)
!561 = !DILocation(line: 80, column: 6, scope: !273, inlinedAt: !551)
!562 = !DILocation(line: 156, column: 17, scope: !525)
!563 = !DILocation(line: 171, column: 2, scope: !525)
!564 = !DILocation(line: 172, column: 11, scope: !525)
!565 = !DILocation(line: 24, column: 46, scope: !484, inlinedAt: !566)
!566 = distinct !DILocation(line: 175, column: 9, scope: !525)
!567 = !DILocation(line: 24, column: 57, scope: !484, inlinedAt: !566)
!568 = !DILocation(line: 26, column: 13, scope: !569, inlinedAt: !566)
!569 = distinct !DILexicalBlock(scope: !484, file: !153, line: 26, column: 6)
!570 = !DILocation(line: 26, column: 6, scope: !484, inlinedAt: !566)
!571 = !DILocation(line: 30, column: 24, scope: !484, inlinedAt: !566)
!572 = !DILocation(line: 31, column: 7, scope: !504, inlinedAt: !566)
!573 = !DILocation(line: 31, column: 6, scope: !484, inlinedAt: !566)
!574 = !DILocation(line: 30, column: 18, scope: !484, inlinedAt: !566)
!575 = !DILocation(line: 38, column: 7, scope: !484, inlinedAt: !566)
!576 = !DILocation(line: 38, column: 17, scope: !484, inlinedAt: !566)
!577 = !DILocation(line: 39, column: 25, scope: !484, inlinedAt: !566)
!578 = !DILocation(line: 39, column: 41, scope: !484, inlinedAt: !566)
!579 = !DILocation(line: 39, column: 34, scope: !484, inlinedAt: !566)
!580 = !DILocation(line: 39, column: 19, scope: !484, inlinedAt: !566)
!581 = !DILocation(line: 39, column: 7, scope: !484, inlinedAt: !566)
!582 = !DILocation(line: 39, column: 16, scope: !484, inlinedAt: !566)
!583 = !DILocation(line: 41, column: 9, scope: !484, inlinedAt: !566)
!584 = !DILocation(line: 41, column: 2, scope: !484, inlinedAt: !566)
!585 = !DILocation(line: 0, scope: !484, inlinedAt: !566)
!586 = !DILocation(line: 42, column: 1, scope: !484, inlinedAt: !566)
!587 = !DILocation(line: 176, column: 1, scope: !525)
!588 = !DILocation(line: 175, column: 2, scope: !525)
!589 = distinct !DISubprogram(name: "xdp_redirect_map_func", scope: !3, file: !3, line: 180, type: !159, scopeLine: 181, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !590)
!590 = !{!591, !592, !593, !594, !595, !596, !597, !598}
!591 = !DILocalVariable(name: "ctx", arg: 1, scope: !589, file: !3, line: 180, type: !161)
!592 = !DILocalVariable(name: "data_end", scope: !589, file: !3, line: 182, type: !44)
!593 = !DILocalVariable(name: "data", scope: !589, file: !3, line: 183, type: !44)
!594 = !DILocalVariable(name: "nh", scope: !589, file: !3, line: 184, type: !174)
!595 = !DILocalVariable(name: "eth", scope: !589, file: !3, line: 185, type: !179)
!596 = !DILocalVariable(name: "eth_type", scope: !589, file: !3, line: 186, type: !99)
!597 = !DILocalVariable(name: "action", scope: !589, file: !3, line: 187, type: !99)
!598 = !DILocalVariable(name: "dst", scope: !589, file: !3, line: 188, type: !599)
!599 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !59, size: 64)
!600 = !DILocation(line: 180, column: 42, scope: !589)
!601 = !DILocation(line: 182, column: 38, scope: !589)
!602 = !DILocation(line: 182, column: 27, scope: !589)
!603 = !DILocation(line: 182, column: 19, scope: !589)
!604 = !DILocation(line: 182, column: 8, scope: !589)
!605 = !DILocation(line: 183, column: 34, scope: !589)
!606 = !DILocation(line: 183, column: 23, scope: !589)
!607 = !DILocation(line: 183, column: 15, scope: !589)
!608 = !DILocation(line: 183, column: 8, scope: !589)
!609 = !DILocation(line: 187, column: 6, scope: !589)
!610 = !DILocation(line: 184, column: 20, scope: !589)
!611 = !DILocation(line: 73, column: 60, scope: !273, inlinedAt: !612)
!612 = distinct !DILocation(line: 194, column: 13, scope: !589)
!613 = !DILocation(line: 73, column: 70, scope: !273, inlinedAt: !612)
!614 = !DILocation(line: 77, column: 6, scope: !273, inlinedAt: !612)
!615 = !DILocation(line: 85, column: 14, scope: !296, inlinedAt: !612)
!616 = !DILocation(line: 85, column: 24, scope: !296, inlinedAt: !612)
!617 = !DILocation(line: 85, column: 6, scope: !273, inlinedAt: !612)
!618 = !DILocation(line: 76, column: 17, scope: !273, inlinedAt: !612)
!619 = !DILocation(line: 89, column: 10, scope: !273, inlinedAt: !612)
!620 = !DILocation(line: 78, column: 19, scope: !273, inlinedAt: !612)
!621 = !DILocation(line: 79, column: 8, scope: !273, inlinedAt: !612)
!622 = !DILocation(line: 80, column: 6, scope: !273, inlinedAt: !612)
!623 = !DILocation(line: 185, column: 17, scope: !589)
!624 = !DILocation(line: 199, column: 46, scope: !589)
!625 = !DILocation(line: 199, column: 8, scope: !589)
!626 = !DILocation(line: 188, column: 17, scope: !589)
!627 = !DILocation(line: 200, column: 7, scope: !628)
!628 = distinct !DILexicalBlock(scope: !589, file: !3, line: 200, column: 6)
!629 = !DILocation(line: 200, column: 6, scope: !589)
!630 = !DILocation(line: 24, column: 46, scope: !484, inlinedAt: !631)
!631 = distinct !DILocation(line: 208, column: 9, scope: !589)
!632 = !DILocation(line: 24, column: 57, scope: !484, inlinedAt: !631)
!633 = !DILocation(line: 26, column: 6, scope: !484, inlinedAt: !631)
!634 = !DILocation(line: 204, column: 2, scope: !589)
!635 = !DILocation(line: 205, column: 11, scope: !589)
!636 = !DILocation(line: 26, column: 13, scope: !569, inlinedAt: !631)
!637 = !DILocation(line: 30, column: 24, scope: !484, inlinedAt: !631)
!638 = !DILocation(line: 31, column: 7, scope: !504, inlinedAt: !631)
!639 = !DILocation(line: 31, column: 6, scope: !484, inlinedAt: !631)
!640 = !DILocation(line: 30, column: 18, scope: !484, inlinedAt: !631)
!641 = !DILocation(line: 38, column: 7, scope: !484, inlinedAt: !631)
!642 = !DILocation(line: 38, column: 17, scope: !484, inlinedAt: !631)
!643 = !DILocation(line: 39, column: 25, scope: !484, inlinedAt: !631)
!644 = !DILocation(line: 39, column: 41, scope: !484, inlinedAt: !631)
!645 = !DILocation(line: 39, column: 34, scope: !484, inlinedAt: !631)
!646 = !DILocation(line: 39, column: 19, scope: !484, inlinedAt: !631)
!647 = !DILocation(line: 39, column: 7, scope: !484, inlinedAt: !631)
!648 = !DILocation(line: 39, column: 16, scope: !484, inlinedAt: !631)
!649 = !DILocation(line: 41, column: 9, scope: !484, inlinedAt: !631)
!650 = !DILocation(line: 41, column: 2, scope: !484, inlinedAt: !631)
!651 = !DILocation(line: 0, scope: !484, inlinedAt: !631)
!652 = !DILocation(line: 42, column: 1, scope: !484, inlinedAt: !631)
!653 = !DILocation(line: 208, column: 2, scope: !589)
!654 = distinct !DISubprogram(name: "xdp_router_func", scope: !3, file: !3, line: 226, type: !159, scopeLine: 227, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !655)
!655 = !{!656, !657, !658, !659, !660, !661, !662, !663, !664, !665, !666, !667, !671}
!656 = !DILocalVariable(name: "ctx", arg: 1, scope: !654, file: !3, line: 226, type: !161)
!657 = !DILocalVariable(name: "data_end", scope: !654, file: !3, line: 228, type: !44)
!658 = !DILocalVariable(name: "data", scope: !654, file: !3, line: 229, type: !44)
!659 = !DILocalVariable(name: "fib_params", scope: !654, file: !3, line: 230, type: !121)
!660 = !DILocalVariable(name: "eth", scope: !654, file: !3, line: 231, type: !179)
!661 = !DILocalVariable(name: "ip6h", scope: !654, file: !3, line: 232, type: !208)
!662 = !DILocalVariable(name: "iph", scope: !654, file: !3, line: 233, type: !191)
!663 = !DILocalVariable(name: "h_proto", scope: !654, file: !3, line: 234, type: !46)
!664 = !DILocalVariable(name: "nh_off", scope: !654, file: !3, line: 235, type: !496)
!665 = !DILocalVariable(name: "rc", scope: !654, file: !3, line: 236, type: !99)
!666 = !DILocalVariable(name: "action", scope: !654, file: !3, line: 237, type: !99)
!667 = !DILocalVariable(name: "src", scope: !668, file: !3, line: 266, type: !49)
!668 = distinct !DILexicalBlock(scope: !669, file: !3, line: 265, column: 47)
!669 = distinct !DILexicalBlock(scope: !670, file: !3, line: 265, column: 13)
!670 = distinct !DILexicalBlock(scope: !654, file: !3, line: 246, column: 6)
!671 = !DILocalVariable(name: "dst", scope: !668, file: !3, line: 267, type: !49)
!672 = !DILocation(line: 226, column: 36, scope: !654)
!673 = !DILocation(line: 228, column: 38, scope: !654)
!674 = !DILocation(line: 228, column: 27, scope: !654)
!675 = !DILocation(line: 228, column: 19, scope: !654)
!676 = !DILocation(line: 228, column: 8, scope: !654)
!677 = !DILocation(line: 229, column: 34, scope: !654)
!678 = !DILocation(line: 229, column: 23, scope: !654)
!679 = !DILocation(line: 229, column: 15, scope: !654)
!680 = !DILocation(line: 229, column: 8, scope: !654)
!681 = !DILocation(line: 230, column: 2, scope: !654)
!682 = !DILocation(line: 230, column: 24, scope: !654)
!683 = !DILocation(line: 231, column: 23, scope: !654)
!684 = !DILocation(line: 231, column: 17, scope: !654)
!685 = !DILocation(line: 237, column: 6, scope: !654)
!686 = !DILocation(line: 235, column: 8, scope: !654)
!687 = !DILocation(line: 240, column: 11, scope: !688)
!688 = distinct !DILexicalBlock(scope: !654, file: !3, line: 240, column: 6)
!689 = !DILocation(line: 240, column: 20, scope: !688)
!690 = !DILocation(line: 240, column: 6, scope: !654)
!691 = !DILocation(line: 245, column: 17, scope: !654)
!692 = !{!693, !307, i64 12}
!693 = !{!"ethhdr", !259, i64 0, !259, i64 6, !307, i64 12}
!694 = !DILocation(line: 234, column: 8, scope: !654)
!695 = !DILocation(line: 246, column: 14, scope: !670)
!696 = !DILocation(line: 246, column: 6, scope: !654)
!697 = !DILocation(line: 247, column: 9, scope: !698)
!698 = distinct !DILexicalBlock(scope: !670, file: !3, line: 246, column: 38)
!699 = !DILocation(line: 233, column: 16, scope: !654)
!700 = !DILocation(line: 249, column: 11, scope: !701)
!701 = distinct !DILexicalBlock(scope: !698, file: !3, line: 249, column: 7)
!702 = !DILocation(line: 249, column: 17, scope: !701)
!703 = !DILocation(line: 249, column: 15, scope: !701)
!704 = !DILocation(line: 249, column: 7, scope: !698)
!705 = !DILocation(line: 254, column: 12, scope: !706)
!706 = distinct !DILexicalBlock(scope: !698, file: !3, line: 254, column: 7)
!707 = !{!349, !259, i64 8}
!708 = !DILocation(line: 254, column: 16, scope: !706)
!709 = !DILocation(line: 254, column: 7, scope: !698)
!710 = !DILocation(line: 257, column: 21, scope: !698)
!711 = !{!712, !259, i64 0}
!712 = !{!"bpf_fib_lookup", !259, i64 0, !259, i64 1, !307, i64 2, !307, i64 4, !307, i64 6, !258, i64 8, !259, i64 12, !259, i64 16, !259, i64 32, !307, i64 48, !307, i64 50, !259, i64 52, !259, i64 58}
!713 = !DILocation(line: 258, column: 26, scope: !698)
!714 = !{!349, !259, i64 1}
!715 = !DILocation(line: 258, column: 14, scope: !698)
!716 = !DILocation(line: 258, column: 19, scope: !698)
!717 = !DILocation(line: 259, column: 33, scope: !698)
!718 = !DILocation(line: 259, column: 14, scope: !698)
!719 = !DILocation(line: 259, column: 26, scope: !698)
!720 = !{!712, !259, i64 1}
!721 = !DILocation(line: 260, column: 14, scope: !698)
!722 = !DILocation(line: 260, column: 20, scope: !698)
!723 = !{!712, !307, i64 2}
!724 = !DILocation(line: 261, column: 14, scope: !698)
!725 = !DILocation(line: 261, column: 20, scope: !698)
!726 = !{!712, !307, i64 4}
!727 = !DILocation(line: 262, column: 24, scope: !698)
!728 = !{!349, !307, i64 2}
!729 = !DILocation(line: 262, column: 14, scope: !698)
!730 = !DILocation(line: 262, column: 22, scope: !698)
!731 = !{!712, !307, i64 6}
!732 = !DILocation(line: 263, column: 30, scope: !698)
!733 = !DILocation(line: 263, column: 14, scope: !698)
!734 = !DILocation(line: 263, column: 23, scope: !698)
!735 = !DILocation(line: 264, column: 30, scope: !698)
!736 = !DILocation(line: 264, column: 14, scope: !698)
!737 = !DILocation(line: 264, column: 23, scope: !698)
!738 = !DILocation(line: 265, column: 2, scope: !698)
!739 = !DILocation(line: 265, column: 21, scope: !669)
!740 = !DILocation(line: 265, column: 13, scope: !670)
!741 = !DILocation(line: 266, column: 46, scope: !668)
!742 = !DILocation(line: 266, column: 20, scope: !668)
!743 = !DILocation(line: 267, column: 46, scope: !668)
!744 = !DILocation(line: 267, column: 20, scope: !668)
!745 = !DILocation(line: 269, column: 10, scope: !668)
!746 = !DILocation(line: 232, column: 18, scope: !654)
!747 = !DILocation(line: 270, column: 12, scope: !748)
!748 = distinct !DILexicalBlock(scope: !668, file: !3, line: 270, column: 7)
!749 = !DILocation(line: 270, column: 18, scope: !748)
!750 = !DILocation(line: 270, column: 16, scope: !748)
!751 = !DILocation(line: 270, column: 7, scope: !668)
!752 = !DILocation(line: 275, column: 13, scope: !753)
!753 = distinct !DILexicalBlock(scope: !668, file: !3, line: 275, column: 7)
!754 = !{!376, !259, i64 7}
!755 = !DILocation(line: 275, column: 23, scope: !753)
!756 = !DILocation(line: 275, column: 7, scope: !668)
!757 = !DILocation(line: 278, column: 21, scope: !668)
!758 = !DILocation(line: 279, column: 25, scope: !668)
!759 = !DILocation(line: 279, column: 42, scope: !668)
!760 = !DILocation(line: 279, column: 14, scope: !668)
!761 = !DILocation(line: 279, column: 23, scope: !668)
!762 = !DILocation(line: 280, column: 34, scope: !668)
!763 = !DILocation(line: 280, column: 14, scope: !668)
!764 = !DILocation(line: 280, column: 26, scope: !668)
!765 = !DILocation(line: 281, column: 14, scope: !668)
!766 = !DILocation(line: 281, column: 20, scope: !668)
!767 = !DILocation(line: 282, column: 14, scope: !668)
!768 = !DILocation(line: 282, column: 20, scope: !668)
!769 = !DILocation(line: 283, column: 24, scope: !668)
!770 = !{!376, !307, i64 4}
!771 = !DILocation(line: 283, column: 14, scope: !668)
!772 = !DILocation(line: 283, column: 22, scope: !668)
!773 = !DILocation(line: 284, column: 18, scope: !668)
!774 = !DILocation(line: 285, column: 18, scope: !668)
!775 = !DILocation(line: 290, column: 28, scope: !654)
!776 = !{!257, !258, i64 12}
!777 = !DILocation(line: 290, column: 13, scope: !654)
!778 = !DILocation(line: 290, column: 21, scope: !654)
!779 = !{!712, !258, i64 8}
!780 = !DILocation(line: 292, column: 22, scope: !654)
!781 = !DILocation(line: 292, column: 7, scope: !654)
!782 = !DILocation(line: 236, column: 6, scope: !654)
!783 = !DILocation(line: 293, column: 2, scope: !654)
!784 = !DILocation(line: 295, column: 7, scope: !785)
!785 = distinct !DILexicalBlock(scope: !654, file: !3, line: 293, column: 14)
!786 = !DILocalVariable(name: "iph", arg: 1, scope: !787, file: !3, line: 216, type: !191)
!787 = distinct !DISubprogram(name: "ip_decrease_ttl", scope: !3, file: !3, line: 216, type: !788, scopeLine: 217, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !790)
!788 = !DISubroutineType(types: !789)
!789 = !{!99, !191}
!790 = !{!786, !791}
!791 = !DILocalVariable(name: "check", scope: !787, file: !3, line: 218, type: !71)
!792 = !DILocation(line: 216, column: 58, scope: !787, inlinedAt: !793)
!793 = distinct !DILocation(line: 296, column: 4, scope: !794)
!794 = distinct !DILexicalBlock(scope: !785, file: !3, line: 295, column: 7)
!795 = !DILocation(line: 218, column: 21, scope: !787, inlinedAt: !793)
!796 = !{!349, !307, i64 10}
!797 = !DILocation(line: 219, column: 8, scope: !787, inlinedAt: !793)
!798 = !DILocation(line: 220, column: 38, scope: !787, inlinedAt: !793)
!799 = !DILocation(line: 220, column: 29, scope: !787, inlinedAt: !793)
!800 = !DILocation(line: 220, column: 13, scope: !787, inlinedAt: !793)
!801 = !DILocation(line: 221, column: 16, scope: !787, inlinedAt: !793)
!802 = !DILocation(line: 221, column: 9, scope: !787, inlinedAt: !793)
!803 = !DILocation(line: 296, column: 4, scope: !794)
!804 = !DILocation(line: 297, column: 20, scope: !805)
!805 = distinct !DILexicalBlock(scope: !794, file: !3, line: 297, column: 12)
!806 = !DILocation(line: 297, column: 12, scope: !794)
!807 = !DILocation(line: 298, column: 10, scope: !805)
!808 = !DILocation(line: 298, column: 19, scope: !805)
!809 = !DILocation(line: 298, column: 4, scope: !805)
!810 = !DILocation(line: 308, column: 3, scope: !785)
!811 = !DILocation(line: 24, column: 46, scope: !484, inlinedAt: !812)
!812 = distinct !DILocation(line: 319, column: 9, scope: !654)
!813 = !DILocation(line: 24, column: 57, scope: !484, inlinedAt: !812)
!814 = !DILocation(line: 26, column: 6, scope: !484, inlinedAt: !812)
!815 = !DILocation(line: 300, column: 3, scope: !785)
!816 = !DILocation(line: 301, column: 3, scope: !785)
!817 = !DILocation(line: 302, column: 50, scope: !785)
!818 = !DILocation(line: 302, column: 12, scope: !785)
!819 = !DILocation(line: 26, column: 13, scope: !569, inlinedAt: !812)
!820 = !DILocation(line: 30, column: 24, scope: !484, inlinedAt: !812)
!821 = !DILocation(line: 31, column: 7, scope: !504, inlinedAt: !812)
!822 = !DILocation(line: 31, column: 6, scope: !484, inlinedAt: !812)
!823 = !DILocation(line: 30, column: 18, scope: !484, inlinedAt: !812)
!824 = !DILocation(line: 38, column: 7, scope: !484, inlinedAt: !812)
!825 = !DILocation(line: 38, column: 17, scope: !484, inlinedAt: !812)
!826 = !DILocation(line: 39, column: 25, scope: !484, inlinedAt: !812)
!827 = !DILocation(line: 39, column: 41, scope: !484, inlinedAt: !812)
!828 = !DILocation(line: 39, column: 34, scope: !484, inlinedAt: !812)
!829 = !DILocation(line: 39, column: 19, scope: !484, inlinedAt: !812)
!830 = !DILocation(line: 39, column: 7, scope: !484, inlinedAt: !812)
!831 = !DILocation(line: 39, column: 16, scope: !484, inlinedAt: !812)
!832 = !DILocation(line: 41, column: 9, scope: !484, inlinedAt: !812)
!833 = !DILocation(line: 41, column: 2, scope: !484, inlinedAt: !812)
!834 = !DILocation(line: 0, scope: !484, inlinedAt: !812)
!835 = !DILocation(line: 42, column: 1, scope: !484, inlinedAt: !812)
!836 = !DILocation(line: 320, column: 1, scope: !654)
!837 = distinct !DISubprogram(name: "xdp_pass_func", scope: !3, file: !3, line: 323, type: !159, scopeLine: 324, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !838)
!838 = !{!839}
!839 = !DILocalVariable(name: "ctx", arg: 1, scope: !837, file: !3, line: 323, type: !161)
!840 = !DILocation(line: 323, column: 34, scope: !837)
!841 = !DILocation(line: 325, column: 2, scope: !837)
