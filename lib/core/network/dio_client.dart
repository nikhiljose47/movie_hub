import 'package:dio/dio.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/failure_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient({
    required String baseUrl,
    Map<String, dynamic>? defaultQuery,
    Map<String, dynamic>? headers,
    bool enableFailureSimulation = false,
  }) {
    
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        queryParameters: defaultQuery ?? {},
        headers: headers ?? {},
      ),
    );

    dio.interceptors.addAll([
      FailureInterceptor(enabled: enableFailureSimulation),
      RetryInterceptor(dio),
      LoggingInterceptor(),
    ]);
  }

  // optional helper methods
  Future<Response> get(
    String path, {
    Map<String, dynamic>? query,
    CancelToken? cancelToken,
  }) {
    return dio.get(
      path,
      queryParameters: query,
      cancelToken: cancelToken,
    );
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? query,
  }) {
    return dio.post(
      path,
      data: data,
      queryParameters: query,
    );
  }
}