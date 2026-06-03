import 'package:intl/intl.dart';

/// Represents user's progress, statistics, and notification settings.
class UserProgress {
  final int id;
  final int currentStreak; // Current consecutive days of devotion completion
  final int longestStreak; // All-time longest streak
  final int totalCompletions; // Total devotions completed
  final DateTime lastCompletionDate; // When was last devotion completed
  final DateTime? joinDate; // When user started using the app
  final Map<String, bool> completionMap; // Date -> completion status for heatmap
  
  // Phase 2: Notification settings
  final bool notificationsEnabled;
  final int notificationHour;
  final int notificationMinute;

  UserProgress({
    int? id,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalCompletions = 0,
    DateTime? lastCompletionDate,
    this.joinDate,
    Map<String, bool>? completionMap,
    this.notificationsEnabled = false,
    this.notificationHour = 8,
    this.notificationMinute = 0,
  })  : id = id ?? 1,
        lastCompletionDate = lastCompletionDate ?? DateTime.now(),
        completionMap = completionMap ?? {};

  // Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'totalCompletions': totalCompletions,
      'lastCompletionDate': lastCompletionDate.toIso8601String(),
      'joinDate': joinDate?.toIso8601String(),
      'completionMap': _encodeCompletionMap(),
      'notificationsEnabled': notificationsEnabled ? 1 : 0,
      'notificationHour': notificationHour,
      'notificationMinute': notificationMinute,
    };
  }

  // Create from JSON
  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      id: json['id'],
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      totalCompletions: json['totalCompletions'] ?? 0,
      lastCompletionDate: DateTime.parse(json['lastCompletionDate'] ?? DateTime.now().toIso8601String()),
      joinDate: json['joinDate'] != null ? DateTime.parse(json['joinDate']) : null,
      completionMap: _decodeCompletionMap(json['completionMap'] ?? ''),
      notificationsEnabled: (json['notificationsEnabled'] ?? 0) == 1,
      notificationHour: json['notificationHour'] ?? 8,
      notificationMinute: json['notificationMinute'] ?? 0,
    );
  }

  // Helper to encode completion map
  String _encodeCompletionMap() {
    // Format: date1=1,date2=0,...
    return completionMap.entries
        .map((e) => '${e.key}=${e.value ? 1 : 0}')
        .join(',');
  }

  // Helper to decode completion map
  static Map<String, bool> _decodeCompletionMap(String encoded) {
    if (encoded.isEmpty) return {};
    final map = <String, bool>{};
    for (final entry in encoded.split(',')) {
      final parts = entry.split('=');
      if (parts.length == 2) {
        map[parts[0]] = parts[1] == '1';
      }
    }
    return map;
  }

  // Create a copy with modified fields
  UserProgress copyWith({
    int? id,
    int? currentStreak,
    int? longestStreak,
    int? totalCompletions,
    DateTime? lastCompletionDate,
    DateTime? joinDate,
    Map<String, bool>? completionMap,
    bool? notificationsEnabled,
    int? notificationHour,
    int? notificationMinute,
  }) {
    return UserProgress(
      id: id ?? this.id,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      lastCompletionDate: lastCompletionDate ?? this.lastCompletionDate,
      joinDate: joinDate ?? this.joinDate,
      completionMap: completionMap ?? this.completionMap,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
    );
  }

  // Check if user completed devotion today
  bool get completedToday {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return completionMap[today] == true;
  }

  // Mark devotion as completed today
  UserProgress markCompletedToday() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final newMap = {...completionMap};
    
    // Check if this continues the streak
    bool continuesStreak = false;
    if (newMap.isEmpty) {
      continuesStreak = true;
    } else {
      final yesterday = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));
      continuesStreak = newMap[yesterday] == true;
    }

    newMap[today] = true;
    final newStreak = continuesStreak ? currentStreak + 1 : 1;
    final newLongest = newStreak > longestStreak ? newStreak : longestStreak;

    return copyWith(
      currentStreak: newStreak,
      longestStreak: newLongest,
      totalCompletions: totalCompletions + 1,
      lastCompletionDate: DateTime.now(),
      completionMap: newMap,
    );
  }
}
