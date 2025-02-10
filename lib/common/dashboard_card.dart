import 'package:codename_ttportal/home/model/dashboard_model.dart';
import 'package:flutter/material.dart';
import 'package:codename_ttportal/common/powerbi_dashboard.dart';

class DashboardCard extends StatelessWidget {
  final Dashboard dashboard;

  const DashboardCard({
    super.key,
    required this.dashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PowerBIDashboard(
                dashboard: dashboard,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.dashboard,
                size: 48,
                color: Colors.blue[900],
              ),
              const SizedBox(height: 8),
              Text(
                dashboard.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                dashboard.dashboardCode,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
