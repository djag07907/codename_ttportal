part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

final class CreateUserEvent extends UserEvent {
  final User user;

  const CreateUserEvent(
    this.user,
  );
}

final class FetchUsersEvent extends UserEvent {
  final int pageNumber;
  final int pageSize;

  const FetchUsersEvent({
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}

final class FetchCompaniesEvent extends UserEvent {
  final int pageNumber;
  final int pageSize;

  const FetchCompaniesEvent({
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}
