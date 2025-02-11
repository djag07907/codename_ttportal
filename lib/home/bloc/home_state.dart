part of 'home_bloc.dart';

sealed class HomeState extends BaseState {}

final class HomeInitial extends HomeState {}

final class HomeInProgress extends HomeState {}

final class HomeSuccess extends HomeState {
  final UserDetails user;

  HomeSuccess({
    required this.user,
  });
}

final class HomeError extends HomeState {
  final int? error;

  HomeError(
    this.error,
  );
}

final class HomeLoadInProgress extends HomeState {}

final class HomeLoadSuccess extends HomeState {}

class DashboardsFetchSuccess extends HomeState {
  final List<Dashboard> dashboard;

  DashboardsFetchSuccess(
    this.dashboard,
  );
}

class DashboardsFetchError extends HomeState {
  final int? error;

  DashboardsFetchError(
    this.error,
  );
}

class UserDetailsFetchSuccess extends HomeState {
  final String companyId;

  UserDetailsFetchSuccess(
    this.companyId,
  );
}

class LicenseExpiredError extends HomeState {}
