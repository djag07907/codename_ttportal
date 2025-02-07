import 'package:codename_ttportal/user/model/user_model.dart';

sealed class UserState {}

class UserInitial extends UserState {}

class UserOperationInProgress extends UserState {}

class UserCreationSuccess extends UserState {
  final User user;
  UserCreationSuccess(this.user);
}

class UserCreationError extends UserState {
  final int? error;
  UserCreationError(this.error);
}

class UsersFetchSuccess extends UserState {
  final List<User> users;
  UsersFetchSuccess(this.users);
}

class UsersFetchError extends UserState {
  final int? error;
  UsersFetchError(this.error);
}
