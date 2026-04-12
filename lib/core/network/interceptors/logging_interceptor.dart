import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  
  @override
  void onRequest(options, handler) {
    return handler.next(options);
  }

  @override
  void onResponse(response, handler) {
    print('✅ ${response.statusCode} ${response.requestOptions.path}');
    return handler.next(response);
  }

  @override
  void onError(err, handler) {
    print('❌ ${err.message}');
    return handler.next(err);
  }
}