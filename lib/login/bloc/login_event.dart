part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object> get props => [];
}

final class LoginOnLoad extends LoginEvent {}

final class LoginWithEmailPassword extends LoginEvent {
  final String email;
  final String password;
  final bool rememberAccount;

  const LoginWithEmailPassword({
    required this.email,
    required this.password,
    required this.rememberAccount,
  });
}
