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
      userName: json['userName'],
      companyId: json['companyId'],
      companyName: json['companyName'],
      email: json['email'],
      isAdmin: json['isAdmin'],
      creationDate: DateTime.parse(json['creationDate']),
      createdUserId: json['createdUserId'],
      id: json['id'],
    );
  }
}
