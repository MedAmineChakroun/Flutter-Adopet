import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'DogDetailsScreen.dart';
import 'DogListScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return DogListScreen();
        },
      ),
      GoRoute(
        path: '/dog/:id',
        builder: (BuildContext context, GoRouterState state) {
          final dogId = state.pathParameters['id']!;
          return DogDetailsScreen(dogId: int.parse(dogId));
        },
      ),
    ],
  );
}
