import 'package:codename_ttportal/repository/respository_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(token) ?? emptyString;
  }

  Future<void> setToken(String tokenValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(token, tokenValue);
  }

  Future<String> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmail) ?? emptyString;
  }

  Future<void> setUserEmail(String userEmailValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userEmail, userEmailValue);
  }

  Future<String> getUserFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userFullName) ?? emptyString;
  }

  Future<void> setUserFullName(String userFullNameValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userFullName, userFullNameValue);
  }

  Future<String> getRememberUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(rememberUser) ?? emptyString;
  }

  Future<void> setRememberUser(String rememberUserValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(rememberUser, rememberUserValue);
  }

  Future<String> getUserIsSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIsSession) ?? emptyString;
  }

  Future<void> setUserIsSession(String isSessionValue) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userIsSession, isSessionValue);
  }
}
