import 'dart:math';
import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;

  RetryInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;

    int retries = request.extra['retries'] ?? 0;

    // ❌ Don't retry client errors (400–499)
    if (err.response?.statusCode != null) {
      final status = err.response!.statusCode!;
      if (status >= 400 && status < 500) {
        return handler.next(err);
      }
    }

    // ✅ Retry only network-related issues
    if (err.type != DioExceptionType.connectionError &&
        err.type != DioExceptionType.receiveTimeout) {
      return handler.next(err);
    }

    if (retries >= 3) {
      return handler.next(err);
    }

    retries++;
    request.extra['retries'] = retries;

    final delay = Duration(milliseconds: 500 * pow(2, retries).toInt());

    await Future.delayed(delay);

    try {
      final response = await dio.fetch(request);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(e as DioException);
    }
  }
}
