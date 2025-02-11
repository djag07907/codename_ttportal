import 'package:codename_ttportal/companies/companies_screen.dart';
import 'package:codename_ttportal/licenses/licenses_screen.dart';
import 'package:codename_ttportal/repository/user_repository.dart';
import 'package:codename_ttportal/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:codename_ttportal/dashboard/dashboard_screen.dart';
import 'package:codename_ttportal/user/user_screen.dart';
import 'package:codename_ttportal/login/login_screen.dart';

class AdminBody extends StatefulWidget {
  final String userName;

  const AdminBody({
    super.key,
    required this.userName,
  });

  @override
  _AdminBodyState createState() => _AdminBodyState();
}

class _AdminBodyState extends State<AdminBody> {
  Widget _currentContent = const Center(
    child: Text(
      'Select an option from the menu',
      style: TextStyle(
        fontSize: 18,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.blue[900],
            child: Column(
              children: [
                Container(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 80,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(
                    Icons.people,
                    color: white,
                  ),
                  title: const Text(
                    'Manage Users',
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                  onTap: () => setState(
                    () => _currentContent = const UserScreen(),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.business_center,
                    color: white,
                  ),
                  title: const Text(
                    'Manage Companies',
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                  onTap: () => setState(
                    () => _currentContent = const CompaniesScreen(),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.phonelink_setup,
                    color: white,
                  ),
                  title: const Text(
                    'Manage Licenses',
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                  onTap: () => setState(
                    () => _currentContent = const LicensesScreen(),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.dashboard,
                    color: white,
                  ),
                  title: const Text(
                    'Manage Dashboards',
                    style: TextStyle(
                      color: white,
                    ),
                  ),
                  onTap: () => setState(
                    () => _currentContent = const DashboardScreen(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 60,
                  color: white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Text(
                          'Welcome, ${widget.userName}',
                          style: const TextStyle(
                            color: black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.logout, color: Colors.blue[900]),
                        onPressed: () => _logout(context),
                      ),
                    ],
                  ),
                ),
                Expanded(child: _currentContent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    final userRepository = UserRepository();
    await userRepository.clear();
    print('User data cleared successfully.');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
