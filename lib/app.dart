import 'package:flutter/material.dart';
import 'package:grace_daily/config/app_router.dart'; // Import our router
import 'package:grace_daily/theme/app_theme.dart'; // Our global theme

class GraceDailyApp extends StatelessWidget {
  const GraceDailyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Grace Daily',
      theme: AppTheme.lightTheme, // Applying our Lumen Grace theme
      routerConfig: AppRouter.router, // This connects GoRouter to the app
      debugShowCheckedModeBanner: false, // Hide the debug banner
    );
  }
}