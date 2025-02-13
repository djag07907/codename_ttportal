import 'package:cdbi/common/bloc/base_bloc.dart';
import 'package:cdbi/common/bloc/base_state.dart';
import 'package:cdbi/companies/model/company_model.dart';
import 'package:cdbi/companies/service/companies_service.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'companies_event.dart';
part 'companies_state.dart';

class CompanyBloc extends BaseBloc<CompanyEvent, BaseState> {
  final CompanyService service = CompanyService();

  CompanyBloc() : super(CompanyInitial()) {
    on<CreateCompanyEvent>(_onCreateCompany);
    on<FetchCompaniesEvent>(_onFetchCompanies);
  }

  Future<void> _onCreateCompany(
    CreateCompanyEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      CompanyInProgress(),
    );
    try {
      final createdCompany = await service.createCompany(
        company: event.company,
      );
      emit(
        CompanyCreationSuccess(
          createdCompany,
        ),
      );
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
    FetchCompaniesEvent event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      CompanyInProgress(),
    );
    try {
      final companies = await service.getCompanies(
        pageNumber: event.pageNumber,
        pageSize: event.pageSize,
      );
      emit(
        CompaniesFetchSuccess(companies),
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
