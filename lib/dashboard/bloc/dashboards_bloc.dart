import 'package:cdbi/common/bloc/base_bloc.dart';
import 'package:cdbi/common/bloc/base_state.dart';
import 'package:cdbi/dashboard/model/dashboard_model.dart';
import 'package:cdbi/dashboard/service/dashboards_service.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboards_event.dart';
part 'dashboards_state.dart';

class DashboardsBloc extends BaseBloc<DashboardsEvent, BaseState> {
  final DashboardsService service = DashboardsService();

  DashboardsBloc() : super(DashboardsInitial()) {
    on<FetchDashboardsEvent>(_onFetchDashboards);
  }

  Future<void> _onFetchDashboards(
    FetchDashboardsEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      DashboardsInProgress(),
    );
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
    Emitter<BaseState> emit,
    Function(int) errorEmitter,
  ) {
    if (error.response?.statusCode == null ||
        error.response!.statusCode! >= 500 ||
        error.response?.data?['code'] == null) {
      emit(
        ServerClientError(),
      );
    } else {
      errorEmitter(error.response!.data['code']);
    }
  }
}
