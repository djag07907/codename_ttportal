import 'package:codename_ttportal/common/bloc/base_state.dart';

sealed class LoginState extends BaseState {}

final class LoginInitial extends LoginState {}

final class LoginInProgress extends LoginState {}

final class LoginSuccess extends LoginState {
  final bool isBoss;
  final bool isFullRegistered;
  LoginSuccess({
    required this.isBoss,
    required this.isFullRegistered,
  });
}

final class LoginError extends LoginState {
  final int? error;
  LoginError(
    this.error,
  );
}

final class LoginLoadInProgress extends LoginState {}

final class LoginLoadSuccess extends LoginState {
  final bool rememberUser;
  final String email;
  LoginLoadSuccess({
    required this.rememberUser,
    required this.email,
  });
}
