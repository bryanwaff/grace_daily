import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:grace_daily/core/providers/devotion_provider.dart';
import 'package:grace_daily/core/services/share_service.dart';
import 'package:grace_daily/core/utils/image_strings.dart';
import 'package:grace_daily/core/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // --- Custom Top Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const SizedBox(width: 48), // Balancing spacer for the bookmark button
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Day ${_getDayOfYear()}',
                          style: theme.textTheme.titleLarge?.copyWith(
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
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.bookmarks_outlined),
                    color: theme.colorScheme.primary,
                    onPressed: () => context.go('/home/bookmarks'),
                    tooltip: 'Bookmarks',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // --- Main Content ---
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

                  return Stack(
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
                            color: theme.colorScheme.surface,
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
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: Icon(
                                          verse.isBookmarked
                                              ? Icons.bookmark_rounded
                                              : Icons.bookmark_border_rounded,
                                          size: 20,
                                        ),
                                        color: theme.colorScheme.primary,
                                        onPressed: () => devotionProvider.toggleBookmark(verse.id),
                                      ),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.share_rounded, size: 20),
                                        color: theme.colorScheme.primary,
                                        onPressed: () => ShareService.shareVerse(verse),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    verse.text,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontFamily: 'Newsreader',
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w400,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    verse.reference,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => context.go('/home/reflection'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: theme.colorScheme.primary,
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
                                          style: theme.textTheme.labelLarge?.copyWith(
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
                  );
                },
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

  int _getDayOfYear() {
    final now = DateTime.now();
    return now.difference(DateTime(now.year, 1, 1)).inDays + 1;
  }
}
