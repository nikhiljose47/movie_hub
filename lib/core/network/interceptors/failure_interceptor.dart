import 'dart:math';
import 'package:dio/dio.dart';

class FailureInterceptor extends Interceptor {
  final bool enabled;
  final Random _random = Random();

  FailureInterceptor({this.enabled = true});

  @override
  void onRequest(options, handler) {
    if (enabled &&
        options.method == 'GET' &&
        _random.nextInt(10) < 3) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: 'Internal Error (Custom)',
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: options,
            statusCode: 500,
            data: {'message': 'Internal server error'},
          ),
        ),
      );
    }

    return handler.next(options);
  }
}