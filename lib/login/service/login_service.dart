import 'package:cdbi/factory/client_factory.dart';
import 'package:cdbi/factory/guess_factory.dart';
import 'package:cdbi/login/model/login_response.dart';
import 'package:cdbi/resources/api_constants.dart';
import 'package:dio/dio.dart';

class LoginService {
  Dio client;
  Dio authClient;

  LoginService()
      : client = GuessFactory.buildClient(),
        authClient = ClientFactory.buildClient();

  LoginService.withClient(
    this.client,
    this.authClient,
  );

  Future<LoginResponse> loginWithPassword({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      loginPath,
      data: {
        "email": email,
        "password": password,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );
    return LoginResponse.fromJson(response.data);
  }
}
