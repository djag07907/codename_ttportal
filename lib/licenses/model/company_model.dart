import 'package:codename_ttportal/repository/respository_constants.dart';

class Company {
  final String companyId;
  final String companyName;
  final String dashboardName;
  final String dashboardCode;
  final String dashboardLink;

  Company({
    required this.companyId,
    required this.companyName,
    required this.dashboardName,
    required this.dashboardCode,
    required this.dashboardLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': companyId,
      'companyName': companyName,
      'dashboardName': dashboardName,
      'dashboardCode': dashboardCode,
      'dashboardLink': dashboardLink,
    };
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyId: (json['id']),
      companyName: (json['companyName']) ?? (json['name']) ?? emptyString,
      dashboardName: (json['dashboardName']) ?? emptyString,
      dashboardCode: (json['dashboardCode']) ?? emptyString,
      dashboardLink: (json['dashboardLink']) ?? emptyString,
    );
  }
}
