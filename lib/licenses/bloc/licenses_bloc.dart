import 'package:codename_ttportal/common/bloc/base_bloc.dart';
import 'package:codename_ttportal/licenses/bloc/licenses_event.dart';
import 'package:codename_ttportal/licenses/bloc/licenses_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codename_ttportal/licenses/service/licenses_service.dart';

class LicensesBloc extends BaseBloc<LicensesEvent, LicensesState> {
  LicensesBloc() : super(LicensesInitial()) {
    on<CreateLicenseEvent>(_onCreateLicense);
    on<FetchLicensesEvent>(_onFetchLicenses);
    on<FetchCompaniesEvent>(_onFetchCompanies);
  }

  final LicensesService service = LicensesService();

  Future<void> _onCreateLicense(
    CreateLicenseEvent event,
    Emitter<LicensesState> emit,
  ) async {
    emit(
      LicensesInProgress(),
    );
    try {
      final createdLicenses =
          await service.createLicense(license: event.license);
      emit(
        LicenseCreationSuccess(createdLicenses),
      );
      emit(
        LicensesInProgress(),
      );
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(
          LicenseCreationError(code),
        ),
      );
    }
  }

  Future<void> _onFetchCompanies(
      FetchCompaniesEvent event, Emitter<LicensesState> emit) async {
    emit(LicensesInProgress());
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

  Future<void> _onFetchLicenses(
      FetchLicensesEvent event, Emitter<LicensesState> emit) async {
    emit(
      LicensesInProgress(),
    );
    try {
      // IMLPEMENT LICENSES FETCH
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(
          LicenseFetchError(code),
        ),
      );
    }
  }

  void _handleDioException(
    DioException error,
    Emitter<LicensesState> emit,
    Function(int) errorEmitter,
  ) {
    if (error.response?.statusCode == null ||
        error.response!.statusCode! >= 500 ||
        error.response?.data?['code'] == null) {
      emit(
        LicenseCreationError(500),
      );
    } else {
      errorEmitter(error.response!.data['code']);
    }
  }
}
