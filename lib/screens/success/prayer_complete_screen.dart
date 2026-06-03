import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/core/widgets/bottom_nav_bar.dart';

/// The prayer complete screen shows a success message and allows users
/// to return to the home screen or view their completed routine.
class PrayerCompleteScreen extends StatelessWidget {
  const PrayerCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Success icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check_circle,
                          size: 60,
                          color: theme.colorScheme.primary,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Success message
                      Text(
                        'Well Done!',
                        style: theme.textTheme.displaySmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'You have completed your daily grace routine.',
                        style: theme.textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // Encouraging message
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        color: theme.cardTheme.color,
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                '"The Lord bless you and keep you; the Lord make his face shine on you and be gracious to you; the Lord turn his face toward you and give you peace."',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Numbers 6:24-26',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // Action buttons
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () => context.go('/home'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Return Home',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          OutlinedButton(
                            onPressed: () {
                              context.go('/home/progress');
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                              foregroundColor: theme.colorScheme.primary,
                              minimumSize: const Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'View Progress',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            BottomNavBar(currentRoute: 'prayer'),
          ],
        ),
      ),
    );
  }
}
