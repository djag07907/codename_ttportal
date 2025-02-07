import 'package:codename_ttportal/companies/model/company_model.dart';
import 'package:equatable/equatable.dart';

sealed class CompanyEvent extends Equatable {
  const CompanyEvent();
  @override
  List<Object> get props => [];
}

class CreateCompanyEvent extends CompanyEvent {
  final Company company;
  const CreateCompanyEvent(this.company);

  @override
  List<Object> get props => [company];
}

class FetchCompaniesEvent extends CompanyEvent {
  final int pageNumber;
  final int pageSize;

  const FetchCompaniesEvent({
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}
