import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:grace_daily/config/app_router.dart'; // Import our router
import 'package:grace_daily/theme/app_theme.dart'; // Our global theme
import 'package:grace_daily/core/providers/devotion_provider.dart';
import 'package:grace_daily/core/providers/journal_provider.dart';
import 'package:grace_daily/core/providers/user_progress_provider.dart';
import 'package:grace_daily/core/providers/community_provider.dart';

class GraceDailyApp extends StatelessWidget {
  const GraceDailyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // State management providers
        ChangeNotifierProvider<DevotionProvider>(
          create: (_) => DevotionProvider()..initializeDevotions(),
        ),
        ChangeNotifierProvider<JournalProvider>(
          create: (_) => JournalProvider()..loadAllEntries(),
        ),
        ChangeNotifierProvider<UserProgressProvider>(
          create: (_) => UserProgressProvider()..initializeProgress(),
        ),
        ChangeNotifierProvider<CommunityProvider>(
          create: (_) => CommunityProvider(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Grace Daily',
        theme: AppTheme.lightTheme, // Applying our Lumen Grace theme
        darkTheme: AppTheme.darkTheme, // Applying our dark mode theme
        themeMode: ThemeMode.system, // Automatically adapt to system preferences
        routerConfig: AppRouter.router, // This connects GoRouter to the app
        debugShowCheckedModeBanner: false, // Hide the debug banner
      ),
    );
  }
}