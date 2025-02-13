import 'package:cdbi/admin/admin_screen.dart';
import 'package:cdbi/companies/companies_screen.dart';
import 'package:cdbi/dashboard/dashboard_screen.dart';
import 'package:cdbi/home/home_screen.dart';
import 'package:cdbi/licenses/licenses_screen.dart';
import 'package:cdbi/login/login_screen.dart';
import 'package:cdbi/user/user_screen.dart';
import 'package:flutter/material.dart';

import 'landing_constants.dart';

class LandingRoutes {
  static Route<dynamic> generateRouteLanding(
    final RouteSettings settings,
  ) {
    switch (settings.name) {
      case rootRoute:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case loginRoute:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );
      case usersRoute:
        return MaterialPageRoute(
          builder: (_) => const UserScreen(),
        );
      case companiesRoute:
        return MaterialPageRoute(
          builder: (_) => const CompaniesScreen(),
        );
      case licensesRoute:
        return MaterialPageRoute(
          builder: (_) => const LicensesScreen(),
        );
      case dashboardsRoute:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No defined route for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
