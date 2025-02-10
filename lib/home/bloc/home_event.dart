import 'package:equatable/equatable.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class FetchDashboardsByCompanyId extends HomeEvent {
  final String companyId;

  const FetchDashboardsByCompanyId(
    this.companyId,
  );
}
