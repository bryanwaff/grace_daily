import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';
import 'package:grace_daily/theme/gdaily_typography.dart';

/// The prayer complete screen shows a success message and allows users
/// to return to the home screen or view their completed routine.
class PrayerCompleteScreen extends StatelessWidget {
  const PrayerCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Complete',
          style: GdailyTypography.lightTextTheme.titleLarge,
        ),
        backgroundColor: GdailyColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove back button
      ),
      body: SafeArea(
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
                  color: GdailyColors.primaryOlive.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 60,
                  color: GdailyColors.primaryOlive,
                ),
              ),

              const SizedBox(height: 32),

              // Success message
              Text(
                'Well Done!',
                style: GdailyTypography.lightTextTheme.displaySmall?.copyWith(
                  color: GdailyColors.primaryOlive,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                'You have completed your daily grace routine.',
                style: GdailyTypography.lightTextTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Encouraging message
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        '"The Lord bless you and keep you; the Lord make his face shine on you and be gracious to you; the Lord turn his face toward you and give you peace."',
                        style: GdailyTypography.lightTextTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Numbers 6:24-26',
                        style: GdailyTypography.lightTextTheme.titleSmall?.copyWith(
                          color: GdailyColors.primaryOlive,
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
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Return Home',
                      style: GdailyTypography.lightTextTheme.labelLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  OutlinedButton(
                    onPressed: () {
                      // TODO: Navigate to history/progress screen when implemented
                      context.go('/home');
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'View Progress',
                      style: GdailyTypography.lightTextTheme.labelLarge?.copyWith(
                        color: GdailyColors.primaryOlive,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
