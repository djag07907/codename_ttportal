import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:codename_ttportal/repository/user_repository.dart';
import 'package:dio/dio.dart';

final class HeadersInterceptor extends QueuedInterceptor {
  final bool isGuess;
  HeadersInterceptor({
    this.isGuess = false,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String osClient;
    if (kIsWeb) {
      osClient = 'Web';
    } else {
      if (Platform.isAndroid) {
        osClient = 'Android';
      } else if (Platform.isIOS) {
        osClient = 'iOS';
      } else {
        osClient = 'Unknown';
      }
    }

    options.headers['SecretKey'] =
        'ujJTh2rta8ItSm/1PYQGxq2GQZXtFEq1yHYhtsIztUi66uaVbfNG7IwX9eoQ817jy8UUeX7X3dMUVGTioLq0Ew==';
    options.headers['AppVersion'] = '1.0.0';
    options.headers['AppBundle'] = '';
    options.headers['OsClient'] = osClient;
    if (!isGuess) {
      final String token = await UserRepository().getToken();
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
