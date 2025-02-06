import 'package:flutter/material.dart';
import 'package:codename_ttportal/login/model/user.dart';
import 'package:codename_ttportal/common/dashboard_card.dart';
import 'package:codename_ttportal/dashboard/model/dashboard_model.dart';
import 'package:codename_ttportal/login/login_screen.dart';

final List<Dashboard> mockDashboards = [
  Dashboard(
    id: '1',
    name: 'Sales Overview',
    codename: 'SALES',
    link: 'https://example.com/sales',
  ),
  Dashboard(
    id: '2',
    name: 'Inventory Management',
    codename: 'INVENTORY',
    link: 'https://example.com/inventory',
  ),
  Dashboard(
    id: '3',
    name: 'Customer Insights',
    codename: 'CUSTOMER',
    link: 'https://example.com/customer',
  ),
  Dashboard(
    id: '4',
    name: 'Marketing Analytics',
    codename: 'MARKETING',
    link: 'https://example.com/marketing',
  ),
];

class HomeBody extends StatelessWidget {
  final User user;

  HomeBody({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final dashboards = mockDashboards
        .where((dashboard) => user.assignedDashboardIds.contains(dashboard.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${user.userName}'),
        backgroundColor: Colors.blue[900],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
          ),
        ],
      ),
      body: dashboards.isEmpty
          ? const Center(
              child: Text('No dashboards available for your account.'),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: dashboards.length,
                itemBuilder: (context, index) {
                  return DashboardCard(dashboard: dashboards[index]);
                },
              ),
            ),
    );
  }
}
