import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';
import 'package:grace_daily/theme/gdaily_typography.dart';

/// The reflection screen allows users to write their thoughts and reflections
/// on the daily verse before proceeding to prayer.
class ReflectionScreen extends StatefulWidget {
  const ReflectionScreen({super.key});

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final TextEditingController _reflectionController = TextEditingController();

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reflection',
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
                'What speaks to you from today\'s verse?',
                style: GdailyTypography.lightTextTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'Take a moment to reflect on Psalm 23:1 and how it relates to your life today.',
                style: GdailyTypography.lightTextTheme.bodyMedium?.copyWith(
                  color: GdailyColors.textMedium,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: TextField(
                  controller: _reflectionController,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'Write your reflections here...',
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
                      onPressed: () => context.go('/home'),
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
                      onPressed: () => context.go('/home/prayer'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Continue to Prayer',
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
