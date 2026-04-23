/// Represents the user's progress through the 365-day devotional journey.
class UserProgress {
  final String userId;
  final int currentDayNumber;    // Last completed day
  final DateTime lastAccessDate;
  final int totalDaysCompleted;
  final List<int> completedDayNumbers;  // Days with prayers marked
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserProgress({
    required this.userId,
    required this.currentDayNumber,
    required this.lastAccessDate,
    required this.totalDaysCompleted,
    required this.completedDayNumbers,
    required this.createdAt,
    this.updatedAt,
  });

  /// Convert UserProgress to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentDayNumber': currentDayNumber,
      'lastAccessDate': lastAccessDate.toIso8601String(),
      'totalDaysCompleted': totalDaysCompleted,
      'completedDays': completedDayNumbers.join(','),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create UserProgress from JSON (from database)
  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'] as String,
      currentDayNumber: json['currentDayNumber'] as int? ?? 1,
      lastAccessDate: DateTime.parse(json['lastAccessDate'] as String),
      totalDaysCompleted: json['totalDaysCompleted'] as int? ?? 0,
      completedDayNumbers: json['completedDays'] != null
          ? (json['completedDays'] as String)
              .split(',')
              .map(int.parse)
              .toList()
          : [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Create a copy of this progress with some fields replaced
  UserProgress copyWith({
    String? userId,
    int? currentDayNumber,
    DateTime? lastAccessDate,
    int? totalDaysCompleted,
    List<int>? completedDayNumbers,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      currentDayNumber: currentDayNumber ?? this.currentDayNumber,
      lastAccessDate: lastAccessDate ?? this.lastAccessDate,
      totalDaysCompleted: totalDaysCompleted ?? this.totalDaysCompleted,
      completedDayNumbers: completedDayNumbers ?? this.completedDayNumbers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if a specific day has been completed
  bool isDayCompleted(int dayNumber) {
    return completedDayNumbers.contains(dayNumber);
  }

  /// Add a completed day to the list
  UserProgress addCompletedDay(int dayNumber) {
    final updated = List<int>.from(completedDayNumbers);
    if (!updated.contains(dayNumber)) {
      updated.add(dayNumber);
      updated.sort();
    }
    return copyWith(
      completedDayNumbers: updated,
      totalDaysCompleted: updated.length,
      currentDayNumber: dayNumber > currentDayNumber ? dayNumber : currentDayNumber,
      lastAccessDate: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  @override
  String toString() =>
      'UserProgress(userId: $userId, currentDay: $currentDayNumber, completed: $totalDaysCompleted/365)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgress &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}

