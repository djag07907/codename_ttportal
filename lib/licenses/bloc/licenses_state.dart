import 'package:codename_ttportal/licenses/model/company_model.dart';
import 'package:codename_ttportal/licenses/model/license_model.dart';

sealed class LicensesState {}

class LicensesInitial extends LicensesState {}

class LicensesInProgress extends LicensesState {}

class LicenseCreationSuccess extends LicensesState {
  final List<License> licenses;
  LicenseCreationSuccess(
    this.licenses,
  );
}

class LicenseCreationError extends LicensesState {
  final int? error;
  LicenseCreationError(
    this.error,
  );
}

class LicenseFetchSuccess extends LicensesState {
  final LicensesData licensesData;
  LicenseFetchSuccess(
    this.licensesData,
  );
}

class LicenseFetchError extends LicensesState {
  final int? error;
  LicenseFetchError(
    this.error,
  );
}

class CompaniesFetchSuccess extends LicensesState {
  final List<Company> companies;

  CompaniesFetchSuccess(
    this.companies,
  );
}

class CompaniesFetchError extends LicensesState {
  final int? error;

  CompaniesFetchError(
    this.error,
  );
}
