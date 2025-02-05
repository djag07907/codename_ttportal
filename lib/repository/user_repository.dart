import 'package:codename_ttportal/repository/respository_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserRepository {
  final FlutterSecureStorage storage;

  UserRepository() : storage = const FlutterSecureStorage();

  UserRepository.withStorage(
    this.storage,
  );

  Future<void> clear() async {
    await storage.deleteAll();
  }

  Future<String> getToken() async {
    return (await storage.read(
          key: token,
        )) ??
        emptyString;
  }

  Future<void> setToken(
    final String tokenValue,
  ) async {
    await storage.write(
      key: token,
      value: tokenValue,
    );
  }

  Future<String> getUserEmail() async {
    return (await storage.read(
          key: userEmail,
        )) ??
        emptyString;
  }

  Future<void> setUserEmail(
    final String userEmailValue,
  ) async {
    await storage.write(
      key: userEmail,
      value: userEmailValue,
    );
  }

  Future<String> getUserFullName() async {
    return (await storage.read(
          key: userFullName,
        )) ??
        emptyString;
  }

  Future<void> setUserFullName(
    final String userFullNameValue,
  ) async {
    await storage.write(
      key: userFullName,
      value: userFullNameValue,
    );
  }

  Future<String> getUserPhoneNumber() async {
    return (await storage.read(
          key: userPhoneNumber,
        )) ??
        emptyString;
  }

  Future<void> setUserPhoneNumber(
    final String userPhoneNumberValue,
  ) async {
    await storage.write(
      key: userPhoneNumber,
      value: userPhoneNumberValue,
    );
  }

  Future<String> getRememberUser() async {
    return (await storage.read(
          key: rememberUser,
        )) ??
        emptyString;
  }

  Future<void> setRememberUser(
    final String companyValue,
  ) async {
    await storage.write(
      key: rememberUser,
      value: companyValue,
    );
  }

  Future<String> getUserIsSession() async {
    return (await storage.read(
          key: userIsSession,
        )) ??
        emptyString;
  }

  Future<void> setUserIsSession(
    final String isSessionValue,
  ) async {
    await storage.write(
      key: userIsSession,
      value: isSessionValue,
    );
  }
}
