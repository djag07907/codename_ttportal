final class LoginData {
  final String token;
  final bool ok;
  final bool isAdmin;
  final String expiration;

  LoginData({
    required this.token,
    required this.ok,
    required this.isAdmin,
    required this.expiration,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'],
      ok: json['ok'],
      isAdmin: json['isAdmin'] ?? false,
      expiration: json['expiration'],
    );
  }
}
