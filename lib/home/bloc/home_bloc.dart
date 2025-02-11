import 'package:codename_ttportal/common/bloc/base_bloc.dart';
import 'package:codename_ttportal/common/bloc/base_state.dart';
import 'package:codename_ttportal/home/model/dashboard_model.dart';
import 'package:codename_ttportal/home/model/user_details_model.dart';
import 'package:codename_ttportal/home/service/home_service.dart';
import 'package:codename_ttportal/resources/constants.dart';
import 'package:codename_ttportal/resources/error_codes.dart';
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
    print("Fetching user details for user ID: ${event.userId}");

    try {
      final response = await service.getUserDetailsById(event.userId);
      print("User details fetched: ${response.toJson()}");
      final companyId = response.companyId;
      print("Company ID obtained: $companyId");

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
    print("Fetching dashboards for company ID: ${event.companyId}");

    try {
      final dashboards = await service.getDashboardsByCompanyId(
        event.companyId,
      );
      print(
          "Dashboards fetched: ${dashboards.map((d) => d.toJson()).toList()}");

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
      print("License expired error (401) received.");
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
      print("Error occurred: ${error.response!.data[responseCode]}");
    }
  }
}
