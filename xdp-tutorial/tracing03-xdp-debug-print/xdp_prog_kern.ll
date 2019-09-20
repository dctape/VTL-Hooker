; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@__const.xdp_prog_simple.____fmt = private unnamed_addr constant [33 x i8] c"src: %llu, dst: %llu, proto: %u\0A\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !0
@llvm.used = appending global [2 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_prog_simple to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_prog_simple(%struct.xdp_md* nocapture readonly) #0 section "xdp" !dbg !38 {
  %2 = alloca [33 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !51, metadata !DIExpression()), !dbg !76
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !77
  %4 = load i32, i32* %3, align 4, !dbg !77, !tbaa !78
  %5 = zext i32 %4 to i64, !dbg !83
  %6 = inttoptr i64 %5 to i8*, !dbg !84
  call void @llvm.dbg.value(metadata i8* %6, metadata !52, metadata !DIExpression()), !dbg !85
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !86
  %8 = load i32, i32* %7, align 4, !dbg !86, !tbaa !87
  %9 = zext i32 %8 to i64, !dbg !88
  %10 = inttoptr i64 %9 to i8*, !dbg !89
  call void @llvm.dbg.value(metadata i8* %10, metadata !53, metadata !DIExpression()), !dbg !90
  %11 = inttoptr i64 %5 to %struct.ethhdr*, !dbg !91
  call void @llvm.dbg.value(metadata %struct.ethhdr* %11, metadata !54, metadata !DIExpression()), !dbg !92
  call void @llvm.dbg.value(metadata i64 14, metadata !68, metadata !DIExpression()), !dbg !93
  %12 = getelementptr i8, i8* %6, i64 14, !dbg !94
  %13 = icmp ugt i8* %12, %10, !dbg !96
  br i1 %13, label %84, label %14, !dbg !97

; <label>:14:                                     ; preds = %1
  %15 = getelementptr inbounds [33 x i8], [33 x i8]* %2, i64 0, i64 0, !dbg !98
  call void @llvm.lifetime.start.p0i8(i64 33, i8* nonnull %15) #3, !dbg !98
  call void @llvm.dbg.declare(metadata [33 x i8]* %2, metadata !71, metadata !DIExpression()), !dbg !98
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 %15, i8* align 1 getelementptr inbounds ([33 x i8], [33 x i8]* @__const.xdp_prog_simple.____fmt, i64 0, i64 0), i64 33, i1 false), !dbg !98
  %16 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 1, i64 0, !dbg !98
  call void @llvm.dbg.value(metadata i8* %16, metadata !99, metadata !DIExpression()), !dbg !109
  call void @llvm.dbg.value(metadata i64 0, metadata !107, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i32 6, metadata !108, metadata !DIExpression()), !dbg !112
  call void @llvm.dbg.value(metadata i64 6, metadata !108, metadata !DIExpression()), !dbg !112
  call void @llvm.dbg.value(metadata i64 0, metadata !107, metadata !DIExpression()), !dbg !111
  %17 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 1, i64 6, !dbg !113
  %18 = load i8, i8* %17, align 1, !dbg !113, !tbaa !116
  %19 = zext i8 %18 to i64, !dbg !113
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !112
  call void @llvm.dbg.value(metadata i64 %19, metadata !107, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 5, metadata !108, metadata !DIExpression()), !dbg !112
  call void @llvm.dbg.value(metadata i64 %19, metadata !107, metadata !DIExpression()), !dbg !111
  %20 = shl nuw nsw i64 %19, 8, !dbg !117
  %21 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 1, i64 5, !dbg !113
  %22 = load i8, i8* %21, align 1, !dbg !113, !tbaa !116
  %23 = zext i8 %22 to i64, !dbg !113
  %24 = or i64 %20, %23, !dbg !118
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !112
  call void @llvm.dbg.value(metadata i64 %24, metadata !107, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 4, metadata !108, metadata !DIExpression()), !dbg !112
  call void @llvm.dbg.value(metadata i64 %24, metadata !107, metadata !DIExpression()), !dbg !111
  %25 = shl nuw nsw i64 %24, 8, !dbg !117
  %26 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 1, i64 4, !dbg !113
  %27 = load i8, i8* %26, align 1, !dbg !113, !tbaa !116
  %28 = zext i8 %27 to i64, !dbg !113
  %29 = or i64 %25, %28, !dbg !118
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !112
  call void @llvm.dbg.value(metadata i64 %29, metadata !107, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 3, metadata !108, metadata !DIExpression()), !dbg !112
  call void @llvm.dbg.value(metadata i64 %29, metadata !107, metadata !DIExpression()), !dbg !111
  %30 = shl nuw nsw i64 %29, 8, !dbg !117
  %31 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 1, i64 3, !dbg !113
  %32 = load i8, i8* %31, align 1, !dbg !113, !tbaa !116
  %33 = zext i8 %32 to i64, !dbg !113
  %34 = or i64 %30, %33, !dbg !118
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !112
  call void @llvm.dbg.value(metadata i64 %34, metadata !107, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 2, metadata !108, metadata !DIExpression()), !dbg !112
  call void @llvm.dbg.value(metadata i64 %34, metadata !107, metadata !DIExpression()), !dbg !111
  %35 = shl i64 %34, 8, !dbg !117
  %36 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 1, i64 2, !dbg !113
  %37 = load i8, i8* %36, align 1, !dbg !113, !tbaa !116
  %38 = zext i8 %37 to i64, !dbg !113
  %39 = or i64 %35, %38, !dbg !118
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !112
  call void @llvm.dbg.value(metadata i64 %39, metadata !107, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 1, metadata !108, metadata !DIExpression()), !dbg !112
  call void @llvm.dbg.value(metadata i64 %39, metadata !107, metadata !DIExpression()), !dbg !111
  %40 = shl i64 %39, 8, !dbg !117
  %41 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 1, i64 1, !dbg !113
  %42 = load i8, i8* %41, align 1, !dbg !113, !tbaa !116
  %43 = zext i8 %42 to i64, !dbg !113
  %44 = or i64 %40, %43, !dbg !118
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !112
  call void @llvm.dbg.value(metadata i64 %44, metadata !107, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 0, metadata !108, metadata !DIExpression()), !dbg !112
  call void @llvm.dbg.value(metadata i64 %44, metadata !107, metadata !DIExpression()), !dbg !111
  %45 = shl i64 %44, 8, !dbg !117
  %46 = load i8, i8* %16, align 1, !dbg !113, !tbaa !116
  %47 = zext i8 %46 to i64, !dbg !113
  %48 = or i64 %45, %47, !dbg !118
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !112
  call void @llvm.dbg.value(metadata i64 %48, metadata !107, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.value(metadata i64 %48, metadata !107, metadata !DIExpression()), !dbg !111
  %49 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 0, i64 0, !dbg !98
  call void @llvm.dbg.value(metadata i8* %49, metadata !99, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.value(metadata i64 0, metadata !107, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i32 6, metadata !108, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i64 6, metadata !108, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i64 0, metadata !107, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !122
  call void @llvm.dbg.value(metadata i64 %47, metadata !107, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 5, metadata !108, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i64 %47, metadata !107, metadata !DIExpression()), !dbg !121
  %50 = shl nuw nsw i64 %47, 8, !dbg !123
  %51 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 0, i64 5, !dbg !124
  %52 = load i8, i8* %51, align 1, !dbg !124, !tbaa !116
  %53 = zext i8 %52 to i64, !dbg !124
  %54 = or i64 %50, %53, !dbg !125
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !122
  call void @llvm.dbg.value(metadata i64 %54, metadata !107, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 4, metadata !108, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i64 %54, metadata !107, metadata !DIExpression()), !dbg !121
  %55 = shl nuw nsw i64 %54, 8, !dbg !123
  %56 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 0, i64 4, !dbg !124
  %57 = load i8, i8* %56, align 1, !dbg !124, !tbaa !116
  %58 = zext i8 %57 to i64, !dbg !124
  %59 = or i64 %55, %58, !dbg !125
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !122
  call void @llvm.dbg.value(metadata i64 %59, metadata !107, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 3, metadata !108, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i64 %59, metadata !107, metadata !DIExpression()), !dbg !121
  %60 = shl nuw nsw i64 %59, 8, !dbg !123
  %61 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 0, i64 3, !dbg !124
  %62 = load i8, i8* %61, align 1, !dbg !124, !tbaa !116
  %63 = zext i8 %62 to i64, !dbg !124
  %64 = or i64 %60, %63, !dbg !125
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !122
  call void @llvm.dbg.value(metadata i64 %64, metadata !107, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 2, metadata !108, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i64 %64, metadata !107, metadata !DIExpression()), !dbg !121
  %65 = shl i64 %64, 8, !dbg !123
  %66 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 0, i64 2, !dbg !124
  %67 = load i8, i8* %66, align 1, !dbg !124, !tbaa !116
  %68 = zext i8 %67 to i64, !dbg !124
  %69 = or i64 %65, %68, !dbg !125
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !122
  call void @llvm.dbg.value(metadata i64 %69, metadata !107, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 1, metadata !108, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i64 %69, metadata !107, metadata !DIExpression()), !dbg !121
  %70 = shl i64 %69, 8, !dbg !123
  %71 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 0, i64 1, !dbg !124
  %72 = load i8, i8* %71, align 1, !dbg !124, !tbaa !116
  %73 = zext i8 %72 to i64, !dbg !124
  %74 = or i64 %70, %73, !dbg !125
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !122
  call void @llvm.dbg.value(metadata i64 %74, metadata !107, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 0, metadata !108, metadata !DIExpression()), !dbg !122
  call void @llvm.dbg.value(metadata i64 %74, metadata !107, metadata !DIExpression()), !dbg !121
  %75 = shl i64 %74, 8, !dbg !123
  %76 = load i8, i8* %49, align 1, !dbg !124, !tbaa !116
  %77 = zext i8 %76 to i64, !dbg !124
  %78 = or i64 %75, %77, !dbg !125
  call void @llvm.dbg.value(metadata i32 undef, metadata !108, metadata !DIExpression(DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value)), !dbg !122
  call void @llvm.dbg.value(metadata i64 %78, metadata !107, metadata !DIExpression()), !dbg !121
  call void @llvm.dbg.value(metadata i64 %78, metadata !107, metadata !DIExpression()), !dbg !121
  %79 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %11, i64 0, i32 2, !dbg !98
  %80 = load i16, i16* %79, align 1, !dbg !98, !tbaa !126
  %81 = tail call i16 @llvm.bswap.i16(i16 %80)
  %82 = zext i16 %81 to i32, !dbg !98
  %83 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %15, i32 33, i64 %48, i64 %78, i32 %82) #3, !dbg !98
  call void @llvm.lifetime.end.p0i8(i64 33, i8* nonnull %15) #3, !dbg !129
  br label %84, !dbg !130

; <label>:84:                                     ; preds = %1, %14
  %85 = phi i32 [ 2, %14 ], [ 0, %1 ], !dbg !131
  ret i32 %85, !dbg !132
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1) #2

; Function Attrs: nounwind readnone speculatable
declare i16 @llvm.bswap.i16(i16) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!34, !35, !36}
!llvm.ident = !{!37}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 49, type: !31, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 8.0.0 (Fedora 8.0.0-1.fc30)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !14, globals: !20, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/fedora/xdp-tutorial/tracing03-xdp-debug-print")
!4 = !{!5}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "../headers/linux/bpf.h", directory: "/home/fedora/xdp-tutorial/tracing03-xdp-debug-print")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !{!15, !16, !17}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!16 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !18, line: 24, baseType: !19)
!18 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!19 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!20 = !{!0, !21}
!21 = !DIGlobalVariableExpression(var: !22, expr: !DIExpression())
!22 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !23, line: 38, type: !24, isLocal: true, isDefinition: true)
!23 = !DIFile(filename: "../headers/bpf_helpers.h", directory: "/home/fedora/xdp-tutorial/tracing03-xdp-debug-print")
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DISubroutineType(types: !26)
!26 = !{!27, !28, !27, null}
!27 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !30)
!30 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 32, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 4)
!34 = !{i32 2, !"Dwarf Version", i32 4}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{!"clang version 8.0.0 (Fedora 8.0.0-1.fc30)"}
!38 = distinct !DISubprogram(name: "xdp_prog_simple", scope: !3, file: !3, line: 31, type: !39, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !50)
!39 = !DISubroutineType(types: !40)
!40 = !{!27, !41}
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!42 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !43)
!43 = !{!44, !46, !47, !48, !49}
!44 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !42, file: !6, line: 2857, baseType: !45, size: 32)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !18, line: 27, baseType: !7)
!46 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !42, file: !6, line: 2858, baseType: !45, size: 32, offset: 32)
!47 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !42, file: !6, line: 2859, baseType: !45, size: 32, offset: 64)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !42, file: !6, line: 2861, baseType: !45, size: 32, offset: 96)
!49 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !42, file: !6, line: 2862, baseType: !45, size: 32, offset: 128)
!50 = !{!51, !52, !53, !54, !68, !71}
!51 = !DILocalVariable(name: "ctx", arg: 1, scope: !38, file: !3, line: 31, type: !41)
!52 = !DILocalVariable(name: "data", scope: !38, file: !3, line: 33, type: !15)
!53 = !DILocalVariable(name: "data_end", scope: !38, file: !3, line: 34, type: !15)
!54 = !DILocalVariable(name: "eth", scope: !38, file: !3, line: 35, type: !55)
!55 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!56 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !57, line: 161, size: 112, elements: !58)
!57 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!58 = !{!59, !64, !65}
!59 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !56, file: !57, line: 162, baseType: !60, size: 48)
!60 = !DICompositeType(tag: DW_TAG_array_type, baseType: !61, size: 48, elements: !62)
!61 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!62 = !{!63}
!63 = !DISubrange(count: 6)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !56, file: !57, line: 163, baseType: !60, size: 48, offset: 48)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !56, file: !57, line: 164, baseType: !66, size: 16, offset: 96)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !67, line: 25, baseType: !17)
!67 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!68 = !DILocalVariable(name: "offset", scope: !38, file: !3, line: 36, type: !69)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !18, line: 31, baseType: !70)
!70 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!71 = !DILocalVariable(name: "____fmt", scope: !72, file: !3, line: 41, type: !73)
!72 = distinct !DILexicalBlock(scope: !38, file: !3, line: 41, column: 2)
!73 = !DICompositeType(tag: DW_TAG_array_type, baseType: !30, size: 264, elements: !74)
!74 = !{!75}
!75 = !DISubrange(count: 33)
!76 = !DILocation(line: 31, column: 37, scope: !38)
!77 = !DILocation(line: 33, column: 34, scope: !38)
!78 = !{!79, !80, i64 0}
!79 = !{!"xdp_md", !80, i64 0, !80, i64 4, !80, i64 8, !80, i64 12, !80, i64 16}
!80 = !{!"int", !81, i64 0}
!81 = !{!"omnipotent char", !82, i64 0}
!82 = !{!"Simple C/C++ TBAA"}
!83 = !DILocation(line: 33, column: 23, scope: !38)
!84 = !DILocation(line: 33, column: 15, scope: !38)
!85 = !DILocation(line: 33, column: 8, scope: !38)
!86 = !DILocation(line: 34, column: 38, scope: !38)
!87 = !{!79, !80, i64 4}
!88 = !DILocation(line: 34, column: 27, scope: !38)
!89 = !DILocation(line: 34, column: 19, scope: !38)
!90 = !DILocation(line: 34, column: 8, scope: !38)
!91 = !DILocation(line: 35, column: 23, scope: !38)
!92 = !DILocation(line: 35, column: 17, scope: !38)
!93 = !DILocation(line: 36, column: 8, scope: !38)
!94 = !DILocation(line: 38, column: 18, scope: !95)
!95 = distinct !DILexicalBlock(scope: !38, file: !3, line: 38, column: 6)
!96 = !DILocation(line: 38, column: 27, scope: !95)
!97 = !DILocation(line: 38, column: 6, scope: !38)
!98 = !DILocation(line: 41, column: 2, scope: !72)
!99 = !DILocalVariable(name: "addr", arg: 1, scope: !100, file: !3, line: 20, type: !103)
!100 = distinct !DISubprogram(name: "ether_addr_to_u64", scope: !3, file: !3, line: 20, type: !101, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !106)
!101 = !DISubroutineType(types: !102)
!102 = !{!69, !103}
!103 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!104 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !105)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !18, line: 21, baseType: !61)
!106 = !{!99, !107, !108}
!107 = !DILocalVariable(name: "u", scope: !100, file: !3, line: 22, type: !69)
!108 = !DILocalVariable(name: "i", scope: !100, file: !3, line: 23, type: !27)
!109 = !DILocation(line: 20, column: 51, scope: !100, inlinedAt: !110)
!110 = distinct !DILocation(line: 41, column: 2, scope: !72)
!111 = !DILocation(line: 22, column: 8, scope: !100, inlinedAt: !110)
!112 = !DILocation(line: 23, column: 6, scope: !100, inlinedAt: !110)
!113 = !DILocation(line: 26, column: 16, scope: !114, inlinedAt: !110)
!114 = distinct !DILexicalBlock(scope: !115, file: !3, line: 25, column: 2)
!115 = distinct !DILexicalBlock(scope: !100, file: !3, line: 25, column: 2)
!116 = !{!81, !81, i64 0}
!117 = !DILocation(line: 26, column: 9, scope: !114, inlinedAt: !110)
!118 = !DILocation(line: 26, column: 14, scope: !114, inlinedAt: !110)
!119 = !DILocation(line: 20, column: 51, scope: !100, inlinedAt: !120)
!120 = distinct !DILocation(line: 41, column: 2, scope: !72)
!121 = !DILocation(line: 22, column: 8, scope: !100, inlinedAt: !120)
!122 = !DILocation(line: 23, column: 6, scope: !100, inlinedAt: !120)
!123 = !DILocation(line: 26, column: 9, scope: !114, inlinedAt: !120)
!124 = !DILocation(line: 26, column: 16, scope: !114, inlinedAt: !120)
!125 = !DILocation(line: 26, column: 14, scope: !114, inlinedAt: !120)
!126 = !{!127, !128, i64 12}
!127 = !{!"ethhdr", !81, i64 0, !81, i64 6, !128, i64 12}
!128 = !{!"short", !81, i64 0}
!129 = !DILocation(line: 41, column: 2, scope: !38)
!130 = !DILocation(line: 46, column: 2, scope: !38)
!131 = !DILocation(line: 0, scope: !38)
!132 = !DILocation(line: 47, column: 1, scope: !38)
