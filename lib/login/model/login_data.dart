final class LoginData {
  final String token;
  final bool ok;
  final String expiration;
  LoginData({
    required this.token,
    required this.ok,
    required this.expiration,
  });

  factory LoginData.fromJson(
    Map<String, dynamic> json,
  ) {
    return LoginData(
      token: json['token'],
      ok: json['ok'],
      expiration: json['expiration'],
    );
  }
}
