import 'package:codename_ttportal/dashboard/model/dashboard_model.dart';

sealed class DashboardsState {}

class DashboardsInitial extends DashboardsState {}

class DashboardsInProgress extends DashboardsState {}

class DashboardsCreationSuccess extends DashboardsState {
  final Dashboard dashboard;
  DashboardsCreationSuccess(this.dashboard);
}

class DashboardsCreationError extends DashboardsState {
  final int? error;
  DashboardsCreationError(this.error);
}

class DashboardsFetchSuccess extends DashboardsState {
  final List<Dashboard> dashboard;
  DashboardsFetchSuccess(this.dashboard);
}

class DashboardsFetchError extends DashboardsState {
  final int? error;
  DashboardsFetchError(this.error);
}
