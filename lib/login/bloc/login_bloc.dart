import 'package:codename_ttportal/common/bloc/base_bloc.dart';
import 'package:codename_ttportal/login/bloc/login_event.dart';
import 'package:codename_ttportal/login/bloc/login_state.dart';
import 'package:codename_ttportal/login/service/login_service.dart';
import 'package:codename_ttportal/repository/respository_constants.dart';
import 'package:codename_ttportal/repository/user_repository.dart';
import 'package:codename_ttportal/resources/constants.dart';
import 'package:codename_ttportal/login/model/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginOnLoad>(loginOnLoad);
    on<LoginWithEmailPassword>(loginWithEmailPassword);
  }

  final LoginService service = LoginService();

  Future<void> loginOnLoad(
    LoginOnLoad event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginInProgress());
    final String rememberUser = await UserRepository().getRememberUser();
    final String userEmail = (rememberUser == trueString)
        ? await UserRepository().getUserEmail()
        : emptyString;
    emit(LoginLoadSuccess(
        rememberUser: (rememberUser == trueString), email: userEmail));
  }

  Future<void> loginWithEmailPassword(
    LoginWithEmailPassword event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginInProgress());
    try {
      final response = await service.loginWithPassword(
        email: event.email,
        password: event.password,
      );
      await UserRepository().setToken(response.data.token);
      await UserRepository().setUserIsSession(trueString);
      UserRepository().setUserEmail(event.email);

      final user = User.fromToken(
        token: response.data.token,
        email: event.email,
        password: event.password,
      );

      emit(
        LoginSuccess(
          user: user,
        ),
      );
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(LoginError(code)),
      );
    }
  }

  void _handleDioException(
    DioException error,
    Emitter<LoginState> emit,
    Function(int) errorEmitter,
  ) {
    if (error.response?.statusCode == null ||
        error.response!.statusCode! >= 500 ||
        error.response?.data?[responseCode] == null) {
      emit(LoginError(500));
    } else {
      errorEmitter(error.response!.data[responseCode]);
    }
  }
}
