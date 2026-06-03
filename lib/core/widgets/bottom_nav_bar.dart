import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grace_daily/theme/gdaily_colors.dart';

/// Reusable bottom navigation bar for all screens
class BottomNavBar extends StatelessWidget {
  final String currentRoute;

  const BottomNavBar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navBgColor = theme.cardTheme.color?.withValues(alpha: 0.9) ?? Colors.white.withValues(alpha: 0.9);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12, top: 8),
      child: Container(
        decoration: BoxDecoration(
          color: navBgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.brightness == Brightness.dark ? Colors.black38 : Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavTab(
              icon: Icons.today_rounded,
              label: 'Today',
              selected: currentRoute == 'home',
              onTap: () => context.go('/home'),
            ),
            _NavTab(
              icon: Icons.menu_book_rounded,
              label: 'Reflection',
              selected: currentRoute == 'reflection',
              onTap: () => context.go('/home/reflection'),
            ),
            _NavTab(
              icon: Icons.self_improvement_rounded,
              label: 'Prayer',
              selected: currentRoute == 'prayer',
              onTap: () => context.go('/home/prayer'),
            ),
            _NavTab(
              icon: Icons.trending_up_rounded,
              label: 'Progress',
              selected: currentRoute == 'progress',
              onTap: () => context.go('/home/progress'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavTab({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.textTheme.bodySmall?.color ?? GdailyColors.textMedium;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          decoration: selected
              ? BoxDecoration(
                  color: activeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected ? activeColor : inactiveColor,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: selected ? activeColor : inactiveColor,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

