import 'package:codename_ttportal/common/bloc/base_bloc.dart';
import 'package:codename_ttportal/common/bloc/base_state.dart';
import 'package:codename_ttportal/resources/constants.dart';
import 'package:codename_ttportal/user/model/company_model.dart';
import 'package:codename_ttportal/user/model/user_model.dart';
import 'package:codename_ttportal/user/service/user_service.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends BaseBloc<UserEvent, BaseState> {
  final UserService service = UserService();

  UserBloc() : super(UserInitial()) {
    on<CreateUserEvent>(_createUser);
    on<FetchUsersEvent>(_fetchUsers);
    on<FetchCompaniesEvent>(_fetchCompanies);
  }

  Future<void> _createUser(
    CreateUserEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      UserInProgress(),
    );
    try {
      final createdUser = await service.createUser(
        user: event.user,
      );
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

  Future<void> _fetchUsers(
    FetchUsersEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      UserInProgress(),
    );
    try {
      final users = await service.getUsers(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      );
      emit(
        UsersFetchSuccess(
          users,
        ),
      );
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

  Future<void> _fetchCompanies(
    FetchCompaniesEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      UserInProgress(),
    );
    try {
      final companies = await service.getCompanies(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      );
      emit(
        CompaniesFetchSuccess(
          companies,
        ),
      );
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(
          CompaniesFetchError(code),
        ),
      );
    }
  }

  void _handleDioException(
    DioException error,
    Emitter<BaseState> emit,
    Function(int) errorEmitter,
  ) {
    if (error.response?.statusCode == null ||
        error.response!.statusCode! >= 500 ||
        error.response?.data?[responseCode] == null) {
      emit(
        ServerClientError(),
      );
    } else {
      errorEmitter(
        error.response!.data[responseCode],
      );
    }
  }
}
