part of 'licenses_bloc.dart';

sealed class LicensesEvent extends Equatable {
  const LicensesEvent();
  @override
  List<Object> get props => [];
}

class CreateLicenseEvent extends LicensesEvent {
  final License license;

  const CreateLicenseEvent(
    this.license,
  );
}

class FetchLicensesEvent extends LicensesEvent {
  final int pageNumber;
  final int pageSize;

  const FetchLicensesEvent({
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}

class FetchCompaniesEvent extends LicensesEvent {
  final int pageNumber;
  final int pageSize;

  const FetchCompaniesEvent({
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}
