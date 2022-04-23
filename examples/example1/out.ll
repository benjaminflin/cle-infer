; ModuleID = 'examples/example1/out.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@llvm.global.annotations = appending global [4 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([58 x i8], [58 x i8]* @.str.1, i32 0, i32 0), i32 56 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double ()* @get_a to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([58 x i8], [58 x i8]* @.str.1, i32 0, i32 0), i32 51 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_b.b to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([58 x i8], [58 x i8]* @.str.1, i32 0, i32 0), i32 65 }, { i8*, i8*, i8*, i32 } { i8* bitcast (i32 ()* @ewma_main to i8*), i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.5, i32 0, i32 0), i8* getelementptr inbounds ([58 x i8], [58 x i8]* @.str.1, i32 0, i32 0), i32 74 }], section "llvm.metadata"
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [58 x i8] c"/workspaces/build/apps/examples/example1/temp2/example1.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@get_b.b = internal global double 1.000000e+00, align 8, !dbg !16
@.str.3 = private unnamed_addr constant [7 x i8] c"PURPLE\00", section "llvm.metadata"
@.str.5 = private unnamed_addr constant [10 x i8] c"EWMA_MAIN\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1
@calc_ewma.c = internal global double 0.000000e+00, align 8, !dbg !11

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !2 {
  %1 = load double, double* @get_a.a, align 8, !dbg !23
  %2 = fadd double %1, 1.000000e+00, !dbg !23
  store double %2, double* @get_a.a, align 8, !dbg !23
  %3 = load double, double* @get_a.a, align 8, !dbg !24
  ret double %3, !dbg !25
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @ewma_main() #0 !dbg !26 {
  %1 = alloca double, align 8
  %2 = alloca double, align 8
  %3 = alloca double, align 8
  %4 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata double* %1, metadata !30, metadata !DIExpression()), !dbg !31
  call void @llvm.dbg.declare(metadata double* %2, metadata !32, metadata !DIExpression()), !dbg !33
  call void @llvm.dbg.declare(metadata double* %3, metadata !34, metadata !DIExpression()), !dbg !35
  %5 = bitcast double* %3 to i8*, !dbg !36
  call void @llvm.var.annotation(i8* %5, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0), i8* getelementptr inbounds ([58 x i8], [58 x i8]* @.str.1, i32 0, i32 0), i32 81), !dbg !36
  call void @llvm.dbg.declare(metadata i32* %4, metadata !37, metadata !DIExpression()), !dbg !39
  store i32 0, i32* %4, align 4, !dbg !39
  br label %6, !dbg !40

6:                                                ; preds = %17, %0
  %7 = load i32, i32* %4, align 4, !dbg !41
  %8 = icmp slt i32 %7, 10, !dbg !43
  br i1 %8, label %9, label %20, !dbg !44

9:                                                ; preds = %6
  %10 = call double @get_a(), !dbg !45
  store double %10, double* %1, align 8, !dbg !47
  %11 = call double @get_b(), !dbg !48
  store double %11, double* %2, align 8, !dbg !49
  %12 = load double, double* %1, align 8, !dbg !50
  %13 = load double, double* %2, align 8, !dbg !51
  %14 = call double @calc_ewma(double %12, double %13), !dbg !52
  store double %14, double* %3, align 8, !dbg !53
  %15 = load double, double* %3, align 8, !dbg !54
  %16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i64 0, i64 0), double %15), !dbg !55
  br label %17, !dbg !56

17:                                               ; preds = %9
  %18 = load i32, i32* %4, align 4, !dbg !57
  %19 = add nsw i32 %18, 1, !dbg !57
  store i32 %19, i32* %4, align 4, !dbg !57
  br label %6, !dbg !58, !llvm.loop !59

20:                                               ; preds = %6
  ret i32 0, !dbg !61
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_b() #0 !dbg !18 {
  %1 = load double, double* @get_b.b, align 8, !dbg !62
  %2 = load double, double* @get_b.b, align 8, !dbg !63
  %3 = fadd double %2, %1, !dbg !63
  store double %3, double* @get_b.b, align 8, !dbg !63
  %4 = load double, double* @get_b.b, align 8, !dbg !64
  ret double %4, !dbg !65
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @calc_ewma(double %0, double %1) #0 !dbg !13 {
  %3 = alloca double, align 8
  %4 = alloca double, align 8
  %5 = alloca double, align 8
  store double %0, double* %3, align 8
  call void @llvm.dbg.declare(metadata double* %3, metadata !66, metadata !DIExpression()), !dbg !67
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !68, metadata !DIExpression()), !dbg !69
  call void @llvm.dbg.declare(metadata double* %5, metadata !70, metadata !DIExpression()), !dbg !72
  store double 2.500000e-01, double* %5, align 8, !dbg !72
  %6 = load double, double* %3, align 8, !dbg !73
  %7 = load double, double* %4, align 8, !dbg !74
  %8 = fadd double %6, %7, !dbg !75
  %9 = fmul double 2.500000e-01, %8, !dbg !76
  %10 = load double, double* @calc_ewma.c, align 8, !dbg !77
  %11 = fmul double 7.500000e-01, %10, !dbg !78
  %12 = fadd double %9, %11, !dbg !79
  store double %12, double* @calc_ewma.c, align 8, !dbg !80
  %13 = load double, double* @calc_ewma.c, align 8, !dbg !81
  ret double %13, !dbg !82
}

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !83 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !89, metadata !DIExpression()), !dbg !90
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !91, metadata !DIExpression()), !dbg !92
  %6 = call i32 @ewma_main(), !dbg !93
  ret i32 %6, !dbg !94
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { nounwind willreturn }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!7}
!llvm.ident = !{!19}
!llvm.module.flags = !{!20, !21, !22}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 56, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 51, type: !4, scopeLine: 51, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!3 = !DIFile(filename: "example1.c", directory: "/workspaces/build/apps/examples/example1/temp2")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !9, globals: !10, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "/workspaces/build/apps/examples/example1/temp2/example1.c", directory: "/workspaces/build/apps/examples/example1/temp2")
!9 = !{}
!10 = !{!11, !0, !16}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "c", scope: !13, file: !3, line: 45, type: !6, isLocal: true, isDefinition: true)
!13 = distinct !DISubprogram(name: "calc_ewma", scope: !3, file: !3, line: 43, type: !14, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!14 = !DISubroutineType(types: !15)
!15 = !{!6, !6, !6}
!16 = !DIGlobalVariableExpression(var: !17, expr: !DIExpression())
!17 = distinct !DIGlobalVariable(name: "b", scope: !18, file: !3, line: 65, type: !6, isLocal: true, isDefinition: true)
!18 = distinct !DISubprogram(name: "get_b", scope: !3, file: !3, line: 62, type: !4, scopeLine: 62, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!19 = !{!"clang version 10.0.0-4ubuntu1 "}
!20 = !{i32 7, !"Dwarf Version", i32 4}
!21 = !{i32 2, !"Debug Info Version", i32 3}
!22 = !{i32 1, !"wchar_size", i32 4}
!23 = !DILocation(line: 59, column: 5, scope: !2)
!24 = !DILocation(line: 60, column: 10, scope: !2)
!25 = !DILocation(line: 60, column: 3, scope: !2)
!26 = distinct !DISubprogram(name: "ewma_main", scope: !3, file: !3, line: 74, type: !27, scopeLine: 74, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!27 = !DISubroutineType(types: !28)
!28 = !{!29}
!29 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!30 = !DILocalVariable(name: "x", scope: !26, file: !3, line: 77, type: !6)
!31 = !DILocation(line: 77, column: 10, scope: !26)
!32 = !DILocalVariable(name: "y", scope: !26, file: !3, line: 78, type: !6)
!33 = !DILocation(line: 78, column: 10, scope: !26)
!34 = !DILocalVariable(name: "ewma", scope: !26, file: !3, line: 81, type: !6)
!35 = !DILocation(line: 81, column: 10, scope: !26)
!36 = !DILocation(line: 81, column: 3, scope: !26)
!37 = !DILocalVariable(name: "i", scope: !38, file: !3, line: 84, type: !29)
!38 = distinct !DILexicalBlock(scope: !26, file: !3, line: 84, column: 3)
!39 = !DILocation(line: 84, column: 12, scope: !38)
!40 = !DILocation(line: 84, column: 8, scope: !38)
!41 = !DILocation(line: 84, column: 17, scope: !42)
!42 = distinct !DILexicalBlock(scope: !38, file: !3, line: 84, column: 3)
!43 = !DILocation(line: 84, column: 19, scope: !42)
!44 = !DILocation(line: 84, column: 3, scope: !38)
!45 = !DILocation(line: 85, column: 9, scope: !46)
!46 = distinct !DILexicalBlock(scope: !42, file: !3, line: 84, column: 30)
!47 = !DILocation(line: 85, column: 7, scope: !46)
!48 = !DILocation(line: 86, column: 9, scope: !46)
!49 = !DILocation(line: 86, column: 7, scope: !46)
!50 = !DILocation(line: 87, column: 22, scope: !46)
!51 = !DILocation(line: 87, column: 24, scope: !46)
!52 = !DILocation(line: 87, column: 12, scope: !46)
!53 = !DILocation(line: 87, column: 10, scope: !46)
!54 = !DILocation(line: 88, column: 20, scope: !46)
!55 = !DILocation(line: 88, column: 5, scope: !46)
!56 = !DILocation(line: 89, column: 3, scope: !46)
!57 = !DILocation(line: 84, column: 26, scope: !42)
!58 = !DILocation(line: 84, column: 3, scope: !42)
!59 = distinct !{!59, !44, !60}
!60 = !DILocation(line: 89, column: 3, scope: !38)
!61 = !DILocation(line: 90, column: 3, scope: !26)
!62 = !DILocation(line: 68, column: 8, scope: !18)
!63 = !DILocation(line: 68, column: 5, scope: !18)
!64 = !DILocation(line: 69, column: 10, scope: !18)
!65 = !DILocation(line: 69, column: 3, scope: !18)
!66 = !DILocalVariable(name: "a", arg: 1, scope: !13, file: !3, line: 43, type: !6)
!67 = !DILocation(line: 43, column: 25, scope: !13)
!68 = !DILocalVariable(name: "b", arg: 2, scope: !13, file: !3, line: 43, type: !6)
!69 = !DILocation(line: 43, column: 35, scope: !13)
!70 = !DILocalVariable(name: "alpha", scope: !13, file: !3, line: 44, type: !71)
!71 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !6)
!72 = !DILocation(line: 44, column: 17, scope: !13)
!73 = !DILocation(line: 46, column: 16, scope: !13)
!74 = !DILocation(line: 46, column: 20, scope: !13)
!75 = !DILocation(line: 46, column: 18, scope: !13)
!76 = !DILocation(line: 46, column: 13, scope: !13)
!77 = !DILocation(line: 46, column: 39, scope: !13)
!78 = !DILocation(line: 46, column: 37, scope: !13)
!79 = !DILocation(line: 46, column: 23, scope: !13)
!80 = !DILocation(line: 46, column: 5, scope: !13)
!81 = !DILocation(line: 47, column: 10, scope: !13)
!82 = !DILocation(line: 47, column: 3, scope: !13)
!83 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 92, type: !84, scopeLine: 92, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!84 = !DISubroutineType(types: !85)
!85 = !{!29, !29, !86}
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !87, size: 64)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!89 = !DILocalVariable(name: "argc", arg: 1, scope: !83, file: !3, line: 92, type: !29)
!90 = !DILocation(line: 92, column: 14, scope: !83)
!91 = !DILocalVariable(name: "argv", arg: 2, scope: !83, file: !3, line: 92, type: !86)
!92 = !DILocation(line: 92, column: 27, scope: !83)
!93 = !DILocation(line: 93, column: 10, scope: !83)
!94 = !DILocation(line: 93, column: 3, scope: !83)
