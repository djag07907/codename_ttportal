part of 'user_bloc.dart';

sealed class UserState extends BaseState {}

final class UserInitial extends UserState {}

final class UserInProgress extends UserState {}

final class UserCreationSuccess extends UserState {
  final User user;

  UserCreationSuccess(
    this.user,
  );
}

final class UserCreationError extends UserState {
  final int? error;

  UserCreationError(
    this.error,
  );
}

final class UsersFetchSuccess extends UserState {
  final List<User> users;

  UsersFetchSuccess(
    this.users,
  );
}

final class UsersFetchError extends UserState {
  final int? error;

  UsersFetchError(
    this.error,
  );
}

final class CompaniesFetchSuccess extends UserState {
  final List<Company> companies;

  CompaniesFetchSuccess(
    this.companies,
  );
}

final class CompaniesFetchError extends UserState {
  final int? error;

  CompaniesFetchError(
    this.error,
  );
}
