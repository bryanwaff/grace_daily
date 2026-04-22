import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/core/utils/image_strings.dart';
import 'package:grace_daily/core/widgets/bottom_nav_bar.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';
import 'package:grace_daily/theme/gdaily_typography.dart';

/// The prayer screen provides a space for users to engage with a daily intention,
/// mark prayers, and add personal reflections.
class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  final TextEditingController _reflectionController = TextEditingController();
  bool _marked = false;

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GdailyColors.neutralLight,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Header ---
                      Text(
                        'THE DAILY INTENTION',
                        style: GdailyTypography.lightTextTheme.labelSmall?.copyWith(
                          color: GdailyColors.textLight,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Finding Stillness',
                        style: GdailyTypography.lightTextTheme.headlineSmall?.copyWith(
                          fontFamily: 'Newsreader',
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w600,
                          color: GdailyColors.primaryOlive,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Prayer Text ---
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '"Lord, in the quiet of this moment, I surrender the noise of my day. Grant me the grace to see Your hand in the small things, and the patience to wait for Your whisper in the storm."',
                              style: GdailyTypography.lightTextTheme.bodyLarge?.copyWith(
                                fontFamily: 'Newsreader',
                                fontStyle: FontStyle.italic,
                                height: 1.8,
                                color: GdailyColors.textDark,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'A Heart\'s Plea',
                              style: GdailyTypography.lightTextTheme.bodySmall?.copyWith(
                                color: GdailyColors.textMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Mark as Prayed Button ---
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _marked = !_marked;
                            });
                          },
                          icon: Icon(
                            _marked ? Icons.check_circle : Icons.circle_outlined,
                            size: 20,
                          ),
                          label: Text(
                            _marked ? 'Marked as Prayed' : 'Mark as Prayed',
                            style: GdailyTypography.lightTextTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GdailyColors.primaryOlive,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Join Counter ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '5,620 others joined in this prayer today',
                            style: GdailyTypography.lightTextTheme.bodySmall?.copyWith(
                              color: GdailyColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // --- Personal Reflections Section ---
                      Text(
                        'Personal Reflections',
                        style: GdailyTypography.lightTextTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: GdailyColors.primaryOlive,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 120,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: GdailyColors.dividerLight,
                          ),
                        ),
                        child: TextField(
                          controller: _reflectionController,
                          maxLines: null,
                          expands: true,
                          decoration: InputDecoration(
                            hintText: 'Write your heart here...',
                            hintStyle: GdailyTypography.lightTextTheme.bodyMedium?.copyWith(
                              color: GdailyColors.textLight,
                            ),
                            border: InputBorder.none,
                          ),
                          style: GdailyTypography.lightTextTheme.bodyMedium,
                          textAlignVertical: TextAlignVertical.top,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // --- Save Button ---
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: const BorderSide(
                              color: GdailyColors.primaryOlive,
                            ),
                          ),
                          child: Text(
                            'Save to Journal',
                            style: GdailyTypography.lightTextTheme.labelLarge?.copyWith(
                              color: GdailyColors.primaryOlive,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Ambient Soundscape Section ---
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(GdailyImages.homeIntro),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 120,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black.withValues(alpha: 0.3),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.volume_up_rounded,
                                  color: GdailyColors.primaryOlive,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'AMBIENT SOUNDSCAPE',
                                      style: GdailyTypography.lightTextTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Cathedral Hymns',
                                      style: GdailyTypography.lightTextTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // --- Complete Button ---
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.go('/home/success'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: GdailyColors.primaryOlive,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Complete Devotion',
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
            ),
            BottomNavBar(currentRoute: 'prayer'),
          ],
        ),
      ),
    );
  }
}
