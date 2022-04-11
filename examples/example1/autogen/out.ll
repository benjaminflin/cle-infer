; ModuleID = 'examples/example1/autogen/out.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque
%struct._tag = type { i32, i32, i32 }
%struct._request_get_a_datatype = type { i32, %struct._trailer_datatype }
%struct._trailer_datatype = type { i32, i32, i32, i16, i16 }
%struct._response_get_a_datatype = type { double, %struct._trailer_datatype }
%struct._codec_map = type { i32, void (i8*, i8*, i64*)*, void (i8*, i8*, i64*)* }
%union.pthread_attr_t = type { i64, [48 x i8] }

@llvm.global.annotations = appending global [3 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @get_a.a to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([62 x i8], [62 x i8]* @.str.1, i32 0, i32 0), i32 37 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double ()* @get_a to i8*), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([62 x i8], [62 x i8]* @.str.1, i32 0, i32 0), i32 30 }, { i8*, i8*, i8*, i32 } { i8* bitcast (void ()* @_handle_request_get_a to i8*), i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.12, i32 0, i32 0), i8* getelementptr inbounds ([64 x i8], [64 x i8]* @.str.5, i32 0, i32 0), i32 29 }], section "llvm.metadata"
@get_a.a = internal global double 0.000000e+00, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"ORANGE\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [62 x i8] c"/home/bflin/gaps/build/apps/examples/example1/temp/example1.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [16 x i8] c"XDLINKAGE_GET_A\00", section "llvm.metadata"
@.str.12 = private unnamed_addr constant [21 x i8] c"HANDLE_REQUEST_GET_A\00", section "llvm.metadata"
@.str.5 = private unnamed_addr constant [64 x i8] c"/home/bflin/gaps/build/apps/examples/example1/temp/orange_rpc.c\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [18 x i8] c"TAG_REQUEST_GET_A\00", section "llvm.metadata"
@.str.6 = private unnamed_addr constant [19 x i8] c"TAG_RESPONSE_GET_A\00", section "llvm.metadata"
@.str.7 = private unnamed_addr constant [26 x i8] c"ipc:///tmp/sock_puborange\00", align 1
@.str.8 = private unnamed_addr constant [26 x i8] c"ipc:///tmp/sock_suborange\00", align 1
@_handle_request_get_a.res_counter = internal global i32 0, align 4, !dbg !11
@_handle_request_get_a.last_processed_result = internal global double 0.000000e+00, align 8, !dbg !24
@_handle_request_get_a.last_processed_error = internal global i32 0, align 4, !dbg !26
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str.9 = private unnamed_addr constant [59 x i8] c"RESP get_a: ReqId=%d ResId=%d err=%d (seq=0x%x) Return=%f \00", align 1
@.str.10 = private unnamed_addr constant [27 x i8] c"t_tag=<%02u, %02u, %02u>, \00", align 1
@.str.11 = private unnamed_addr constant [26 x i8] c"o_tag=<%02u, %02u, %02u>\0A\00", align 1
@.str.3 = private unnamed_addr constant [19 x i8] c"orange RPC=2-way, \00", align 1
@.str.1.4 = private unnamed_addr constant [10 x i8] c"API=new, \00", align 1
@.str.2.5 = private unnamed_addr constant [12 x i8] c"THR=multi, \00", align 1
@.str.3.6 = private unnamed_addr constant [18 x i8] c"ARQ={n:5 t:1000)\0A\00", align 1

; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #3

declare dso_local void @request_get_a_data_encode(i8*, i8*, i64*) #2

declare dso_local void @request_get_a_data_decode(i8*, i8*, i64*) #2

declare dso_local void @my_xdc_register(void (i8*, i8*, i64*)*, void (i8*, i8*, i64*)*, i32, %struct._codec_map*) #2

declare dso_local void @response_get_a_data_encode(i8*, i8*, i64*) #2

declare dso_local void @response_get_a_data_decode(i8*, i8*, i64*) #2

declare dso_local i8* @zmq_ctx_new() #2

declare dso_local i8* @my_xdc_pub_socket(i8*, i8*) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

declare dso_local i8* @my_xdc_sub_socket(i64, i32, i8*, i8*) #2

declare dso_local i32 @sleep(i32) #2

declare dso_local void @my_xdc_blocking_recv(i8*, i8*, %struct._tag*, %struct._codec_map*) #2

declare dso_local void @my_xdc_asyn_send(i8*, i8*, %struct._tag*, %struct._codec_map*) #2

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

declare dso_local i32 @zmq_close(i8*) #2

declare dso_local i32 @zmq_ctx_shutdown(i8*) #2

declare dso_local void @my_tag_write(%struct._tag*, i32, i32, i32) #2

; Function Attrs: nounwind
declare !callback !272 dso_local i32 @pthread_create(i64*, %union.pthread_attr_t*, i8* (i8*)*, i8*) #5

declare dso_local i32 @pthread_join(i64, i8**) #2


; Function Attrs: noinline nounwind optnone uwtable
define dso_local double @get_a() #0 !dbg !2 {
  %1 = load double, double* @get_a.a, align 8, !dbg !35
  %2 = fadd double %1, 1.000000e+00, !dbg !35
  store double %2, double* @get_a.a, align 8, !dbg !35
  %3 = load double, double* @get_a.a, align 8, !dbg !36
  ret double %3, !dbg !37
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_handle_request_get_a() #0 !dbg !13 {
  %1 = alloca %struct._tag, align 4
  %2 = alloca %struct._tag, align 4
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca %struct._request_get_a_datatype, align 1
  %6 = alloca %struct._response_get_a_datatype, align 1
  %7 = alloca [200 x %struct._codec_map], align 16
  %8 = alloca i32, align 4
  %9 = alloca i8*, align 8
  %10 = alloca { i64, i32 }, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  call void @llvm.dbg.declare(metadata %struct._tag* %1, metadata !48, metadata !DIExpression()), !dbg !61
  call void @llvm.dbg.declare(metadata %struct._tag* %2, metadata !62, metadata !DIExpression()), !dbg !63
  call void @my_tag_write(%struct._tag* %1, i32 2, i32 2, i32 3), !dbg !64
  call void @my_tag_write(%struct._tag* %2, i32 1, i32 1, i32 4), !dbg !65
  call void @llvm.dbg.declare(metadata i8** %3, metadata !66, metadata !DIExpression()), !dbg !67
  call void @llvm.dbg.declare(metadata i8** %4, metadata !68, metadata !DIExpression()), !dbg !69
  call void @llvm.dbg.declare(metadata %struct._request_get_a_datatype* %5, metadata !70, metadata !DIExpression()), !dbg !91
  %13 = bitcast %struct._request_get_a_datatype* %5 to i8*, !dbg !92
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([64 x i8], [64 x i8]* @.str.5, i32 0, i32 0), i32 59), !dbg !92
  call void @llvm.dbg.declare(metadata %struct._response_get_a_datatype* %6, metadata !93, metadata !DIExpression()), !dbg !99
  %14 = bitcast %struct._response_get_a_datatype* %6 to i8*, !dbg !100
  call void @llvm.var.annotation(i8* %14, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.6, i32 0, i32 0), i8* getelementptr inbounds ([64 x i8], [64 x i8]* @.str.5, i32 0, i32 0), i32 66), !dbg !100
  call void @llvm.dbg.declare(metadata [200 x %struct._codec_map]* %7, metadata !101, metadata !DIExpression()), !dbg !119
  call void @llvm.dbg.declare(metadata i32* %8, metadata !120, metadata !DIExpression()), !dbg !122
  store i32 0, i32* %8, align 4, !dbg !122
  br label %15, !dbg !123

15:                                               ; preds = %23, %0
  %16 = load i32, i32* %8, align 4, !dbg !124
  %17 = icmp slt i32 %16, 200, !dbg !126
  br i1 %17, label %18, label %26, !dbg !127

18:                                               ; preds = %15
  %19 = load i32, i32* %8, align 4, !dbg !128
  %20 = sext i32 %19 to i64, !dbg !129
  %21 = getelementptr inbounds [200 x %struct._codec_map], [200 x %struct._codec_map]* %7, i64 0, i64 %20, !dbg !129
  %22 = getelementptr inbounds %struct._codec_map, %struct._codec_map* %21, i32 0, i32 0, !dbg !130
  store i32 0, i32* %22, align 8, !dbg !131
  br label %23, !dbg !129

23:                                               ; preds = %18
  %24 = load i32, i32* %8, align 4, !dbg !132
  %25 = add nsw i32 %24, 1, !dbg !132
  store i32 %25, i32* %8, align 4, !dbg !132
  br label %15, !dbg !133, !llvm.loop !134

26:                                               ; preds = %15
  %27 = getelementptr inbounds [200 x %struct._codec_map], [200 x %struct._codec_map]* %7, i64 0, i64 0, !dbg !136
  call void @my_xdc_register(void (i8*, i8*, i64*)* @request_get_a_data_encode, void (i8*, i8*, i64*)* @request_get_a_data_decode, i32 3, %struct._codec_map* %27), !dbg !137
  %28 = getelementptr inbounds [200 x %struct._codec_map], [200 x %struct._codec_map]* %7, i64 0, i64 0, !dbg !138
  call void @my_xdc_register(void (i8*, i8*, i64*)* @response_get_a_data_encode, void (i8*, i8*, i64*)* @response_get_a_data_decode, i32 4, %struct._codec_map* %28), !dbg !139
  call void @llvm.dbg.declare(metadata i8** %9, metadata !140, metadata !DIExpression()), !dbg !141
  %29 = call i8* @zmq_ctx_new(), !dbg !142
  store i8* %29, i8** %9, align 8, !dbg !141
  %30 = load i8*, i8** %9, align 8, !dbg !143
  %31 = call i8* @my_xdc_pub_socket(i8* %30, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.7, i64 0, i64 0)), !dbg !144
  store i8* %31, i8** %3, align 8, !dbg !145
  %32 = load i8*, i8** %9, align 8, !dbg !146
  %33 = bitcast { i64, i32 }* %10 to i8*, !dbg !147
  %34 = bitcast %struct._tag* %1 to i8*, !dbg !147
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %33, i8* align 4 %34, i64 12, i1 false), !dbg !147
  %35 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %10, i32 0, i32 0, !dbg !147
  %36 = load i64, i64* %35, align 4, !dbg !147
  %37 = getelementptr inbounds { i64, i32 }, { i64, i32 }* %10, i32 0, i32 1, !dbg !147
  %38 = load i32, i32* %37, align 4, !dbg !147
  %39 = call i8* @my_xdc_sub_socket(i64 %36, i32 %38, i8* %32, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.8, i64 0, i64 0)), !dbg !147
  store i8* %39, i8** %4, align 8, !dbg !148
  %40 = call i32 @sleep(i32 1), !dbg !149
  call void @llvm.dbg.declare(metadata i32* %11, metadata !150, metadata !DIExpression()), !dbg !151
  store i32 1, i32* %11, align 4, !dbg !151
  br label %41, !dbg !152

41:                                               ; preds = %60, %26
  %42 = load i32, i32* %11, align 4, !dbg !153
  %43 = icmp eq i32 %42, 1, !dbg !154
  br i1 %43, label %44, label %94, !dbg !152

44:                                               ; preds = %41
  %45 = load i8*, i8** %4, align 8, !dbg !155
  %46 = bitcast %struct._request_get_a_datatype* %5 to i8*, !dbg !157
  %47 = getelementptr inbounds [200 x %struct._codec_map], [200 x %struct._codec_map]* %7, i64 0, i64 0, !dbg !158
  call void @my_xdc_blocking_recv(i8* %45, i8* %46, %struct._tag* %1, %struct._codec_map* %47), !dbg !159
  call void @llvm.dbg.declare(metadata i32* %12, metadata !160, metadata !DIExpression()), !dbg !161
  %48 = getelementptr inbounds %struct._request_get_a_datatype, %struct._request_get_a_datatype* %5, i32 0, i32 1, !dbg !162
  %49 = getelementptr inbounds %struct._trailer_datatype, %struct._trailer_datatype* %48, i32 0, i32 0, !dbg !163
  %50 = load i32, i32* %49, align 1, !dbg !163
  store i32 %50, i32* %12, align 4, !dbg !161
  %51 = load i32, i32* %12, align 4, !dbg !164
  %52 = load i32, i32* @_handle_request_get_a.res_counter, align 4, !dbg !166
  %53 = icmp sgt i32 %51, %52, !dbg !167
  br i1 %53, label %54, label %60, !dbg !168

54:                                               ; preds = %44
  store i32 0, i32* %11, align 4, !dbg !169
  %55 = load i32, i32* %12, align 4, !dbg !171
  store i32 %55, i32* @_handle_request_get_a.res_counter, align 4, !dbg !172
  %56 = call double (...) bitcast (double ()* @get_a to double (...)*)(), !dbg !173
  store double %56, double* @_handle_request_get_a.last_processed_result, align 8, !dbg !174
  %57 = load double, double* @_handle_request_get_a.last_processed_result, align 8, !dbg !175
  %58 = getelementptr inbounds %struct._response_get_a_datatype, %struct._response_get_a_datatype* %6, i32 0, i32 0, !dbg !176
  store double %57, double* %58, align 1, !dbg !177
  %59 = load i32, i32* %11, align 4, !dbg !178
  store i32 %59, i32* @_handle_request_get_a.last_processed_error, align 4, !dbg !179
  br label %60, !dbg !180

60:                                               ; preds = %54, %44
  %61 = load i32, i32* @_handle_request_get_a.res_counter, align 4, !dbg !181
  %62 = shl i32 %61, 2, !dbg !182
  %63 = load i32, i32* @_handle_request_get_a.last_processed_error, align 4, !dbg !183
  %64 = shl i32 %63, 1, !dbg !184
  %65 = or i32 %62, %64, !dbg !185
  %66 = getelementptr inbounds %struct._response_get_a_datatype, %struct._response_get_a_datatype* %6, i32 0, i32 1, !dbg !186
  %67 = getelementptr inbounds %struct._trailer_datatype, %struct._trailer_datatype* %66, i32 0, i32 0, !dbg !187
  store i32 %65, i32* %67, align 1, !dbg !188
  %68 = load i8*, i8** %3, align 8, !dbg !189
  %69 = bitcast %struct._response_get_a_datatype* %6 to i8*, !dbg !190
  %70 = getelementptr inbounds [200 x %struct._codec_map], [200 x %struct._codec_map]* %7, i64 0, i64 0, !dbg !191
  call void @my_xdc_asyn_send(i8* %68, i8* %69, %struct._tag* %2, %struct._codec_map* %70), !dbg !192
  %71 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !193
  %72 = load i32, i32* %12, align 4, !dbg !194
  %73 = load i32, i32* @_handle_request_get_a.res_counter, align 4, !dbg !195
  %74 = load i32, i32* %11, align 4, !dbg !196
  %75 = load i32, i32* @_handle_request_get_a.last_processed_error, align 4, !dbg !197
  %76 = load double, double* @_handle_request_get_a.last_processed_result, align 8, !dbg !198
  %77 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %71, i8* getelementptr inbounds ([59 x i8], [59 x i8]* @.str.9, i64 0, i64 0), i32 %72, i32 %73, i32 %74, i32 %75, double %76), !dbg !199
  %78 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !200
  %79 = getelementptr inbounds %struct._tag, %struct._tag* %1, i32 0, i32 0, !dbg !201
  %80 = load i32, i32* %79, align 4, !dbg !201
  %81 = getelementptr inbounds %struct._tag, %struct._tag* %1, i32 0, i32 1, !dbg !202
  %82 = load i32, i32* %81, align 4, !dbg !202
  %83 = getelementptr inbounds %struct._tag, %struct._tag* %1, i32 0, i32 2, !dbg !203
  %84 = load i32, i32* %83, align 4, !dbg !203
  %85 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %78, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.10, i64 0, i64 0), i32 %80, i32 %82, i32 %84), !dbg !204
  %86 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !205
  %87 = getelementptr inbounds %struct._tag, %struct._tag* %2, i32 0, i32 0, !dbg !206
  %88 = load i32, i32* %87, align 4, !dbg !206
  %89 = getelementptr inbounds %struct._tag, %struct._tag* %2, i32 0, i32 1, !dbg !207
  %90 = load i32, i32* %89, align 4, !dbg !207
  %91 = getelementptr inbounds %struct._tag, %struct._tag* %2, i32 0, i32 2, !dbg !208
  %92 = load i32, i32* %91, align 4, !dbg !208
  %93 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %86, i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.11, i64 0, i64 0), i32 %88, i32 %90, i32 %92), !dbg !209
  br label %41, !dbg !152, !llvm.loop !210

94:                                               ; preds = %41
  %95 = load i8*, i8** %3, align 8, !dbg !212
  %96 = call i32 @zmq_close(i8* %95), !dbg !213
  %97 = load i8*, i8** %4, align 8, !dbg !214
  %98 = call i32 @zmq_close(i8* %97), !dbg !215
  %99 = load i8*, i8** %9, align 8, !dbg !216
  %100 = call i32 @zmq_ctx_shutdown(i8* %99), !dbg !217
  ret void, !dbg !218
}




; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_hal_init(i8* %0, i8* %1) #0 !dbg !219 {
  %3 = alloca i8*, align 8
  %4 = alloca i8*, align 8
  store i8* %0, i8** %3, align 8
  call void @llvm.dbg.declare(metadata i8** %3, metadata !222, metadata !DIExpression()), !dbg !223
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !224, metadata !DIExpression()), !dbg !225
  %5 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !226
  %6 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %5, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.3, i64 0, i64 0)), !dbg !227
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !228
  %8 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.1.4, i64 0, i64 0)), !dbg !229
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !230
  %10 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.2.5, i64 0, i64 0)), !dbg !231
  %11 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !232
  %12 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %11, i8* getelementptr inbounds ([18 x i8], [18 x i8]* @.str.3.6, i64 0, i64 0)), !dbg !233
  ret void, !dbg !234
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i8* @_wrapper_request_get_a(i8* %0) #0 !dbg !235 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8
  call void @llvm.dbg.declare(metadata i8** %2, metadata !238, metadata !DIExpression()), !dbg !239
  br label %3, !dbg !239

3:                                                ; preds = %1, %3
  call void @_handle_request_get_a(), !dbg !240
  br label %3, !dbg !239, !llvm.loop !242
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_slave_rpc_loop() #0 !dbg !243 {
  %1 = alloca [1 x i64], align 8
  %2 = alloca i32, align 4
  call void @_hal_init(i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.8, i64 0, i64 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.7, i64 0, i64 0)), !dbg !246
  call void @llvm.dbg.declare(metadata [1 x i64]* %1, metadata !247, metadata !DIExpression()), !dbg !253
  %3 = getelementptr inbounds [1 x i64], [1 x i64]* %1, i64 0, i64 0, !dbg !254
  %4 = call i32 @pthread_create(i64* %3, %union.pthread_attr_t* null, i8* (i8*)* @_wrapper_request_get_a, i8* null) #6, !dbg !255
  call void @llvm.dbg.declare(metadata i32* %2, metadata !256, metadata !DIExpression()), !dbg !258
  store i32 0, i32* %2, align 4, !dbg !258
  br label %5, !dbg !259

5:                                                ; preds = %14, %0
  %6 = load i32, i32* %2, align 4, !dbg !260
  %7 = icmp slt i32 %6, 1, !dbg !262
  br i1 %7, label %8, label %17, !dbg !263

8:                                                ; preds = %5
  %9 = load i32, i32* %2, align 4, !dbg !264
  %10 = sext i32 %9 to i64, !dbg !265
  %11 = getelementptr inbounds [1 x i64], [1 x i64]* %1, i64 0, i64 %10, !dbg !265
  %12 = load i64, i64* %11, align 8, !dbg !265
  %13 = call i32 @pthread_join(i64 %12, i8** null), !dbg !266
  br label %14, !dbg !266

14:                                               ; preds = %8
  %15 = load i32, i32* %2, align 4, !dbg !267
  %16 = add nsw i32 %15, 1, !dbg !267
  store i32 %16, i32* %2, align 4, !dbg !267
  br label %5, !dbg !268, !llvm.loop !269

17:                                               ; preds = %5
  ret i32 0, !dbg !271
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !38 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !42, metadata !DIExpression()), !dbg !43
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !44, metadata !DIExpression()), !dbg !45
  %6 = call i32 (...) bitcast (i32 ()* @_slave_rpc_loop to i32 (...)*)(), !dbg !46
  ret i32 %6, !dbg !47
}



attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind willreturn }
attributes #4 = { argmemonly nounwind willreturn }
attributes #5 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!7, !17}
!llvm.ident = !{!31, !31}
!llvm.module.flags = !{!32, !33, !34}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !3, line: 37, type: !6, isLocal: true, isDefinition: true)
!2 = distinct !DISubprogram(name: "get_a", scope: !3, file: !3, line: 30, type: !4, scopeLine: 30, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!3 = !DIFile(filename: "example1.c", directory: "/home/bflin/gaps/build/apps/examples/example1/temp")
!4 = !DISubroutineType(types: !5)
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = distinct !DICompileUnit(language: DW_LANG_C99, file: !8, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !9, globals: !10, splitDebugInlining: false, nameTableKind: None)
!8 = !DIFile(filename: "/home/bflin/gaps/build/apps/examples/example1/temp/example1.c", directory: "/home/bflin/gaps/build/apps/examples/example1/temp")
!9 = !{}
!10 = !{!0}
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "res_counter", scope: !13, file: !14, line: 45, type: !28, isLocal: true, isDefinition: true)
!13 = distinct !DISubprogram(name: "_handle_request_get_a", scope: !14, file: !14, line: 29, type: !15, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !9)
!14 = !DIFile(filename: "orange_rpc.c", directory: "/home/bflin/gaps/build/apps/examples/example1/temp")
!15 = !DISubroutineType(types: !16)
!16 = !{null}
!17 = distinct !DICompileUnit(language: DW_LANG_C99, file: !18, producer: "clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !9, retainedTypes: !19, globals: !23, splitDebugInlining: false, nameTableKind: None)
!18 = !DIFile(filename: "/home/bflin/gaps/build/apps/examples/example1/temp/orange_rpc.c", directory: "/home/bflin/gaps/build/apps/examples/example1/temp")
!19 = !{!20, !22}
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!23 = !{!11, !24, !26, !29}
!24 = !DIGlobalVariableExpression(var: !25, expr: !DIExpression())
!25 = distinct !DIGlobalVariable(name: "last_processed_result", scope: !13, file: !14, line: 46, type: !6, isLocal: true, isDefinition: true)
!26 = !DIGlobalVariableExpression(var: !27, expr: !DIExpression())
!27 = distinct !DIGlobalVariable(name: "last_processed_error", scope: !13, file: !14, line: 47, type: !28, isLocal: true, isDefinition: true)
!28 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!29 = !DIGlobalVariableExpression(var: !30, expr: !DIExpression())
!30 = distinct !DIGlobalVariable(name: "inited", scope: !13, file: !14, line: 48, type: !28, isLocal: true, isDefinition: true)
!31 = !{!"clang version 10.0.1 (https://github.com/gaps-closure/llvm-project.git 4954dd8b02af91d5e8d4815824208b6004f667a8)"}
!32 = !{i32 7, !"Dwarf Version", i32 4}
!33 = !{i32 2, !"Debug Info Version", i32 3}
!34 = !{i32 1, !"wchar_size", i32 4}
!35 = !DILocation(line: 41, column: 5, scope: !2)
!36 = !DILocation(line: 42, column: 10, scope: !2)
!37 = !DILocation(line: 42, column: 3, scope: !2)
!38 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 44, type: !39, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !7, retainedNodes: !9)
!39 = !DISubroutineType(types: !40)
!40 = !{!28, !28, !41}
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!42 = !DILocalVariable(name: "argc", arg: 1, scope: !38, file: !3, line: 44, type: !28)
!43 = !DILocation(line: 44, column: 14, scope: !38)
!44 = !DILocalVariable(name: "argv", arg: 2, scope: !38, file: !3, line: 44, type: !41)
!45 = !DILocation(line: 44, column: 26, scope: !38)
!46 = !DILocation(line: 45, column: 10, scope: !38)
!47 = !DILocation(line: 45, column: 3, scope: !38)
!48 = !DILocalVariable(name: "t_tag", scope: !13, file: !14, line: 33, type: !49)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "gaps_tag", file: !50, line: 25, baseType: !51)
!50 = !DIFile(filename: "partitioned/multithreaded/orange/myxdcomms.h", directory: "/home/bflin/gaps/build/apps/examples/example1")
!51 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_tag", file: !50, line: 21, size: 96, elements: !52)
!52 = !{!53, !59, !60}
!53 = !DIDerivedType(tag: DW_TAG_member, name: "mux", scope: !51, file: !50, line: 22, baseType: !54, size: 32)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !55, line: 26, baseType: !56)
!55 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !57, line: 42, baseType: !58)
!57 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!58 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "sec", scope: !51, file: !50, line: 23, baseType: !54, size: 32, offset: 32)
!60 = !DIDerivedType(tag: DW_TAG_member, name: "typ", scope: !51, file: !50, line: 24, baseType: !54, size: 32, offset: 64)
!61 = !DILocation(line: 33, column: 14, scope: !13)
!62 = !DILocalVariable(name: "o_tag", scope: !13, file: !14, line: 34, type: !49)
!63 = !DILocation(line: 34, column: 14, scope: !13)
!64 = !DILocation(line: 36, column: 5, scope: !13)
!65 = !DILocation(line: 41, column: 5, scope: !13)
!66 = !DILocalVariable(name: "psocket", scope: !13, file: !14, line: 50, type: !22)
!67 = !DILocation(line: 50, column: 11, scope: !13)
!68 = !DILocalVariable(name: "ssocket", scope: !13, file: !14, line: 51, type: !22)
!69 = !DILocation(line: 51, column: 11, scope: !13)
!70 = !DILocalVariable(name: "request_get_a", scope: !13, file: !14, line: 59, type: !71)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "request_get_a_datatype", file: !72, line: 75, baseType: !73)
!72 = !DIFile(filename: "partitioned/multithreaded/autogen/codec.h", directory: "/home/bflin/gaps/build/apps/examples/example1")
!73 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_request_get_a_datatype", file: !72, line: 72, size: 160, elements: !74)
!74 = !{!75, !79}
!75 = !DIDerivedType(tag: DW_TAG_member, name: "dummy", scope: !73, file: !72, line: 73, baseType: !76, size: 32)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !77, line: 26, baseType: !78)
!77 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !57, line: 41, baseType: !28)
!79 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !73, file: !72, line: 74, baseType: !80, size: 128, offset: 32)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "trailer_datatype", file: !72, line: 28, baseType: !81)
!81 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_trailer_datatype", file: !72, line: 22, size: 128, elements: !82)
!82 = !{!83, !84, !85, !86, !90}
!83 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !81, file: !72, line: 23, baseType: !54, size: 32)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "rqr", scope: !81, file: !72, line: 24, baseType: !54, size: 32, offset: 32)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "oid", scope: !81, file: !72, line: 25, baseType: !54, size: 32, offset: 64)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "mid", scope: !81, file: !72, line: 26, baseType: !87, size: 16, offset: 96)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !55, line: 25, baseType: !88)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !57, line: 40, baseType: !89)
!89 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!90 = !DIDerivedType(tag: DW_TAG_member, name: "crc", scope: !81, file: !72, line: 27, baseType: !87, size: 16, offset: 112)
!91 = !DILocation(line: 59, column: 28, scope: !13)
!92 = !DILocation(line: 59, column: 5, scope: !13)
!93 = !DILocalVariable(name: "response_get_a", scope: !13, file: !14, line: 66, type: !94)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "response_get_a_datatype", file: !72, line: 89, baseType: !95)
!95 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_response_get_a_datatype", file: !72, line: 86, size: 192, elements: !96)
!96 = !{!97, !98}
!97 = !DIDerivedType(tag: DW_TAG_member, name: "ret", scope: !95, file: !72, line: 87, baseType: !6, size: 64)
!98 = !DIDerivedType(tag: DW_TAG_member, name: "trailer", scope: !95, file: !72, line: 88, baseType: !80, size: 128, offset: 64)
!99 = !DILocation(line: 66, column: 29, scope: !13)
!100 = !DILocation(line: 66, column: 5, scope: !13)
!101 = !DILocalVariable(name: "mycmap", scope: !13, file: !14, line: 71, type: !102)
!102 = !DICompositeType(tag: DW_TAG_array_type, baseType: !103, size: 38400, elements: !117)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "codec_map", file: !50, line: 39, baseType: !104)
!104 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_codec_map", file: !50, line: 35, size: 192, elements: !105)
!105 = !{!106, !107, !116}
!106 = !DIDerivedType(tag: DW_TAG_member, name: "valid", scope: !104, file: !50, line: 36, baseType: !28, size: 32)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "encode", scope: !104, file: !50, line: 37, baseType: !108, size: 64, offset: 64)
!108 = !DIDerivedType(tag: DW_TAG_typedef, name: "codec_func_ptr", file: !50, line: 34, baseType: !109)
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !110, size: 64)
!110 = !DISubroutineType(types: !111)
!111 = !{null, !22, !22, !112}
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !114, line: 46, baseType: !115)
!114 = !DIFile(filename: "/usr/local/lib/clang/10.0.1/include/stddef.h", directory: "")
!115 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "decode", scope: !104, file: !50, line: 38, baseType: !108, size: 64, offset: 128)
!117 = !{!118}
!118 = !DISubrange(count: 200)
!119 = !DILocation(line: 71, column: 16, scope: !13)
!120 = !DILocalVariable(name: "i", scope: !121, file: !14, line: 72, type: !28)
!121 = distinct !DILexicalBlock(scope: !13, file: !14, line: 72, column: 5)
!122 = !DILocation(line: 72, column: 14, scope: !121)
!123 = !DILocation(line: 72, column: 10, scope: !121)
!124 = !DILocation(line: 72, column: 19, scope: !125)
!125 = distinct !DILexicalBlock(scope: !121, file: !14, line: 72, column: 5)
!126 = !DILocation(line: 72, column: 21, scope: !125)
!127 = !DILocation(line: 72, column: 5, scope: !121)
!128 = !DILocation(line: 72, column: 53, scope: !125)
!129 = !DILocation(line: 72, column: 46, scope: !125)
!130 = !DILocation(line: 72, column: 56, scope: !125)
!131 = !DILocation(line: 72, column: 61, scope: !125)
!132 = !DILocation(line: 72, column: 41, scope: !125)
!133 = !DILocation(line: 72, column: 5, scope: !125)
!134 = distinct !{!134, !127, !135}
!135 = !DILocation(line: 72, column: 62, scope: !121)
!136 = !DILocation(line: 73, column: 99, scope: !13)
!137 = !DILocation(line: 73, column: 5, scope: !13)
!138 = !DILocation(line: 74, column: 102, scope: !13)
!139 = !DILocation(line: 74, column: 5, scope: !13)
!140 = !DILocalVariable(name: "ctx", scope: !13, file: !14, line: 77, type: !22)
!141 = !DILocation(line: 77, column: 12, scope: !13)
!142 = !DILocation(line: 77, column: 18, scope: !13)
!143 = !DILocation(line: 78, column: 33, scope: !13)
!144 = !DILocation(line: 78, column: 15, scope: !13)
!145 = !DILocation(line: 78, column: 13, scope: !13)
!146 = !DILocation(line: 79, column: 40, scope: !13)
!147 = !DILocation(line: 79, column: 15, scope: !13)
!148 = !DILocation(line: 79, column: 13, scope: !13)
!149 = !DILocation(line: 80, column: 5, scope: !13)
!150 = !DILocalVariable(name: "proc_error", scope: !13, file: !14, line: 90, type: !28)
!151 = !DILocation(line: 90, column: 9, scope: !13)
!152 = !DILocation(line: 91, column: 5, scope: !13)
!153 = !DILocation(line: 91, column: 12, scope: !13)
!154 = !DILocation(line: 91, column: 23, scope: !13)
!155 = !DILocation(line: 92, column: 30, scope: !156)
!156 = distinct !DILexicalBlock(scope: !13, file: !14, line: 91, column: 29)
!157 = !DILocation(line: 92, column: 39, scope: !156)
!158 = !DILocation(line: 92, column: 63, scope: !156)
!159 = !DILocation(line: 92, column: 9, scope: !156)
!160 = !DILocalVariable(name: "req_counter", scope: !156, file: !14, line: 93, type: !28)
!161 = !DILocation(line: 93, column: 13, scope: !156)
!162 = !DILocation(line: 93, column: 41, scope: !156)
!163 = !DILocation(line: 93, column: 49, scope: !156)
!164 = !DILocation(line: 94, column: 12, scope: !165)
!165 = distinct !DILexicalBlock(scope: !156, file: !14, line: 94, column: 12)
!166 = !DILocation(line: 94, column: 26, scope: !165)
!167 = !DILocation(line: 94, column: 24, scope: !165)
!168 = !DILocation(line: 94, column: 12, scope: !156)
!169 = !DILocation(line: 95, column: 24, scope: !170)
!170 = distinct !DILexicalBlock(scope: !165, file: !14, line: 94, column: 38)
!171 = !DILocation(line: 96, column: 27, scope: !170)
!172 = !DILocation(line: 96, column: 25, scope: !170)
!173 = !DILocation(line: 97, column: 37, scope: !170)
!174 = !DILocation(line: 97, column: 35, scope: !170)
!175 = !DILocation(line: 98, column: 34, scope: !170)
!176 = !DILocation(line: 98, column: 28, scope: !170)
!177 = !DILocation(line: 98, column: 32, scope: !170)
!178 = !DILocation(line: 99, column: 36, scope: !170)
!179 = !DILocation(line: 99, column: 34, scope: !170)
!180 = !DILocation(line: 100, column: 9, scope: !170)
!181 = !DILocation(line: 102, column: 38, scope: !156)
!182 = !DILocation(line: 102, column: 50, scope: !156)
!183 = !DILocation(line: 102, column: 57, scope: !156)
!184 = !DILocation(line: 102, column: 78, scope: !156)
!185 = !DILocation(line: 102, column: 55, scope: !156)
!186 = !DILocation(line: 102, column: 24, scope: !156)
!187 = !DILocation(line: 102, column: 32, scope: !156)
!188 = !DILocation(line: 102, column: 36, scope: !156)
!189 = !DILocation(line: 103, column: 26, scope: !156)
!190 = !DILocation(line: 103, column: 35, scope: !156)
!191 = !DILocation(line: 103, column: 60, scope: !156)
!192 = !DILocation(line: 103, column: 9, scope: !156)
!193 = !DILocation(line: 107, column: 17, scope: !156)
!194 = !DILocation(line: 107, column: 87, scope: !156)
!195 = !DILocation(line: 107, column: 100, scope: !156)
!196 = !DILocation(line: 107, column: 113, scope: !156)
!197 = !DILocation(line: 107, column: 125, scope: !156)
!198 = !DILocation(line: 107, column: 147, scope: !156)
!199 = !DILocation(line: 107, column: 9, scope: !156)
!200 = !DILocation(line: 108, column: 17, scope: !156)
!201 = !DILocation(line: 108, column: 61, scope: !156)
!202 = !DILocation(line: 108, column: 72, scope: !156)
!203 = !DILocation(line: 108, column: 83, scope: !156)
!204 = !DILocation(line: 108, column: 9, scope: !156)
!205 = !DILocation(line: 109, column: 17, scope: !156)
!206 = !DILocation(line: 109, column: 61, scope: !156)
!207 = !DILocation(line: 109, column: 72, scope: !156)
!208 = !DILocation(line: 109, column: 83, scope: !156)
!209 = !DILocation(line: 109, column: 9, scope: !156)
!210 = distinct !{!210, !152, !211}
!211 = !DILocation(line: 110, column: 5, scope: !13)
!212 = !DILocation(line: 111, column: 15, scope: !13)
!213 = !DILocation(line: 111, column: 5, scope: !13)
!214 = !DILocation(line: 112, column: 15, scope: !13)
!215 = !DILocation(line: 112, column: 5, scope: !13)
!216 = !DILocation(line: 113, column: 22, scope: !13)
!217 = !DILocation(line: 113, column: 5, scope: !13)
!218 = !DILocation(line: 137, column: 1, scope: !13)
!219 = distinct !DISubprogram(name: "_hal_init", scope: !14, file: !14, line: 5, type: !220, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !9)
!220 = !DISubroutineType(types: !221)
!221 = !{null, !20, !20}
!222 = !DILocalVariable(name: "inuri", arg: 1, scope: !219, file: !14, line: 5, type: !20)
!223 = !DILocation(line: 5, column: 22, scope: !219)
!224 = !DILocalVariable(name: "outuri", arg: 2, scope: !219, file: !14, line: 5, type: !20)
!225 = !DILocation(line: 5, column: 35, scope: !219)
!226 = !DILocation(line: 16, column: 13, scope: !219)
!227 = !DILocation(line: 16, column: 5, scope: !219)
!228 = !DILocation(line: 19, column: 13, scope: !219)
!229 = !DILocation(line: 19, column: 5, scope: !219)
!230 = !DILocation(line: 23, column: 13, scope: !219)
!231 = !DILocation(line: 23, column: 5, scope: !219)
!232 = !DILocation(line: 24, column: 13, scope: !219)
!233 = !DILocation(line: 24, column: 5, scope: !219)
!234 = !DILocation(line: 25, column: 1, scope: !219)
!235 = distinct !DISubprogram(name: "_wrapper_request_get_a", scope: !14, file: !14, line: 139, type: !236, scopeLine: 139, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !9)
!236 = !DISubroutineType(types: !237)
!237 = !{!22, !22}
!238 = !DILocalVariable(name: "tag", arg: 1, scope: !235, file: !14, line: 139, type: !22)
!239 = !DILocation(line: 139, column: 1, scope: !235)
!240 = !DILocation(line: 139, column: 1, scope: !241)
!241 = distinct !DILexicalBlock(scope: !235, file: !14, line: 139, column: 1)
!242 = distinct !{!242, !239, !239}
!243 = distinct !DISubprogram(name: "_slave_rpc_loop", scope: !14, file: !14, line: 142, type: !244, scopeLine: 142, spFlags: DISPFlagDefinition, unit: !17, retainedNodes: !9)
!244 = !DISubroutineType(types: !245)
!245 = !{!28}
!246 = !DILocation(line: 143, column: 5, scope: !243)
!247 = !DILocalVariable(name: "tid", scope: !243, file: !14, line: 144, type: !248)
!248 = !DICompositeType(tag: DW_TAG_array_type, baseType: !249, size: 64, elements: !251)
!249 = !DIDerivedType(tag: DW_TAG_typedef, name: "pthread_t", file: !250, line: 27, baseType: !115)
!250 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/pthreadtypes.h", directory: "")
!251 = !{!252}
!252 = !DISubrange(count: 1)
!253 = !DILocation(line: 144, column: 15, scope: !243)
!254 = !DILocation(line: 145, column: 21, scope: !243)
!255 = !DILocation(line: 145, column: 5, scope: !243)
!256 = !DILocalVariable(name: "i", scope: !257, file: !14, line: 146, type: !28)
!257 = distinct !DILexicalBlock(scope: !243, file: !14, line: 146, column: 5)
!258 = !DILocation(line: 146, column: 14, scope: !257)
!259 = !DILocation(line: 146, column: 10, scope: !257)
!260 = !DILocation(line: 146, column: 21, scope: !261)
!261 = distinct !DILexicalBlock(scope: !257, file: !14, line: 146, column: 5)
!262 = !DILocation(line: 146, column: 23, scope: !261)
!263 = !DILocation(line: 146, column: 5, scope: !257)
!264 = !DILocation(line: 146, column: 55, scope: !261)
!265 = !DILocation(line: 146, column: 51, scope: !261)
!266 = !DILocation(line: 146, column: 38, scope: !261)
!267 = !DILocation(line: 146, column: 34, scope: !261)
!268 = !DILocation(line: 146, column: 5, scope: !261)
!269 = distinct !{!269, !263, !270}
!270 = !DILocation(line: 146, column: 63, scope: !257)
!271 = !DILocation(line: 147, column: 5, scope: !243)
!272 = !{!273}
!273 = !{i64 2, i64 3, i1 false}
