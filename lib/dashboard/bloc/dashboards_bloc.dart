import 'package:codename_ttportal/common/bloc/base_bloc.dart';
import 'package:codename_ttportal/dashboard/bloc/dashboards_event.dart';
import 'package:codename_ttportal/dashboard/bloc/dashboards_state.dart';
import 'package:codename_ttportal/dashboard/service/dashboards_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardsBloc extends BaseBloc<DashboardsEvent, DashboardsState> {
  DashboardsBloc() : super(DashboardsInitial()) {
    // on<CreateDashboardEvent>(_onCreateDashboard);
    on<FetchDashboardsEvent>(_onFetchDashboards);
  }

  final DashboardsService service = DashboardsService();

  // Future<void> _onCreateDashboard(
  //   CreateDashboardEvent event,
  //   Emitter<DashboardsState> emit,
  // ) async {
  //   emit(
  //     DashboardsInProgress(),
  //   );
  //   try {
  //     final createdDashboard =
  //         await service.createDashboard(dashboard: event.dashboard);
  //     emit(
  //       DashboardsCreationSuccess(createdDashboard),
  //     );
  //   } on DioException catch (error) {
  //     _handleDioException(
  //       error,
  //       emit,
  //       (code) => emit(
  //         DashboardCreationError(code),
  //       ),
  //     );
  //   }
  // }

  Future<void> _onFetchDashboards(
      FetchDashboardsEvent event, Emitter<DashboardsState> emit) async {
    emit(DashboardsInProgress());
    try {
      final dashboards = await service.getDashboards(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      );
      emit(
        DashboardsFetchSuccess(dashboards),
      );
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(
          DashboardsFetchError(code),
        ),
      );
    }
  }

  void _handleDioException(
    DioException error,
    Emitter<DashboardsState> emit,
    Function(int) errorEmitter,
  ) {
    if (error.response?.statusCode == null ||
        error.response!.statusCode! >= 500 ||
        error.response?.data?['code'] == null) {
      emit(DashboardsCreationError(500));
    } else {
      errorEmitter(error.response!.data['code']);
    }
  }
}
