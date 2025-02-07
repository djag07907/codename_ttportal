import 'package:equatable/equatable.dart';
import 'package:codename_ttportal/licenses/model/license_model.dart';

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

  @override
  List<Object> get props => [license];
}

class FetchLicensesEvent extends LicensesEvent {
  final int pageNumber;
  final int pageSize;
  const FetchLicensesEvent({
    this.pageNumber = 1,
    this.pageSize = 10,
  });

  // @override
  // List<Object> get props => [pageNumber, pageSize];
}
