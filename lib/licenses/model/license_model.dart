import 'package:cdbi/repository/respository_constants.dart';

class License {
  final String? codeLicense;
  final String companyId;
  final String? companyName;
  final DateTime expirationDate;
  final int amountOfLicenses;
  final String? id;

  License({
    this.codeLicense,
    required this.companyId,
    this.companyName,
    required this.expirationDate,
    required this.amountOfLicenses,
    this.id,
  });

  factory License.fromJson(Map<String, dynamic> json) {
    return License(
      codeLicense: json['codeLicense'],
      companyId: json['companyId'] ?? emptyString,
      companyName: json['companyName'],
      expirationDate: DateTime.parse(json['expirationDate']),
      amountOfLicenses: json['amoungOfLicenses'] ?? emptyInt,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "companyId": companyId,
      "amoungOfLicenses": amountOfLicenses,
      "expirationDate": expirationDate.toUtc().toIso8601String(),
    };
  }
}

class LicensesData {
  final int totalItems;
  final int currentPage;
  final int? nextPage;
  final int? previousPage;
  final int totalPages;
  final List<License> results;

  LicensesData({
    required this.totalItems,
    required this.currentPage,
    this.nextPage,
    this.previousPage,
    required this.totalPages,
    required this.results,
  });

  factory LicensesData.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<License> licensesList =
        list.map((item) => License.fromJson(item)).toList();
    return LicensesData(
      totalItems: json['totalItems'],
      currentPage: json['currentPage'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
      totalPages: json['totalPages'],
      results: licensesList,
    );
  }
}
