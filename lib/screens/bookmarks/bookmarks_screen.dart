import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:grace_daily/core/models/verse.dart';
import 'package:grace_daily/core/providers/devotion_provider.dart';
import 'package:grace_daily/core/services/share_service.dart';
import 'package:grace_daily/core/widgets/bottom_nav_bar.dart';

/// Screen displaying all bookmarked verses with search, filtering, and sharing capabilities.
class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  String _searchQuery = '';
  String _selectedTheme = 'All';

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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    color: theme.colorScheme.primary,
                    onPressed: () => context.go('/home'),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Bookmarks',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontFamily: 'Newsreader',
                          fontStyle: FontStyle.italic,
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balancing back button
                ],
              ),
            ),

            // --- Search Bar ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search bookmarked verses...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(Icons.search_rounded, color: theme.colorScheme.primary),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.colorScheme.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                  ),
                ),
              ),
            ),

            // --- Theme Filter chips ---
            Consumer<DevotionProvider>(
              builder: (context, devotionProvider, _) {
                final allBookmarked = devotionProvider.bookmarkedVerses;
                if (allBookmarked.isEmpty) return const SizedBox.shrink();

                // Extract unique themes/titles
                final themes = <String>{'All'};
                for (final v in allBookmarked) {
                  themes.add(v.title);
                }

                return SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    children: themes.map((themeName) {
                      final isSelected = _selectedTheme == themeName;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(themeName),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedTheme = themeName;
                              });
                            }
                          },
                          selectedColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                          backgroundColor: theme.colorScheme.surface,
                          labelStyle: theme.textTheme.labelMedium?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          checkmarkColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),

            const SizedBox(height: 8),

            // --- Bookmarked list ---
            Expanded(
              child: Consumer<DevotionProvider>(
                builder: (context, devotionProvider, _) {
                  final allBookmarked = devotionProvider.bookmarkedVerses;

                  if (allBookmarked.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  // Apply search and theme filtering
                  final filtered = allBookmarked.where((v) {
                    final matchesSearch = v.text.toLowerCase().contains(_searchQuery) ||
                        v.reference.toLowerCase().contains(_searchQuery) ||
                        v.title.toLowerCase().contains(_searchQuery);
                    final matchesTheme = _selectedTheme == 'All' || v.title == _selectedTheme;
                    return matchesSearch && matchesTheme;
                  }).toList();

                  if (filtered.isEmpty) {
                    return _buildNoResultsState(context);
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final verse = filtered[index];
                      return _buildBookmarkCard(context, verse, devotionProvider);
                    },
                  );
                },
              ),
            ),
            BottomNavBar(currentRoute: 'bookmarks'),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.bookmark_border_rounded,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Bookmarks Yet',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'As you read your daily devotions, tap the bookmark icon on the reflection page to save verses here for quiet moments.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No matching bookmarks found',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search query or selecting a different theme.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarkCard(BuildContext context, Verse verse, DevotionProvider devotionProvider) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: theme.cardTheme.color,
      child: InkWell(
        onTap: () => _showVerseDetailsBottomSheet(context, verse, devotionProvider),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Theme badge & actions row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      verse.title.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share_rounded, size: 20),
                        color: theme.colorScheme.primary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => ShareService.shareVerse(verse),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.bookmark_rounded, size: 20),
                        color: theme.colorScheme.primary,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => devotionProvider.toggleBookmark(verse.id),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Scripture text
              Text(
                verse.text,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Newsreader',
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              // Reference
              Text(
                verse.reference,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showVerseDetailsBottomSheet(BuildContext context, Verse verse, DevotionProvider devotionProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final theme = Theme.of(context);
            final isDark = theme.brightness == Brightness.dark;

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Grab indicator
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Header with controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          color: theme.colorScheme.primary,
                          onPressed: () => Navigator.pop(context),
                        ),
                        Text(
                          'Saved Verse',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontFamily: 'Newsreader',
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.share_rounded),
                              color: theme.colorScheme.primary,
                              onPressed: () => ShareService.shareVerse(verse),
                            ),
                            Consumer<DevotionProvider>(
                              builder: (context, dp, _) {
                                final isCurrentlyBookmarked = dp.bookmarkedVerses.any((v) => v.id == verse.id);
                                return IconButton(
                                  icon: Icon(
                                    isCurrentlyBookmarked
                                        ? Icons.bookmark_rounded
                                        : Icons.bookmark_border_rounded,
                                  ),
                                  color: theme.colorScheme.primary,
                                  onPressed: () async {
                                    await dp.toggleBookmark(verse.id);
                                    setModalState(() {});
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: theme.colorScheme.outline),

                  // Detail Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Verse Title
                          Text(
                            verse.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Scripture Verse
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: theme.cardTheme.color,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: theme.colorScheme.outline),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  verse.text,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontFamily: 'Newsreader',
                                    fontStyle: FontStyle.italic,
                                    height: 1.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  verse.reference,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Reflection Heading
                          Text(
                            'Daily Meditation',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            verse.reflection,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Thought For Today
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF23301B) // Beautiful deep olive dark mode background
                                  : const Color(0xFFE8F0E4), // Beautiful light olive background
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Daily Thought',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  verse.thoughtForTheDay,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Prayer Text Section
                          Text(
                            'Daily Prayer',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            verse.prayerText,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
