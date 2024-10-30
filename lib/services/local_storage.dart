import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:codename_ttportal/user/model/user_model.dart';
import 'package:codename_ttportal/dashboard/model/dashboard_model.dart';

class LocalStorageService {
  static const String USERS_KEY = 'users';
  static const String DASHBOARDS_KEY = 'dashboards';

  Future<void> addUser(User user) async {
    final users = await getUsers();
    users.add(user);
    await saveUsers(users);
  }

  Future<void> updateUser(User updatedUser) async {
    final users = await getUsers();
    final index = users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      users[index] = updatedUser;
      await saveUsers(users);
    }
  }

  Future<void> deleteUser(String userId) async {
    final users = await getUsers();
    users.removeWhere((user) => user.id == userId);
    await saveUsers(users);
  }

  Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        json.encode(users.map((user) => user.toJson()).toList());
    await prefs.setString(USERS_KEY, encodedData);
  }

  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(USERS_KEY);
    if (encodedData != null) {
      final List<dynamic> decodedData = json.decode(encodedData);
      return decodedData.map((item) => User.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> saveDashboards(List<Dashboard> dashboards) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        json.encode(dashboards.map((dashboard) => dashboard.toJson()).toList());
    await prefs.setString(DASHBOARDS_KEY, encodedData);
  }

  Future<List<Dashboard>> getDashboards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString(DASHBOARDS_KEY);
    if (encodedData != null) {
      final List<dynamic> decodedData = json.decode(encodedData);
      return decodedData.map((item) => Dashboard.fromJson(item)).toList();
    }
    return [];
  }

  Future<void> addDashboard(Dashboard dashboard) async {
    final dashboards = await getDashboards();
    dashboards.add(dashboard);
    await saveDashboards(dashboards);
  }

  Future<void> updateDashboard(Dashboard updatedDashboard) async {
    final dashboards = await getDashboards();
    final index = dashboards
        .indexWhere((dashboard) => dashboard.id == updatedDashboard.id);
    if (index != -1) {
      dashboards[index] = updatedDashboard;
      await saveDashboards(dashboards);
    }
  }

  Future<void> deleteDashboard(String dashboardId) async {
    final dashboards = await getDashboards();
    dashboards.removeWhere((dashboard) => dashboard.id == dashboardId);
    await saveDashboards(dashboards);
  }
}
