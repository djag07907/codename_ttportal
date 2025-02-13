import 'dart:io' show Platform;
import 'package:cdbi/resources/colors.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cdbi/routes/landing_constants.dart';
import 'package:cdbi/routes/landing_routes.dart';
import 'package:cdbi/login/login_screen.dart';
import 'package:internationalization/internationalization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String locale;
  if (kIsWeb) {
    locale = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  } else {
    locale = Platform.localeName.split('_').first;
  }

  runApp(
    MyApp(
      routeList: await _getRouteList(),
      initialRouteName: await _getInitialRoute(),
      language: locale,
    ),
  );
}

Future<Route<dynamic> Function(RouteSettings settings)> _getRouteList() async =>
    LandingRoutes.generateRouteLanding;

Future<String> _getInitialRoute() async {
  return rootRoute;
}

class MyApp extends StatelessWidget {
  final Route<dynamic> Function(RouteSettings settings) routeList;
  final String initialRouteName;
  final String language;

  const MyApp({
    super.key,
    required this.routeList,
    required this.initialRouteName,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Control Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: white,
        appBarTheme: const AppBarTheme(
          backgroundColor: tectransblue,
          foregroundColor: white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: tectransblue,
            foregroundColor: white,
          ),
        ),
      ),
      initialRoute: initialRouteName,
      onGenerateRoute: routeList,
      supportedLocales: _supportedLocales(),
      localizationsDelegates: [
        InternationalizationDelegate(
          suportedLocales: _supportedLocales(),
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeListResolutionCallback: (locale, supportedLocales) {
        if (language.isEmpty) {
          return _supportedLocales().first;
        }
        return _supportedLocales().firstWhere(
          (loc) => loc.languageCode == language,
          orElse: () => _supportedLocales().first,
        );
      },
      home: const LoginScreen(),
    );
  }
}

List<Locale> _supportedLocales() {
  return const <Locale>[
    Locale('es'),
    Locale('en'),
  ];
}
