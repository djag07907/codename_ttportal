import 'package:codename_ttportal/companies/model/company_model.dart';

sealed class CompanyState {}

class CompanyInitial extends CompanyState {}

class CompanyOperationInProgress extends CompanyState {}

class CompanyCreationSuccess extends CompanyState {
  final Company company;
  CompanyCreationSuccess(this.company);
}

class CompanyCreationError extends CompanyState {
  final int? error;
  CompanyCreationError(this.error);
}

class CompaniesFetchSuccess extends CompanyState {
  final List<Company> companies;
  CompaniesFetchSuccess(
    this.companies,
  );
}

class CompaniesFetchError extends CompanyState {
  final int? error;
  CompaniesFetchError(this.error);
}
