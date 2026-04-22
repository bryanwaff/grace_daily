import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/screens/home/home_screen.dart';
import 'package:grace_daily/screens/reflection/reflection_screen.dart';
import 'package:grace_daily/screens/prayer/prayer_screen.dart';
import 'package:grace_daily/screens/success/prayer_complete_screen.dart';

/// Manages all application routes using GoRouter.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home', // The application starts on the Home screen
    debugLogDiagnostics: true, // Good for development to see route changes

    routes: <RouteBase>[
      // The base /home route, representing the Daily Verse screen
      GoRoute(
        path: '/home',
        name: 'home', // Named route for easier navigation
        builder: (BuildContext context, GoRouterState state) {
          return const HomeScreen();
        },
        // Nested routes for the daily flow: Reflection, Prayer, Success
        routes: <RouteBase>[
          GoRoute(
            path: 'reflection', // Full path: /home/reflection
            name: 'reflection',
            builder: (BuildContext context, GoRouterState state) {
              return const ReflectionScreen();
            },
          ),
          GoRoute(
            path: 'prayer', // Full path: /home/prayer
            name: 'prayer',
            builder: (BuildContext context, GoRouterState state) {
              return const PrayerScreen();
            },
          ),
          GoRoute(
            path: 'success', // Full path: /home/success
            name: 'success',
            builder: (BuildContext context, GoRouterState state) {
              return const PrayerCompleteScreen();
            },
          ),
        ],
      ),
      // --- Example of other top-level routes (if needed in the future) ---
      // GoRoute(
      //   path: '/settings',
      //   name: 'settings',
      //   builder: (BuildContext context, GoRouterState state) => const SettingsScreen(),
      // ),
    ],

    // Optional: A custom error page for paths that don't match any route
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Oops! Page not found: ${state.uri.path}'),
      ),
    ),
  );
}