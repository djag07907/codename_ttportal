import 'package:codename_ttportal/common/bloc/base_bloc.dart';
import 'package:codename_ttportal/companies/bloc/companies_event.dart';
import 'package:codename_ttportal/companies/bloc/companies_state.dart';
import 'package:codename_ttportal/companies/service/companies_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompanyBloc extends BaseBloc<CompanyEvent, CompanyState> {
  CompanyBloc() : super(CompanyInitial()) {
    on<CreateCompanyEvent>(_onCreateCompany);
    on<FetchCompaniesEvent>(_onFetchCompanies);
  }

  final CompanyService service = CompanyService();

  Future<void> _onCreateCompany(
      CreateCompanyEvent event, Emitter<CompanyState> emit) async {
    emit(CompanyOperationInProgress());
    try {
      final createdCompany =
          await service.createCompany(company: event.company);
      emit(CompanyCreationSuccess(createdCompany));
    } on DioException catch (error) {
      _handleDioException(
        error,
        emit,
        (code) => emit(
          CompanyCreationError(code),
        ),
      );
    }
  }

  Future<void> _onFetchCompanies(
      FetchCompaniesEvent event, Emitter<CompanyState> emit) async {
    emit(CompanyOperationInProgress());
    try {
      final companies = await service.getCompanies(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      );
      emit(CompaniesFetchSuccess(companies));
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

  void _handleDioException(
    DioException error,
    Emitter<CompanyState> emit,
    Function(int) errorEmitter,
  ) {
    if (error.response?.statusCode == null ||
        error.response!.statusCode! >= 500 ||
        error.response?.data?['code'] == null) {
      emit(CompanyCreationError(500));
    } else {
      errorEmitter(error.response!.data['code']);
    }
  }
}
