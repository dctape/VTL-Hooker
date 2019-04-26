; ModuleID = 'test_cgroups_kern.c'
source_filename = "test_cgroups_kern.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.bpf_sock_ops = type { i32, %union.anon, i32, i32, i32, [4 x i32], [4 x i32], i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i32, i64, i64 }
%union.anon = type { [4 x i32] }

@bpf_bufs.____fmt.1 = private unnamed_addr constant [14 x i8] c"Returning %d\0A\00", align 1
@_license = global [4 x i8] c"GPL\00", section "license", align 1
@llvm.used = appending global [2 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.bpf_sock_ops*)* @bpf_bufs to i8*)], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define i32 @bpf_bufs(%struct.bpf_sock_ops*) #0 section "sockops" {
  %2 = alloca i32, align 4
  %3 = alloca [14 x i8], align 1
  %4 = alloca [14 x i8], align 1
  %5 = bitcast i32* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %5) #2
  store i32 1500000, i32* %2, align 4, !tbaa !2
  %6 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 7
  %7 = load i32, i32* %6, align 8, !tbaa !6
  %8 = icmp eq i32 %7, 836304896
  br i1 %8, label %13, label %9

; <label>:9:                                      ; preds = %1
  %10 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 8
  %11 = load i32, i32* %10, align 4, !tbaa !9
  %12 = icmp eq i32 %11, 55601
  br i1 %12, label %13, label %34

; <label>:13:                                     ; preds = %9, %1
  %14 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 0
  %15 = load i32, i32* %14, align 8, !tbaa !10
  %16 = getelementptr inbounds [14 x i8], [14 x i8]* %3, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %16) #2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %16, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @bpf_bufs.____fmt.1, i64 0, i64 0), i64 14, i32 1, i1 false)
  %17 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %16, i32 14, i32 0) #2
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %16) #2
  switch i32 %15, label %29 [
    i32 2, label %18
    i32 3, label %19
    i32 4, label %30
    i32 5, label %24
  ]

; <label>:18:                                     ; preds = %13
  br label %30

; <label>:19:                                     ; preds = %13
  %20 = bitcast %struct.bpf_sock_ops* %0 to i8*
  %21 = call i32 inttoptr (i64 49 to i32 (i8*, i32, i32, i8*, i32)*)(i8* %20, i32 1, i32 7, i8* nonnull %5, i32 4) #2
  %22 = call i32 inttoptr (i64 49 to i32 (i8*, i32, i32, i8*, i32)*)(i8* %20, i32 1, i32 8, i8* nonnull %5, i32 4) #2
  %23 = add nsw i32 %22, %21
  br label %30

; <label>:24:                                     ; preds = %13
  %25 = bitcast %struct.bpf_sock_ops* %0 to i8*
  %26 = call i32 inttoptr (i64 49 to i32 (i8*, i32, i32, i8*, i32)*)(i8* %25, i32 1, i32 7, i8* nonnull %5, i32 4) #2
  %27 = call i32 inttoptr (i64 49 to i32 (i8*, i32, i32, i8*, i32)*)(i8* %25, i32 1, i32 8, i8* nonnull %5, i32 4) #2
  %28 = add nsw i32 %27, %26
  br label %30

; <label>:29:                                     ; preds = %13
  br label %30

; <label>:30:                                     ; preds = %29, %24, %13, %19, %18
  %31 = phi i32 [ -1, %29 ], [ %28, %24 ], [ 0, %13 ], [ %23, %19 ], [ 40, %18 ]
  %32 = getelementptr inbounds [14 x i8], [14 x i8]* %4, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 14, i8* nonnull %32) #2
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull %32, i8* getelementptr inbounds ([14 x i8], [14 x i8]* @bpf_bufs.____fmt.1, i64 0, i64 0), i64 14, i32 1, i1 false)
  %33 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %32, i32 14, i32 %31) #2
  call void @llvm.lifetime.end.p0i8(i64 14, i8* nonnull %32) #2
  br label %34

; <label>:34:                                     ; preds = %9, %30
  %35 = phi i32 [ %31, %30 ], [ -1, %9 ]
  %36 = getelementptr inbounds %struct.bpf_sock_ops, %struct.bpf_sock_ops* %0, i64 0, i32 1, i32 0, i64 0
  store i32 %35, i32* %36, align 4, !tbaa !11
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %5) #2
  ret i32 1
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i32, i1) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #1

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 6.0.1-svn334776-1~exp1~20190124082834.118 (branches/release_60)"}
!2 = !{!3, !3, i64 0}
!3 = !{!"int", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7, !3, i64 64}
!7 = !{!"bpf_sock_ops", !3, i64 0, !4, i64 4, !3, i64 20, !3, i64 24, !3, i64 28, !4, i64 32, !4, i64 48, !3, i64 64, !3, i64 68, !3, i64 72, !3, i64 76, !3, i64 80, !3, i64 84, !3, i64 88, !3, i64 92, !3, i64 96, !3, i64 100, !3, i64 104, !3, i64 108, !3, i64 112, !3, i64 116, !3, i64 120, !3, i64 124, !3, i64 128, !3, i64 132, !3, i64 136, !3, i64 140, !3, i64 144, !3, i64 148, !3, i64 152, !3, i64 156, !3, i64 160, !3, i64 164, !8, i64 168, !8, i64 176}
!8 = !{!"long long", !4, i64 0}
!9 = !{!7, !3, i64 68}
!10 = !{!7, !3, i64 0}
!11 = !{!4, !4, i64 0}
