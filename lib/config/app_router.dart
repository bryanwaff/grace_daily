import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/screens/bookmarks/bookmarks_screen.dart';
import 'package:grace_daily/screens/home/home_screen.dart';
import 'package:grace_daily/screens/reflection/reflection_screen.dart';
import 'package:grace_daily/screens/prayer/prayer_screen.dart';
import 'package:grace_daily/screens/success/prayer_complete_screen.dart';
import 'package:grace_daily/screens/progress/progress_screen.dart';

/// Manages all application routes using GoRouter with custom transitions.
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,

    routes: <RouteBase>[
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomeScreen(),
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'reflection',
            name: 'reflection',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ReflectionScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                );
              },
            ),
          ),
          GoRoute(
            path: 'prayer',
            name: 'prayer',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const PrayerScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                  child: child,
                );
              },
            ),
          ),
          GoRoute(
            path: 'success',
            name: 'success',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const PrayerCompleteScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return ScaleTransition(
                  scale: CurveTween(curve: Curves.elasticOut).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
            ),
          ),
          GoRoute(
            path: 'progress',
            name: 'progress',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const ProgressScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(CurveTween(curve: Curves.easeOut).animate(animation)),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
            ),
          ),
          GoRoute(
            path: 'bookmarks',
            name: 'bookmarks',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const BookmarksScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurveTween(curve: Curves.easeOutCubic).animate(animation)),
                  child: child,
                );
              },
            ),
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Text('Oops! Page not found: ${state.uri.path}'),
      ),
    ),
  );
}
