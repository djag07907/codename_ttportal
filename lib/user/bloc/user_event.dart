import 'package:codename_ttportal/user/model/user_model.dart';
import 'package:equatable/equatable.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class CreateUserEvent extends UserEvent {
  final User user;
  const CreateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

class FetchUsersEvent extends UserEvent {
  final int pageNumber;
  final int pageSize;
  const FetchUsersEvent({
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}

class FetchCompaniesEvent extends UserEvent {
  final int pageNumber;
  final int pageSize;

  const FetchCompaniesEvent({
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}
