import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';
import 'package:grace_daily/theme/gdaily_typography.dart';

/// The home screen displays the daily verse/devotion and provides navigation
/// to the reflection screen to begin the daily grace routine.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grace Daily',
          style: GdailyTypography.lightTextTheme.titleLarge,
        ),
        backgroundColor: GdailyColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Date display
              Text(
                _getCurrentDate(),
                style: GdailyTypography.lightTextTheme.titleMedium?.copyWith(
                  color: GdailyColors.textMedium,
                ),
              ),
              const SizedBox(height: 32),

              // Daily verse title
              Text(
                'Daily Verse',
                style: GdailyTypography.lightTextTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Verse content in a card
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Bible reference
                        Text(
                          'Psalm 23:1',
                          style: GdailyTypography.lightTextTheme.titleMedium?.copyWith(
                            color: GdailyColors.primaryOlive,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Verse text
                        Text(
                          '"The Lord is my shepherd, I lack nothing. He makes me lie down in green pastures, he leads me beside quiet waters, he refreshes my soul."',
                          style: GdailyTypography.lightTextTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // Inspirational message
                        Text(
                          'Take a moment to reflect on God\'s provision and care in your life today.',
                          style: GdailyTypography.lightTextTheme.bodyMedium?.copyWith(
                            color: GdailyColors.textMedium,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Continue button
              ElevatedButton(
                onPressed: () => context.go('/home/reflection'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Begin Reflection',
                  style: GdailyTypography.lightTextTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}
