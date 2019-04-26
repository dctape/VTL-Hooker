; ModuleID = 'xdp_l4_count_kern.c'
source_filename = "xdp_l4_count_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }

@rxcnt = global %struct.bpf_map_def { i32 1, i32 4, i32 8, i32 256, i32 0, i32 0, i32 0 }, section "maps", align 4
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_l4_count_program to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @xdp_l4_count_program(%struct.xdp_md* nocapture readonly) #0 section "xdp_l4_count" {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1
  %5 = load i32, i32* %4, align 4, !tbaa !2
  %6 = zext i32 %5 to i64
  %7 = inttoptr i64 %6 to i8*
  %8 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0
  %9 = load i32, i32* %8, align 4, !tbaa !7
  %10 = zext i32 %9 to i64
  %11 = inttoptr i64 %10 to i8*
  %12 = getelementptr i8, i8* %11, i64 14
  %13 = icmp ugt i8* %12, %7
  br i1 %13, label %110, label %14

; <label>:14:                                     ; preds = %1
  %15 = inttoptr i64 %10 to %struct.ethhdr*
  %16 = getelementptr inbounds %struct.ethhdr, %struct.ethhdr* %15, i64 0, i32 2
  %17 = load i16, i16* %16, align 1, !tbaa !8
  switch i16 %17, label %25 [
    i16 129, label %18
    i16 -22392, label %18
  ]

; <label>:18:                                     ; preds = %14, %14
  %19 = getelementptr i8, i8* %11, i64 18
  %20 = icmp ugt i8* %19, %7
  br i1 %20, label %110, label %21

; <label>:21:                                     ; preds = %18
  %22 = getelementptr inbounds i8, i8* %11, i64 16
  %23 = bitcast i8* %22 to i16*
  %24 = load i16, i16* %23, align 2, !tbaa !11
  br label %25

; <label>:25:                                     ; preds = %21, %14
  %26 = phi i16 [ %17, %14 ], [ %24, %21 ]
  %27 = phi i64 [ 14, %14 ], [ 18, %21 ]
  switch i16 %26, label %110 [
    i16 8, label %28
    i16 -8826, label %69
  ]

; <label>:28:                                     ; preds = %25
  %29 = getelementptr i8, i8* %11, i64 %27
  %30 = getelementptr inbounds i8, i8* %29, i64 20
  %31 = icmp ugt i8* %30, %7
  br i1 %31, label %32, label %34

; <label>:32:                                     ; preds = %28
  %33 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %33)
  store i32 0, i32* %2, align 4, !tbaa !13
  br label %60

; <label>:34:                                     ; preds = %28
  %35 = getelementptr inbounds i8, i8* %29, i64 9
  %36 = load i8, i8* %35, align 1, !tbaa !14
  %37 = zext i8 %36 to i32
  %38 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %38)
  store i32 %37, i32* %2, align 4, !tbaa !13
  switch i8 %36, label %60 [
    i8 17, label %39
    i8 6, label %46
    i8 1, label %53
  ]

; <label>:39:                                     ; preds = %34
  %40 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* nonnull %38) #2
  %41 = bitcast i8* %40 to i64*
  %42 = icmp eq i8* %40, null
  br i1 %42, label %60, label %43

; <label>:43:                                     ; preds = %39
  %44 = load i64, i64* %41, align 8, !tbaa !16
  %45 = add i64 %44, 1
  store i64 %45, i64* %41, align 8, !tbaa !16
  br label %60

; <label>:46:                                     ; preds = %34
  %47 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* nonnull %38) #2
  %48 = bitcast i8* %47 to i64*
  %49 = icmp eq i8* %47, null
  br i1 %49, label %60, label %50

; <label>:50:                                     ; preds = %46
  %51 = load i64, i64* %48, align 8, !tbaa !16
  %52 = add i64 %51, 1
  store i64 %52, i64* %48, align 8, !tbaa !16
  br label %60

; <label>:53:                                     ; preds = %34
  %54 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* nonnull %38) #2
  %55 = bitcast i8* %54 to i64*
  %56 = icmp eq i8* %54, null
  br i1 %56, label %60, label %57

; <label>:57:                                     ; preds = %53
  %58 = load i64, i64* %55, align 8, !tbaa !16
  %59 = add i64 %58, 1
  store i64 %59, i64* %55, align 8, !tbaa !16
  br label %60

; <label>:60:                                     ; preds = %34, %32, %57, %53, %50, %46, %43, %39
  %61 = phi i8* [ %38, %39 ], [ %38, %46 ], [ %38, %53 ], [ %38, %57 ], [ %38, %50 ], [ %38, %43 ], [ %33, %32 ], [ %38, %34 ]
  store i32 0, i32* %2, align 4, !tbaa !13
  %62 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* nonnull %61) #2
  %63 = bitcast i8* %62 to i64*
  %64 = icmp eq i8* %62, null
  br i1 %64, label %68, label %65

; <label>:65:                                     ; preds = %60
  %66 = load i64, i64* %63, align 8, !tbaa !16
  %67 = add i64 %66, 1
  store i64 %67, i64* %63, align 8, !tbaa !16
  br label %68

; <label>:68:                                     ; preds = %60, %65
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %61)
  br label %110

; <label>:69:                                     ; preds = %25
  %70 = getelementptr i8, i8* %11, i64 %27
  %71 = getelementptr inbounds i8, i8* %70, i64 40
  %72 = icmp ugt i8* %71, %7
  br i1 %72, label %73, label %75

; <label>:73:                                     ; preds = %69
  %74 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %74)
  store i32 0, i32* %3, align 4, !tbaa !13
  br label %101

; <label>:75:                                     ; preds = %69
  %76 = getelementptr inbounds i8, i8* %70, i64 6
  %77 = load i8, i8* %76, align 2, !tbaa !18
  %78 = zext i8 %77 to i32
  %79 = bitcast i32* %3 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %79)
  store i32 %78, i32* %3, align 4, !tbaa !13
  switch i8 %77, label %101 [
    i8 17, label %80
    i8 6, label %87
    i8 1, label %94
  ]

; <label>:80:                                     ; preds = %75
  %81 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* nonnull %79) #2
  %82 = bitcast i8* %81 to i64*
  %83 = icmp eq i8* %81, null
  br i1 %83, label %101, label %84

; <label>:84:                                     ; preds = %80
  %85 = load i64, i64* %82, align 8, !tbaa !16
  %86 = add i64 %85, 1
  store i64 %86, i64* %82, align 8, !tbaa !16
  br label %101

; <label>:87:                                     ; preds = %75
  %88 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* nonnull %79) #2
  %89 = bitcast i8* %88 to i64*
  %90 = icmp eq i8* %88, null
  br i1 %90, label %101, label %91

; <label>:91:                                     ; preds = %87
  %92 = load i64, i64* %89, align 8, !tbaa !16
  %93 = add i64 %92, 1
  store i64 %93, i64* %89, align 8, !tbaa !16
  br label %101

; <label>:94:                                     ; preds = %75
  %95 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* nonnull %79) #2
  %96 = bitcast i8* %95 to i64*
  %97 = icmp eq i8* %95, null
  br i1 %97, label %101, label %98

; <label>:98:                                     ; preds = %94
  %99 = load i64, i64* %96, align 8, !tbaa !16
  %100 = add i64 %99, 1
  store i64 %100, i64* %96, align 8, !tbaa !16
  br label %101

; <label>:101:                                    ; preds = %75, %73, %98, %94, %91, %87, %84, %80
  %102 = phi i8* [ %79, %80 ], [ %79, %87 ], [ %79, %94 ], [ %79, %98 ], [ %79, %91 ], [ %79, %84 ], [ %74, %73 ], [ %79, %75 ]
  store i32 0, i32* %3, align 4, !tbaa !13
  %103 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @rxcnt to i8*), i8* nonnull %102) #2
  %104 = bitcast i8* %103 to i64*
  %105 = icmp eq i8* %103, null
  br i1 %105, label %109, label %106

; <label>:106:                                    ; preds = %101
  %107 = load i64, i64* %104, align 8, !tbaa !16
  %108 = add i64 %107, 1
  store i64 %108, i64* %104, align 8, !tbaa !16
  br label %109

; <label>:109:                                    ; preds = %101, %106
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %102)
  br label %110

; <label>:110:                                    ; preds = %18, %68, %109, %25, %1
  %111 = phi i32 [ 0, %1 ], [ 2, %25 ], [ 2, %109 ], [ 2, %68 ], [ 0, %18 ]
  ret i32 %111
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.1-svn334776-1~exp1~20190124082834.118 (branches/release_60)"}
!2 = !{!3, !4, i64 4}
!3 = !{!"xdp_md", !4, i64 0, !4, i64 4, !4, i64 8, !4, i64 12, !4, i64 16}
!4 = !{!"int", !5, i64 0}
!5 = !{!"omnipotent char", !6, i64 0}
!6 = !{!"Simple C/C++ TBAA"}
!7 = !{!3, !4, i64 0}
!8 = !{!9, !10, i64 12}
!9 = !{!"ethhdr", !5, i64 0, !5, i64 6, !10, i64 12}
!10 = !{!"short", !5, i64 0}
!11 = !{!12, !10, i64 2}
!12 = !{!"vlan_hdr", !10, i64 0, !10, i64 2}
!13 = !{!4, !4, i64 0}
!14 = !{!15, !5, i64 9}
!15 = !{!"iphdr", !5, i64 0, !5, i64 0, !5, i64 1, !10, i64 2, !10, i64 4, !10, i64 6, !5, i64 8, !5, i64 9, !10, i64 10, !4, i64 12, !4, i64 16}
!16 = !{!17, !17, i64 0}
!17 = !{!"long long", !5, i64 0}
!18 = !{!19, !5, i64 6}
!19 = !{!"ipv6hdr", !5, i64 0, !5, i64 0, !5, i64 1, !10, i64 4, !5, i64 6, !5, i64 7, !20, i64 8, !20, i64 24}
!20 = !{!"in6_addr", !5, i64 0}
