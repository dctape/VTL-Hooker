; ModuleID = 'xdp_prog_kern_02.c'
source_filename = "xdp_prog_kern_02.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }
%struct.vlan_hdr = type { i16, i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }
%struct.ipv6hdr = type { i8, [3 x i8], i16, i8, i8, %struct.in6_addr, %struct.in6_addr }
%struct.in6_addr = type { %union.anon }
%union.anon = type { [4 x i32] }
%struct.udphdr = type { i16, i16, i16, i16 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0, i32 0, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !51
@llvm.used = appending global [5 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_pass_func to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_patch_ports_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_vlan_swap_func to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_patch_ports_func(%struct.xdp_md* nocapture readonly) #0 section "xdp_patch_ports" !dbg !82 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !95, metadata !DIExpression()), !dbg !202
  call void @llvm.dbg.value(metadata i32 2, metadata !96, metadata !DIExpression()), !dbg !203
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !204
  %4 = load i32, i32* %3, align 4, !dbg !204, !tbaa !205
  %5 = zext i32 %4 to i64, !dbg !210
  %6 = inttoptr i64 %5 to i8*, !dbg !211
  call void @llvm.dbg.value(metadata i8* %6, metadata !195, metadata !DIExpression()), !dbg !212
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !213
  %8 = load i32, i32* %7, align 4, !dbg !213, !tbaa !214
  %9 = zext i32 %8 to i64, !dbg !215
  %10 = inttoptr i64 %9 to i8*, !dbg !216
  call void @llvm.dbg.value(metadata i8* %10, metadata !196, metadata !DIExpression()), !dbg !217
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !99, metadata !DIExpression(DW_OP_deref)), !dbg !218
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !197, metadata !DIExpression(DW_OP_deref)), !dbg !219
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !220, metadata !DIExpression()), !dbg !239
  call void @llvm.dbg.value(metadata i8* %6, metadata !227, metadata !DIExpression()), !dbg !241
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !228, metadata !DIExpression()), !dbg !242
  call void @llvm.dbg.value(metadata i32 14, metadata !230, metadata !DIExpression()), !dbg !243
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !244
  %12 = icmp ugt i8* %11, %6, !dbg !246
  br i1 %12, label %134, label %13, !dbg !247

; <label>:13:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !229, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata i8* %11, metadata !231, metadata !DIExpression()), !dbg !249
  %14 = getelementptr inbounds i8, i8* %10, i64 12, !dbg !250
  %15 = bitcast i8* %14 to i16*, !dbg !250
  call void @llvm.dbg.value(metadata i16* %15, metadata !237, metadata !DIExpression(DW_OP_deref)), !dbg !251
  call void @llvm.dbg.value(metadata i32 0, metadata !238, metadata !DIExpression()), !dbg !252
  %16 = load i16, i16* %15, align 1, !dbg !253, !tbaa !254
  call void @llvm.dbg.value(metadata i16 %16, metadata !237, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.value(metadata i8* %11, metadata !231, metadata !DIExpression()), !dbg !249
  %17 = inttoptr i64 %5 to %struct.vlan_hdr*
  call void @llvm.dbg.value(metadata i32 0, metadata !238, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i8* %11, metadata !231, metadata !DIExpression()), !dbg !249
  switch i16 %16, label %50 [
    i16 -22392, label %18
    i16 129, label %18
  ], !dbg !256

; <label>:18:                                     ; preds = %13, %13
  %19 = getelementptr inbounds i8, i8* %10, i64 18, !dbg !260
  %20 = bitcast i8* %19 to %struct.vlan_hdr*, !dbg !260
  %21 = icmp ugt %struct.vlan_hdr* %20, %17, !dbg !262
  br i1 %21, label %50, label %22, !dbg !263

; <label>:22:                                     ; preds = %18
  %23 = getelementptr inbounds i8, i8* %10, i64 16, !dbg !264
  %24 = bitcast i8* %23 to i16*, !dbg !264
  call void @llvm.dbg.value(metadata i16* %24, metadata !237, metadata !DIExpression(DW_OP_deref)), !dbg !251
  %25 = load i16, i16* %24, align 1, !dbg !253, !tbaa !254
  call void @llvm.dbg.value(metadata i32 1, metadata !238, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i16 %25, metadata !237, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %20, metadata !231, metadata !DIExpression()), !dbg !249
  call void @llvm.dbg.value(metadata i32 1, metadata !238, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %20, metadata !231, metadata !DIExpression()), !dbg !249
  switch i16 %25, label %50 [
    i16 -22392, label %26
    i16 129, label %26
  ], !dbg !256

; <label>:26:                                     ; preds = %22, %22
  %27 = getelementptr inbounds i8, i8* %10, i64 22, !dbg !260
  %28 = bitcast i8* %27 to %struct.vlan_hdr*, !dbg !260
  %29 = icmp ugt %struct.vlan_hdr* %28, %17, !dbg !262
  br i1 %29, label %50, label %30, !dbg !263

; <label>:30:                                     ; preds = %26
  %31 = getelementptr inbounds i8, i8* %10, i64 20, !dbg !264
  %32 = bitcast i8* %31 to i16*, !dbg !264
  call void @llvm.dbg.value(metadata i16* %32, metadata !237, metadata !DIExpression(DW_OP_deref)), !dbg !251
  %33 = load i16, i16* %32, align 1, !dbg !253, !tbaa !254
  call void @llvm.dbg.value(metadata i32 2, metadata !238, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i16 %33, metadata !237, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %28, metadata !231, metadata !DIExpression()), !dbg !249
  call void @llvm.dbg.value(metadata i32 2, metadata !238, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %28, metadata !231, metadata !DIExpression()), !dbg !249
  switch i16 %33, label %50 [
    i16 -22392, label %34
    i16 129, label %34
  ], !dbg !256

; <label>:34:                                     ; preds = %30, %30
  %35 = getelementptr inbounds i8, i8* %10, i64 26, !dbg !260
  %36 = bitcast i8* %35 to %struct.vlan_hdr*, !dbg !260
  %37 = icmp ugt %struct.vlan_hdr* %36, %17, !dbg !262
  br i1 %37, label %50, label %38, !dbg !263

; <label>:38:                                     ; preds = %34
  %39 = getelementptr inbounds i8, i8* %10, i64 24, !dbg !264
  %40 = bitcast i8* %39 to i16*, !dbg !264
  call void @llvm.dbg.value(metadata i16* %40, metadata !237, metadata !DIExpression(DW_OP_deref)), !dbg !251
  %41 = load i16, i16* %40, align 1, !dbg !253, !tbaa !254
  call void @llvm.dbg.value(metadata i32 3, metadata !238, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i16 %41, metadata !237, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %36, metadata !231, metadata !DIExpression()), !dbg !249
  call void @llvm.dbg.value(metadata i32 3, metadata !238, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %36, metadata !231, metadata !DIExpression()), !dbg !249
  switch i16 %41, label %50 [
    i16 -22392, label %42
    i16 129, label %42
  ], !dbg !256

; <label>:42:                                     ; preds = %38, %38
  %43 = getelementptr inbounds i8, i8* %10, i64 30, !dbg !260
  %44 = bitcast i8* %43 to %struct.vlan_hdr*, !dbg !260
  %45 = icmp ugt %struct.vlan_hdr* %44, %17, !dbg !262
  br i1 %45, label %50, label %46, !dbg !263

; <label>:46:                                     ; preds = %42
  %47 = getelementptr inbounds i8, i8* %10, i64 28, !dbg !264
  %48 = bitcast i8* %47 to i16*, !dbg !264
  call void @llvm.dbg.value(metadata i16* %48, metadata !237, metadata !DIExpression(DW_OP_deref)), !dbg !251
  %49 = load i16, i16* %48, align 1, !dbg !253, !tbaa !254
  call void @llvm.dbg.value(metadata i32 4, metadata !238, metadata !DIExpression()), !dbg !252
  call void @llvm.dbg.value(metadata i16 %49, metadata !237, metadata !DIExpression()), !dbg !251
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %44, metadata !231, metadata !DIExpression()), !dbg !249
  br label %50

; <label>:50:                                     ; preds = %46, %42, %38, %34, %30, %26, %22, %18, %13
  %51 = phi i8* [ %11, %13 ], [ %11, %18 ], [ %19, %22 ], [ %19, %26 ], [ %27, %30 ], [ %27, %34 ], [ %35, %38 ], [ %35, %42 ], [ %43, %46 ], !dbg !253
  %52 = phi i16 [ %16, %13 ], [ %16, %18 ], [ %25, %22 ], [ %25, %26 ], [ %33, %30 ], [ %33, %34 ], [ %41, %38 ], [ %41, %42 ], [ %49, %46 ], !dbg !253
  call void @llvm.dbg.value(metadata i16 %52, metadata !97, metadata !DIExpression(DW_OP_dup, DW_OP_constu, 15, DW_OP_shr, DW_OP_lit0, DW_OP_not, DW_OP_mul, DW_OP_or, DW_OP_stack_value)), !dbg !265
  switch i16 %52, label %134 [
    i16 8, label %53
    i16 -8826, label %63
  ], !dbg !266

; <label>:53:                                     ; preds = %50
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !113, metadata !DIExpression(DW_OP_deref)), !dbg !267
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !197, metadata !DIExpression(DW_OP_deref)), !dbg !219
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !268, metadata !DIExpression()), !dbg !278
  call void @llvm.dbg.value(metadata i8* %6, metadata !274, metadata !DIExpression()), !dbg !282
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !275, metadata !DIExpression()), !dbg !283
  call void @llvm.dbg.value(metadata i8* %51, metadata !276, metadata !DIExpression()), !dbg !284
  %54 = getelementptr inbounds i8, i8* %51, i64 20, !dbg !285
  %55 = icmp ugt i8* %54, %6, !dbg !287
  br i1 %55, label %134, label %56, !dbg !288

; <label>:56:                                     ; preds = %53
  %57 = load i8, i8* %51, align 4, !dbg !289
  %58 = shl i8 %57, 2, !dbg !290
  %59 = and i8 %58, 60, !dbg !290
  %60 = zext i8 %59 to i64, !dbg !291
  call void @llvm.dbg.value(metadata i64 %60, metadata !277, metadata !DIExpression()), !dbg !293
  %61 = getelementptr i8, i8* %51, i64 %60, !dbg !291
  %62 = icmp ugt i8* %61, %6, !dbg !294
  br i1 %62, label %134, label %68, !dbg !295

; <label>:63:                                     ; preds = %50
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !197, metadata !DIExpression(DW_OP_deref)), !dbg !219
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !296, metadata !DIExpression()), !dbg !305
  call void @llvm.dbg.value(metadata i8* %6, metadata !302, metadata !DIExpression()), !dbg !309
  %64 = getelementptr inbounds i8, i8* %51, i64 40, !dbg !310
  %65 = bitcast i8* %64 to %struct.ipv6hdr*, !dbg !310
  %66 = inttoptr i64 %5 to %struct.ipv6hdr*, !dbg !312
  %67 = icmp ugt %struct.ipv6hdr* %65, %66, !dbg !313
  br i1 %67, label %134, label %68, !dbg !314

; <label>:68:                                     ; preds = %63, %56
  %69 = phi i64 [ 9, %56 ], [ 6, %63 ]
  %70 = phi i8* [ %61, %56 ], [ %64, %63 ], !dbg !315
  %71 = getelementptr inbounds i8, i8* %51, i64 %69, !dbg !316
  %72 = load i8, i8* %71, align 1, !dbg !316, !tbaa !317
  call void @llvm.dbg.value(metadata i8 %72, metadata !98, metadata !DIExpression(DW_OP_dup, DW_OP_constu, 7, DW_OP_shr, DW_OP_lit0, DW_OP_not, DW_OP_mul, DW_OP_or, DW_OP_stack_value)), !dbg !318
  switch i8 %72, label %134 [
    i8 17, label %73
    i8 6, label %103
  ], !dbg !319

; <label>:73:                                     ; preds = %68
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !197, metadata !DIExpression(DW_OP_deref)), !dbg !219
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !320, metadata !DIExpression()) #5, !dbg !330
  call void @llvm.dbg.value(metadata i8* %6, metadata !326, metadata !DIExpression()) #5, !dbg !335
  call void @llvm.dbg.value(metadata i8* %70, metadata !329, metadata !DIExpression()) #5, !dbg !336
  %74 = getelementptr inbounds i8, i8* %70, i64 8, !dbg !337
  %75 = bitcast i8* %74 to %struct.udphdr*, !dbg !337
  %76 = inttoptr i64 %5 to %struct.udphdr*, !dbg !339
  %77 = icmp ugt %struct.udphdr* %75, %76, !dbg !340
  br i1 %77, label %134, label %78, !dbg !341

; <label>:78:                                     ; preds = %73
  %79 = getelementptr inbounds i8, i8* %70, i64 4, !dbg !342
  %80 = bitcast i8* %79 to i16*, !dbg !342
  %81 = load i16, i16* %80, align 2, !dbg !342, !tbaa !343
  %82 = tail call i16 @llvm.bswap.i16(i16 %81) #5
  %83 = icmp ugt i16 %82, 7, !dbg !345
  br i1 %83, label %84, label %134

; <label>:84:                                     ; preds = %78
  call void @llvm.dbg.value(metadata i8* %70, metadata !164, metadata !DIExpression()), !dbg !347
  %85 = getelementptr inbounds i8, i8* %70, i64 2, !dbg !348
  %86 = bitcast i8* %85 to i16*, !dbg !348
  %87 = load i16, i16* %86, align 2, !dbg !348, !tbaa !349
  %88 = tail call i16 @llvm.bswap.i16(i16 %87)
  %89 = zext i16 %88 to i32, !dbg !348
  %90 = add nsw i32 %89, -1, !dbg !348
  %91 = tail call i1 @llvm.is.constant.i32(i32 %90), !dbg !348
  call void @llvm.dbg.value(metadata i8* %70, metadata !164, metadata !DIExpression()), !dbg !347
  br i1 %91, label %92, label %98, !dbg !348

; <label>:92:                                     ; preds = %84
  %93 = shl i16 %88, 8, !dbg !348
  %94 = add i16 %93, -256, !dbg !348
  call void @llvm.dbg.value(metadata i8* %70, metadata !164, metadata !DIExpression()), !dbg !347
  %95 = add i16 %88, -1, !dbg !348
  %96 = lshr i16 %95, 8, !dbg !348
  %97 = or i16 %94, %96, !dbg !348
  br label %101, !dbg !348

; <label>:98:                                     ; preds = %84
  %99 = add i16 %88, -1, !dbg !348
  %100 = tail call i16 @llvm.bswap.i16(i16 %99), !dbg !348
  br label %101, !dbg !348

; <label>:101:                                    ; preds = %98, %92
  %102 = phi i16 [ %97, %92 ], [ %100, %98 ]
  call void @llvm.dbg.value(metadata i8* %70, metadata !164, metadata !DIExpression()), !dbg !347
  store i16 %102, i16* %86, align 2, !dbg !350, !tbaa !349
  br label %134, !dbg !351

; <label>:103:                                    ; preds = %68
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !197, metadata !DIExpression(DW_OP_deref)), !dbg !219
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !352, metadata !DIExpression()), !dbg !362
  call void @llvm.dbg.value(metadata i8* %6, metadata !358, metadata !DIExpression()), !dbg !367
  call void @llvm.dbg.value(metadata i8* %70, metadata !361, metadata !DIExpression()), !dbg !368
  %104 = getelementptr inbounds i8, i8* %70, i64 20, !dbg !369
  %105 = icmp ugt i8* %104, %6, !dbg !371
  br i1 %105, label %134, label %106, !dbg !372

; <label>:106:                                    ; preds = %103
  %107 = getelementptr inbounds i8, i8* %70, i64 12, !dbg !373
  %108 = bitcast i8* %107 to i16*, !dbg !373
  %109 = load i16, i16* %108, align 4, !dbg !373
  %110 = lshr i16 %109, 2, !dbg !374
  %111 = and i16 %110, 60, !dbg !374
  %112 = zext i16 %111 to i64, !dbg !375
  %113 = getelementptr i8, i8* %70, i64 %112, !dbg !375
  %114 = icmp ugt i8* %113, %6, !dbg !377
  br i1 %114, label %134, label %115, !dbg !378

; <label>:115:                                    ; preds = %106
  call void @llvm.dbg.value(metadata i8* %70, metadata !173, metadata !DIExpression()), !dbg !379
  %116 = getelementptr inbounds i8, i8* %70, i64 2, !dbg !380
  %117 = bitcast i8* %116 to i16*, !dbg !380
  %118 = load i16, i16* %117, align 2, !dbg !380, !tbaa !381
  %119 = tail call i16 @llvm.bswap.i16(i16 %118)
  %120 = zext i16 %119 to i32, !dbg !380
  %121 = add nsw i32 %120, -1, !dbg !380
  %122 = tail call i1 @llvm.is.constant.i32(i32 %121), !dbg !380
  call void @llvm.dbg.value(metadata i8* %70, metadata !173, metadata !DIExpression()), !dbg !379
  br i1 %122, label %123, label %129, !dbg !380

; <label>:123:                                    ; preds = %115
  %124 = shl i16 %119, 8, !dbg !380
  %125 = add i16 %124, -256, !dbg !380
  call void @llvm.dbg.value(metadata i8* %70, metadata !173, metadata !DIExpression()), !dbg !379
  %126 = add i16 %119, -1, !dbg !380
  %127 = lshr i16 %126, 8, !dbg !380
  %128 = or i16 %125, %127, !dbg !380
  br label %132, !dbg !380

; <label>:129:                                    ; preds = %115
  %130 = add i16 %119, -1, !dbg !380
  %131 = tail call i16 @llvm.bswap.i16(i16 %130), !dbg !380
  br label %132, !dbg !380

; <label>:132:                                    ; preds = %129, %123
  %133 = phi i16 [ %128, %123 ], [ %131, %129 ]
  call void @llvm.dbg.value(metadata i8* %70, metadata !173, metadata !DIExpression()), !dbg !379
  store i16 %133, i16* %117, align 2, !dbg !383, !tbaa !381
  br label %134, !dbg !384

; <label>:134:                                    ; preds = %106, %103, %73, %78, %63, %56, %53, %1, %68, %50, %101, %132
  %135 = phi i32 [ 2, %101 ], [ 2, %132 ], [ 2, %50 ], [ 2, %68 ], [ 0, %1 ], [ 2, %53 ], [ 2, %56 ], [ 2, %63 ], [ 0, %78 ], [ 0, %73 ], [ 0, %103 ], [ 0, %106 ], !dbg !385
  call void @llvm.dbg.value(metadata i32 %135, metadata !96, metadata !DIExpression()), !dbg !203
  %136 = bitcast i32* %2 to i8*, !dbg !386
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %136), !dbg !386
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !391, metadata !DIExpression()) #5, !dbg !386
  call void @llvm.dbg.value(metadata i32 %135, metadata !392, metadata !DIExpression()) #5, !dbg !403
  store i32 %135, i32* %2, align 4, !tbaa !404
  %137 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %136) #5, !dbg !405
  %138 = icmp eq i8* %137, null, !dbg !406
  br i1 %138, label %152, label %139, !dbg !408

; <label>:139:                                    ; preds = %134
  call void @llvm.dbg.value(metadata i8* %137, metadata !393, metadata !DIExpression()) #5, !dbg !409
  %140 = bitcast i8* %137 to i64*, !dbg !410
  %141 = load i64, i64* %140, align 8, !dbg !411, !tbaa !412
  %142 = add i64 %141, 1, !dbg !411
  store i64 %142, i64* %140, align 8, !dbg !411, !tbaa !412
  %143 = load i32, i32* %3, align 4, !dbg !415, !tbaa !205
  %144 = load i32, i32* %7, align 4, !dbg !416, !tbaa !214
  %145 = sub i32 %143, %144, !dbg !417
  %146 = zext i32 %145 to i64, !dbg !418
  %147 = getelementptr inbounds i8, i8* %137, i64 8, !dbg !419
  %148 = bitcast i8* %147 to i64*, !dbg !419
  %149 = load i64, i64* %148, align 8, !dbg !420, !tbaa !421
  %150 = add i64 %149, %146, !dbg !420
  store i64 %150, i64* %148, align 8, !dbg !420, !tbaa !421
  %151 = load i32, i32* %2, align 4, !dbg !422, !tbaa !404
  call void @llvm.dbg.value(metadata i32 %151, metadata !392, metadata !DIExpression()) #5, !dbg !403
  br label %152, !dbg !423

; <label>:152:                                    ; preds = %134, %139
  %153 = phi i32 [ %151, %139 ], [ 0, %134 ], !dbg !424
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %136), !dbg !425
  ret i32 %153, !dbg !426
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable
declare i16 @llvm.bswap.i16(i16) #2

; Function Attrs: nounwind readnone
declare i1 @llvm.is.constant.i32(i32) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

; Function Attrs: nounwind
define dso_local i32 @xdp_vlan_swap_func(%struct.xdp_md*) #0 section "xdp_vlan_swap" !dbg !427 {
  %2 = alloca %struct.ethhdr, align 1
  %3 = alloca %struct.ethhdr, align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !429, metadata !DIExpression()), !dbg !435
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !436
  %5 = load i32, i32* %4, align 4, !dbg !436, !tbaa !205
  %6 = zext i32 %5 to i64, !dbg !437
  %7 = inttoptr i64 %6 to i8*, !dbg !438
  call void @llvm.dbg.value(metadata i8* %7, metadata !430, metadata !DIExpression()), !dbg !439
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !440
  %9 = load i32, i32* %8, align 4, !dbg !440, !tbaa !214
  %10 = zext i32 %9 to i64, !dbg !441
  %11 = inttoptr i64 %10 to i8*, !dbg !442
  call void @llvm.dbg.value(metadata i8* %11, metadata !431, metadata !DIExpression()), !dbg !443
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !432, metadata !DIExpression(DW_OP_deref)), !dbg !444
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !220, metadata !DIExpression()), !dbg !445
  call void @llvm.dbg.value(metadata i8* %7, metadata !227, metadata !DIExpression()), !dbg !447
  call void @llvm.dbg.value(metadata i32 14, metadata !230, metadata !DIExpression()), !dbg !448
  %12 = getelementptr i8, i8* %11, i64 14, !dbg !449
  %13 = icmp ugt i8* %12, %7, !dbg !450
  br i1 %13, label %74, label %14, !dbg !451

; <label>:14:                                     ; preds = %1
  call void @llvm.dbg.value(metadata i8* %11, metadata !229, metadata !DIExpression()), !dbg !452
  %15 = inttoptr i64 %10 to %struct.ethhdr*, !dbg !453
  call void @llvm.dbg.value(metadata i8* %12, metadata !231, metadata !DIExpression()), !dbg !454
  call void @llvm.dbg.value(metadata i8* %11, metadata !237, metadata !DIExpression(DW_OP_plus_uconst, 12, DW_OP_deref, DW_OP_stack_value)), !dbg !455
  call void @llvm.dbg.value(metadata i32 0, metadata !238, metadata !DIExpression()), !dbg !456
  call void @llvm.dbg.value(metadata i8* %12, metadata !231, metadata !DIExpression()), !dbg !454
  call void @llvm.dbg.value(metadata i32 0, metadata !238, metadata !DIExpression()), !dbg !456
  call void @llvm.dbg.value(metadata i8* %12, metadata !231, metadata !DIExpression()), !dbg !454
  call void @llvm.dbg.value(metadata %struct.ethhdr* %15, metadata !434, metadata !DIExpression()), !dbg !457
  %16 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 0, i32 2, !dbg !458
  %17 = load i16, i16* %16, align 1, !dbg !458, !tbaa !460
  call void @llvm.dbg.value(metadata %struct.ethhdr* %15, metadata !434, metadata !DIExpression()), !dbg !457
  switch i16 %17, label %46 [
    i16 -22392, label %18
    i16 129, label %18
  ], !dbg !462

; <label>:18:                                     ; preds = %14, %14
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !463, metadata !DIExpression()) #5, !dbg !475
  call void @llvm.dbg.value(metadata %struct.ethhdr* %15, metadata !469, metadata !DIExpression()) #5, !dbg !477
  %19 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %2, i64 0, i32 0, i64 0, !dbg !478
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %19), !dbg !478
  switch i16 %17, label %45 [
    i16 -22392, label %20
    i16 129, label %20
  ], !dbg !479

; <label>:20:                                     ; preds = %18, %18
  call void @llvm.dbg.value(metadata i64 %6, metadata !470, metadata !DIExpression()) #5, !dbg !480
  %21 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 1, i32 0, i64 4, !dbg !481
  %22 = bitcast i8* %21 to %struct.vlan_hdr*, !dbg !481
  %23 = inttoptr i64 %6 to %struct.vlan_hdr*, !dbg !483
  %24 = icmp ugt %struct.vlan_hdr* %22, %23, !dbg !484
  br i1 %24, label %45, label %25, !dbg !485

; <label>:25:                                     ; preds = %20
  %26 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 1, i32 0, i64 2, !dbg !486
  %27 = bitcast i8* %26 to i16*, !dbg !486
  %28 = load i16, i16* %27, align 2, !dbg !486, !tbaa !487
  call void @llvm.dbg.value(metadata i16 %28, metadata !473, metadata !DIExpression()) #5, !dbg !489
  %29 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 0, i32 0, i64 0, !dbg !490
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 %19, i8* align 1 %29, i64 14, i1 false) #5, !dbg !490
  %30 = bitcast %struct.xdp_md* %0 to i8*, !dbg !491
  %31 = tail call i32 inttoptr (i64 44 to i32 (i8*, i32)*)(i8* %30, i32 4) #5, !dbg !493
  %32 = icmp eq i32 %31, 0, !dbg !493
  br i1 %32, label %33, label %45, !dbg !494

; <label>:33:                                     ; preds = %25
  %34 = load i32, i32* %8, align 4, !dbg !495, !tbaa !214
  %35 = zext i32 %34 to i64, !dbg !496
  %36 = inttoptr i64 %35 to %struct.ethhdr*, !dbg !497
  call void @llvm.dbg.value(metadata %struct.ethhdr* %36, metadata !469, metadata !DIExpression()) #5, !dbg !477
  %37 = load i32, i32* %4, align 4, !dbg !498, !tbaa !205
  %38 = zext i32 %37 to i64, !dbg !499
  call void @llvm.dbg.value(metadata i64 %38, metadata !470, metadata !DIExpression()) #5, !dbg !480
  %39 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %36, i64 1, !dbg !500
  %40 = inttoptr i64 %38 to %struct.ethhdr*, !dbg !502
  %41 = icmp ugt %struct.ethhdr* %39, %40, !dbg !503
  br i1 %41, label %45, label %42, !dbg !504

; <label>:42:                                     ; preds = %33
  %43 = inttoptr i64 %35 to i8*, !dbg !497
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %43, i8* nonnull align 1 %19, i64 14, i1 false) #5, !dbg !505
  %44 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %36, i64 0, i32 2, !dbg !506
  store i16 %28, i16* %44, align 1, !dbg !507, !tbaa !460
  br label %45, !dbg !508

; <label>:45:                                     ; preds = %18, %20, %25, %33, %42
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %19), !dbg !509
  br label %74, !dbg !510

; <label>:46:                                     ; preds = %14
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !511, metadata !DIExpression()) #5, !dbg !521
  call void @llvm.dbg.value(metadata %struct.ethhdr* %15, metadata !516, metadata !DIExpression()) #5, !dbg !523
  call void @llvm.dbg.value(metadata i32 1, metadata !517, metadata !DIExpression()) #5, !dbg !524
  %47 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %3, i64 0, i32 0, i64 0, !dbg !525
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %47), !dbg !525
  %48 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 0, i32 0, i64 0, !dbg !526
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 %47, i8* align 1 %48, i64 14, i1 false) #5, !dbg !526
  %49 = bitcast %struct.xdp_md* %0 to i8*, !dbg !527
  %50 = tail call i32 inttoptr (i64 44 to i32 (i8*, i32)*)(i8* %49, i32 -4) #5, !dbg !529
  %51 = icmp eq i32 %50, 0, !dbg !529
  br i1 %51, label %52, label %73, !dbg !530

; <label>:52:                                     ; preds = %46
  %53 = load i32, i32* %4, align 4, !dbg !531, !tbaa !205
  %54 = zext i32 %53 to i64, !dbg !532
  %55 = load i32, i32* %8, align 4, !dbg !533, !tbaa !214
  %56 = zext i32 %55 to i64, !dbg !534
  %57 = inttoptr i64 %56 to %struct.ethhdr*, !dbg !535
  call void @llvm.dbg.value(metadata %struct.ethhdr* %57, metadata !516, metadata !DIExpression()) #5, !dbg !523
  %58 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %57, i64 1, !dbg !536
  %59 = inttoptr i64 %54 to %struct.ethhdr*, !dbg !538
  %60 = icmp ugt %struct.ethhdr* %58, %59, !dbg !539
  br i1 %60, label %73, label %61, !dbg !540

; <label>:61:                                     ; preds = %52
  call void @llvm.dbg.value(metadata i64 %54, metadata !518, metadata !DIExpression()) #5, !dbg !541
  %62 = inttoptr i64 %56 to i8*, !dbg !535
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %62, i8* nonnull align 1 %47, i64 14, i1 false) #5, !dbg !542
  call void @llvm.dbg.value(metadata %struct.ethhdr* %58, metadata !520, metadata !DIExpression()) #5, !dbg !543
  %63 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %57, i64 1, i32 0, i64 4, !dbg !544
  %64 = bitcast i8* %63 to %struct.vlan_hdr*, !dbg !544
  %65 = inttoptr i64 %54 to %struct.vlan_hdr*, !dbg !546
  %66 = icmp ugt %struct.vlan_hdr* %64, %65, !dbg !547
  br i1 %66, label %73, label %67, !dbg !548

; <label>:67:                                     ; preds = %61
  %68 = bitcast %struct.ethhdr* %58 to i16*, !dbg !549
  store i16 256, i16* %68, align 2, !dbg !550, !tbaa !551
  %69 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %57, i64 0, i32 2, !dbg !552
  %70 = load i16, i16* %69, align 1, !dbg !552, !tbaa !460
  %71 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %57, i64 1, i32 0, i64 2, !dbg !553
  %72 = bitcast i8* %71 to i16*, !dbg !553
  store i16 %70, i16* %72, align 2, !dbg !554, !tbaa !487
  store i16 129, i16* %69, align 1, !dbg !555, !tbaa !460
  br label %73, !dbg !556

; <label>:73:                                     ; preds = %46, %52, %61, %67
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %47), !dbg !557
  br label %74

; <label>:74:                                     ; preds = %1, %45, %73
  ret i32 2, !dbg !558
}

; Function Attrs: norecurse nounwind readnone
define dso_local i32 @xdp_pass_func(%struct.xdp_md* nocapture readnone) #4 section "xdp_pass" !dbg !559 {
  call void @llvm.dbg.value(metadata %struct.xdp_md* undef, metadata !561, metadata !DIExpression()), !dbg !562
  ret i32 2, !dbg !563
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1) #1

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind readnone }
attributes #4 = { norecurse nounwind readnone "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!78, !79, !80}
!llvm.ident = !{!81}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !68, line: 16, type: !69, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !43, globals: !50, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern_02.c", directory: "/home/fedora/xdp-tutorial/packet-solutions")
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
!43 = !{!44, !45, !46, !49}
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!45 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !47, line: 24, baseType: !48)
!47 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!48 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!49 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!50 = !{!0, !51, !57, !63}
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 100, type: !53, isLocal: false, isDefinition: true)
!53 = !DICompositeType(tag: DW_TAG_array_type, baseType: !54, size: 32, elements: !55)
!54 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!55 = !{!56}
!56 = !DISubrange(count: 4)
!57 = !DIGlobalVariableExpression(var: !58, expr: !DIExpression())
!58 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !59, line: 20, type: !60, isLocal: true, isDefinition: true)
!59 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DISubroutineType(types: !62)
!62 = !{!44, !44, !44}
!63 = !DIGlobalVariableExpression(var: !64, expr: !DIExpression())
!64 = distinct !DIGlobalVariable(name: "bpf_xdp_adjust_head", scope: !2, file: !59, line: 79, type: !65, isLocal: true, isDefinition: true)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DISubroutineType(types: !67)
!67 = !{!49, !44, !49}
!68 = !DIFile(filename: "./../common/xdp_stats_kern.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!69 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !59, line: 210, size: 224, elements: !70)
!70 = !{!71, !72, !73, !74, !75, !76, !77}
!71 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !69, file: !59, line: 211, baseType: !7, size: 32)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !69, file: !59, line: 212, baseType: !7, size: 32, offset: 32)
!73 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !69, file: !59, line: 213, baseType: !7, size: 32, offset: 64)
!74 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !69, file: !59, line: 214, baseType: !7, size: 32, offset: 96)
!75 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !69, file: !59, line: 215, baseType: !7, size: 32, offset: 128)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "inner_map_idx", scope: !69, file: !59, line: 216, baseType: !7, size: 32, offset: 160)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "numa_node", scope: !69, file: !59, line: 217, baseType: !7, size: 32, offset: 192)
!78 = !{i32 2, !"Dwarf Version", i32 4}
!79 = !{i32 2, !"Debug Info Version", i32 3}
!80 = !{i32 1, !"wchar_size", i32 4}
!81 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!82 = distinct !DISubprogram(name: "xdp_patch_ports_func", scope: !3, file: !3, line: 21, type: !83, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !94)
!83 = !DISubroutineType(types: !84)
!84 = !{!49, !85}
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !87)
!87 = !{!88, !90, !91, !92, !93}
!88 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !86, file: !6, line: 2857, baseType: !89, size: 32)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !86, file: !6, line: 2858, baseType: !89, size: 32, offset: 32)
!91 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !86, file: !6, line: 2859, baseType: !89, size: 32, offset: 64)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !86, file: !6, line: 2861, baseType: !89, size: 32, offset: 96)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !86, file: !6, line: 2862, baseType: !89, size: 32, offset: 128)
!94 = !{!95, !96, !97, !98, !99, !113, !132, !164, !173, !195, !196, !197}
!95 = !DILocalVariable(name: "ctx", arg: 1, scope: !82, file: !3, line: 21, type: !85)
!96 = !DILocalVariable(name: "action", scope: !82, file: !3, line: 23, type: !49)
!97 = !DILocalVariable(name: "eth_type", scope: !82, file: !3, line: 24, type: !49)
!98 = !DILocalVariable(name: "ip_type", scope: !82, file: !3, line: 24, type: !49)
!99 = !DILocalVariable(name: "eth", scope: !82, file: !3, line: 25, type: !100)
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !102, line: 161, size: 112, elements: !103)
!102 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!103 = !{!104, !109, !110}
!104 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !101, file: !102, line: 162, baseType: !105, size: 48)
!105 = !DICompositeType(tag: DW_TAG_array_type, baseType: !106, size: 48, elements: !107)
!106 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!107 = !{!108}
!108 = !DISubrange(count: 6)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !101, file: !102, line: 163, baseType: !105, size: 48, offset: 48)
!110 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !101, file: !102, line: 164, baseType: !111, size: 16, offset: 96)
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !112, line: 25, baseType: !46)
!112 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!113 = !DILocalVariable(name: "iphdr", scope: !82, file: !3, line: 26, type: !114)
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!115 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !116, line: 86, size: 160, elements: !117)
!116 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "")
!117 = !{!118, !120, !121, !122, !123, !124, !125, !126, !127, !129, !131}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !115, file: !116, line: 88, baseType: !119, size: 4, flags: DIFlagBitField, extraData: i64 0)
!119 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !47, line: 21, baseType: !106)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !115, file: !116, line: 89, baseType: !119, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !115, file: !116, line: 96, baseType: !119, size: 8, offset: 8)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !115, file: !116, line: 97, baseType: !111, size: 16, offset: 16)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !115, file: !116, line: 98, baseType: !111, size: 16, offset: 32)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !115, file: !116, line: 99, baseType: !111, size: 16, offset: 48)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !115, file: !116, line: 100, baseType: !119, size: 8, offset: 64)
!126 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !115, file: !116, line: 101, baseType: !119, size: 8, offset: 72)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !115, file: !116, line: 102, baseType: !128, size: 16, offset: 80)
!128 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !112, line: 31, baseType: !46)
!129 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !115, file: !116, line: 103, baseType: !130, size: 32, offset: 96)
!130 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !112, line: 27, baseType: !89)
!131 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !115, file: !116, line: 104, baseType: !130, size: 32, offset: 128)
!132 = !DILocalVariable(name: "ipv6hdr", scope: !82, file: !3, line: 27, type: !133)
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !134, size: 64)
!134 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !135, line: 116, size: 320, elements: !136)
!135 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "")
!136 = !{!137, !138, !139, !143, !144, !145, !146, !163}
!137 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !134, file: !135, line: 118, baseType: !119, size: 4, flags: DIFlagBitField, extraData: i64 0)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !134, file: !135, line: 119, baseType: !119, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !134, file: !135, line: 126, baseType: !140, size: 24, offset: 8)
!140 = !DICompositeType(tag: DW_TAG_array_type, baseType: !119, size: 24, elements: !141)
!141 = !{!142}
!142 = !DISubrange(count: 3)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !134, file: !135, line: 128, baseType: !111, size: 16, offset: 32)
!144 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !134, file: !135, line: 129, baseType: !119, size: 8, offset: 48)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !134, file: !135, line: 130, baseType: !119, size: 8, offset: 56)
!146 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !134, file: !135, line: 132, baseType: !147, size: 128, offset: 64)
!147 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !148, line: 33, size: 128, elements: !149)
!148 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "")
!149 = !{!150}
!150 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !147, file: !148, line: 40, baseType: !151, size: 128)
!151 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !147, file: !148, line: 34, size: 128, elements: !152)
!152 = !{!153, !157, !161}
!153 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !151, file: !148, line: 35, baseType: !154, size: 128)
!154 = !DICompositeType(tag: DW_TAG_array_type, baseType: !119, size: 128, elements: !155)
!155 = !{!156}
!156 = !DISubrange(count: 16)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !151, file: !148, line: 37, baseType: !158, size: 128)
!158 = !DICompositeType(tag: DW_TAG_array_type, baseType: !111, size: 128, elements: !159)
!159 = !{!160}
!160 = !DISubrange(count: 8)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !151, file: !148, line: 38, baseType: !162, size: 128)
!162 = !DICompositeType(tag: DW_TAG_array_type, baseType: !130, size: 128, elements: !55)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !134, file: !135, line: 133, baseType: !147, size: 128, offset: 192)
!164 = !DILocalVariable(name: "udphdr", scope: !82, file: !3, line: 28, type: !165)
!165 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !166, size: 64)
!166 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !167, line: 23, size: 64, elements: !168)
!167 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "")
!168 = !{!169, !170, !171, !172}
!169 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !166, file: !167, line: 24, baseType: !111, size: 16)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !166, file: !167, line: 25, baseType: !111, size: 16, offset: 16)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !166, file: !167, line: 26, baseType: !111, size: 16, offset: 32)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !166, file: !167, line: 27, baseType: !128, size: 16, offset: 48)
!173 = !DILocalVariable(name: "tcphdr", scope: !82, file: !3, line: 29, type: !174)
!174 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !175, size: 64)
!175 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !176, line: 25, size: 160, elements: !177)
!176 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "")
!177 = !{!178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190, !191, !192, !193, !194}
!178 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !175, file: !176, line: 26, baseType: !111, size: 16)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !175, file: !176, line: 27, baseType: !111, size: 16, offset: 16)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !175, file: !176, line: 28, baseType: !130, size: 32, offset: 32)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !175, file: !176, line: 29, baseType: !130, size: 32, offset: 64)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !175, file: !176, line: 31, baseType: !46, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !175, file: !176, line: 32, baseType: !46, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !175, file: !176, line: 33, baseType: !46, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !175, file: !176, line: 34, baseType: !46, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !175, file: !176, line: 35, baseType: !46, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !175, file: !176, line: 36, baseType: !46, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !175, file: !176, line: 37, baseType: !46, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !175, file: !176, line: 38, baseType: !46, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !175, file: !176, line: 39, baseType: !46, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !175, file: !176, line: 40, baseType: !46, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !175, file: !176, line: 55, baseType: !111, size: 16, offset: 112)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !175, file: !176, line: 56, baseType: !128, size: 16, offset: 128)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !175, file: !176, line: 57, baseType: !111, size: 16, offset: 144)
!195 = !DILocalVariable(name: "data_end", scope: !82, file: !3, line: 30, type: !44)
!196 = !DILocalVariable(name: "data", scope: !82, file: !3, line: 31, type: !44)
!197 = !DILocalVariable(name: "nh", scope: !82, file: !3, line: 32, type: !198)
!198 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !199, line: 33, size: 64, elements: !200)
!199 = !DIFile(filename: "./../common/parsing_helpers.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!200 = !{!201}
!201 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !198, file: !199, line: 34, baseType: !44, size: 64)
!202 = !DILocation(line: 21, column: 41, scope: !82)
!203 = !DILocation(line: 23, column: 6, scope: !82)
!204 = !DILocation(line: 30, column: 38, scope: !82)
!205 = !{!206, !207, i64 4}
!206 = !{!"xdp_md", !207, i64 0, !207, i64 4, !207, i64 8, !207, i64 12, !207, i64 16}
!207 = !{!"int", !208, i64 0}
!208 = !{!"omnipotent char", !209, i64 0}
!209 = !{!"Simple C/C++ TBAA"}
!210 = !DILocation(line: 30, column: 27, scope: !82)
!211 = !DILocation(line: 30, column: 19, scope: !82)
!212 = !DILocation(line: 30, column: 8, scope: !82)
!213 = !DILocation(line: 31, column: 34, scope: !82)
!214 = !{!206, !207, i64 0}
!215 = !DILocation(line: 31, column: 23, scope: !82)
!216 = !DILocation(line: 31, column: 15, scope: !82)
!217 = !DILocation(line: 31, column: 8, scope: !82)
!218 = !DILocation(line: 25, column: 17, scope: !82)
!219 = !DILocation(line: 32, column: 20, scope: !82)
!220 = !DILocalVariable(name: "nh", arg: 1, scope: !221, file: !199, line: 73, type: !224)
!221 = distinct !DISubprogram(name: "parse_ethhdr", scope: !199, file: !199, line: 73, type: !222, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !226)
!222 = !DISubroutineType(types: !223)
!223 = !{!49, !224, !44, !225}
!224 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !198, size: 64)
!225 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !100, size: 64)
!226 = !{!220, !227, !228, !229, !230, !231, !237, !238}
!227 = !DILocalVariable(name: "data_end", arg: 2, scope: !221, file: !199, line: 73, type: !44)
!228 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !221, file: !199, line: 74, type: !225)
!229 = !DILocalVariable(name: "eth", scope: !221, file: !199, line: 76, type: !100)
!230 = !DILocalVariable(name: "hdrsize", scope: !221, file: !199, line: 77, type: !49)
!231 = !DILocalVariable(name: "vlh", scope: !221, file: !199, line: 78, type: !232)
!232 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !233, size: 64)
!233 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !199, line: 42, size: 32, elements: !234)
!234 = !{!235, !236}
!235 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !233, file: !199, line: 43, baseType: !111, size: 16)
!236 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !233, file: !199, line: 44, baseType: !111, size: 16, offset: 16)
!237 = !DILocalVariable(name: "h_proto", scope: !221, file: !199, line: 79, type: !46)
!238 = !DILocalVariable(name: "i", scope: !221, file: !199, line: 80, type: !49)
!239 = !DILocation(line: 73, column: 60, scope: !221, inlinedAt: !240)
!240 = distinct !DILocation(line: 34, column: 13, scope: !82)
!241 = !DILocation(line: 73, column: 70, scope: !221, inlinedAt: !240)
!242 = !DILocation(line: 74, column: 22, scope: !221, inlinedAt: !240)
!243 = !DILocation(line: 77, column: 6, scope: !221, inlinedAt: !240)
!244 = !DILocation(line: 85, column: 14, scope: !245, inlinedAt: !240)
!245 = distinct !DILexicalBlock(scope: !221, file: !199, line: 85, column: 6)
!246 = !DILocation(line: 85, column: 24, scope: !245, inlinedAt: !240)
!247 = !DILocation(line: 85, column: 6, scope: !221, inlinedAt: !240)
!248 = !DILocation(line: 76, column: 17, scope: !221, inlinedAt: !240)
!249 = !DILocation(line: 78, column: 19, scope: !221, inlinedAt: !240)
!250 = !DILocation(line: 91, column: 17, scope: !221, inlinedAt: !240)
!251 = !DILocation(line: 79, column: 8, scope: !221, inlinedAt: !240)
!252 = !DILocation(line: 80, column: 6, scope: !221, inlinedAt: !240)
!253 = !DILocation(line: 0, scope: !221, inlinedAt: !240)
!254 = !{!255, !255, i64 0}
!255 = !{!"short", !208, i64 0}
!256 = !DILocation(line: 98, column: 7, scope: !257, inlinedAt: !240)
!257 = distinct !DILexicalBlock(scope: !258, file: !199, line: 97, column: 39)
!258 = distinct !DILexicalBlock(scope: !259, file: !199, line: 97, column: 2)
!259 = distinct !DILexicalBlock(scope: !221, file: !199, line: 97, column: 2)
!260 = !DILocation(line: 101, column: 11, scope: !261, inlinedAt: !240)
!261 = distinct !DILexicalBlock(scope: !257, file: !199, line: 101, column: 7)
!262 = !DILocation(line: 101, column: 15, scope: !261, inlinedAt: !240)
!263 = !DILocation(line: 101, column: 7, scope: !257, inlinedAt: !240)
!264 = !DILocation(line: 104, column: 18, scope: !257, inlinedAt: !240)
!265 = !DILocation(line: 24, column: 6, scope: !82)
!266 = !DILocation(line: 40, column: 6, scope: !82)
!267 = !DILocation(line: 26, column: 16, scope: !82)
!268 = !DILocalVariable(name: "nh", arg: 1, scope: !269, file: !199, line: 131, type: !224)
!269 = distinct !DISubprogram(name: "parse_iphdr", scope: !199, file: !199, line: 131, type: !270, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !273)
!270 = !DISubroutineType(types: !271)
!271 = !{!49, !224, !44, !272}
!272 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!273 = !{!268, !274, !275, !276, !277}
!274 = !DILocalVariable(name: "data_end", arg: 2, scope: !269, file: !199, line: 132, type: !44)
!275 = !DILocalVariable(name: "iphdr", arg: 3, scope: !269, file: !199, line: 133, type: !272)
!276 = !DILocalVariable(name: "iph", scope: !269, file: !199, line: 135, type: !114)
!277 = !DILocalVariable(name: "hdrsize", scope: !269, file: !199, line: 136, type: !49)
!278 = !DILocation(line: 131, column: 59, scope: !269, inlinedAt: !279)
!279 = distinct !DILocation(line: 41, column: 13, scope: !280)
!280 = distinct !DILexicalBlock(scope: !281, file: !3, line: 40, column: 39)
!281 = distinct !DILexicalBlock(scope: !82, file: !3, line: 40, column: 6)
!282 = !DILocation(line: 132, column: 18, scope: !269, inlinedAt: !279)
!283 = !DILocation(line: 133, column: 27, scope: !269, inlinedAt: !279)
!284 = !DILocation(line: 135, column: 16, scope: !269, inlinedAt: !279)
!285 = !DILocation(line: 138, column: 10, scope: !286, inlinedAt: !279)
!286 = distinct !DILexicalBlock(scope: !269, file: !199, line: 138, column: 6)
!287 = !DILocation(line: 138, column: 14, scope: !286, inlinedAt: !279)
!288 = !DILocation(line: 138, column: 6, scope: !269, inlinedAt: !279)
!289 = !DILocation(line: 141, column: 17, scope: !269, inlinedAt: !279)
!290 = !DILocation(line: 141, column: 21, scope: !269, inlinedAt: !279)
!291 = !DILocation(line: 144, column: 14, scope: !292, inlinedAt: !279)
!292 = distinct !DILexicalBlock(scope: !269, file: !199, line: 144, column: 6)
!293 = !DILocation(line: 136, column: 6, scope: !269, inlinedAt: !279)
!294 = !DILocation(line: 144, column: 24, scope: !292, inlinedAt: !279)
!295 = !DILocation(line: 144, column: 6, scope: !269, inlinedAt: !279)
!296 = !DILocalVariable(name: "nh", arg: 1, scope: !297, file: !199, line: 112, type: !224)
!297 = distinct !DISubprogram(name: "parse_ip6hdr", scope: !199, file: !199, line: 112, type: !298, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !301)
!298 = !DISubroutineType(types: !299)
!299 = !{!49, !224, !44, !300}
!300 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !133, size: 64)
!301 = !{!296, !302, !303, !304}
!302 = !DILocalVariable(name: "data_end", arg: 2, scope: !297, file: !199, line: 113, type: !44)
!303 = !DILocalVariable(name: "ip6hdr", arg: 3, scope: !297, file: !199, line: 114, type: !300)
!304 = !DILocalVariable(name: "ip6h", scope: !297, file: !199, line: 116, type: !133)
!305 = !DILocation(line: 112, column: 60, scope: !297, inlinedAt: !306)
!306 = distinct !DILocation(line: 43, column: 13, scope: !307)
!307 = distinct !DILexicalBlock(scope: !308, file: !3, line: 42, column: 48)
!308 = distinct !DILexicalBlock(scope: !281, file: !3, line: 42, column: 13)
!309 = !DILocation(line: 113, column: 12, scope: !297, inlinedAt: !306)
!310 = !DILocation(line: 122, column: 11, scope: !311, inlinedAt: !306)
!311 = distinct !DILexicalBlock(scope: !297, file: !199, line: 122, column: 6)
!312 = !DILocation(line: 122, column: 17, scope: !311, inlinedAt: !306)
!313 = !DILocation(line: 122, column: 15, scope: !311, inlinedAt: !306)
!314 = !DILocation(line: 122, column: 6, scope: !297, inlinedAt: !306)
!315 = !DILocation(line: 32, column: 25, scope: !82)
!316 = !DILocation(line: 0, scope: !281)
!317 = !{!208, !208, i64 0}
!318 = !DILocation(line: 24, column: 16, scope: !82)
!319 = !DILocation(line: 48, column: 6, scope: !82)
!320 = !DILocalVariable(name: "nh", arg: 1, scope: !321, file: !199, line: 201, type: !224)
!321 = distinct !DISubprogram(name: "parse_udphdr", scope: !199, file: !199, line: 201, type: !322, scopeLine: 204, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !325)
!322 = !DISubroutineType(types: !323)
!323 = !{!49, !224, !44, !324}
!324 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !165, size: 64)
!325 = !{!320, !326, !327, !328, !329}
!326 = !DILocalVariable(name: "data_end", arg: 2, scope: !321, file: !199, line: 202, type: !44)
!327 = !DILocalVariable(name: "udphdr", arg: 3, scope: !321, file: !199, line: 203, type: !324)
!328 = !DILocalVariable(name: "len", scope: !321, file: !199, line: 205, type: !49)
!329 = !DILocalVariable(name: "h", scope: !321, file: !199, line: 206, type: !165)
!330 = !DILocation(line: 201, column: 60, scope: !321, inlinedAt: !331)
!331 = distinct !DILocation(line: 49, column: 7, scope: !332)
!332 = distinct !DILexicalBlock(scope: !333, file: !3, line: 49, column: 7)
!333 = distinct !DILexicalBlock(scope: !334, file: !3, line: 48, column: 30)
!334 = distinct !DILexicalBlock(scope: !82, file: !3, line: 48, column: 6)
!335 = !DILocation(line: 202, column: 12, scope: !321, inlinedAt: !331)
!336 = !DILocation(line: 206, column: 17, scope: !321, inlinedAt: !331)
!337 = !DILocation(line: 208, column: 8, scope: !338, inlinedAt: !331)
!338 = distinct !DILexicalBlock(scope: !321, file: !199, line: 208, column: 6)
!339 = !DILocation(line: 208, column: 14, scope: !338, inlinedAt: !331)
!340 = !DILocation(line: 208, column: 12, scope: !338, inlinedAt: !331)
!341 = !DILocation(line: 208, column: 6, scope: !321, inlinedAt: !331)
!342 = !DILocation(line: 214, column: 8, scope: !321, inlinedAt: !331)
!343 = !{!344, !255, i64 4}
!344 = !{!"udphdr", !255, i64 0, !255, i64 2, !255, i64 4, !255, i64 6}
!345 = !DILocation(line: 215, column: 10, scope: !346, inlinedAt: !331)
!346 = distinct !DILexicalBlock(scope: !321, file: !199, line: 215, column: 6)
!347 = !DILocation(line: 28, column: 17, scope: !82)
!348 = !DILocation(line: 53, column: 18, scope: !333)
!349 = !{!344, !255, i64 2}
!350 = !DILocation(line: 53, column: 16, scope: !333)
!351 = !DILocation(line: 54, column: 2, scope: !333)
!352 = !DILocalVariable(name: "nh", arg: 1, scope: !353, file: !199, line: 224, type: !224)
!353 = distinct !DISubprogram(name: "parse_tcphdr", scope: !199, file: !199, line: 224, type: !354, scopeLine: 227, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !357)
!354 = !DISubroutineType(types: !355)
!355 = !{!49, !224, !44, !356}
!356 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !174, size: 64)
!357 = !{!352, !358, !359, !360, !361}
!358 = !DILocalVariable(name: "data_end", arg: 2, scope: !353, file: !199, line: 225, type: !44)
!359 = !DILocalVariable(name: "tcphdr", arg: 3, scope: !353, file: !199, line: 226, type: !356)
!360 = !DILocalVariable(name: "len", scope: !353, file: !199, line: 228, type: !49)
!361 = !DILocalVariable(name: "h", scope: !353, file: !199, line: 229, type: !174)
!362 = !DILocation(line: 224, column: 60, scope: !353, inlinedAt: !363)
!363 = distinct !DILocation(line: 55, column: 7, scope: !364)
!364 = distinct !DILexicalBlock(scope: !365, file: !3, line: 55, column: 7)
!365 = distinct !DILexicalBlock(scope: !366, file: !3, line: 54, column: 37)
!366 = distinct !DILexicalBlock(scope: !334, file: !3, line: 54, column: 13)
!367 = !DILocation(line: 225, column: 12, scope: !353, inlinedAt: !363)
!368 = !DILocation(line: 229, column: 17, scope: !353, inlinedAt: !363)
!369 = !DILocation(line: 231, column: 8, scope: !370, inlinedAt: !363)
!370 = distinct !DILexicalBlock(scope: !353, file: !199, line: 231, column: 6)
!371 = !DILocation(line: 231, column: 12, scope: !370, inlinedAt: !363)
!372 = !DILocation(line: 231, column: 6, scope: !353, inlinedAt: !363)
!373 = !DILocation(line: 234, column: 11, scope: !353, inlinedAt: !363)
!374 = !DILocation(line: 234, column: 16, scope: !353, inlinedAt: !363)
!375 = !DILocation(line: 235, column: 17, scope: !376, inlinedAt: !363)
!376 = distinct !DILexicalBlock(scope: !353, file: !199, line: 235, column: 6)
!377 = !DILocation(line: 235, column: 23, scope: !376, inlinedAt: !363)
!378 = !DILocation(line: 235, column: 6, scope: !353, inlinedAt: !363)
!379 = !DILocation(line: 29, column: 17, scope: !82)
!380 = !DILocation(line: 59, column: 18, scope: !365)
!381 = !{!382, !255, i64 2}
!382 = !{!"tcphdr", !255, i64 0, !255, i64 2, !207, i64 4, !207, i64 8, !255, i64 12, !255, i64 12, !255, i64 13, !255, i64 13, !255, i64 13, !255, i64 13, !255, i64 13, !255, i64 13, !255, i64 13, !255, i64 13, !255, i64 14, !255, i64 16, !255, i64 18}
!383 = !DILocation(line: 59, column: 16, scope: !365)
!384 = !DILocation(line: 60, column: 2, scope: !365)
!385 = !DILocation(line: 0, scope: !82)
!386 = !DILocation(line: 24, column: 46, scope: !387, inlinedAt: !402)
!387 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !68, file: !68, line: 24, type: !388, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !390)
!388 = !DISubroutineType(types: !389)
!389 = !{!89, !85, !89}
!390 = !{!391, !392, !393}
!391 = !DILocalVariable(name: "ctx", arg: 1, scope: !387, file: !68, line: 24, type: !85)
!392 = !DILocalVariable(name: "action", arg: 2, scope: !387, file: !68, line: 24, type: !89)
!393 = !DILocalVariable(name: "rec", scope: !387, file: !68, line: 30, type: !394)
!394 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !395, size: 64)
!395 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !396, line: 10, size: 128, elements: !397)
!396 = !DIFile(filename: "./../common/xdp_stats_kern_user.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!397 = !{!398, !401}
!398 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !395, file: !396, line: 11, baseType: !399, size: 64)
!399 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !400)
!400 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!401 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !395, file: !396, line: 12, baseType: !399, size: 64, offset: 64)
!402 = distinct !DILocation(line: 63, column: 9, scope: !82)
!403 = !DILocation(line: 24, column: 57, scope: !387, inlinedAt: !402)
!404 = !{!207, !207, i64 0}
!405 = !DILocation(line: 30, column: 24, scope: !387, inlinedAt: !402)
!406 = !DILocation(line: 31, column: 7, scope: !407, inlinedAt: !402)
!407 = distinct !DILexicalBlock(scope: !387, file: !68, line: 31, column: 6)
!408 = !DILocation(line: 31, column: 6, scope: !387, inlinedAt: !402)
!409 = !DILocation(line: 30, column: 18, scope: !387, inlinedAt: !402)
!410 = !DILocation(line: 38, column: 7, scope: !387, inlinedAt: !402)
!411 = !DILocation(line: 38, column: 17, scope: !387, inlinedAt: !402)
!412 = !{!413, !414, i64 0}
!413 = !{!"datarec", !414, i64 0, !414, i64 8}
!414 = !{!"long long", !208, i64 0}
!415 = !DILocation(line: 39, column: 25, scope: !387, inlinedAt: !402)
!416 = !DILocation(line: 39, column: 41, scope: !387, inlinedAt: !402)
!417 = !DILocation(line: 39, column: 34, scope: !387, inlinedAt: !402)
!418 = !DILocation(line: 39, column: 19, scope: !387, inlinedAt: !402)
!419 = !DILocation(line: 39, column: 7, scope: !387, inlinedAt: !402)
!420 = !DILocation(line: 39, column: 16, scope: !387, inlinedAt: !402)
!421 = !{!413, !414, i64 8}
!422 = !DILocation(line: 41, column: 9, scope: !387, inlinedAt: !402)
!423 = !DILocation(line: 41, column: 2, scope: !387, inlinedAt: !402)
!424 = !DILocation(line: 0, scope: !387, inlinedAt: !402)
!425 = !DILocation(line: 42, column: 1, scope: !387, inlinedAt: !402)
!426 = !DILocation(line: 63, column: 2, scope: !82)
!427 = distinct !DISubprogram(name: "xdp_vlan_swap_func", scope: !3, file: !3, line: 71, type: !83, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !428)
!428 = !{!429, !430, !431, !432, !433, !434}
!429 = !DILocalVariable(name: "ctx", arg: 1, scope: !427, file: !3, line: 71, type: !85)
!430 = !DILocalVariable(name: "data_end", scope: !427, file: !3, line: 73, type: !44)
!431 = !DILocalVariable(name: "data", scope: !427, file: !3, line: 74, type: !44)
!432 = !DILocalVariable(name: "nh", scope: !427, file: !3, line: 77, type: !198)
!433 = !DILocalVariable(name: "nh_type", scope: !427, file: !3, line: 78, type: !49)
!434 = !DILocalVariable(name: "eth", scope: !427, file: !3, line: 81, type: !100)
!435 = !DILocation(line: 71, column: 39, scope: !427)
!436 = !DILocation(line: 73, column: 38, scope: !427)
!437 = !DILocation(line: 73, column: 27, scope: !427)
!438 = !DILocation(line: 73, column: 19, scope: !427)
!439 = !DILocation(line: 73, column: 8, scope: !427)
!440 = !DILocation(line: 74, column: 34, scope: !427)
!441 = !DILocation(line: 74, column: 23, scope: !427)
!442 = !DILocation(line: 74, column: 15, scope: !427)
!443 = !DILocation(line: 74, column: 8, scope: !427)
!444 = !DILocation(line: 77, column: 20, scope: !427)
!445 = !DILocation(line: 73, column: 60, scope: !221, inlinedAt: !446)
!446 = distinct !DILocation(line: 82, column: 12, scope: !427)
!447 = !DILocation(line: 73, column: 70, scope: !221, inlinedAt: !446)
!448 = !DILocation(line: 77, column: 6, scope: !221, inlinedAt: !446)
!449 = !DILocation(line: 85, column: 14, scope: !245, inlinedAt: !446)
!450 = !DILocation(line: 85, column: 24, scope: !245, inlinedAt: !446)
!451 = !DILocation(line: 85, column: 6, scope: !221, inlinedAt: !446)
!452 = !DILocation(line: 76, column: 17, scope: !221, inlinedAt: !446)
!453 = !DILocation(line: 89, column: 10, scope: !221, inlinedAt: !446)
!454 = !DILocation(line: 78, column: 19, scope: !221, inlinedAt: !446)
!455 = !DILocation(line: 79, column: 8, scope: !221, inlinedAt: !446)
!456 = !DILocation(line: 80, column: 6, scope: !221, inlinedAt: !446)
!457 = !DILocation(line: 81, column: 17, scope: !427)
!458 = !DILocation(line: 86, column: 25, scope: !459)
!459 = distinct !DILexicalBlock(scope: !427, file: !3, line: 86, column: 6)
!460 = !{!461, !255, i64 12}
!461 = !{!"ethhdr", !208, i64 0, !208, i64 6, !255, i64 12}
!462 = !DILocation(line: 86, column: 6, scope: !427)
!463 = !DILocalVariable(name: "ctx", arg: 1, scope: !464, file: !465, line: 22, type: !85)
!464 = distinct !DISubprogram(name: "vlan_tag_pop", scope: !465, file: !465, line: 22, type: !466, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !468)
!465 = !DIFile(filename: "./../common/rewrite_helpers.h", directory: "/home/fedora/xdp-tutorial/packet-solutions")
!466 = !DISubroutineType(types: !467)
!467 = !{!49, !85, !100}
!468 = !{!463, !469, !470, !471, !472, !473, !474}
!469 = !DILocalVariable(name: "eth", arg: 2, scope: !464, file: !465, line: 22, type: !100)
!470 = !DILocalVariable(name: "data_end", scope: !464, file: !465, line: 24, type: !44)
!471 = !DILocalVariable(name: "eth_cpy", scope: !464, file: !465, line: 25, type: !101)
!472 = !DILocalVariable(name: "vlh", scope: !464, file: !465, line: 26, type: !232)
!473 = !DILocalVariable(name: "h_proto", scope: !464, file: !465, line: 27, type: !111)
!474 = !DILocalVariable(name: "vlid", scope: !464, file: !465, line: 28, type: !49)
!475 = !DILocation(line: 22, column: 56, scope: !464, inlinedAt: !476)
!476 = distinct !DILocation(line: 87, column: 3, scope: !459)
!477 = !DILocation(line: 22, column: 76, scope: !464, inlinedAt: !476)
!478 = !DILocation(line: 25, column: 2, scope: !464, inlinedAt: !476)
!479 = !DILocation(line: 30, column: 6, scope: !464, inlinedAt: !476)
!480 = !DILocation(line: 24, column: 8, scope: !464, inlinedAt: !476)
!481 = !DILocation(line: 37, column: 10, scope: !482, inlinedAt: !476)
!482 = distinct !DILexicalBlock(scope: !464, file: !465, line: 37, column: 6)
!483 = !DILocation(line: 37, column: 16, scope: !482, inlinedAt: !476)
!484 = !DILocation(line: 37, column: 14, scope: !482, inlinedAt: !476)
!485 = !DILocation(line: 37, column: 6, scope: !464, inlinedAt: !476)
!486 = !DILocation(line: 42, column: 17, scope: !464, inlinedAt: !476)
!487 = !{!488, !255, i64 2}
!488 = !{!"vlan_hdr", !255, i64 0, !255, i64 2}
!489 = !DILocation(line: 27, column: 9, scope: !464, inlinedAt: !476)
!490 = !DILocation(line: 45, column: 2, scope: !464, inlinedAt: !476)
!491 = !DILocation(line: 48, column: 26, scope: !492, inlinedAt: !476)
!492 = distinct !DILexicalBlock(scope: !464, file: !465, line: 48, column: 6)
!493 = !DILocation(line: 48, column: 6, scope: !492, inlinedAt: !476)
!494 = !DILocation(line: 48, column: 6, scope: !464, inlinedAt: !476)
!495 = !DILocation(line: 54, column: 27, scope: !464, inlinedAt: !476)
!496 = !DILocation(line: 54, column: 16, scope: !464, inlinedAt: !476)
!497 = !DILocation(line: 54, column: 8, scope: !464, inlinedAt: !476)
!498 = !DILocation(line: 55, column: 32, scope: !464, inlinedAt: !476)
!499 = !DILocation(line: 55, column: 21, scope: !464, inlinedAt: !476)
!500 = !DILocation(line: 56, column: 10, scope: !501, inlinedAt: !476)
!501 = distinct !DILexicalBlock(scope: !464, file: !465, line: 56, column: 6)
!502 = !DILocation(line: 56, column: 16, scope: !501, inlinedAt: !476)
!503 = !DILocation(line: 56, column: 14, scope: !501, inlinedAt: !476)
!504 = !DILocation(line: 56, column: 6, scope: !464, inlinedAt: !476)
!505 = !DILocation(line: 60, column: 2, scope: !464, inlinedAt: !476)
!506 = !DILocation(line: 61, column: 7, scope: !464, inlinedAt: !476)
!507 = !DILocation(line: 61, column: 15, scope: !464, inlinedAt: !476)
!508 = !DILocation(line: 63, column: 2, scope: !464, inlinedAt: !476)
!509 = !DILocation(line: 64, column: 1, scope: !464, inlinedAt: !476)
!510 = !DILocation(line: 87, column: 3, scope: !459)
!511 = !DILocalVariable(name: "ctx", arg: 1, scope: !512, file: !465, line: 69, type: !85)
!512 = distinct !DISubprogram(name: "vlan_tag_push", scope: !465, file: !465, line: 69, type: !513, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !515)
!513 = !DISubroutineType(types: !514)
!514 = !{!49, !85, !100, !49}
!515 = !{!511, !516, !517, !518, !519, !520}
!516 = !DILocalVariable(name: "eth", arg: 2, scope: !512, file: !465, line: 70, type: !100)
!517 = !DILocalVariable(name: "vlid", arg: 3, scope: !512, file: !465, line: 70, type: !49)
!518 = !DILocalVariable(name: "data_end", scope: !512, file: !465, line: 72, type: !44)
!519 = !DILocalVariable(name: "eth_cpy", scope: !512, file: !465, line: 73, type: !101)
!520 = !DILocalVariable(name: "vlh", scope: !512, file: !465, line: 74, type: !232)
!521 = !DILocation(line: 69, column: 57, scope: !512, inlinedAt: !522)
!522 = distinct !DILocation(line: 89, column: 3, scope: !459)
!523 = !DILocation(line: 70, column: 18, scope: !512, inlinedAt: !522)
!524 = !DILocation(line: 70, column: 27, scope: !512, inlinedAt: !522)
!525 = !DILocation(line: 73, column: 2, scope: !512, inlinedAt: !522)
!526 = !DILocation(line: 77, column: 2, scope: !512, inlinedAt: !522)
!527 = !DILocation(line: 80, column: 26, scope: !528, inlinedAt: !522)
!528 = distinct !DILexicalBlock(scope: !512, file: !465, line: 80, column: 6)
!529 = !DILocation(line: 80, column: 6, scope: !528, inlinedAt: !522)
!530 = !DILocation(line: 80, column: 6, scope: !512, inlinedAt: !522)
!531 = !DILocation(line: 87, column: 32, scope: !512, inlinedAt: !522)
!532 = !DILocation(line: 87, column: 21, scope: !512, inlinedAt: !522)
!533 = !DILocation(line: 88, column: 27, scope: !512, inlinedAt: !522)
!534 = !DILocation(line: 88, column: 16, scope: !512, inlinedAt: !522)
!535 = !DILocation(line: 88, column: 8, scope: !512, inlinedAt: !522)
!536 = !DILocation(line: 90, column: 10, scope: !537, inlinedAt: !522)
!537 = distinct !DILexicalBlock(scope: !512, file: !465, line: 90, column: 6)
!538 = !DILocation(line: 90, column: 16, scope: !537, inlinedAt: !522)
!539 = !DILocation(line: 90, column: 14, scope: !537, inlinedAt: !522)
!540 = !DILocation(line: 90, column: 6, scope: !512, inlinedAt: !522)
!541 = !DILocation(line: 72, column: 8, scope: !512, inlinedAt: !522)
!542 = !DILocation(line: 96, column: 2, scope: !512, inlinedAt: !522)
!543 = !DILocation(line: 74, column: 19, scope: !512, inlinedAt: !522)
!544 = !DILocation(line: 100, column: 10, scope: !545, inlinedAt: !522)
!545 = distinct !DILexicalBlock(scope: !512, file: !465, line: 100, column: 6)
!546 = !DILocation(line: 100, column: 16, scope: !545, inlinedAt: !522)
!547 = !DILocation(line: 100, column: 14, scope: !545, inlinedAt: !522)
!548 = !DILocation(line: 100, column: 6, scope: !512, inlinedAt: !522)
!549 = !DILocation(line: 103, column: 7, scope: !512, inlinedAt: !522)
!550 = !DILocation(line: 103, column: 18, scope: !512, inlinedAt: !522)
!551 = !{!488, !255, i64 0}
!552 = !DILocation(line: 104, column: 40, scope: !512, inlinedAt: !522)
!553 = !DILocation(line: 104, column: 7, scope: !512, inlinedAt: !522)
!554 = !DILocation(line: 104, column: 33, scope: !512, inlinedAt: !522)
!555 = !DILocation(line: 106, column: 15, scope: !512, inlinedAt: !522)
!556 = !DILocation(line: 107, column: 2, scope: !512, inlinedAt: !522)
!557 = !DILocation(line: 108, column: 1, scope: !512, inlinedAt: !522)
!558 = !DILocation(line: 92, column: 1, scope: !427)
!559 = distinct !DISubprogram(name: "xdp_pass_func", scope: !3, file: !3, line: 95, type: !83, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !560)
!560 = !{!561}
!561 = !DILocalVariable(name: "ctx", arg: 1, scope: !559, file: !3, line: 95, type: !85)
!562 = !DILocation(line: 95, column: 34, scope: !559)
!563 = !DILocation(line: 97, column: 2, scope: !559)
