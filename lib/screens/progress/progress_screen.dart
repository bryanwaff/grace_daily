import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/core/providers/user_progress_provider.dart';
import 'package:grace_daily/core/providers/journal_provider.dart';
import 'package:grace_daily/core/services/notification_service.dart';
import 'package:grace_daily/core/services/firebase_service.dart';
import 'package:grace_daily/core/services/share_service.dart';
import 'package:grace_daily/core/providers/devotion_provider.dart';
import 'package:grace_daily/core/providers/community_provider.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';

/// Screen displaying user's progress, streaks, and completion history.
class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommunityProvider>().loadLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    color: theme.colorScheme.primary,
                    onPressed: () => context.go('/home'),
                  ),
                  const Spacer(),
                  Text(
                    'Your Progress',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),
            // Main content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _StreakCard(),
                      const SizedBox(height: 24),
                      // Statistics cards
                      const _StatisticsGrid(),
                      const SizedBox(height: 24),
                      // Notification settings
                      const _NotificationSettingsCard(),
                      const SizedBox(height: 24),
                      // Cloud Setup (One-time)
                      const _CloudSetupCard(),
                      const SizedBox(height: 24),
                      // Leaderboard
                      const _AnonymousLeaderboard(),
                      const SizedBox(height: 24),
                      // Recent entries
                      const _RecentEntriesSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Displays current streak with encouraging message and gentle pulse animation.
class _StreakCard extends StatefulWidget {
  const _StreakCard();

  @override
  State<_StreakCard> createState() => _StreakCardState();
}

class _StreakCardState extends State<_StreakCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(begin: 0.98, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Consumer<UserProgressProvider>(
      builder: (context, progressProvider, _) {
        final streak = progressProvider.currentStreak;
        final completedToday = progressProvider.completedToday;

        return ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.15),
                  theme.colorScheme.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Streak',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$streak ${streak == 1 ? 'day' : 'days'}',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: completedToday
                            ? theme.colorScheme.primary
                            : (isDark ? Colors.grey[800] : GdailyColors.dividerLight),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        completedToday ? Icons.check : Icons.circle_outlined,
                        color: completedToday ? Colors.white : theme.colorScheme.onSurfaceVariant,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  completedToday
                      ? '✨ Great! You\'ve completed today\'s devotion.'
                      : '📖 Complete today\'s devotion to continue your streak!',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => ShareService.shareProgress(
                      progressProvider.currentStreak,
                      progressProvider.totalCompletions,
                    ),
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text('Share My Journey'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                      side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () => ShareService.shareVerse(
                      context.read<DevotionProvider>().currentVerse!
                    ),
                    icon: const Icon(Icons.group_add_outlined, size: 18),
                    label: const Text('Invite a Friend to Devotion'),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Displays statistics grid.
class _StatisticsGrid extends StatelessWidget {
  const _StatisticsGrid();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<UserProgressProvider>(
      builder: (context, progressProvider, _) {
        return Column(
          children: [
            Text(
              'Your Statistics',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total Devotions',
                    value: progressProvider.totalCompletions.toString(),
                    icon: Icons.menu_book_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Longest Streak',
                    value: '${progressProvider.longestStreak} days',
                    icon: Icons.trending_up_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Month Completion',
                    value: '${(progressProvider.monthCompletionPercentage * 100).toStringAsFixed(0)}%',
                    icon: Icons.assessment_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Days Since Joined',
                    value: progressProvider.daysSinceJoined.toString(),
                    icon: Icons.calendar_today_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _StatCard(
              label: 'Global Prayer Community',
              value: '${progressProvider.globalPrayerCount} hearts praying together',
              icon: Icons.public_rounded,
              isWide: true,
            ),
          ],
        );
      },
    );
  }
}

/// Individual stat card.
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isWide;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: isWide ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                icon,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Recent journal entries section.
class _RecentEntriesSection extends StatelessWidget {
  const _RecentEntriesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<JournalProvider>(
      builder: (context, journalProvider, _) {
        if (journalProvider.totalEntries == 0) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.edit_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 40,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your reflections will appear here.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final recentEntries = journalProvider.allEntries.take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Reflections',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentEntries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = recentEntries[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Day ${entry.verseId}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (entry.isPrayed)
                            Icon(
                              Icons.check_circle,
                              color: theme.colorScheme.primary,
                              size: 16,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        entry.content,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

/// Displays notification controls and time picker.
class _NotificationSettingsCard extends StatelessWidget {
  const _NotificationSettingsCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<UserProgressProvider>(
      builder: (context, progressProvider, _) {
        final enabled = progressProvider.notificationsEnabled;
        final hour = progressProvider.notificationHour;
        final minute = progressProvider.notificationMinute;
        
        final timeString = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications_active_outlined,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'Daily Reminders',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Switch.adaptive(
                    value: enabled,
                    activeTrackColor: theme.colorScheme.primary.withValues(alpha: 0.5),
                    activeThumbColor: theme.colorScheme.primary,
                    onChanged: (val) {
                      progressProvider.updateNotificationSettings(
                        val,
                        hour,
                        minute,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Schedule a gentle reminder to protect your quiet time and build your daily devotion streak.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              if (enabled) ...[
                const SizedBox(height: 16),
                Divider(color: theme.colorScheme.outline),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(hour: hour, minute: minute),
                      builder: (context, child) {
                        return Theme(
                          data: theme.copyWith(
                            colorScheme: theme.colorScheme.copyWith(
                              primary: theme.colorScheme.primary,
                              onPrimary: Colors.white,
                              onSurface: theme.colorScheme.onSurface,
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null) {
                      progressProvider.updateNotificationSettings(
                        true,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Reminder Time',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            Text(
                              timeString,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Admin tool card to initialize Firestore collections.
class _CloudSetupCard extends StatefulWidget {
  const _CloudSetupCard();

  @override
  State<_CloudSetupCard> createState() => _CloudSetupCardState();
}

class _CloudSetupCardState extends State<_CloudSetupCard> {
  bool _isSeeding = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final devotionProvider = context.read<DevotionProvider>();
    final firebaseService = FirebaseService();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                color: theme.colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Cloud Database Setup',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Admin: Use these tools to initialize the cloud library and global statistics.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSeeding
                  ? null
                  : () async {
                      setState(() => _isSeeding = true);
                      try {
                        // 1. Force sync local JSON to Firestore
                        await devotionProvider.forceSyncLibraryToCloud();
                        // 2. Initialize global stats
                        await firebaseService.initializeGlobalStats();

                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('✅ Cloud library updated from local JSON!')),
                        );
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('❌ Error: $e')),
                        );
                      } finally {
                        if (mounted) setState(() => _isSeeding = false);
                      }
                    },
              icon: _isSeeding
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.playlist_add_check_rounded),
              label: Text(_isSeeding ? 'Seeding...' : 'Push Local Content to Cloud'),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnonymousLeaderboard extends StatelessWidget {
  const _AnonymousLeaderboard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CommunityProvider>(
      builder: (context, provider, child) {
        if (provider.leaderboard.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Community Leaderboard',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.leaderboard.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final entry = provider.leaderboard[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: index < 3 
                              ? theme.colorScheme.primary 
                              : theme.colorScheme.outline,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: index < 3 ? Colors.white : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry['name'],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: index < 3 ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${entry['streak']} day streak',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${entry['total']} total',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Celebrating each soul\'s consistency in grace.',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
