import 'package:cdbi/common/bloc/base_bloc.dart';
import 'package:cdbi/common/bloc/base_state.dart';
import 'package:cdbi/login/service/login_service.dart';
import 'package:cdbi/repository/respository_constants.dart';
import 'package:cdbi/repository/user_repository.dart';
import 'package:cdbi/resources/constants.dart';
import 'package:cdbi/login/model/user.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends BaseBloc<LoginEvent, BaseState> {
  final LoginService service = LoginService();

  LoginBloc() : super(LoginInitial()) {
    on<LoginOnLoad>(loginOnLoad);
    on<LoginWithEmailPassword>(loginWithEmailPassword);
  }

  Future<void> loginOnLoad(
    LoginOnLoad event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      LoginInProgress(),
    );
    final String rememberUser = await UserRepository().getRememberUser();
    final String userEmail = (rememberUser == trueString)
        ? await UserRepository().getUserEmail()
        : emptyString;
    emit(LoginLoadSuccess(
        rememberUser: (rememberUser == trueString), email: userEmail));
  }

  Future<void> loginWithEmailPassword(
    LoginWithEmailPassword event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      LoginInProgress(),
    );
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
        (code) => emit(
          LoginError(code),
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
      errorEmitter(error.response!.data[responseCode]);
    }
  }
}
