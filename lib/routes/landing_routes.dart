import 'package:codename_ttportal/login/login_screen.dart';
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
