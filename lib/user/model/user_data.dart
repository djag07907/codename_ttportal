import 'package:codename_ttportal/user/model/user_model.dart';

class UsersData {
  final int totalItems;
  final int currentPage;
  final int? nextPage;
  final int? previousPage;
  final int totalPages;
  final List<User> results;

  UsersData({
    required this.totalItems,
    required this.currentPage,
    this.nextPage,
    this.previousPage,
    required this.totalPages,
    required this.results,
  });

  factory UsersData.fromJson(Map<String, dynamic> json) {
    var list = json['results'] as List;
    List<User> usersList = list.map((item) => User.fromJson(item)).toList();
    return UsersData(
      totalItems: json['totalItems'],
      currentPage: json['currentPage'],
      nextPage: json['nextPage'],
      previousPage: json['previousPage'],
      totalPages: json['totalPages'],
      results: usersList,
    );
  }
}
