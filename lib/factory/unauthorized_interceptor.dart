import 'package:dio/dio.dart';

class UnauthorizedInterceptor extends Interceptor {
  final Dio dio;

  UnauthorizedInterceptor(this.dio);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
      );
    } else {
      return super.onResponse(response, handler);
    }
  }
}
