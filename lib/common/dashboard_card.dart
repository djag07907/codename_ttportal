import 'package:codename_ttportal/common/powerbi_dashboard.dart';
import 'package:codename_ttportal/dashboard/model/dashboard_model.dart';
import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final Dashboard dashboard;

  const DashboardCard({
    super.key,
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PowerBIDashboard(dashboard: dashboard),
            ),
          );
        },
        child: Column(
          children: [
            Text(dashboard.name),
            Text(dashboard.codename),
          ],
        ),
      ),
    );
  }
}
