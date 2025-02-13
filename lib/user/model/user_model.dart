import 'package:cdbi/repository/respository_constants.dart';

class User {
  final String userName;
  final String email;
  final String? password;
  final bool isAdmin;
  final String? companyId;
  final String? companyName;
  final String? id;
  final DateTime? createdDate;
  final DateTime? modifiedDate;

  User({
    required this.userName,
    required this.email,
    this.password,
    required this.isAdmin,
    this.companyId,
    this.companyName,
    this.id,
    this.createdDate,
    this.modifiedDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'],
      email: json['email'],
      password: json['password'] ?? emptyString,
      isAdmin: json['isAdmin'],
      companyId: json['companyId'] ?? emptyString,
      companyName: json['companyName'] ?? emptyString,
      id: json['id'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      modifiedDate: json['modifiedDate'] != null
          ? DateTime.parse(json['modifiedDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "email": email,
      "password": password,
      "isAdmin": isAdmin,
      if (companyId != null) "companyId": companyId,
      "companyName": companyName ?? emptyString,
    };
  }
}
