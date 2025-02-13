import 'package:cdbi/companies/companies_screen.dart';
import 'package:cdbi/dashboard/dashboard_screen.dart';
import 'package:cdbi/licenses/licenses_screen.dart';
import 'package:cdbi/login/login_screen.dart';
import 'package:cdbi/repository/user_repository.dart';
import 'package:cdbi/resources/colors.dart';
import 'package:cdbi/resources/constants.dart';
import 'package:cdbi/user/user_screen.dart';
import 'package:flutter/material.dart';

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
            color: tectransblue,
            child: Column(
              children: [
                Container(
                  color: white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      '${imagePath}logo.png',
                      height: 80,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                        icon: const Icon(
                          Icons.logout,
                          color: tectransblue,
                        ),
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }
}
