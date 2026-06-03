import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:grace_daily/core/providers/devotion_provider.dart';
import 'package:grace_daily/core/providers/journal_provider.dart';
import 'package:grace_daily/core/providers/user_progress_provider.dart';
import 'package:grace_daily/core/widgets/bottom_nav_bar.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';

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
    final theme = Theme.of(context);

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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Header ---
                          Text(
                            'THE DAILY INTENTION',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            verse.dailyIntention,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFamily: 'Newsreader',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- Prayer Text ---
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.cardTheme.color,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: theme.colorScheme.outline),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  verse.prayerText,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontFamily: 'Newsreader',
                                    fontStyle: FontStyle.italic,
                                    height: 1.8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'A Heart\'s Plea',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
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
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- Reflection Field ---
                          Text(
                            'Personal Reflections',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _reflectionController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Pour out your heart here...',
                              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              fillColor: theme.cardTheme.color,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: theme.colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- Ambient Sound Block ---
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: GdailyColors.primaryOliveDark,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.spa_outlined,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'AMBIENT MUSIC',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: Colors.white,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        'Cathedral Hymns',
                                        style: theme.textTheme.bodyMedium?.copyWith(
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
                          const SizedBox(height: 24),

                          // --- Complete Button ---
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _completeDevotion(context, verse.id),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Complete Devotion',
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
                    ),
                  );
                },
              ),
            ),
            BottomNavBar(currentRoute: 'prayer'),
          ],
        ),
      ),
    );
  }

  void _saveJournal(BuildContext context, int verseId) {
    final theme = Theme.of(context);
    final journalProvider = context.read<JournalProvider>();
    if (_reflectionController.text.trim().isNotEmpty) {
      journalProvider.saveEntry(
        verseId,
        _reflectionController.text,
        isPrayed: _marked,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('📖 Your reflection has been saved!'),
          backgroundColor: theme.colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _completeDevotion(BuildContext context, int verseId) {
    final progressProvider = context.read<UserProgressProvider>();
    
    // Save journal if there's content
    if (_reflectionController.text.trim().isNotEmpty) {
      _saveJournal(context, verseId);
    }
    
    // Mark as completed and update streak
    progressProvider.completeDevotionToday().then((_) {
      if (context.mounted) {
        context.go('/home/success');
      }
    });
  }
}
