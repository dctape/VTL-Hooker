; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
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
@tx_port = dso_local global %struct.bpf_map_def { i32 14, i32 4, i32 4, i32 256, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !50
@redirect_params = dso_local global %struct.bpf_map_def { i32 1, i32 6, i32 6, i32 1, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !62
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !64
@llvm.used = appending global [9 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @redirect_params to i8*), i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_icmp_echo_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_pass_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_redirect_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_redirect_map_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_router_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_icmp_echo_func(%struct.xdp_md* nocapture readonly) #0 section "xdp_icmp_echo" !dbg !130 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !142, metadata !DIExpression()), !dbg !220
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !221
  %4 = load i32, i32* %3, align 4, !dbg !221, !tbaa !222
  %5 = zext i32 %4 to i64, !dbg !227
  %6 = inttoptr i64 %5 to i8*, !dbg !228
  call void @llvm.dbg.value(metadata i8* %6, metadata !143, metadata !DIExpression()), !dbg !229
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !230
  %8 = load i32, i32* %7, align 4, !dbg !230, !tbaa !231
  %9 = zext i32 %8 to i64, !dbg !232
  %10 = inttoptr i64 %9 to i8*, !dbg !233
  call void @llvm.dbg.value(metadata i8* %10, metadata !144, metadata !DIExpression()), !dbg !234
  call void @llvm.dbg.value(metadata i32 2, metadata !219, metadata !DIExpression()), !dbg !235
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !145, metadata !DIExpression(DW_OP_deref)), !dbg !236
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !150, metadata !DIExpression(DW_OP_deref)), !dbg !237
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !238, metadata !DIExpression()), !dbg !257
  call void @llvm.dbg.value(metadata i8* %6, metadata !245, metadata !DIExpression()), !dbg !259
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !246, metadata !DIExpression()), !dbg !260
  call void @llvm.dbg.value(metadata i32 14, metadata !248, metadata !DIExpression()), !dbg !261
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !262
  %12 = icmp ugt i8* %11, %6, !dbg !264
  br i1 %12, label %93, label %13, !dbg !265

; <label>:13:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !247, metadata !DIExpression()), !dbg !266
  call void @llvm.dbg.value(metadata i8* %11, metadata !249, metadata !DIExpression()), !dbg !267
  %14 = getelementptr inbounds i8, i8* %10, i64 12, !dbg !268
  %15 = bitcast i8* %14 to i16*, !dbg !268
  call void @llvm.dbg.value(metadata i16* %15, metadata !255, metadata !DIExpression(DW_OP_deref)), !dbg !269
  call void @llvm.dbg.value(metadata i32 0, metadata !256, metadata !DIExpression()), !dbg !270
  %16 = load i16, i16* %15, align 1, !dbg !271, !tbaa !272
  call void @llvm.dbg.value(metadata i16 %16, metadata !255, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata i8* %11, metadata !249, metadata !DIExpression()), !dbg !267
  %17 = inttoptr i64 %5 to %struct.vlan_hdr*
  call void @llvm.dbg.value(metadata i32 0, metadata !256, metadata !DIExpression()), !dbg !270
  call void @llvm.dbg.value(metadata i8* %11, metadata !249, metadata !DIExpression()), !dbg !267
  switch i16 %16, label %50 [
    i16 -22392, label %18
    i16 129, label %18
  ], !dbg !274

; <label>:18:                                     ; preds = %13, %13
  %19 = getelementptr inbounds i8, i8* %10, i64 18, !dbg !278
  %20 = bitcast i8* %19 to %struct.vlan_hdr*, !dbg !278
  %21 = icmp ugt %struct.vlan_hdr* %20, %17, !dbg !280
  br i1 %21, label %50, label %22, !dbg !281

; <label>:22:                                     ; preds = %18
  %23 = getelementptr inbounds i8, i8* %10, i64 16, !dbg !282
  %24 = bitcast i8* %23 to i16*, !dbg !282
  call void @llvm.dbg.value(metadata i16* %24, metadata !255, metadata !DIExpression(DW_OP_deref)), !dbg !269
  %25 = load i16, i16* %24, align 1, !dbg !271, !tbaa !272
  call void @llvm.dbg.value(metadata i32 1, metadata !256, metadata !DIExpression()), !dbg !270
  call void @llvm.dbg.value(metadata i16 %25, metadata !255, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %20, metadata !249, metadata !DIExpression()), !dbg !267
  call void @llvm.dbg.value(metadata i32 1, metadata !256, metadata !DIExpression()), !dbg !270
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %20, metadata !249, metadata !DIExpression()), !dbg !267
  switch i16 %25, label %50 [
    i16 -22392, label %26
    i16 129, label %26
  ], !dbg !274

; <label>:26:                                     ; preds = %22, %22
  %27 = getelementptr inbounds i8, i8* %10, i64 22, !dbg !278
  %28 = bitcast i8* %27 to %struct.vlan_hdr*, !dbg !278
  %29 = icmp ugt %struct.vlan_hdr* %28, %17, !dbg !280
  br i1 %29, label %50, label %30, !dbg !281

; <label>:30:                                     ; preds = %26
  %31 = getelementptr inbounds i8, i8* %10, i64 20, !dbg !282
  %32 = bitcast i8* %31 to i16*, !dbg !282
  call void @llvm.dbg.value(metadata i16* %32, metadata !255, metadata !DIExpression(DW_OP_deref)), !dbg !269
  %33 = load i16, i16* %32, align 1, !dbg !271, !tbaa !272
  call void @llvm.dbg.value(metadata i32 2, metadata !256, metadata !DIExpression()), !dbg !270
  call void @llvm.dbg.value(metadata i16 %33, metadata !255, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %28, metadata !249, metadata !DIExpression()), !dbg !267
  call void @llvm.dbg.value(metadata i32 2, metadata !256, metadata !DIExpression()), !dbg !270
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %28, metadata !249, metadata !DIExpression()), !dbg !267
  switch i16 %33, label %50 [
    i16 -22392, label %34
    i16 129, label %34
  ], !dbg !274

; <label>:34:                                     ; preds = %30, %30
  %35 = getelementptr inbounds i8, i8* %10, i64 26, !dbg !278
  %36 = bitcast i8* %35 to %struct.vlan_hdr*, !dbg !278
  %37 = icmp ugt %struct.vlan_hdr* %36, %17, !dbg !280
  br i1 %37, label %50, label %38, !dbg !281

; <label>:38:                                     ; preds = %34
  %39 = getelementptr inbounds i8, i8* %10, i64 24, !dbg !282
  %40 = bitcast i8* %39 to i16*, !dbg !282
  call void @llvm.dbg.value(metadata i16* %40, metadata !255, metadata !DIExpression(DW_OP_deref)), !dbg !269
  %41 = load i16, i16* %40, align 1, !dbg !271, !tbaa !272
  call void @llvm.dbg.value(metadata i32 3, metadata !256, metadata !DIExpression()), !dbg !270
  call void @llvm.dbg.value(metadata i16 %41, metadata !255, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %36, metadata !249, metadata !DIExpression()), !dbg !267
  call void @llvm.dbg.value(metadata i32 3, metadata !256, metadata !DIExpression()), !dbg !270
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %36, metadata !249, metadata !DIExpression()), !dbg !267
  switch i16 %41, label %50 [
    i16 -22392, label %42
    i16 129, label %42
  ], !dbg !274

; <label>:42:                                     ; preds = %38, %38
  %43 = getelementptr inbounds i8, i8* %10, i64 30, !dbg !278
  %44 = bitcast i8* %43 to %struct.vlan_hdr*, !dbg !278
  %45 = icmp ugt %struct.vlan_hdr* %44, %17, !dbg !280
  br i1 %45, label %50, label %46, !dbg !281

; <label>:46:                                     ; preds = %42
  %47 = getelementptr inbounds i8, i8* %10, i64 28, !dbg !282
  %48 = bitcast i8* %47 to i16*, !dbg !282
  call void @llvm.dbg.value(metadata i16* %48, metadata !255, metadata !DIExpression(DW_OP_deref)), !dbg !269
  %49 = load i16, i16* %48, align 1, !dbg !271, !tbaa !272
  call void @llvm.dbg.value(metadata i32 4, metadata !256, metadata !DIExpression()), !dbg !270
  call void @llvm.dbg.value(metadata i16 %49, metadata !255, metadata !DIExpression()), !dbg !269
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %44, metadata !249, metadata !DIExpression()), !dbg !267
  br label %50

; <label>:50:                                     ; preds = %13, %18, %22, %26, %30, %34, %38, %42, %46
  %51 = phi i8* [ %11, %13 ], [ %11, %18 ], [ %19, %22 ], [ %19, %26 ], [ %27, %30 ], [ %27, %34 ], [ %35, %38 ], [ %35, %42 ], [ %43, %46 ], !dbg !271
  %52 = phi i16 [ %16, %13 ], [ %16, %18 ], [ %25, %22 ], [ %25, %26 ], [ %33, %30 ], [ %33, %34 ], [ %41, %38 ], [ %41, %42 ], [ %49, %46 ], !dbg !271
  call void @llvm.dbg.value(metadata i16 %52, metadata !159, metadata !DIExpression(DW_OP_dup, DW_OP_constu, 15, DW_OP_shr, DW_OP_lit0, DW_OP_not, DW_OP_mul, DW_OP_or, DW_OP_stack_value)), !dbg !283
  switch i16 %52, label %93 [
    i16 8, label %53
    i16 -8826, label %67
  ], !dbg !284

; <label>:53:                                     ; preds = %50
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !145, metadata !DIExpression(DW_OP_deref)), !dbg !236
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !162, metadata !DIExpression(DW_OP_deref)), !dbg !285
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !286, metadata !DIExpression()), !dbg !296
  call void @llvm.dbg.value(metadata i8* %6, metadata !292, metadata !DIExpression()), !dbg !300
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !293, metadata !DIExpression()), !dbg !301
  call void @llvm.dbg.value(metadata i8* %51, metadata !294, metadata !DIExpression()), !dbg !302
  %54 = getelementptr inbounds i8, i8* %51, i64 20, !dbg !303
  %55 = icmp ugt i8* %54, %6, !dbg !305
  br i1 %55, label %93, label %56, !dbg !306

; <label>:56:                                     ; preds = %53
  %57 = load i8, i8* %51, align 4, !dbg !307
  %58 = shl i8 %57, 2, !dbg !308
  %59 = and i8 %58, 60, !dbg !308
  %60 = zext i8 %59 to i64, !dbg !309
  call void @llvm.dbg.value(metadata i64 %60, metadata !295, metadata !DIExpression()), !dbg !311
  %61 = getelementptr i8, i8* %51, i64 %60, !dbg !309
  %62 = icmp ugt i8* %61, %6, !dbg !312
  br i1 %62, label %93, label %63, !dbg !313

; <label>:63:                                     ; preds = %56
  %64 = getelementptr inbounds i8, i8* %51, i64 9, !dbg !314
  %65 = load i8, i8* %64, align 1, !dbg !314, !tbaa !315
  %66 = icmp eq i8 %65, 1, !dbg !317
  br i1 %66, label %76, label %93, !dbg !319

; <label>:67:                                     ; preds = %50
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !145, metadata !DIExpression(DW_OP_deref)), !dbg !236
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !320, metadata !DIExpression()), !dbg !329
  call void @llvm.dbg.value(metadata i8* %6, metadata !326, metadata !DIExpression()), !dbg !333
  %68 = getelementptr inbounds i8, i8* %51, i64 40, !dbg !334
  %69 = bitcast i8* %68 to %struct.ipv6hdr*, !dbg !334
  %70 = inttoptr i64 %5 to %struct.ipv6hdr*, !dbg !336
  %71 = icmp ugt %struct.ipv6hdr* %69, %70, !dbg !337
  br i1 %71, label %93, label %72, !dbg !338

; <label>:72:                                     ; preds = %67
  call void @llvm.dbg.value(metadata i8* %51, metadata !328, metadata !DIExpression()), !dbg !339
  %73 = getelementptr inbounds i8, i8* %51, i64 6, !dbg !340
  %74 = load i8, i8* %73, align 2, !dbg !340, !tbaa !341
  %75 = icmp eq i8 %74, 58, !dbg !344
  br i1 %75, label %76, label %93, !dbg !346

; <label>:76:                                     ; preds = %63, %72
  %77 = phi i1 [ true, %63 ], [ false, %72 ]
  %78 = phi i32 [ 8, %63 ], [ 56710, %72 ]
  %79 = phi i8* [ %61, %63 ], [ %68, %72 ], !dbg !347
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !145, metadata !DIExpression(DW_OP_deref)), !dbg !236
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !348, metadata !DIExpression()), !dbg !357
  call void @llvm.dbg.value(metadata i8* %6, metadata !354, metadata !DIExpression()), !dbg !359
  %80 = getelementptr inbounds i8, i8* %79, i64 4, !dbg !360
  %81 = bitcast i8* %80 to %struct.icmphdr_common*, !dbg !360
  %82 = inttoptr i64 %5 to %struct.icmphdr_common*, !dbg !362
  %83 = icmp ugt %struct.icmphdr_common* %81, %82, !dbg !363
  br i1 %83, label %93, label %84, !dbg !364

; <label>:84:                                     ; preds = %76
  call void @llvm.dbg.value(metadata i8* %79, metadata !356, metadata !DIExpression()), !dbg !365
  %85 = load i8, i8* %79, align 2, !dbg !366, !tbaa !367
  %86 = icmp eq i8 %85, 8, !dbg !369
  %87 = and i1 %77, %86, !dbg !371
  br i1 %87, label %92, label %88, !dbg !371

; <label>:88:                                     ; preds = %84
  %89 = icmp eq i32 %78, 56710, !dbg !372
  %90 = icmp eq i8 %85, -128, !dbg !374
  %91 = and i1 %89, %90, !dbg !375
  br i1 %91, label %92, label %93, !dbg !375

; <label>:92:                                     ; preds = %88, %84
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !150, metadata !DIExpression(DW_OP_deref)), !dbg !237
  call void @llvm.dbg.value(metadata i32 3, metadata !219, metadata !DIExpression()), !dbg !235
  br label %93, !dbg !376

; <label>:93:                                     ; preds = %50, %76, %67, %56, %53, %1, %63, %72, %88, %92
  %94 = phi i32 [ 2, %63 ], [ 3, %92 ], [ 2, %88 ], [ 2, %72 ], [ 2, %1 ], [ 2, %53 ], [ 2, %56 ], [ 2, %67 ], [ 2, %76 ], [ 2, %50 ], !dbg !377
  call void @llvm.dbg.value(metadata i32 %94, metadata !219, metadata !DIExpression()), !dbg !235
  %95 = bitcast i32* %2 to i8*, !dbg !378
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %95), !dbg !378
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !383, metadata !DIExpression()) #4, !dbg !378
  call void @llvm.dbg.value(metadata i32 %94, metadata !384, metadata !DIExpression()) #4, !dbg !395
  store i32 %94, i32* %2, align 4, !tbaa !396
  %96 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %95) #4, !dbg !397
  %97 = icmp eq i8* %96, null, !dbg !398
  br i1 %97, label %111, label %98, !dbg !400

; <label>:98:                                     ; preds = %93
  call void @llvm.dbg.value(metadata i8* %96, metadata !385, metadata !DIExpression()) #4, !dbg !401
  %99 = bitcast i8* %96 to i64*, !dbg !402
  %100 = load i64, i64* %99, align 8, !dbg !403, !tbaa !404
  %101 = add i64 %100, 1, !dbg !403
  store i64 %101, i64* %99, align 8, !dbg !403, !tbaa !404
  %102 = load i32, i32* %3, align 4, !dbg !407, !tbaa !222
  %103 = load i32, i32* %7, align 4, !dbg !408, !tbaa !231
  %104 = sub i32 %102, %103, !dbg !409
  %105 = zext i32 %104 to i64, !dbg !410
  %106 = getelementptr inbounds i8, i8* %96, i64 8, !dbg !411
  %107 = bitcast i8* %106 to i64*, !dbg !411
  %108 = load i64, i64* %107, align 8, !dbg !412, !tbaa !413
  %109 = add i64 %108, %105, !dbg !412
  store i64 %109, i64* %107, align 8, !dbg !412, !tbaa !413
  %110 = load i32, i32* %2, align 4, !dbg !414, !tbaa !396
  call void @llvm.dbg.value(metadata i32 %110, metadata !384, metadata !DIExpression()) #4, !dbg !395
  br label %111, !dbg !415

; <label>:111:                                    ; preds = %93, %98
  %112 = phi i32 [ %110, %98 ], [ 0, %93 ], !dbg !416
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %95), !dbg !417
  ret i32 %112, !dbg !418
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind
define dso_local i32 @xdp_redirect_func(%struct.xdp_md* nocapture readonly) #0 section "xdp_redirect" !dbg !419 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !421, metadata !DIExpression()), !dbg !428
  call void @llvm.dbg.value(metadata i32 2, metadata !427, metadata !DIExpression()), !dbg !429
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !424, metadata !DIExpression(DW_OP_deref)), !dbg !430
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !425, metadata !DIExpression(DW_OP_deref)), !dbg !431
  %3 = bitcast i32* %2 to i8*, !dbg !432
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %3), !dbg !432
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !383, metadata !DIExpression()) #4, !dbg !432
  call void @llvm.dbg.value(metadata i32 2, metadata !384, metadata !DIExpression()) #4, !dbg !434
  store i32 2, i32* %2, align 4, !tbaa !396
  %4 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %3) #4, !dbg !435
  %5 = icmp eq i8* %4, null, !dbg !436
  br i1 %5, label %21, label %6, !dbg !437

; <label>:6:                                      ; preds = %1
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !438
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !439
  call void @llvm.dbg.value(metadata i8* %4, metadata !385, metadata !DIExpression()) #4, !dbg !440
  %9 = bitcast i8* %4 to i64*, !dbg !441
  %10 = load i64, i64* %9, align 8, !dbg !442, !tbaa !404
  %11 = add i64 %10, 1, !dbg !442
  store i64 %11, i64* %9, align 8, !dbg !442, !tbaa !404
  %12 = load i32, i32* %8, align 4, !dbg !443, !tbaa !222
  %13 = load i32, i32* %7, align 4, !dbg !444, !tbaa !231
  %14 = sub i32 %12, %13, !dbg !445
  %15 = zext i32 %14 to i64, !dbg !446
  %16 = getelementptr inbounds i8, i8* %4, i64 8, !dbg !447
  %17 = bitcast i8* %16 to i64*, !dbg !447
  %18 = load i64, i64* %17, align 8, !dbg !448, !tbaa !413
  %19 = add i64 %18, %15, !dbg !448
  store i64 %19, i64* %17, align 8, !dbg !448, !tbaa !413
  %20 = load i32, i32* %2, align 4, !dbg !449, !tbaa !396
  call void @llvm.dbg.value(metadata i32 %20, metadata !384, metadata !DIExpression()) #4, !dbg !434
  br label %21, !dbg !450

; <label>:21:                                     ; preds = %1, %6
  %22 = phi i32 [ %20, %6 ], [ 0, %1 ], !dbg !451
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %3), !dbg !452
  ret i32 %22, !dbg !453
}

; Function Attrs: nounwind
define dso_local i32 @xdp_redirect_map_func(%struct.xdp_md* nocapture readonly) #0 section "xdp_redirect_map" !dbg !454 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !456, metadata !DIExpression()), !dbg !465
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !466
  %4 = load i32, i32* %3, align 4, !dbg !466, !tbaa !222
  %5 = zext i32 %4 to i64, !dbg !467
  %6 = inttoptr i64 %5 to i8*, !dbg !468
  call void @llvm.dbg.value(metadata i8* %6, metadata !457, metadata !DIExpression()), !dbg !469
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !470
  %8 = load i32, i32* %7, align 4, !dbg !470, !tbaa !231
  %9 = zext i32 %8 to i64, !dbg !471
  %10 = inttoptr i64 %9 to i8*, !dbg !472
  call void @llvm.dbg.value(metadata i8* %10, metadata !458, metadata !DIExpression()), !dbg !473
  call void @llvm.dbg.value(metadata i32 2, metadata !462, metadata !DIExpression()), !dbg !474
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !459, metadata !DIExpression(DW_OP_deref)), !dbg !475
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !238, metadata !DIExpression()), !dbg !476
  call void @llvm.dbg.value(metadata i8* %6, metadata !245, metadata !DIExpression()), !dbg !478
  call void @llvm.dbg.value(metadata i32 14, metadata !248, metadata !DIExpression()), !dbg !479
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !480
  %12 = icmp ugt i8* %11, %6, !dbg !481
  br i1 %12, label %18, label %13, !dbg !482

; <label>:13:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !247, metadata !DIExpression()), !dbg !483
  %14 = inttoptr i64 %9 to %struct.ethhdr*, !dbg !484
  call void @llvm.dbg.value(metadata i8* %11, metadata !249, metadata !DIExpression()), !dbg !485
  call void @llvm.dbg.value(metadata i8* %10, metadata !255, metadata !DIExpression(DW_OP_plus_uconst, 12, DW_OP_deref, DW_OP_stack_value)), !dbg !486
  call void @llvm.dbg.value(metadata i32 0, metadata !256, metadata !DIExpression()), !dbg !487
  call void @llvm.dbg.value(metadata i8* %11, metadata !249, metadata !DIExpression()), !dbg !485
  call void @llvm.dbg.value(metadata i32 0, metadata !256, metadata !DIExpression()), !dbg !487
  call void @llvm.dbg.value(metadata i8* %11, metadata !249, metadata !DIExpression()), !dbg !485
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !460, metadata !DIExpression()), !dbg !488
  %15 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 1, i64 0, !dbg !489
  %16 = tail call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @redirect_params to i8*), i8* nonnull %15) #4, !dbg !490
  call void @llvm.dbg.value(metadata i8* %16, metadata !463, metadata !DIExpression()), !dbg !491
  %17 = icmp eq i8* %16, null, !dbg !492
  br i1 %17, label %18, label %20, !dbg !494

; <label>:18:                                     ; preds = %13, %1
  call void @llvm.dbg.value(metadata i32 %22, metadata !462, metadata !DIExpression()), !dbg !474
  %19 = bitcast i32* %2 to i8*, !dbg !495
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %19), !dbg !495
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !383, metadata !DIExpression()) #4, !dbg !495
  call void @llvm.dbg.value(metadata i32 %22, metadata !384, metadata !DIExpression()) #4, !dbg !497
  store i32 2, i32* %2, align 4, !tbaa !396
  br label %25, !dbg !498

; <label>:20:                                     ; preds = %13
  call void @llvm.dbg.value(metadata %struct.ethhdr* %14, metadata !460, metadata !DIExpression()), !dbg !488
  %21 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %14, i64 0, i32 0, i64 0, !dbg !499
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %21, i8* nonnull align 1 %16, i64 6, i1 false), !dbg !499
  %22 = tail call i32 inttoptr (i64 51 to i32 (i8*, i32, i32)*)(i8* bitcast (%struct.bpf_map_def* @tx_port to i8*), i32 0, i32 0) #4, !dbg !500
  call void @llvm.dbg.value(metadata i32 %22, metadata !462, metadata !DIExpression()), !dbg !474
  call void @llvm.dbg.value(metadata i32 %22, metadata !462, metadata !DIExpression()), !dbg !474
  %23 = bitcast i32* %2 to i8*, !dbg !495
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %23), !dbg !495
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !383, metadata !DIExpression()) #4, !dbg !495
  call void @llvm.dbg.value(metadata i32 %22, metadata !384, metadata !DIExpression()) #4, !dbg !497
  store i32 %22, i32* %2, align 4, !tbaa !396
  %24 = icmp ugt i32 %22, 4, !dbg !501
  br i1 %24, label %42, label %25, !dbg !498

; <label>:25:                                     ; preds = %18, %20
  %26 = phi i8* [ %19, %18 ], [ %23, %20 ]
  %27 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %26) #4, !dbg !503
  %28 = icmp eq i8* %27, null, !dbg !504
  br i1 %28, label %42, label %29, !dbg !505

; <label>:29:                                     ; preds = %25
  call void @llvm.dbg.value(metadata i8* %27, metadata !385, metadata !DIExpression()) #4, !dbg !506
  %30 = bitcast i8* %27 to i64*, !dbg !507
  %31 = load i64, i64* %30, align 8, !dbg !508, !tbaa !404
  %32 = add i64 %31, 1, !dbg !508
  store i64 %32, i64* %30, align 8, !dbg !508, !tbaa !404
  %33 = load i32, i32* %3, align 4, !dbg !509, !tbaa !222
  %34 = load i32, i32* %7, align 4, !dbg !510, !tbaa !231
  %35 = sub i32 %33, %34, !dbg !511
  %36 = zext i32 %35 to i64, !dbg !512
  %37 = getelementptr inbounds i8, i8* %27, i64 8, !dbg !513
  %38 = bitcast i8* %37 to i64*, !dbg !513
  %39 = load i64, i64* %38, align 8, !dbg !514, !tbaa !413
  %40 = add i64 %39, %36, !dbg !514
  store i64 %40, i64* %38, align 8, !dbg !514, !tbaa !413
  %41 = load i32, i32* %2, align 4, !dbg !515, !tbaa !396
  call void @llvm.dbg.value(metadata i32 %41, metadata !384, metadata !DIExpression()) #4, !dbg !497
  br label %42, !dbg !516

; <label>:42:                                     ; preds = %20, %25, %29
  %43 = phi i8* [ %23, %20 ], [ %26, %29 ], [ %26, %25 ]
  %44 = phi i32 [ 0, %20 ], [ %41, %29 ], [ 0, %25 ], !dbg !517
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %43), !dbg !518
  ret i32 %44, !dbg !519
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1) #1

; Function Attrs: nounwind
define dso_local i32 @xdp_router_func(%struct.xdp_md*) #0 section "xdp_router" !dbg !520 {
  %2 = alloca i32, align 4
  %3 = alloca %struct.bpf_fib_lookup, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !522, metadata !DIExpression()), !dbg !533
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !534
  %5 = load i32, i32* %4, align 4, !dbg !534, !tbaa !222
  %6 = zext i32 %5 to i64, !dbg !535
  %7 = inttoptr i64 %6 to i8*, !dbg !536
  call void @llvm.dbg.value(metadata i8* %7, metadata !523, metadata !DIExpression()), !dbg !537
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !538
  %9 = load i32, i32* %8, align 4, !dbg !538, !tbaa !231
  %10 = zext i32 %9 to i64, !dbg !539
  %11 = inttoptr i64 %10 to i8*, !dbg !540
  call void @llvm.dbg.value(metadata i8* %11, metadata !524, metadata !DIExpression()), !dbg !541
  %12 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 0, !dbg !542
  call void @llvm.lifetime.start.p0i8(i64 64, i8* nonnull %12) #4, !dbg !542
  call void @llvm.memset.p0i8.i64(i8* nonnull align 4 %12, i8 0, i64 64, i1 false), !dbg !543
  call void @llvm.dbg.value(metadata i32 2, metadata !532, metadata !DIExpression()), !dbg !544
  call void @llvm.dbg.value(metadata i64 14, metadata !530, metadata !DIExpression()), !dbg !545
  %13 = getelementptr i8, i8* %11, i64 14, !dbg !546
  %14 = icmp ugt i8* %13, %7, !dbg !548
  br i1 %14, label %62, label %15, !dbg !549

; <label>:15:                                     ; preds = %1
  %16 = inttoptr i64 %10 to %struct.ethhdr*, !dbg !550
  call void @llvm.dbg.value(metadata %struct.ethhdr* %16, metadata !526, metadata !DIExpression()), !dbg !551
  %17 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %16, i64 0, i32 2, !dbg !552
  %18 = load i16, i16* %17, align 1, !dbg !552, !tbaa !553
  call void @llvm.dbg.value(metadata i16 %18, metadata !529, metadata !DIExpression()), !dbg !555
  %19 = icmp eq i16 %18, 8, !dbg !556
  br i1 %19, label %20, label %30, !dbg !558

; <label>:20:                                     ; preds = %15
  %21 = getelementptr inbounds i8, i8* %11, i64 34, !dbg !559
  %22 = bitcast i8* %21 to %struct.iphdr*, !dbg !559
  %23 = inttoptr i64 %6 to %struct.iphdr*, !dbg !562
  %24 = icmp ugt %struct.iphdr* %22, %23, !dbg !563
  br i1 %24, label %62, label %25, !dbg !564

; <label>:25:                                     ; preds = %20
  %26 = bitcast i8* %13 to %struct.iphdr*, !dbg !565
  call void @llvm.dbg.value(metadata %struct.iphdr* %26, metadata !528, metadata !DIExpression()), !dbg !566
  %27 = getelementptr inbounds i8, i8* %11, i64 22, !dbg !567
  %28 = load i8, i8* %27, align 4, !dbg !567, !tbaa !569
  %29 = icmp ult i8 %28, 2, !dbg !570
  br i1 %29, label %62, label %42, !dbg !571

; <label>:30:                                     ; preds = %15
  %31 = icmp eq i16 %18, -8826, !dbg !572
  br i1 %31, label %32, label %62, !dbg !574

; <label>:32:                                     ; preds = %30
  %33 = getelementptr inbounds i8, i8* %11, i64 54, !dbg !575
  %34 = bitcast i8* %33 to %struct.ipv6hdr*, !dbg !575
  %35 = inttoptr i64 %6 to %struct.ipv6hdr*, !dbg !578
  %36 = icmp ugt %struct.ipv6hdr* %34, %35, !dbg !579
  br i1 %36, label %62, label %37, !dbg !580

; <label>:37:                                     ; preds = %32
  %38 = bitcast i8* %13 to %struct.ipv6hdr*, !dbg !581
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %38, metadata !527, metadata !DIExpression()), !dbg !582
  %39 = getelementptr inbounds i8, i8* %11, i64 21, !dbg !583
  %40 = load i8, i8* %39, align 1, !dbg !583, !tbaa !585
  %41 = icmp ult i8 %40, 2, !dbg !586
  br i1 %41, label %62, label %42, !dbg !587

; <label>:42:                                     ; preds = %37, %25
  %43 = phi %struct.iphdr* [ %26, %25 ], [ undef, %37 ]
  %44 = phi %struct.ipv6hdr* [ undef, %25 ], [ %38, %37 ]
  call void @llvm.dbg.value(metadata %struct.ipv6hdr* %44, metadata !527, metadata !DIExpression()), !dbg !582
  call void @llvm.dbg.value(metadata %struct.iphdr* %43, metadata !528, metadata !DIExpression()), !dbg !566
  %45 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 3, !dbg !588
  %46 = load i32, i32* %45, align 4, !dbg !588, !tbaa !589
  %47 = getelementptr inbounds %struct.bpf_fib_lookup, %struct.bpf_fib_lookup* %3, i64 0, i32 5, !dbg !590
  store i32 %46, i32* %47, align 4, !dbg !591, !tbaa !592
  %48 = bitcast %struct.xdp_md* %0 to i8*, !dbg !594
  call void @llvm.dbg.value(metadata %struct.bpf_fib_lookup* %3, metadata !525, metadata !DIExpression(DW_OP_deref)), !dbg !543
  %49 = call i32 inttoptr (i64 69 to i32 (i8*, %struct.bpf_fib_lookup*, i32, i32)*)(i8* %48, %struct.bpf_fib_lookup* nonnull %3, i32 64, i32 0) #4, !dbg !595
  call void @llvm.dbg.value(metadata i32 %49, metadata !531, metadata !DIExpression()), !dbg !596
  switch i32 %49, label %62 [
    i32 0, label %50
    i32 1, label %61
    i32 2, label %61
    i32 3, label %61
  ], !dbg !597

; <label>:50:                                     ; preds = %42
  br i1 %19, label %51, label %55, !dbg !598

; <label>:51:                                     ; preds = %50
  call void @llvm.dbg.value(metadata %struct.iphdr* %43, metadata !600, metadata !DIExpression()), !dbg !605
  %52 = getelementptr inbounds %struct.iphdr, %struct.iphdr* %43, i64 0, i32 5, !dbg !608
  %53 = load i8, i8* %52, align 4, !dbg !609, !tbaa !569
  %54 = add i8 %53, -1, !dbg !609
  store i8 %54, i8* %52, align 4, !dbg !609, !tbaa !569
  br label %62, !dbg !610

; <label>:55:                                     ; preds = %50
  %56 = icmp eq i16 %18, -8826, !dbg !611
  br i1 %56, label %57, label %62, !dbg !613

; <label>:57:                                     ; preds = %55
  %58 = getelementptr inbounds %struct.ipv6hdr, %struct.ipv6hdr* %44, i64 0, i32 4, !dbg !614
  %59 = load i8, i8* %58, align 1, !dbg !615, !tbaa !585
  %60 = add i8 %59, -1, !dbg !615
  store i8 %60, i8* %58, align 1, !dbg !615, !tbaa !585
  br label %62, !dbg !616

; <label>:61:                                     ; preds = %42, %42, %42
  call void @llvm.dbg.value(metadata i32 1, metadata !532, metadata !DIExpression()), !dbg !544
  br label %62, !dbg !617

; <label>:62:                                     ; preds = %32, %20, %1, %61, %42, %55, %57, %51, %30, %37, %25
  %63 = phi i32 [ 2, %25 ], [ 2, %42 ], [ 1, %61 ], [ 2, %51 ], [ 2, %57 ], [ 2, %55 ], [ 2, %37 ], [ 2, %30 ], [ 1, %1 ], [ 1, %20 ], [ 1, %32 ], !dbg !618
  call void @llvm.dbg.value(metadata i32 %63, metadata !532, metadata !DIExpression()), !dbg !544
  %64 = bitcast i32* %2 to i8*, !dbg !619
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %64), !dbg !619
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !383, metadata !DIExpression()) #4, !dbg !619
  call void @llvm.dbg.value(metadata i32 %63, metadata !384, metadata !DIExpression()) #4, !dbg !621
  store i32 %63, i32* %2, align 4, !tbaa !396
  %65 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %64) #4, !dbg !622
  %66 = icmp eq i8* %65, null, !dbg !623
  br i1 %66, label %80, label %67, !dbg !624

; <label>:67:                                     ; preds = %62
  call void @llvm.dbg.value(metadata i8* %65, metadata !385, metadata !DIExpression()) #4, !dbg !625
  %68 = bitcast i8* %65 to i64*, !dbg !626
  %69 = load i64, i64* %68, align 8, !dbg !627, !tbaa !404
  %70 = add i64 %69, 1, !dbg !627
  store i64 %70, i64* %68, align 8, !dbg !627, !tbaa !404
  %71 = load i32, i32* %4, align 4, !dbg !628, !tbaa !222
  %72 = load i32, i32* %8, align 4, !dbg !629, !tbaa !231
  %73 = sub i32 %71, %72, !dbg !630
  %74 = zext i32 %73 to i64, !dbg !631
  %75 = getelementptr inbounds i8, i8* %65, i64 8, !dbg !632
  %76 = bitcast i8* %75 to i64*, !dbg !632
  %77 = load i64, i64* %76, align 8, !dbg !633, !tbaa !413
  %78 = add i64 %77, %74, !dbg !633
  store i64 %78, i64* %76, align 8, !dbg !633, !tbaa !413
  %79 = load i32, i32* %2, align 4, !dbg !634, !tbaa !396
  call void @llvm.dbg.value(metadata i32 %79, metadata !384, metadata !DIExpression()) #4, !dbg !621
  br label %80, !dbg !635

; <label>:80:                                     ; preds = %62, %67
  %81 = phi i32 [ %79, %67 ], [ 0, %62 ], !dbg !636
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %64), !dbg !637
  call void @llvm.lifetime.end.p0i8(i64 64, i8* nonnull %12) #4, !dbg !638
  ret i32 %81, !dbg !639
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #1

; Function Attrs: norecurse nounwind readnone
define dso_local i32 @xdp_pass_func(%struct.xdp_md* nocapture readnone) #2 section "xdp_pass" !dbg !640 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !642, metadata !DIExpression()), !dbg !643
  ret i32 2, !dbg !644
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #3

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { norecurse nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind readnone speculatable }
attributes #4 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!126, !127, !128}
!llvm.ident = !{!129}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !125, line: 16, type: !52, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !43, globals: !49, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/fedora/xdp-tutorial/packet03-redirecting")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/fedora/xdp-tutorial/packet03-redirecting")
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
!49 = !{!0, !50, !62, !64, !70, !75, !81}
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "tx_port", scope: !2, file: !3, line: 18, type: !52, isLocal: false, isDefinition: true)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !53, line: 210, size: 224, elements: !54)
!53 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/fedora/xdp-tutorial/packet03-redirecting")
!54 = !{!55, !56, !57, !58, !59, !60, !61}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !52, file: !53, line: 211, baseType: !7, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !52, file: !53, line: 212, baseType: !7, size: 32, offset: 32)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !52, file: !53, line: 213, baseType: !7, size: 32, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !52, file: !53, line: 214, baseType: !7, size: 32, offset: 96)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !52, file: !53, line: 215, baseType: !7, size: 32, offset: 128)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !52, file: !53, line: 216, baseType: !7, size: 32, offset: 160)
!61 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !52, file: !53, line: 217, baseType: !7, size: 32, offset: 192)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "redirect_params", scope: !2, file: !3, line: 25, type: !52, isLocal: false, isDefinition: true)
!64 = !DIGlobalVariableExpression(var: !65, expr: !DIExpression())
!65 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 274, type: !66, isLocal: false, isDefinition: true)
!66 = !DICompositeType(tag: DW_TAG_array_type, baseType: !67, size: 32, elements: !68)
!67 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!68 = !{!69}
!69 = !DISubrange(count: 4)
!70 = !DIGlobalVariableExpression(var: !71, expr: !DIExpression())
!71 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !53, line: 20, type: !72, isLocal: true, isDefinition: true)
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !73, size: 64)
!73 = !DISubroutineType(types: !74)
!74 = !{!44, !44, !44}
!75 = !DIGlobalVariableExpression(var: !76, expr: !DIExpression())
!76 = distinct !DIGlobalVariable(name: "bpf_redirect_map", scope: !2, file: !53, line: 57, type: !77, isLocal: true, isDefinition: true)
!77 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !78, size: 64)
!78 = !DISubroutineType(types: !79)
!79 = !{!80, !44, !80, !80}
!80 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!81 = !DIGlobalVariableExpression(var: !82, expr: !DIExpression())
!82 = distinct !DIGlobalVariable(name: "bpf_fib_lookup", scope: !2, file: !53, line: 137, type: !83, isLocal: true, isDefinition: true)
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = !DISubroutineType(types: !85)
!85 = !{!80, !44, !86, !80, !99}
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_fib_lookup", file: !6, line: 3179, size: 512, elements: !88)
!88 = !{!89, !92, !93, !96, !97, !98, !100, !107, !113, !118, !119, !120, !124}
!89 = !DIDerivedType(tag: DW_TAG_member, name: "family", scope: !87, file: !6, line: 3183, baseType: !90, size: 8)
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !47, line: 21, baseType: !91)
!91 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "l4_protocol", scope: !87, file: !6, line: 3186, baseType: !90, size: 8, offset: 8)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !87, file: !6, line: 3187, baseType: !94, size: 16, offset: 16)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !95, line: 25, baseType: !46)
!95 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!96 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !87, file: !6, line: 3188, baseType: !94, size: 16, offset: 32)
!97 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !87, file: !6, line: 3191, baseType: !46, size: 16, offset: 48)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "ifindex", scope: !87, file: !6, line: 3196, baseType: !99, size: 32, offset: 64)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!100 = !DIDerivedType(tag: DW_TAG_member, scope: !87, file: !6, line: 3198, baseType: !101, size: 32, offset: 96)
!101 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !87, file: !6, line: 3198, size: 32, elements: !102)
!102 = !{!103, !104, !106}
!103 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !101, file: !6, line: 3200, baseType: !90, size: 8)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "flowinfo", scope: !101, file: !6, line: 3201, baseType: !105, size: 32)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !95, line: 27, baseType: !99)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "rt_metric", scope: !101, file: !6, line: 3204, baseType: !99, size: 32)
!107 = !DIDerivedType(tag: DW_TAG_member, scope: !87, file: !6, line: 3207, baseType: !108, size: 128, offset: 128)
!108 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !87, file: !6, line: 3207, size: 128, elements: !109)
!109 = !{!110, !111}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_src", scope: !108, file: !6, line: 3208, baseType: !105, size: 32)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_src", scope: !108, file: !6, line: 3209, baseType: !112, size: 128)
!112 = !DICompositeType(tag: DW_TAG_array_type, baseType: !99, size: 128, elements: !68)
!113 = !DIDerivedType(tag: DW_TAG_member, scope: !87, file: !6, line: 3216, baseType: !114, size: 128, offset: 256)
!114 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !87, file: !6, line: 3216, size: 128, elements: !115)
!115 = !{!116, !117}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "ipv4_dst", scope: !114, file: !6, line: 3217, baseType: !105, size: 32)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "ipv6_dst", scope: !114, file: !6, line: 3218, baseType: !112, size: 128)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_proto", scope: !87, file: !6, line: 3222, baseType: !94, size: 16, offset: 384)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !87, file: !6, line: 3223, baseType: !94, size: 16, offset: 400)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "smac", scope: !87, file: !6, line: 3224, baseType: !121, size: 48, offset: 416)
!121 = !DICompositeType(tag: DW_TAG_array_type, baseType: !90, size: 48, elements: !122)
!122 = !{!123}
!123 = !DISubrange(count: 6)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "dmac", scope: !87, file: !6, line: 3225, baseType: !121, size: 48, offset: 464)
!125 = !DIFile(filename: "./../common/xdp_stats_kern.h", directory: "/home/fedora/xdp-tutorial/packet03-redirecting")
!126 = !{i32 2, !"Dwarf Version", i32 4}
!127 = !{i32 2, !"Debug Info Version", i32 3}
!128 = !{i32 1, !"wchar_size", i32 4}
!129 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!130 = distinct !DISubprogram(name: "xdp_icmp_echo_func", scope: !3, file: !3, line: 49, type: !131, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !141)
!131 = !DISubroutineType(types: !132)
!132 = !{!80, !133}
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !134, size: 64)
!134 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !135)
!135 = !{!136, !137, !138, !139, !140}
!136 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !134, file: !6, line: 2857, baseType: !99, size: 32)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !134, file: !6, line: 2858, baseType: !99, size: 32, offset: 32)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !134, file: !6, line: 2859, baseType: !99, size: 32, offset: 64)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !134, file: !6, line: 2861, baseType: !99, size: 32, offset: 96)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !134, file: !6, line: 2862, baseType: !99, size: 32, offset: 128)
!141 = !{!142, !143, !144, !145, !150, !159, !160, !161, !162, !179, !211, !212, !219}
!142 = !DILocalVariable(name: "ctx", arg: 1, scope: !130, file: !3, line: 49, type: !133)
!143 = !DILocalVariable(name: "data_end", scope: !130, file: !3, line: 51, type: !44)
!144 = !DILocalVariable(name: "data", scope: !130, file: !3, line: 52, type: !44)
!145 = !DILocalVariable(name: "nh", scope: !130, file: !3, line: 53, type: !146)
!146 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !147, line: 33, size: 64, elements: !148)
!147 = !DIFile(filename: "./../common/parsing_helpers.h", directory: "/home/fedora/xdp-tutorial/packet03-redirecting")
!148 = !{!149}
!149 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !146, file: !147, line: 34, baseType: !44, size: 64)
!150 = !DILocalVariable(name: "eth", scope: !130, file: !3, line: 54, type: !151)
!151 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !152, size: 64)
!152 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !153, line: 161, size: 112, elements: !154)
!153 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!154 = !{!155, !157, !158}
!155 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !152, file: !153, line: 162, baseType: !156, size: 48)
!156 = !DICompositeType(tag: DW_TAG_array_type, baseType: !91, size: 48, elements: !122)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !152, file: !153, line: 163, baseType: !156, size: 48, offset: 48)
!158 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !152, file: !153, line: 164, baseType: !94, size: 16, offset: 96)
!159 = !DILocalVariable(name: "eth_type", scope: !130, file: !3, line: 55, type: !80)
!160 = !DILocalVariable(name: "ip_type", scope: !130, file: !3, line: 56, type: !80)
!161 = !DILocalVariable(name: "icmp_type", scope: !130, file: !3, line: 57, type: !80)
!162 = !DILocalVariable(name: "iphdr", scope: !130, file: !3, line: 58, type: !163)
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !164, size: 64)
!164 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !165, line: 86, size: 160, elements: !166)
!165 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "")
!166 = !{!167, !168, !169, !170, !171, !172, !173, !174, !175, !177, !178}
!167 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !164, file: !165, line: 88, baseType: !90, size: 4, flags: DIFlagBitField, extraData: i64 0)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !164, file: !165, line: 89, baseType: !90, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !164, file: !165, line: 96, baseType: !90, size: 8, offset: 8)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !164, file: !165, line: 97, baseType: !94, size: 16, offset: 16)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !164, file: !165, line: 98, baseType: !94, size: 16, offset: 32)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !164, file: !165, line: 99, baseType: !94, size: 16, offset: 48)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !164, file: !165, line: 100, baseType: !90, size: 8, offset: 64)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !164, file: !165, line: 101, baseType: !90, size: 8, offset: 72)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !164, file: !165, line: 102, baseType: !176, size: 16, offset: 80)
!176 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !95, line: 31, baseType: !46)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !164, file: !165, line: 103, baseType: !105, size: 32, offset: 96)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !164, file: !165, line: 104, baseType: !105, size: 32, offset: 128)
!179 = !DILocalVariable(name: "ipv6hdr", scope: !130, file: !3, line: 59, type: !180)
!180 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !181, size: 64)
!181 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !182, line: 116, size: 320, elements: !183)
!182 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "")
!183 = !{!184, !185, !186, !190, !191, !192, !193, !210}
!184 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !181, file: !182, line: 118, baseType: !90, size: 4, flags: DIFlagBitField, extraData: i64 0)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !181, file: !182, line: 119, baseType: !90, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !181, file: !182, line: 126, baseType: !187, size: 24, offset: 8)
!187 = !DICompositeType(tag: DW_TAG_array_type, baseType: !90, size: 24, elements: !188)
!188 = !{!189}
!189 = !DISubrange(count: 3)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !181, file: !182, line: 128, baseType: !94, size: 16, offset: 32)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !181, file: !182, line: 129, baseType: !90, size: 8, offset: 48)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !181, file: !182, line: 130, baseType: !90, size: 8, offset: 56)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !181, file: !182, line: 132, baseType: !194, size: 128, offset: 64)
!194 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !195, line: 33, size: 128, elements: !196)
!195 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "")
!196 = !{!197}
!197 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !194, file: !195, line: 40, baseType: !198, size: 128)
!198 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !194, file: !195, line: 34, size: 128, elements: !199)
!199 = !{!200, !204, !208}
!200 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !198, file: !195, line: 35, baseType: !201, size: 128)
!201 = !DICompositeType(tag: DW_TAG_array_type, baseType: !90, size: 128, elements: !202)
!202 = !{!203}
!203 = !DISubrange(count: 16)
!204 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !198, file: !195, line: 37, baseType: !205, size: 128)
!205 = !DICompositeType(tag: DW_TAG_array_type, baseType: !94, size: 128, elements: !206)
!206 = !{!207}
!207 = !DISubrange(count: 8)
!208 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !198, file: !195, line: 38, baseType: !209, size: 128)
!209 = !DICompositeType(tag: DW_TAG_array_type, baseType: !105, size: 128, elements: !68)
!210 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !181, file: !182, line: 133, baseType: !194, size: 128, offset: 192)
!211 = !DILocalVariable(name: "echo_reply", scope: !130, file: !3, line: 60, type: !46)
!212 = !DILocalVariable(name: "icmphdr", scope: !130, file: !3, line: 61, type: !213)
!213 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !214, size: 64)
!214 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "icmphdr_common", file: !147, line: 51, size: 32, elements: !215)
!215 = !{!216, !217, !218}
!216 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !214, file: !147, line: 52, baseType: !90, size: 8)
!217 = !DIDerivedType(tag: DW_TAG_member, name: "code", scope: !214, file: !147, line: 53, baseType: !90, size: 8, offset: 8)
!218 = !DIDerivedType(tag: DW_TAG_member, name: "cksum", scope: !214, file: !147, line: 54, baseType: !176, size: 16, offset: 16)
!219 = !DILocalVariable(name: "action", scope: !130, file: !3, line: 62, type: !99)
!220 = !DILocation(line: 49, column: 39, scope: !130)
!221 = !DILocation(line: 51, column: 38, scope: !130)
!222 = !{!223, !224, i64 4}
!223 = !{!"xdp_md", !224, i64 0, !224, i64 4, !224, i64 8, !224, i64 12, !224, i64 16}
!224 = !{!"int", !225, i64 0}
!225 = !{!"omnipotent char", !226, i64 0}
!226 = !{!"Simple C/C++ TBAA"}
!227 = !DILocation(line: 51, column: 27, scope: !130)
!228 = !DILocation(line: 51, column: 19, scope: !130)
!229 = !DILocation(line: 51, column: 8, scope: !130)
!230 = !DILocation(line: 52, column: 34, scope: !130)
!231 = !{!223, !224, i64 0}
!232 = !DILocation(line: 52, column: 23, scope: !130)
!233 = !DILocation(line: 52, column: 15, scope: !130)
!234 = !DILocation(line: 52, column: 8, scope: !130)
!235 = !DILocation(line: 62, column: 8, scope: !130)
!236 = !DILocation(line: 53, column: 20, scope: !130)
!237 = !DILocation(line: 54, column: 17, scope: !130)
!238 = !DILocalVariable(name: "nh", arg: 1, scope: !239, file: !147, line: 73, type: !242)
!239 = distinct !DISubprogram(name: "parse_ethhdr", scope: !147, file: !147, line: 73, type: !240, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !244)
!240 = !DISubroutineType(types: !241)
!241 = !{!80, !242, !44, !243}
!242 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!243 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !151, size: 64)
!244 = !{!238, !245, !246, !247, !248, !249, !255, !256}
!245 = !DILocalVariable(name: "data_end", arg: 2, scope: !239, file: !147, line: 73, type: !44)
!246 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !239, file: !147, line: 74, type: !243)
!247 = !DILocalVariable(name: "eth", scope: !239, file: !147, line: 76, type: !151)
!248 = !DILocalVariable(name: "hdrsize", scope: !239, file: !147, line: 77, type: !80)
!249 = !DILocalVariable(name: "vlh", scope: !239, file: !147, line: 78, type: !250)
!250 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !251, size: 64)
!251 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !147, line: 42, size: 32, elements: !252)
!252 = !{!253, !254}
!253 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !251, file: !147, line: 43, baseType: !94, size: 16)
!254 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !251, file: !147, line: 44, baseType: !94, size: 16, offset: 16)
!255 = !DILocalVariable(name: "h_proto", scope: !239, file: !147, line: 79, type: !46)
!256 = !DILocalVariable(name: "i", scope: !239, file: !147, line: 80, type: !80)
!257 = !DILocation(line: 73, column: 60, scope: !239, inlinedAt: !258)
!258 = distinct !DILocation(line: 68, column: 13, scope: !130)
!259 = !DILocation(line: 73, column: 70, scope: !239, inlinedAt: !258)
!260 = !DILocation(line: 74, column: 22, scope: !239, inlinedAt: !258)
!261 = !DILocation(line: 77, column: 6, scope: !239, inlinedAt: !258)
!262 = !DILocation(line: 85, column: 14, scope: !263, inlinedAt: !258)
!263 = distinct !DILexicalBlock(scope: !239, file: !147, line: 85, column: 6)
!264 = !DILocation(line: 85, column: 24, scope: !263, inlinedAt: !258)
!265 = !DILocation(line: 85, column: 6, scope: !239, inlinedAt: !258)
!266 = !DILocation(line: 76, column: 17, scope: !239, inlinedAt: !258)
!267 = !DILocation(line: 78, column: 19, scope: !239, inlinedAt: !258)
!268 = !DILocation(line: 91, column: 17, scope: !239, inlinedAt: !258)
!269 = !DILocation(line: 79, column: 8, scope: !239, inlinedAt: !258)
!270 = !DILocation(line: 80, column: 6, scope: !239, inlinedAt: !258)
!271 = !DILocation(line: 0, scope: !239, inlinedAt: !258)
!272 = !{!273, !273, i64 0}
!273 = !{!"short", !225, i64 0}
!274 = !DILocation(line: 98, column: 7, scope: !275, inlinedAt: !258)
!275 = distinct !DILexicalBlock(scope: !276, file: !147, line: 97, column: 39)
!276 = distinct !DILexicalBlock(scope: !277, file: !147, line: 97, column: 2)
!277 = distinct !DILexicalBlock(scope: !239, file: !147, line: 97, column: 2)
!278 = !DILocation(line: 101, column: 11, scope: !279, inlinedAt: !258)
!279 = distinct !DILexicalBlock(scope: !275, file: !147, line: 101, column: 7)
!280 = !DILocation(line: 101, column: 15, scope: !279, inlinedAt: !258)
!281 = !DILocation(line: 101, column: 7, scope: !275, inlinedAt: !258)
!282 = !DILocation(line: 104, column: 18, scope: !275, inlinedAt: !258)
!283 = !DILocation(line: 55, column: 6, scope: !130)
!284 = !DILocation(line: 69, column: 6, scope: !130)
!285 = !DILocation(line: 58, column: 16, scope: !130)
!286 = !DILocalVariable(name: "nh", arg: 1, scope: !287, file: !147, line: 131, type: !242)
!287 = distinct !DISubprogram(name: "parse_iphdr", scope: !147, file: !147, line: 131, type: !288, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !291)
!288 = !DISubroutineType(types: !289)
!289 = !{!80, !242, !44, !290}
!290 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !163, size: 64)
!291 = !{!286, !292, !293, !294, !295}
!292 = !DILocalVariable(name: "data_end", arg: 2, scope: !287, file: !147, line: 132, type: !44)
!293 = !DILocalVariable(name: "iphdr", arg: 3, scope: !287, file: !147, line: 133, type: !290)
!294 = !DILocalVariable(name: "iph", scope: !287, file: !147, line: 135, type: !163)
!295 = !DILocalVariable(name: "hdrsize", scope: !287, file: !147, line: 136, type: !80)
!296 = !DILocation(line: 131, column: 59, scope: !287, inlinedAt: !297)
!297 = distinct !DILocation(line: 70, column: 13, scope: !298)
!298 = distinct !DILexicalBlock(scope: !299, file: !3, line: 69, column: 39)
!299 = distinct !DILexicalBlock(scope: !130, file: !3, line: 69, column: 6)
!300 = !DILocation(line: 132, column: 18, scope: !287, inlinedAt: !297)
!301 = !DILocation(line: 133, column: 27, scope: !287, inlinedAt: !297)
!302 = !DILocation(line: 135, column: 16, scope: !287, inlinedAt: !297)
!303 = !DILocation(line: 138, column: 10, scope: !304, inlinedAt: !297)
!304 = distinct !DILexicalBlock(scope: !287, file: !147, line: 138, column: 6)
!305 = !DILocation(line: 138, column: 14, scope: !304, inlinedAt: !297)
!306 = !DILocation(line: 138, column: 6, scope: !287, inlinedAt: !297)
!307 = !DILocation(line: 141, column: 17, scope: !287, inlinedAt: !297)
!308 = !DILocation(line: 141, column: 21, scope: !287, inlinedAt: !297)
!309 = !DILocation(line: 144, column: 14, scope: !310, inlinedAt: !297)
!310 = distinct !DILexicalBlock(scope: !287, file: !147, line: 144, column: 6)
!311 = !DILocation(line: 136, column: 6, scope: !287, inlinedAt: !297)
!312 = !DILocation(line: 144, column: 24, scope: !310, inlinedAt: !297)
!313 = !DILocation(line: 144, column: 6, scope: !287, inlinedAt: !297)
!314 = !DILocation(line: 150, column: 14, scope: !287, inlinedAt: !297)
!315 = !{!316, !225, i64 9}
!316 = !{!"iphdr", !225, i64 0, !225, i64 0, !225, i64 1, !273, i64 2, !273, i64 4, !273, i64 6, !225, i64 8, !225, i64 9, !273, i64 10, !224, i64 12, !224, i64 16}
!317 = !DILocation(line: 71, column: 15, scope: !318)
!318 = distinct !DILexicalBlock(scope: !298, file: !3, line: 71, column: 7)
!319 = !DILocation(line: 71, column: 7, scope: !298)
!320 = !DILocalVariable(name: "nh", arg: 1, scope: !321, file: !147, line: 112, type: !242)
!321 = distinct !DISubprogram(name: "parse_ip6hdr", scope: !147, file: !147, line: 112, type: !322, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !325)
!322 = !DISubroutineType(types: !323)
!323 = !{!80, !242, !44, !324}
!324 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !180, size: 64)
!325 = !{!320, !326, !327, !328}
!326 = !DILocalVariable(name: "data_end", arg: 2, scope: !321, file: !147, line: 113, type: !44)
!327 = !DILocalVariable(name: "ip6hdr", arg: 3, scope: !321, file: !147, line: 114, type: !324)
!328 = !DILocalVariable(name: "ip6h", scope: !321, file: !147, line: 116, type: !180)
!329 = !DILocation(line: 112, column: 60, scope: !321, inlinedAt: !330)
!330 = distinct !DILocation(line: 74, column: 13, scope: !331)
!331 = distinct !DILexicalBlock(scope: !332, file: !3, line: 73, column: 48)
!332 = distinct !DILexicalBlock(scope: !299, file: !3, line: 73, column: 13)
!333 = !DILocation(line: 113, column: 12, scope: !321, inlinedAt: !330)
!334 = !DILocation(line: 122, column: 11, scope: !335, inlinedAt: !330)
!335 = distinct !DILexicalBlock(scope: !321, file: !147, line: 122, column: 6)
!336 = !DILocation(line: 122, column: 17, scope: !335, inlinedAt: !330)
!337 = !DILocation(line: 122, column: 15, scope: !335, inlinedAt: !330)
!338 = !DILocation(line: 122, column: 6, scope: !321, inlinedAt: !330)
!339 = !DILocation(line: 116, column: 18, scope: !321, inlinedAt: !330)
!340 = !DILocation(line: 128, column: 15, scope: !321, inlinedAt: !330)
!341 = !{!342, !225, i64 6}
!342 = !{!"ipv6hdr", !225, i64 0, !225, i64 0, !225, i64 1, !273, i64 4, !225, i64 6, !225, i64 7, !343, i64 8, !343, i64 24}
!343 = !{!"in6_addr", !225, i64 0}
!344 = !DILocation(line: 75, column: 15, scope: !345)
!345 = distinct !DILexicalBlock(scope: !331, file: !3, line: 75, column: 7)
!346 = !DILocation(line: 75, column: 7, scope: !331)
!347 = !DILocation(line: 65, column: 9, scope: !130)
!348 = !DILocalVariable(name: "nh", arg: 1, scope: !349, file: !147, line: 183, type: !242)
!349 = distinct !DISubprogram(name: "parse_icmphdr_common", scope: !147, file: !147, line: 183, type: !350, scopeLine: 186, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !353)
!350 = !DISubroutineType(types: !351)
!351 = !{!80, !242, !44, !352}
!352 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !213, size: 64)
!353 = !{!348, !354, !355, !356}
!354 = !DILocalVariable(name: "data_end", arg: 2, scope: !349, file: !147, line: 184, type: !44)
!355 = !DILocalVariable(name: "icmphdr", arg: 3, scope: !349, file: !147, line: 185, type: !352)
!356 = !DILocalVariable(name: "h", scope: !349, file: !147, line: 187, type: !213)
!357 = !DILocation(line: 183, column: 68, scope: !349, inlinedAt: !358)
!358 = distinct !DILocation(line: 87, column: 14, scope: !130)
!359 = !DILocation(line: 184, column: 13, scope: !349, inlinedAt: !358)
!360 = !DILocation(line: 189, column: 8, scope: !361, inlinedAt: !358)
!361 = distinct !DILexicalBlock(scope: !349, file: !147, line: 189, column: 6)
!362 = !DILocation(line: 189, column: 14, scope: !361, inlinedAt: !358)
!363 = !DILocation(line: 189, column: 12, scope: !361, inlinedAt: !358)
!364 = !DILocation(line: 189, column: 6, scope: !349, inlinedAt: !358)
!365 = !DILocation(line: 187, column: 25, scope: !349, inlinedAt: !358)
!366 = !DILocation(line: 195, column: 12, scope: !349, inlinedAt: !358)
!367 = !{!368, !225, i64 0}
!368 = !{!"icmphdr_common", !225, i64 0, !225, i64 1, !273, i64 2}
!369 = !DILocation(line: 88, column: 51, scope: !370)
!370 = distinct !DILexicalBlock(scope: !130, file: !3, line: 88, column: 6)
!371 = !DILocation(line: 88, column: 38, scope: !370)
!372 = !DILocation(line: 92, column: 22, scope: !373)
!373 = distinct !DILexicalBlock(scope: !370, file: !3, line: 92, column: 13)
!374 = !DILocation(line: 93, column: 19, scope: !373)
!375 = !DILocation(line: 93, column: 6, scope: !373)
!376 = !DILocation(line: 107, column: 2, scope: !130)
!377 = !DILocation(line: 0, scope: !130)
!378 = !DILocation(line: 24, column: 46, scope: !379, inlinedAt: !394)
!379 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !125, file: !125, line: 24, type: !380, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !382)
!380 = !DISubroutineType(types: !381)
!381 = !{!99, !133, !99}
!382 = !{!383, !384, !385}
!383 = !DILocalVariable(name: "ctx", arg: 1, scope: !379, file: !125, line: 24, type: !133)
!384 = !DILocalVariable(name: "action", arg: 2, scope: !379, file: !125, line: 24, type: !99)
!385 = !DILocalVariable(name: "rec", scope: !379, file: !125, line: 30, type: !386)
!386 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !387, size: 64)
!387 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !388, line: 10, size: 128, elements: !389)
!388 = !DIFile(filename: "./../common/xdp_stats_kern_user.h", directory: "/home/fedora/xdp-tutorial/packet03-redirecting")
!389 = !{!390, !393}
!390 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !387, file: !388, line: 11, baseType: !391, size: 64)
!391 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !392)
!392 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!393 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !387, file: !388, line: 12, baseType: !391, size: 64, offset: 64)
!394 = distinct !DILocation(line: 110, column: 9, scope: !130)
!395 = !DILocation(line: 24, column: 57, scope: !379, inlinedAt: !394)
!396 = !{!224, !224, i64 0}
!397 = !DILocation(line: 30, column: 24, scope: !379, inlinedAt: !394)
!398 = !DILocation(line: 31, column: 7, scope: !399, inlinedAt: !394)
!399 = distinct !DILexicalBlock(scope: !379, file: !125, line: 31, column: 6)
!400 = !DILocation(line: 31, column: 6, scope: !379, inlinedAt: !394)
!401 = !DILocation(line: 30, column: 18, scope: !379, inlinedAt: !394)
!402 = !DILocation(line: 38, column: 7, scope: !379, inlinedAt: !394)
!403 = !DILocation(line: 38, column: 17, scope: !379, inlinedAt: !394)
!404 = !{!405, !406, i64 0}
!405 = !{!"datarec", !406, i64 0, !406, i64 8}
!406 = !{!"long long", !225, i64 0}
!407 = !DILocation(line: 39, column: 25, scope: !379, inlinedAt: !394)
!408 = !DILocation(line: 39, column: 41, scope: !379, inlinedAt: !394)
!409 = !DILocation(line: 39, column: 34, scope: !379, inlinedAt: !394)
!410 = !DILocation(line: 39, column: 19, scope: !379, inlinedAt: !394)
!411 = !DILocation(line: 39, column: 7, scope: !379, inlinedAt: !394)
!412 = !DILocation(line: 39, column: 16, scope: !379, inlinedAt: !394)
!413 = !{!405, !406, i64 8}
!414 = !DILocation(line: 41, column: 9, scope: !379, inlinedAt: !394)
!415 = !DILocation(line: 41, column: 2, scope: !379, inlinedAt: !394)
!416 = !DILocation(line: 0, scope: !379, inlinedAt: !394)
!417 = !DILocation(line: 42, column: 1, scope: !379, inlinedAt: !394)
!418 = !DILocation(line: 110, column: 2, scope: !130)
!419 = distinct !DISubprogram(name: "xdp_redirect_func", scope: !3, file: !3, line: 115, type: !131, scopeLine: 116, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !420)
!420 = !{!421, !422, !423, !424, !425, !426, !427}
!421 = !DILocalVariable(name: "ctx", arg: 1, scope: !419, file: !3, line: 115, type: !133)
!422 = !DILocalVariable(name: "data_end", scope: !419, file: !3, line: 117, type: !44)
!423 = !DILocalVariable(name: "data", scope: !419, file: !3, line: 118, type: !44)
!424 = !DILocalVariable(name: "nh", scope: !419, file: !3, line: 119, type: !146)
!425 = !DILocalVariable(name: "eth", scope: !419, file: !3, line: 120, type: !151)
!426 = !DILocalVariable(name: "eth_type", scope: !419, file: !3, line: 121, type: !80)
!427 = !DILocalVariable(name: "action", scope: !419, file: !3, line: 122, type: !80)
!428 = !DILocation(line: 115, column: 38, scope: !419)
!429 = !DILocation(line: 122, column: 6, scope: !419)
!430 = !DILocation(line: 119, column: 20, scope: !419)
!431 = !DILocation(line: 120, column: 17, scope: !419)
!432 = !DILocation(line: 24, column: 46, scope: !379, inlinedAt: !433)
!433 = distinct !DILocation(line: 138, column: 9, scope: !419)
!434 = !DILocation(line: 24, column: 57, scope: !379, inlinedAt: !433)
!435 = !DILocation(line: 30, column: 24, scope: !379, inlinedAt: !433)
!436 = !DILocation(line: 31, column: 7, scope: !399, inlinedAt: !433)
!437 = !DILocation(line: 31, column: 6, scope: !379, inlinedAt: !433)
!438 = !DILocation(line: 118, column: 34, scope: !419)
!439 = !DILocation(line: 117, column: 38, scope: !419)
!440 = !DILocation(line: 30, column: 18, scope: !379, inlinedAt: !433)
!441 = !DILocation(line: 38, column: 7, scope: !379, inlinedAt: !433)
!442 = !DILocation(line: 38, column: 17, scope: !379, inlinedAt: !433)
!443 = !DILocation(line: 39, column: 25, scope: !379, inlinedAt: !433)
!444 = !DILocation(line: 39, column: 41, scope: !379, inlinedAt: !433)
!445 = !DILocation(line: 39, column: 34, scope: !379, inlinedAt: !433)
!446 = !DILocation(line: 39, column: 19, scope: !379, inlinedAt: !433)
!447 = !DILocation(line: 39, column: 7, scope: !379, inlinedAt: !433)
!448 = !DILocation(line: 39, column: 16, scope: !379, inlinedAt: !433)
!449 = !DILocation(line: 41, column: 9, scope: !379, inlinedAt: !433)
!450 = !DILocation(line: 41, column: 2, scope: !379, inlinedAt: !433)
!451 = !DILocation(line: 0, scope: !379, inlinedAt: !433)
!452 = !DILocation(line: 42, column: 1, scope: !379, inlinedAt: !433)
!453 = !DILocation(line: 138, column: 2, scope: !419)
!454 = distinct !DISubprogram(name: "xdp_redirect_map_func", scope: !3, file: !3, line: 143, type: !131, scopeLine: 144, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !455)
!455 = !{!456, !457, !458, !459, !460, !461, !462, !463}
!456 = !DILocalVariable(name: "ctx", arg: 1, scope: !454, file: !3, line: 143, type: !133)
!457 = !DILocalVariable(name: "data_end", scope: !454, file: !3, line: 145, type: !44)
!458 = !DILocalVariable(name: "data", scope: !454, file: !3, line: 146, type: !44)
!459 = !DILocalVariable(name: "nh", scope: !454, file: !3, line: 147, type: !146)
!460 = !DILocalVariable(name: "eth", scope: !454, file: !3, line: 148, type: !151)
!461 = !DILocalVariable(name: "eth_type", scope: !454, file: !3, line: 149, type: !80)
!462 = !DILocalVariable(name: "action", scope: !454, file: !3, line: 150, type: !80)
!463 = !DILocalVariable(name: "dst", scope: !454, file: !3, line: 151, type: !464)
!464 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !91, size: 64)
!465 = !DILocation(line: 143, column: 42, scope: !454)
!466 = !DILocation(line: 145, column: 38, scope: !454)
!467 = !DILocation(line: 145, column: 27, scope: !454)
!468 = !DILocation(line: 145, column: 19, scope: !454)
!469 = !DILocation(line: 145, column: 8, scope: !454)
!470 = !DILocation(line: 146, column: 34, scope: !454)
!471 = !DILocation(line: 146, column: 23, scope: !454)
!472 = !DILocation(line: 146, column: 15, scope: !454)
!473 = !DILocation(line: 146, column: 8, scope: !454)
!474 = !DILocation(line: 150, column: 6, scope: !454)
!475 = !DILocation(line: 147, column: 20, scope: !454)
!476 = !DILocation(line: 73, column: 60, scope: !239, inlinedAt: !477)
!477 = distinct !DILocation(line: 157, column: 13, scope: !454)
!478 = !DILocation(line: 73, column: 70, scope: !239, inlinedAt: !477)
!479 = !DILocation(line: 77, column: 6, scope: !239, inlinedAt: !477)
!480 = !DILocation(line: 85, column: 14, scope: !263, inlinedAt: !477)
!481 = !DILocation(line: 85, column: 24, scope: !263, inlinedAt: !477)
!482 = !DILocation(line: 85, column: 6, scope: !239, inlinedAt: !477)
!483 = !DILocation(line: 76, column: 17, scope: !239, inlinedAt: !477)
!484 = !DILocation(line: 89, column: 10, scope: !239, inlinedAt: !477)
!485 = !DILocation(line: 78, column: 19, scope: !239, inlinedAt: !477)
!486 = !DILocation(line: 79, column: 8, scope: !239, inlinedAt: !477)
!487 = !DILocation(line: 80, column: 6, scope: !239, inlinedAt: !477)
!488 = !DILocation(line: 148, column: 17, scope: !454)
!489 = !DILocation(line: 162, column: 46, scope: !454)
!490 = !DILocation(line: 162, column: 8, scope: !454)
!491 = !DILocation(line: 151, column: 17, scope: !454)
!492 = !DILocation(line: 163, column: 7, scope: !493)
!493 = distinct !DILexicalBlock(scope: !454, file: !3, line: 163, column: 6)
!494 = !DILocation(line: 163, column: 6, scope: !454)
!495 = !DILocation(line: 24, column: 46, scope: !379, inlinedAt: !496)
!496 = distinct !DILocation(line: 171, column: 9, scope: !454)
!497 = !DILocation(line: 24, column: 57, scope: !379, inlinedAt: !496)
!498 = !DILocation(line: 26, column: 6, scope: !379, inlinedAt: !496)
!499 = !DILocation(line: 167, column: 2, scope: !454)
!500 = !DILocation(line: 168, column: 11, scope: !454)
!501 = !DILocation(line: 26, column: 13, scope: !502, inlinedAt: !496)
!502 = distinct !DILexicalBlock(scope: !379, file: !125, line: 26, column: 6)
!503 = !DILocation(line: 30, column: 24, scope: !379, inlinedAt: !496)
!504 = !DILocation(line: 31, column: 7, scope: !399, inlinedAt: !496)
!505 = !DILocation(line: 31, column: 6, scope: !379, inlinedAt: !496)
!506 = !DILocation(line: 30, column: 18, scope: !379, inlinedAt: !496)
!507 = !DILocation(line: 38, column: 7, scope: !379, inlinedAt: !496)
!508 = !DILocation(line: 38, column: 17, scope: !379, inlinedAt: !496)
!509 = !DILocation(line: 39, column: 25, scope: !379, inlinedAt: !496)
!510 = !DILocation(line: 39, column: 41, scope: !379, inlinedAt: !496)
!511 = !DILocation(line: 39, column: 34, scope: !379, inlinedAt: !496)
!512 = !DILocation(line: 39, column: 19, scope: !379, inlinedAt: !496)
!513 = !DILocation(line: 39, column: 7, scope: !379, inlinedAt: !496)
!514 = !DILocation(line: 39, column: 16, scope: !379, inlinedAt: !496)
!515 = !DILocation(line: 41, column: 9, scope: !379, inlinedAt: !496)
!516 = !DILocation(line: 41, column: 2, scope: !379, inlinedAt: !496)
!517 = !DILocation(line: 0, scope: !379, inlinedAt: !496)
!518 = !DILocation(line: 42, column: 1, scope: !379, inlinedAt: !496)
!519 = !DILocation(line: 171, column: 2, scope: !454)
!520 = distinct !DISubprogram(name: "xdp_router_func", scope: !3, file: !3, line: 183, type: !131, scopeLine: 184, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !521)
!521 = !{!522, !523, !524, !525, !526, !527, !528, !529, !530, !531, !532}
!522 = !DILocalVariable(name: "ctx", arg: 1, scope: !520, file: !3, line: 183, type: !133)
!523 = !DILocalVariable(name: "data_end", scope: !520, file: !3, line: 185, type: !44)
!524 = !DILocalVariable(name: "data", scope: !520, file: !3, line: 186, type: !44)
!525 = !DILocalVariable(name: "fib_params", scope: !520, file: !3, line: 187, type: !87)
!526 = !DILocalVariable(name: "eth", scope: !520, file: !3, line: 188, type: !151)
!527 = !DILocalVariable(name: "ip6h", scope: !520, file: !3, line: 189, type: !180)
!528 = !DILocalVariable(name: "iph", scope: !520, file: !3, line: 190, type: !163)
!529 = !DILocalVariable(name: "h_proto", scope: !520, file: !3, line: 191, type: !46)
!530 = !DILocalVariable(name: "nh_off", scope: !520, file: !3, line: 192, type: !391)
!531 = !DILocalVariable(name: "rc", scope: !520, file: !3, line: 193, type: !80)
!532 = !DILocalVariable(name: "action", scope: !520, file: !3, line: 194, type: !80)
!533 = !DILocation(line: 183, column: 36, scope: !520)
!534 = !DILocation(line: 185, column: 38, scope: !520)
!535 = !DILocation(line: 185, column: 27, scope: !520)
!536 = !DILocation(line: 185, column: 19, scope: !520)
!537 = !DILocation(line: 185, column: 8, scope: !520)
!538 = !DILocation(line: 186, column: 34, scope: !520)
!539 = !DILocation(line: 186, column: 23, scope: !520)
!540 = !DILocation(line: 186, column: 15, scope: !520)
!541 = !DILocation(line: 186, column: 8, scope: !520)
!542 = !DILocation(line: 187, column: 2, scope: !520)
!543 = !DILocation(line: 187, column: 24, scope: !520)
!544 = !DILocation(line: 194, column: 6, scope: !520)
!545 = !DILocation(line: 192, column: 8, scope: !520)
!546 = !DILocation(line: 197, column: 11, scope: !547)
!547 = distinct !DILexicalBlock(scope: !520, file: !3, line: 197, column: 6)
!548 = !DILocation(line: 197, column: 20, scope: !547)
!549 = !DILocation(line: 197, column: 6, scope: !520)
!550 = !DILocation(line: 188, column: 23, scope: !520)
!551 = !DILocation(line: 188, column: 17, scope: !520)
!552 = !DILocation(line: 202, column: 17, scope: !520)
!553 = !{!554, !273, i64 12}
!554 = !{!"ethhdr", !225, i64 0, !225, i64 6, !273, i64 12}
!555 = !DILocation(line: 191, column: 8, scope: !520)
!556 = !DILocation(line: 203, column: 14, scope: !557)
!557 = distinct !DILexicalBlock(scope: !520, file: !3, line: 203, column: 6)
!558 = !DILocation(line: 203, column: 6, scope: !520)
!559 = !DILocation(line: 206, column: 11, scope: !560)
!560 = distinct !DILexicalBlock(scope: !561, file: !3, line: 206, column: 7)
!561 = distinct !DILexicalBlock(scope: !557, file: !3, line: 203, column: 38)
!562 = !DILocation(line: 206, column: 17, scope: !560)
!563 = !DILocation(line: 206, column: 15, scope: !560)
!564 = !DILocation(line: 206, column: 7, scope: !561)
!565 = !DILocation(line: 204, column: 9, scope: !561)
!566 = !DILocation(line: 190, column: 16, scope: !520)
!567 = !DILocation(line: 211, column: 12, scope: !568)
!568 = distinct !DILexicalBlock(scope: !561, file: !3, line: 211, column: 7)
!569 = !{!316, !225, i64 8}
!570 = !DILocation(line: 211, column: 16, scope: !568)
!571 = !DILocation(line: 211, column: 7, scope: !561)
!572 = !DILocation(line: 215, column: 21, scope: !573)
!573 = distinct !DILexicalBlock(scope: !557, file: !3, line: 215, column: 13)
!574 = !DILocation(line: 215, column: 13, scope: !557)
!575 = !DILocation(line: 221, column: 12, scope: !576)
!576 = distinct !DILexicalBlock(scope: !577, file: !3, line: 221, column: 7)
!577 = distinct !DILexicalBlock(scope: !573, file: !3, line: 215, column: 47)
!578 = !DILocation(line: 221, column: 18, scope: !576)
!579 = !DILocation(line: 221, column: 16, scope: !576)
!580 = !DILocation(line: 221, column: 7, scope: !577)
!581 = !DILocation(line: 220, column: 10, scope: !577)
!582 = !DILocation(line: 189, column: 18, scope: !520)
!583 = !DILocation(line: 226, column: 13, scope: !584)
!584 = distinct !DILexicalBlock(scope: !577, file: !3, line: 226, column: 7)
!585 = !{!342, !225, i64 7}
!586 = !DILocation(line: 226, column: 23, scope: !584)
!587 = !DILocation(line: 226, column: 7, scope: !577)
!588 = !DILocation(line: 234, column: 28, scope: !520)
!589 = !{!223, !224, i64 12}
!590 = !DILocation(line: 234, column: 13, scope: !520)
!591 = !DILocation(line: 234, column: 21, scope: !520)
!592 = !{!593, !224, i64 8}
!593 = !{!"bpf_fib_lookup", !225, i64 0, !225, i64 1, !273, i64 2, !273, i64 4, !273, i64 6, !224, i64 8, !225, i64 12, !225, i64 16, !225, i64 32, !273, i64 48, !273, i64 50, !225, i64 52, !225, i64 58}
!594 = !DILocation(line: 236, column: 22, scope: !520)
!595 = !DILocation(line: 236, column: 7, scope: !520)
!596 = !DILocation(line: 193, column: 6, scope: !520)
!597 = !DILocation(line: 237, column: 2, scope: !520)
!598 = !DILocation(line: 239, column: 7, scope: !599)
!599 = distinct !DILexicalBlock(scope: !520, file: !3, line: 237, column: 14)
!600 = !DILocalVariable(name: "iph", arg: 1, scope: !601, file: !3, line: 175, type: !163)
!601 = distinct !DISubprogram(name: "ip_decrease_ttl", scope: !3, file: !3, line: 175, type: !602, scopeLine: 176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !604)
!602 = !DISubroutineType(types: !603)
!603 = !{!80, !163}
!604 = !{!600}
!605 = !DILocation(line: 175, column: 58, scope: !601, inlinedAt: !606)
!606 = distinct !DILocation(line: 240, column: 4, scope: !607)
!607 = distinct !DILexicalBlock(scope: !599, file: !3, line: 239, column: 7)
!608 = !DILocation(line: 178, column: 16, scope: !601, inlinedAt: !606)
!609 = !DILocation(line: 178, column: 9, scope: !601, inlinedAt: !606)
!610 = !DILocation(line: 240, column: 4, scope: !607)
!611 = !DILocation(line: 241, column: 20, scope: !612)
!612 = distinct !DILexicalBlock(scope: !607, file: !3, line: 241, column: 12)
!613 = !DILocation(line: 241, column: 12, scope: !607)
!614 = !DILocation(line: 242, column: 10, scope: !612)
!615 = !DILocation(line: 242, column: 19, scope: !612)
!616 = !DILocation(line: 242, column: 4, scope: !612)
!617 = !DILocation(line: 254, column: 3, scope: !599)
!618 = !DILocation(line: 0, scope: !520)
!619 = !DILocation(line: 24, column: 46, scope: !379, inlinedAt: !620)
!620 = distinct !DILocation(line: 265, column: 9, scope: !520)
!621 = !DILocation(line: 24, column: 57, scope: !379, inlinedAt: !620)
!622 = !DILocation(line: 30, column: 24, scope: !379, inlinedAt: !620)
!623 = !DILocation(line: 31, column: 7, scope: !399, inlinedAt: !620)
!624 = !DILocation(line: 31, column: 6, scope: !379, inlinedAt: !620)
!625 = !DILocation(line: 30, column: 18, scope: !379, inlinedAt: !620)
!626 = !DILocation(line: 38, column: 7, scope: !379, inlinedAt: !620)
!627 = !DILocation(line: 38, column: 17, scope: !379, inlinedAt: !620)
!628 = !DILocation(line: 39, column: 25, scope: !379, inlinedAt: !620)
!629 = !DILocation(line: 39, column: 41, scope: !379, inlinedAt: !620)
!630 = !DILocation(line: 39, column: 34, scope: !379, inlinedAt: !620)
!631 = !DILocation(line: 39, column: 19, scope: !379, inlinedAt: !620)
!632 = !DILocation(line: 39, column: 7, scope: !379, inlinedAt: !620)
!633 = !DILocation(line: 39, column: 16, scope: !379, inlinedAt: !620)
!634 = !DILocation(line: 41, column: 9, scope: !379, inlinedAt: !620)
!635 = !DILocation(line: 41, column: 2, scope: !379, inlinedAt: !620)
!636 = !DILocation(line: 0, scope: !379, inlinedAt: !620)
!637 = !DILocation(line: 42, column: 1, scope: !379, inlinedAt: !620)
!638 = !DILocation(line: 266, column: 1, scope: !520)
!639 = !DILocation(line: 265, column: 2, scope: !520)
!640 = distinct !DISubprogram(name: "xdp_pass_func", scope: !3, file: !3, line: 269, type: !131, scopeLine: 270, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !641)
!641 = !{!642}
!642 = !DILocalVariable(name: "ctx", arg: 1, scope: !640, file: !3, line: 269, type: !133)
!643 = !DILocation(line: 269, column: 34, scope: !640)
!644 = !DILocation(line: 271, column: 2, scope: !640)
