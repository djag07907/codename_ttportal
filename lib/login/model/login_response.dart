import 'package:cdbi/common/baseResponse/base_response.dart';
import 'package:cdbi/login/model/login_data.dart';

final class LoginResponse extends BaseResponse {
  final LoginData data;

  LoginResponse({
    required super.message,
    required super.code,
    required super.lang,
    required this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      code: json['code'],
      lang: json['lang'],
      data: LoginData.fromJson(json['data']),
    );
  }
}
