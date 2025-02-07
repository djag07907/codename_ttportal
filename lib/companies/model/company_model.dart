import 'package:codename_ttportal/repository/respository_constants.dart';

class Company {
  final String companyName;
  final String dashboardName;
  final String dashboardCode;
  final String dashboardLink;

  Company({
    required this.companyName,
    required this.dashboardName,
    required this.dashboardCode,
    required this.dashboardLink,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'dashboardName': dashboardName,
      'dashboardCode': dashboardCode,
      'dashboardLink': dashboardLink,
    };
  }

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyName: (json['companyName'] as String?) ??
          (json['name'] as String?) ??
          emptyString,
      dashboardName: (json['dashboardName'] as String?) ?? emptyString,
      dashboardCode: (json['dashboardCode'] as String?) ?? emptyString,
      dashboardLink: (json['dashboardLink'] as String?) ?? emptyString,
    );
  }
}
