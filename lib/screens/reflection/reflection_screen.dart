import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/core/utils/image_strings.dart';
import 'package:grace_daily/core/widgets/bottom_nav_bar.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';
import 'package:grace_daily/theme/gdaily_typography.dart';

/// The reflection screen displays daily devotion content including
/// the verse, meditation text, and thought for the day.
class ReflectionScreen extends StatelessWidget {
  const ReflectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GdailyColors.neutralLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // --- Top Bar with Date ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded),
                            color: GdailyColors.primaryOlive,
                            onPressed: () => context.go('/home'),
                          ),
                          Text(
                            _getCurrentDate(),
                            style: GdailyTypography.lightTextTheme.titleMedium?.copyWith(
                              fontFamily: 'Newsreader',
                              fontStyle: FontStyle.italic,
                              color: GdailyColors.primaryOlive,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert_rounded),
                            color: GdailyColors.primaryOlive,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // --- Verse Section ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Text(
                            '"Be still, and know that I am God"',
                            style: GdailyTypography.lightTextTheme.headlineSmall?.copyWith(
                              fontFamily: 'Newsreader',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'PSALM 46:10',
                            style: GdailyTypography.lightTextTheme.labelSmall?.copyWith(
                              color: GdailyColors.textLight,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // --- Image Section ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: AspectRatio(
                          aspectRatio: 1.3,
                          child: Image.asset(
                            GdailyImages.homeIntro,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // --- Content Section ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'The Gift of Quiet',
                            style: GdailyTypography.lightTextTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: GdailyColors.primaryOlive,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'In a world that demands our constant attention, stillness feels almost rebellious. We are conditioned to equate productivity with worth, yet the most profound growth happens in quiet spaces wherever our effort.',
                            style: GdailyTypography.lightTextTheme.bodyMedium?.copyWith(
                              color: GdailyColors.textMedium,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // --- Quote Section ---
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: GdailyColors.dividerLight,
                              ),
                            ),
                            child: Text(
                              '"Stillness is not the absence of energy, but the absence of friction in it."',
                              style: GdailyTypography.lightTextTheme.bodyLarge?.copyWith(
                                fontFamily: 'Newsreader',
                                fontStyle: FontStyle.italic,
                                color: GdailyColors.textDark,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'When we stop trying to control every moment, we create space for deeper meditation. Notice how isn\'t about clearing the mind, but about the realization that this universe is held by something greater than our self.',
                            style: GdailyTypography.lightTextTheme.bodyMedium?.copyWith(
                              color: GdailyColors.textMedium,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // --- Thought for Your Day Section ---
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24.0),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0E4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'A Thought for Your Day',
                            style: GdailyTypography.lightTextTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: GdailyColors.primaryOlive,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Take one intentional pause today. Notice what happens when you resist the urge to fill the silence.',
                            style: GdailyTypography.lightTextTheme.bodyMedium?.copyWith(
                              color: GdailyColors.textDark,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    // --- Button Section ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: ElevatedButton(
                        onPressed: () => context.go('/home/prayer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GdailyColors.primaryOlive,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: Text(
                          'See Reflection',
                          style: GdailyTypography.lightTextTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            BottomNavBar(currentRoute: 'reflection'),
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
