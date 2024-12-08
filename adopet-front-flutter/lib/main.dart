import 'package:adopet/SignUpScreen.dart';
import 'package:adopet/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'DogDetailsScreen.dart';
import 'DogListScreen.dart';
import 'SignInScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/signin',
    routes: [
      GoRoute(
        path: '/signup',
        builder: (BuildContext context, GoRouterState state) {
          return SignUpScreen();
        },
      ),
      GoRoute(
        path: '/signin',
        builder: (BuildContext context, GoRouterState state) {
          return SignInScreen();
        },
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return DogListScreen();
        },
      ),
      GoRoute(
        path: '/dog/:id',
        builder: (BuildContext context, GoRouterState state) {
          final dogId = state.pathParameters['id'];

          if (dogId != null) {
            return DogDetailsScreen(dogId: dogId);
          } else {
            return Center(child: Text('Dog not found'));
          }
        },
      ),
    ],
  );
}
