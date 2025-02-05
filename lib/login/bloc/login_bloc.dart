import 'package:codename_ttportal/common/bloc/base_bloc.dart';
import 'package:codename_ttportal/common/bloc/base_state.dart';
import 'package:codename_ttportal/login/bloc/login_event.dart';
import 'package:codename_ttportal/login/bloc/login_state.dart';
import 'package:codename_ttportal/login/service/login_service.dart';
import 'package:codename_ttportal/repository/respository_constants.dart';
import 'package:codename_ttportal/repository/user_repository.dart';
import 'package:codename_ttportal/resources/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends BaseBloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginOnLoad>(loginOnLoad);
    on<LoginWithEmailPassword>(loginWithEmailPassword);
  }

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

    // If admin then proceed without calling API
    if (event.email == "daniel.alvarez@soas.com" &&
        event.password == "So452024#") {
      // Store a dummy token and set session info for admin if needed
      await UserRepository().setToken("ADMIN_TOKEN");
      await UserRepository().setUserIsSession(trueString);
      UserRepository().setUserEmail(event.email);
      emit(LoginSuccess(isBoss: true, isFullRegistered: true));
      return;
    }

    try {
      final LoginService service = LoginService();
      final response = await service.loginWithPassword(
        email: event.email,
        password: event.password,
      );
      if (response.data != null) {
        await UserRepository().setToken(response.data.token);
        await UserRepository().setUserIsSession(trueString);
        UserRepository().setUserEmail(event.email);
        // Use response.data.ok to decide if the registration is complete.
        emit(LoginSuccess(isBoss: false, isFullRegistered: response.data.ok));
      } else {
        // Optionally emit an error state if no data is returned.
        emit(LoginError(null));
      }
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
      emit(
        LoginError(500),
      );
    } else {
      errorEmitter(error.response!.data[responseCode]);
    }
  }
}
