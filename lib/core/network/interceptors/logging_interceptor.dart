import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  
  @override
  void onRequest(options, handler) {
    return handler.next(options);
  }

  @override
  void onResponse(response, handler) {
    return handler.next(response);
  }

  @override
  void onError(err, handler) {
    return handler.next(err);
  }
}