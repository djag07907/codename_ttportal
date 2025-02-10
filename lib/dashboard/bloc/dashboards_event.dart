import 'package:codename_ttportal/dashboard/model/dashboard_model.dart';
import 'package:equatable/equatable.dart';

sealed class DashboardsEvent extends Equatable {
  const DashboardsEvent();

  @override
  List<Object> get props => [];
}

class CreateDashboardEvent extends DashboardsEvent {
  final Dashboard dashboard;
  const CreateDashboardEvent(this.dashboard);
}

class FetchDashboardsEvent extends DashboardsEvent {
  final int pageNumber;
  final int pageSize;
  const FetchDashboardsEvent({
    this.pageNumber = 1,
    this.pageSize = 10,
  });
}
