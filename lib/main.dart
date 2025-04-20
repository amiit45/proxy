import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_state.dart';
import 'core/services/service_locator.dart';
import 'routes.dart';

void main() {
  // Initialize service locator
  setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => getIt<AppState>(),
        ),
      ],
      child: ProximityApp(),
    ),
  );
}

class ProximityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proximity Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: Routes.auth,
      routes: appRoutes,
    );
  }
}