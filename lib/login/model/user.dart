import 'package:jwt_decoder/jwt_decoder.dart';

class User {
  final String userName;
  final String email;
  final String password;
  final bool isAdmin;
  final String companyId;
  final List<String> assignedDashboardIds;

  User({
    required this.userName,
    required this.email,
    required this.password,
    required this.isAdmin,
    required this.companyId,
    this.assignedDashboardIds = const [],
  });

  factory User.fromToken({
    required String token,
    required String email,
    String password = '',
  }) {
    final Map<String, dynamic> payload = JwtDecoder.decode(token);
    final dynamic rawIsAdmin = payload['isAdmin'] ?? payload['IsAdmin'];
    final bool adminValue = rawIsAdmin is bool
        ? rawIsAdmin
        : rawIsAdmin.toString().toLowerCase() == 'true';

    return User(
      userName: payload['userName'] ?? email,
      email: email,
      password: password,
      isAdmin: adminValue,
      companyId: payload['companyId'] ?? '',
      assignedDashboardIds: payload['assignedDashboardIds'] != null
          ? List<String>.from(payload['assignedDashboardIds'])
          : [],
    );
  }
}
