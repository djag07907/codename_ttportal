import 'package:codename_ttportal/common/bloc/base_bloc.dart';
import 'package:codename_ttportal/common/bloc/base_state.dart';
import 'package:codename_ttportal/licenses/model/company_model.dart';
import 'package:codename_ttportal/licenses/model/license_model.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:codename_ttportal/licenses/service/licenses_service.dart';

part 'licenses_event.dart';
part 'licenses_state.dart';

class LicensesBloc extends BaseBloc<LicensesEvent, BaseState> {
  final LicensesService service = LicensesService();

  LicensesBloc() : super(LicensesInitial()) {
    on<CreateLicenseEvent>(_onCreateLicense);
    on<FetchLicensesEvent>(_onFetchLicenses);
    on<FetchCompaniesEvent>(_onFetchCompanies);
  }

  Future<void> _onCreateLicense(
    CreateLicenseEvent event,
    Emitter<BaseState> emit,
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
    FetchCompaniesEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      LicensesInProgress(),
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

  Future<void> _onFetchLicenses(
    FetchLicensesEvent event,
    Emitter<BaseState> emit,
  ) async {
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
