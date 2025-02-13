import 'package:cdbi/common/bloc/base_bloc.dart';
import 'package:cdbi/common/bloc/base_state.dart';
import 'package:cdbi/home/model/dashboard_model.dart';
import 'package:cdbi/home/model/user_details_model.dart';
import 'package:cdbi/home/service/home_service.dart';
import 'package:cdbi/resources/constants.dart';
import 'package:cdbi/resources/error_codes.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends BaseBloc<HomeEvent, BaseState> {
  final HomeService service = HomeService();

  HomeBloc() : super(HomeInitial()) {
    on<FetchUserDetailsById>(fetchUserDetailsById);
    on<FetchDashboardsByCompanyId>(fetchDashboardsByCompanyId);
  }

  Future<void> fetchUserDetailsById(
    FetchUserDetailsById event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      HomeInProgress(),
    );
    try {
      final response = await service.getUserDetailsById(event.userId);
      final companyId = response.companyId;
      emit(
        UserDetailsFetchSuccess(
          companyId,
        ),
      );
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(HomeError(code)),
      );
    }
  }

  Future<void> fetchDashboardsByCompanyId(
    FetchDashboardsByCompanyId event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      HomeInProgress(),
    );
    try {
      final dashboards = await service.getDashboardsByCompanyId(
        event.companyId,
      );
      emit(
        DashboardsFetchSuccess(
          dashboards,
        ),
      );
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(HomeError(code)),
      );
    }
  }

  void _handleDioException(
    DioException error,
    Emitter<BaseState> emit,
    Function(int) errorEmitter,
  ) {
    if (error.response!.statusCode == errorCode401) {
      emit(
        LicenseExpiredError(),
      );
    }
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
