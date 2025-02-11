part of 'home_bloc.dart';

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

class FetchUserDetailsById extends HomeEvent {
  final String userId;

  const FetchUserDetailsById(
    this.userId,
  );
}
