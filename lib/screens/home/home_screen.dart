import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/core/utils/image_strings.dart';
import 'package:grace_daily/core/widgets/bottom_nav_bar.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';
import 'package:grace_daily/theme/gdaily_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GdailyColors.neutralLight,
      body: SafeArea(
        child: Column(
          children: [
            // --- Custom Top Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        _getCurrentDate(),
                        style: GdailyTypography.lightTextTheme.titleLarge?.copyWith(
                          fontFamily: 'Newsreader',
                          fontStyle: FontStyle.italic,
                          color: GdailyColors.primaryOlive,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // --- Main Content ---
            Expanded(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Background image card
                  Positioned(
                    top: 0,
                    left: 24,
                    right: 24,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: AspectRatio(
                        aspectRatio: 1.6,
                        child: Image.asset(
                          GdailyImages.homeIntro,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Overlapping verse card
                  Positioned(
                    top: 160,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'VERSE OF THE DAY',
                                    style: GdailyTypography.lightTextTheme.labelMedium?.copyWith(
                                      color: GdailyColors.textLight,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.share_rounded, size: 20),
                                    color: GdailyColors.primaryOlive,
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '"For I know the plans I have for you,"\ndeclares the LORD,\n"plans to prosper you and not to harm you,\nplans to give you hope and a future."',
                                style: GdailyTypography.lightTextTheme.headlineSmall?.copyWith(
                                  fontFamily: 'Newsreader',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Jeremiah 29:11',
                                style: GdailyTypography.lightTextTheme.titleMedium?.copyWith(
                                  color: GdailyColors.primaryOlive,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context.go('/home/reflection'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: GdailyColors.primaryOlive,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  minimumSize: const Size(double.infinity, 48),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Start Devotion',
                                      style: GdailyTypography.lightTextTheme.labelLarge?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_rounded, size: 20, color: Colors.white),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // --- Bottom Navigation Bar ---
            BottomNavBar(currentRoute: 'home'),
          ],
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
    return '${now.day} ${months[now.month - 1]}';
  }
}

