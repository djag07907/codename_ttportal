import 'package:codename_ttportal/common/dashboard_card.dart';
import 'package:codename_ttportal/dashboard/model/dashboard_model.dart';
import 'package:codename_ttportal/login/login_screen.dart';
import 'package:codename_ttportal/services/local_storage.dart';
import 'package:codename_ttportal/user/model/user_model.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  final User user;
  final LocalStorageService _storageService = LocalStorageService();

  HomeBody({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hello ${user.email}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Dashboard>>(
        future: _storageService.getDashboards(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          final dashboards = snapshot.data!
              .where((dashboard) =>
                  user.assignedDashboardIds.contains(dashboard.id))
              .toList();
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemCount: dashboards.length,
            itemBuilder: (context, index) {
              return DashboardCard(dashboard: dashboards[index]);
            },
          );
        },
      ),
    );
  }
}
