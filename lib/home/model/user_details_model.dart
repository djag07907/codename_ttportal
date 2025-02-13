import 'package:cdbi/repository/respository_constants.dart';

class UserDetails {
  final String userName;
  final String companyId;
  final String companyName;
  final String email;
  final bool isAdmin;
  final DateTime creationDate;
  final String createdUserId;
  final String id;

  UserDetails({
    required this.userName,
    required this.companyId,
    required this.companyName,
    required this.email,
    required this.isAdmin,
    required this.creationDate,
    required this.createdUserId,
    required this.id,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      userName: json['userName'] ?? emptyString,
      companyId: json['companyId'] ?? emptyString,
      companyName: json['companyName'] ?? emptyString,
      email: json['email'] ?? emptyString,
      isAdmin: json['isAdmin'] ?? emptyString,
      creationDate: json['creationDate'] ?? emptyString,
      createdUserId: json['createdUserId'] ?? emptyString,
      id: json['id'] ?? emptyString,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'companyId': companyId,
      'companyName': companyName,
      'email': email,
      'isAdmin': isAdmin,
      'creationDate': creationDate.toIso8601String(),
      'createdUserId': createdUserId,
      'id': id,
    };
  }
}
