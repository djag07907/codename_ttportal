import 'package:codename_ttportal/repository/respository_constants.dart';

class Dashboard {
  final String id;
  final String name;
  final String dashboardCode;
  final String link;
  final String? companyId;
  final String? companyName;
  final DateTime? creationDate;
  final DateTime? modificationDate;

  Dashboard({
    required this.id,
    required this.name,
    required this.dashboardCode,
    required this.link,
    this.companyId,
    this.companyName,
    this.creationDate,
    this.modificationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dashboardCode': dashboardCode,
      'link': link,
      'companyId': companyId,
      'companyName': companyName,
    };
  }

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      id: json['id'] ?? emptyString,
      name: json['name'] ?? emptyString,
      dashboardCode: json['dashboardCode'] ?? emptyString,
      link: json['link'] ?? emptyString,
      companyId: json['companyId'],
      companyName: json['companyName'],
      creationDate: json['creationDate'] != null
          ? DateTime.parse(json['creationDate'])
          : null,
      modificationDate: json['modificationDate'] != null
          ? DateTime.parse(json['modificationDate'])
          : null,
    );
  }
}
