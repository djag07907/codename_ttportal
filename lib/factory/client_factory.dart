import 'package:cdbi/factory/headers_interceptor.dart';
import 'package:cdbi/factory/unauthorized_interceptor.dart';
import 'package:cdbi/resources/api_constants.dart';
import 'package:dio/dio.dart';

final class ClientFactory {
  static Dio buildClient() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        validateStatus: (status) => status! <= 201,
      ),
    );

    dio.interceptors
      ..add(LogInterceptor())
      ..add(HeadersInterceptor())
      ..add(
        UnauthorizedInterceptor(
          dio,
        ),
      );

    return dio;
  }
}
