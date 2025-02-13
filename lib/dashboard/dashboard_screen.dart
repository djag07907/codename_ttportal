import 'package:cdbi/dashboard/bloc/dashboards_bloc.dart';
import 'package:cdbi/dashboard/widget/dashboard_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DashboardsBloc(),
      child: const DashboardBody(),
    );
  }
}
