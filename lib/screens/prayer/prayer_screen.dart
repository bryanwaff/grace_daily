import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';
import 'package:grace_daily/theme/gdaily_typography.dart';

/// The prayer screen provides a space for users to write their prayers
/// and complete their daily grace routine.
class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final TextEditingController _prayerController = TextEditingController();

  @override
  void dispose() {
    _prayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prayer',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Share your heart with God',
                style: GdailyTypography.lightTextTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Write your prayers, praises, and petitions. God is listening.',
                style: GdailyTypography.lightTextTheme.bodyMedium?.copyWith(
                  color: GdailyColors.textMedium,
                ),
              ),
              const SizedBox(height: 32),

              // Suggested prayer starters
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prayer Starters:',
                        style: GdailyTypography.lightTextTheme.titleSmall?.copyWith(
                          color: GdailyColors.primaryOlive,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Thank God for His provision\n• Ask for guidance in your day\n• Pray for loved ones\n• Seek wisdom for decisions',
                        style: GdailyTypography.lightTextTheme.bodySmall?.copyWith(
                          color: GdailyColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: TextField(
                  controller: _prayerController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Write your prayer here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: GdailyTypography.lightTextTheme.bodyLarge,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.go('/home/reflection'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: GdailyTypography.lightTextTheme.labelLarge?.copyWith(
                          color: GdailyColors.primaryOlive,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => context.go('/home/success'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Complete',
                        style: GdailyTypography.lightTextTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
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
