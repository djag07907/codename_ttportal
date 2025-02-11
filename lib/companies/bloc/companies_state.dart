part of 'companies_bloc.dart';

sealed class CompanyState extends BaseState {}

class CompanyInitial extends CompanyState {}

class CompanyInProgress extends CompanyState {}

class CompanyCreationSuccess extends CompanyState {
  final Company company;

  CompanyCreationSuccess(
    this.company,
  );
}

class CompanyCreationError extends CompanyState {
  final int? error;

  CompanyCreationError(
    this.error,
  );
}

class CompaniesFetchSuccess extends CompanyState {
  final List<Company> companies;

  CompaniesFetchSuccess(
    this.companies,
  );
}

class CompaniesFetchError extends CompanyState {
  final int? error;

  CompaniesFetchError(
    this.error,
  );
}
