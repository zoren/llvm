; RUN: opt -safe-stack -S -mtriple=aarch64-linux-android < %s -o - | FileCheck --check-prefix=TLS %s


define void @foo() nounwind uwtable safestack sspreq {
entry:
; The first @llvm.aarch64.thread.pointer is for the unsafe stack pointer, skip it.
; TLS: call i8* @llvm.aarch64.thread.pointer()

; TLS: %[[TP2:.*]] = call i8* @llvm.aarch64.thread.pointer()
; TLS: %[[B:.*]] = getelementptr i8, i8* %[[TP2]], i32 40
; TLS: %[[C:.*]] = bitcast i8* %[[B]] to i8**
; TLS: %[[StackGuard:.*]] = load i8*, i8** %[[C]]
; TLS: store i8* %[[StackGuard]], i8** %[[StackGuardSlot:.*]]
  %a = alloca i128, align 16
  call void @Capture(i128* %a)

; TLS: %[[A:.*]] = load i8*, i8** %[[StackGuardSlot]]
; TLS: icmp ne i8* %[[StackGuard]], %[[A]]
  ret void
}

declare void @Capture(i128*)
