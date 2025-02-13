import 'package:cdbi/factory/headers_interceptor.dart';
import 'package:cdbi/resources/api_constants.dart';
import 'package:dio/dio.dart';

class GuessFactory {
  static Dio buildClient() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        validateStatus: (status) => status! <= 200,
      ),
    );

    dio.interceptors
      ..add(LogInterceptor())
      ..add(
        HeadersInterceptor(
          isGuess: true,
        ),
      );
    return dio;
  }
}
