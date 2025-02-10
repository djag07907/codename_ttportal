import 'package:codename_ttportal/common/bloc/base_bloc.dart';
import 'package:codename_ttportal/home/bloc/home_event.dart';
import 'package:codename_ttportal/home/bloc/home_state.dart';
import 'package:codename_ttportal/home/service/home_service.dart';
import 'package:codename_ttportal/resources/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchDashboardsByCompanyId>(fetchDashboardsByCompanyId);
  }
  final HomeService service = HomeService();

  Future<void> fetchDashboardsByCompanyId(
    FetchDashboardsByCompanyId event,
    Emitter<HomeState> emit,
  ) async {
    emit(
      HomeInProgress(),
    );
    try {
      final dashboards = await service.getDashboardsByCompanyId(
        event.companyId,
      );
      emit(
        DashboardsFetchSuccess(dashboards),
      );
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(
          HomeError(code),
        ),
      );
    }
  }

  void _handleDioException(
    DioException error,
    Emitter<HomeState> emit,
    Function(int) errorEmitter,
  ) {
    if (error.response?.statusCode == null ||
        error.response!.statusCode! >= 500 ||
        error.response?.data?[responseCode] == null) {
      emit(HomeError(500));
    } else {
      errorEmitter(
        error.response!.data[responseCode],
      );
    }
  }
}
