import 'package:codename_ttportal/common/bloc/base_bloc.dart';
import 'package:codename_ttportal/user/bloc/user_event.dart';
import 'package:codename_ttportal/user/bloc/user_state.dart';
import 'package:codename_ttportal/user/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends BaseBloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<CreateUserEvent>(_onCreateUser);
    on<FetchUsersEvent>(_onFetchUsers);
  }

  final UserService service = UserService();

  Future<void> _onCreateUser(
      CreateUserEvent event, Emitter<UserState> emit) async {
    emit(
      UserOperationInProgress(),
    );
    try {
      final createdUser = await service.createUser(user: event.user);
      emit(
        UserCreationSuccess(createdUser),
      );
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(
          UserCreationError(code),
        ),
      );
    }
  }

  Future<void> _onFetchUsers(
      FetchUsersEvent event, Emitter<UserState> emit) async {
    emit(UserOperationInProgress());
    try {
      final users = await service.getUsers(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      );
      emit(UsersFetchSuccess(users));
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(
          UsersFetchError(code),
        ),
      );
    }
  }

  void _handleDioException(
    DioException error,
    Emitter<UserState> emit,
    Function(int) errorEmitter,
  ) {
    if (error.response?.statusCode == null ||
        error.response!.statusCode! >= 500 ||
        error.response?.data?['code'] == null) {
      emit(UserCreationError(500));
    } else {
      errorEmitter(error.response!.data['code']);
    }
  }
}
