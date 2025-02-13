import 'package:cdbi/repository/respository_constants.dart';

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

  factory Company.fromJson(
    Map<String, dynamic> json,
  ) {
    return Company(
      companyName: (json['companyName']) ?? (json['name']) ?? emptyString,
      dashboardName: (json['dashboardName']) ?? emptyString,
      dashboardCode: (json['dashboardCode']) ?? emptyString,
      dashboardLink: (json['dashboardLink']) ?? emptyString,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'dashboardName': dashboardName,
      'dashboardCode': dashboardCode,
      'dashboardLink': dashboardLink,
    };
  }
}
