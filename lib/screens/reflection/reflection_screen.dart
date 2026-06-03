import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:grace_daily/core/providers/devotion_provider.dart';
import 'package:grace_daily/core/services/share_service.dart';
import 'package:grace_daily/core/utils/image_strings.dart';
import 'package:grace_daily/core/widgets/bottom_nav_bar.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';

/// The reflection screen displays daily devotion content including
/// the verse, meditation text, and thought for the day.
class ReflectionScreen extends StatelessWidget {
  const ReflectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Consumer<DevotionProvider>(
                builder: (context, devotionProvider, _) {
                  if (devotionProvider.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    );
                  }

                  final verse = devotionProvider.currentVerse;
                  if (verse == null) {
                    return const Center(
                      child: Text('No devotion content found for today.'),
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // --- Top Bar with Date & Actions ---
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_rounded),
                                color: theme.colorScheme.primary,
                                onPressed: () => context.go('/home'),
                              ),
                              Column(
                                children: [
                                  Text(
                                    'Day ${_getDayOfYear()}',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontFamily: 'Newsreader',
                                      fontStyle: FontStyle.italic,
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _getCurrentDate().toUpperCase(),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      letterSpacing: 1.2,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 9,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      verse.isBookmarked
                                          ? Icons.bookmark_rounded
                                          : Icons.bookmark_border_rounded,
                                    ),
                                    color: theme.colorScheme.primary,
                                    onPressed: () => devotionProvider.toggleBookmark(verse.id),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.share_rounded),
                                    color: theme.colorScheme.primary,
                                    onPressed: () => ShareService.shareVerse(verse),
                                  ),
                                ],
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
                                verse.text,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontFamily: 'Newsreader',
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                verse.reference.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
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
                                verse.title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                verse.reflection,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // --- Quote Section ---
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.cardTheme.color,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                                child: Text(
                                  verse.quote,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontFamily: 'Newsreader',
                                    fontStyle: FontStyle.italic,
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // --- Thought for Your Day Section ---
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24.0),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF23301B) : const Color(0xFFE8F0E4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'A Thought for Your Day',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                verse.thoughtForTheDay,
                                style: theme.textTheme.bodyMedium?.copyWith(
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
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: Text(
                              'See Intention & Prayer',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  );
                },
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

  int _getDayOfYear() {
    final now = DateTime.now();
    return now.difference(DateTime(now.year, 1, 1)).inDays + 1;
  }
}
