; ModuleID = 'examples/example2/out.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [3 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([57 x i8], [57 x i8]* @.str.1, i32 0, i32 0), i32 43 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([57 x i8], [57 x i8]* @.str.1, i32 0, i32 0), i32 53 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double (double)* @get_ewma to i8*), i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([57 x i8], [57 x i8]* @.str.1, i32 0, i32 0), i32 62 }], section "llvm.metadata"
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [57 x i8] c"/workspaces/build/apps/examples/example2/temp/example2.c\00", section "llvm.metadata"
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !16
@.str.2 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [19 x i8] c"XDLINKAGE_GET_EWMA\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [17 x i8] c"PURPLE_SHAREABLE\00", section "llvm.metadata"
@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !11
@.str.5 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_ewma(double %0) #0 !dbg !23 {
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %2, align 8
  call void @llvm.dbg.declare(metadata double* %2, metadata !26, metadata !DIExpression()), !dbg !27
  call void @llvm.dbg.declare(metadata double* %3, metadata !28, metadata !DIExpression()), !dbg !29
  %6 = bitcast double* %3 to i8*, !dbg !30
  call void @llvm.var.annotation(i8* %6, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([57 x i8], [57 x i8]* @.str.1, i32 0, i32 0), i32 67), !dbg !30
  call void @llvm.dbg.declare(metadata double* %4, metadata !31, metadata !DIExpression()), !dbg !32
  %7 = bitcast double* %4 to i8*, !dbg !30
  call void @llvm.var.annotation(i8* %7, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([57 x i8], [57 x i8]* @.str.1, i32 0, i32 0), i32 67), !dbg !30
  call void @llvm.dbg.declare(metadata double* %5, metadata !33, metadata !DIExpression()), !dbg !34
  %8 = bitcast double* %5 to i8*, !dbg !30
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([57 x i8], [57 x i8]* @.str.1, i32 0, i32 0), i32 67), !dbg !30
  %9 = load double, double* %2, align 8, !dbg !35
  store double %9, double* %3, align 8, !dbg !36
  %10 = call double @get_b(), !dbg !37
  store double %10, double* %4, align 8, !dbg !38
  %11 = load double, double* %3, align 8, !dbg !39
  %12 = load double, double* %4, align 8, !dbg !40
  %13 = call double @calc_ewma(double %11, double %12), !dbg !41
  store double %13, double* %5, align 8, !dbg !42
  %14 = load double, double* %5, align 8, !dbg !43
  ret double %14, !dbg !44
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !18 {
  %1 = load double, double* @get_b.b, align 8, !dbg !45
  %2 = load double, double* @get_b.b, align 8, !dbg !46
  %3 = fadd double %2, %1, !dbg !46
  store double %3, double* @get_b.b, align 8, !dbg !46
  %4 = load double, double* @get_b.b, align 8, !dbg !47
  ret double %4, !dbg !48
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double %0, double %1) #0 !dbg !13 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !49, metadata !DIExpression()), !dbg !50
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !51, metadata !DIExpression()), !dbg !52
  call void @llvm.dbg.declare(metadata double* %5, metadata !53, metadata !DIExpression()), !dbg !55
  store double 2.500000e-01, double* %5, align 8, !dbg !55
  %6 = load double, double* %3, align 8, !dbg !56
  %7 = load double, double* %4, align 8, !dbg !57
  %8 = fadd double %6, %7, !dbg !58
  %9 = fmul double 2.500000e-01, %8, !dbg !59
  %10 = load double, double* @calc_ewma.c, align 8, !dbg !60
  %11 = fmul double 7.500000e-01, %10, !dbg !61
  %12 = fadd double %9, %11, !dbg !62
  store double %12, double* @calc_ewma.c, align 8, !dbg !63
  %13 = load double, double* @calc_ewma.c, align 8, !dbg !64
  ret double %13, !dbg !65
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !2 {
  %1 = load double, double* @get_a.a, align 8, !dbg !66
  %2 = fadd double %1, 1.000000e+00, !dbg !66
  store double %2, double* @get_a.a, align 8, !dbg !66
  %3 = load double, double* @get_a.a, align 8, !dbg !67
  ret double %3, !dbg !68
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !69 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !73, metadata !DIExpression()), !dbg !74
  call void @llvm.dbg.declare(metadata double* %2, metadata !75, metadata !DIExpression()), !dbg !76
  call void @llvm.dbg.declare(metadata double* %3, metadata !77, metadata !DIExpression()), !dbg !78
  %5 = bitcast double* %3 to i8*, !dbg !79
  call void @llvm.var.annotation(i8* %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([57 x i8], [57 x i8]* @.str.1, i32 0, i32 0), i32 81), !dbg !79
  call void @llvm.dbg.declare(metadata i32* %4, metadata !80, metadata !DIExpression()), !dbg !82
  store i32 0, i32* %4, align 4, !dbg !82
  br label %6, !dbg !83

6:                                                ; preds = %15, %0
  %7 = load i32, i32* %4, align 4, !dbg !84
  %8 = icmp slt i32 %7, 10, !dbg !86
  br i1 %8, label %9, label %18, !dbg !87

9:                                                ; preds = %6
  %10 = call double @get_a(), !dbg !88
  store double %10, double* %1, align 8, !dbg !90
  %11 = load double, double* %1, align 8, !dbg !91
  %12 = call double @get_ewma(double %11), !dbg !92
  store double %12, double* %3, align 8, !dbg !93
  %13 = load double, double* %3, align 8, !dbg !94
  %14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i64 0, i64 0), double %13), !dbg !95
  br label %15, !dbg !96

15:                                               ; preds = %9
  %16 = load i32, i32* %4, align 4, !dbg !97
  %17 = add nsw i32 %16, 1, !dbg !97
  store i32 %17, i32* %4, align 4, !dbg !97
  br label %6, !dbg !98, !llvm.loop !99

18:                                               ; preds = %6
  ret i32 0, !dbg !101
}

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 !dbg !102 {
  %1 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  %2 = call i32 @ewma_main(), !dbg !103
  ret i32 %2, !dbg !104
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.ident = !{!19}
!llvm.module.flags = !{!20, !21, !22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 43, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 40, type: !4, scopeLine: 40, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!3 = !DIFile(filename: "example2.c", directory: "/workspaces/build/apps/examples/example2/temp")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !9, globals: !10, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "/workspaces/build/apps/examples/example2/temp/example2.c", directory: "/workspaces/build/apps/examples/example2/temp")
!9 = !{}
!10 = !{!11, !0, !16}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "c", scope: !13, file: !3, line: 35, type: !6, isLocal: true, isDefinition: true)
!13 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 33, type: !14, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!14 = !DISubroutineType(types: !15)
!15 = !{!6, !6, !6}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "b", scope: !18, file: !3, line: 53, type: !6, isLocal: true, isDefinition: true)
!18 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 50, type: !4, scopeLine: 50, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!19 = !{!"clang version 10.0.0-4ubuntu1 "}
!20 = !{i32 7, !"Dwarf Version", i32 4}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 4}
!23 = distinct !DISubprogram(name: "get_ewma", scope: !3, file: !3, line: 62, type: !24, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!24 = !DISubroutineType(types: !25)
!25 = !{!6, !6}
!26 = !DILocalVariable(name: "x", arg: 1, scope: !23, file: !3, line: 62, type: !6)
!27 = !DILocation(line: 62, column: 24, scope: !23)
!28 = !DILocalVariable(name: "x1", scope: !23, file: !3, line: 67, type: !6)
!29 = !DILocation(line: 67, column: 10, scope: !23)
!30 = !DILocation(line: 67, column: 3, scope: !23)
!31 = !DILocalVariable(name: "y1", scope: !23, file: !3, line: 67, type: !6)
!32 = !DILocation(line: 67, column: 14, scope: !23)
!33 = !DILocalVariable(name: "z1", scope: !23, file: !3, line: 67, type: !6)
!34 = !DILocation(line: 67, column: 18, scope: !23)
!35 = !DILocation(line: 70, column: 8, scope: !23)
!36 = !DILocation(line: 70, column: 6, scope: !23)
!37 = !DILocation(line: 71, column: 8, scope: !23)
!38 = !DILocation(line: 71, column: 6, scope: !23)
!39 = !DILocation(line: 72, column: 18, scope: !23)
!40 = !DILocation(line: 72, column: 22, scope: !23)
!41 = !DILocation(line: 72, column: 8, scope: !23)
!42 = !DILocation(line: 72, column: 6, scope: !23)
!43 = !DILocation(line: 73, column: 10, scope: !23)
!44 = !DILocation(line: 73, column: 3, scope: !23)
!45 = !DILocation(line: 56, column: 8, scope: !18)
!46 = !DILocation(line: 56, column: 5, scope: !18)
!47 = !DILocation(line: 57, column: 10, scope: !18)
!48 = !DILocation(line: 57, column: 3, scope: !18)
!49 = !DILocalVariable(name: "a", arg: 1, scope: !13, file: !3, line: 33, type: !6)
!50 = !DILocation(line: 33, column: 25, scope: !13)
!51 = !DILocalVariable(name: "b", arg: 2, scope: !13, file: !3, line: 33, type: !6)
!52 = !DILocation(line: 33, column: 35, scope: !13)
!53 = !DILocalVariable(name: "alpha", scope: !13, file: !3, line: 34, type: !54)
!54 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!55 = !DILocation(line: 34, column: 17, scope: !13)
!56 = !DILocation(line: 36, column: 16, scope: !13)
!57 = !DILocation(line: 36, column: 20, scope: !13)
!58 = !DILocation(line: 36, column: 18, scope: !13)
!59 = !DILocation(line: 36, column: 13, scope: !13)
!60 = !DILocation(line: 36, column: 39, scope: !13)
!61 = !DILocation(line: 36, column: 37, scope: !13)
!62 = !DILocation(line: 36, column: 23, scope: !13)
!63 = !DILocation(line: 36, column: 5, scope: !13)
!64 = !DILocation(line: 37, column: 10, scope: !13)
!65 = !DILocation(line: 37, column: 3, scope: !13)
!66 = !DILocation(line: 46, column: 5, scope: !2)
!67 = !DILocation(line: 47, column: 10, scope: !2)
!68 = !DILocation(line: 47, column: 3, scope: !2)
!69 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 76, type: !70, scopeLine: 76, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!70 = !DISubroutineType(types: !71)
!71 = !{!72}
!72 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!73 = !DILocalVariable(name: "x", scope: !69, file: !3, line: 77, type: !6)
!74 = !DILocation(line: 77, column: 10, scope: !69)
!75 = !DILocalVariable(name: "y", scope: !69, file: !3, line: 78, type: !6)
!76 = !DILocation(line: 78, column: 10, scope: !69)
!77 = !DILocalVariable(name: "ewma", scope: !69, file: !3, line: 81, type: !6)
!78 = !DILocation(line: 81, column: 10, scope: !69)
!79 = !DILocation(line: 81, column: 3, scope: !69)
!80 = !DILocalVariable(name: "i", scope: !81, file: !3, line: 84, type: !72)
!81 = distinct !DILexicalBlock(scope: !69, file: !3, line: 84, column: 3)
!82 = !DILocation(line: 84, column: 12, scope: !81)
!83 = !DILocation(line: 84, column: 8, scope: !81)
!84 = !DILocation(line: 84, column: 17, scope: !85)
!85 = distinct !DILexicalBlock(scope: !81, file: !3, line: 84, column: 3)
!86 = !DILocation(line: 84, column: 19, scope: !85)
!87 = !DILocation(line: 84, column: 3, scope: !81)
!88 = !DILocation(line: 85, column: 9, scope: !89)
!89 = distinct !DILexicalBlock(scope: !85, file: !3, line: 84, column: 30)
!90 = !DILocation(line: 85, column: 7, scope: !89)
!91 = !DILocation(line: 86, column: 21, scope: !89)
!92 = !DILocation(line: 86, column: 12, scope: !89)
!93 = !DILocation(line: 86, column: 10, scope: !89)
!94 = !DILocation(line: 87, column: 20, scope: !89)
!95 = !DILocation(line: 87, column: 5, scope: !89)
!96 = !DILocation(line: 88, column: 3, scope: !89)
!97 = !DILocation(line: 84, column: 26, scope: !85)
!98 = !DILocation(line: 84, column: 3, scope: !85)
!99 = distinct !{!99, !87, !100}
!100 = !DILocation(line: 88, column: 3, scope: !81)
!101 = !DILocation(line: 89, column: 3, scope: !69)
!102 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 92, type: !70, scopeLine: 92, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!103 = !DILocation(line: 93, column: 10, scope: !102)
!104 = !DILocation(line: 93, column: 3, scope: !102)
