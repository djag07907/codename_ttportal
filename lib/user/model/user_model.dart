class User {
  final String id;
  final String email;
  final String password;
  final bool isAdmin;
  final List<String> assignedDashboardIds;

  User({
    required this.id,
    required this.email,
    required this.password,
    this.isAdmin = false,
    this.assignedDashboardIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'isAdmin': isAdmin,
      'assignedDashboardIds': assignedDashboardIds,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      isAdmin: json['isAdmin'] ?? false,
      assignedDashboardIds:
          List<String>.from(json['assignedDashboardIds'] ?? []),
    );
  }
}
