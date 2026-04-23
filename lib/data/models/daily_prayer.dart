/// Represents the daily intention/prayer content for a specific day.
class DailyPrayer {
  final int dayNumber;           // 1-365, matches devotion
  final DateTime date;
  final String intention;        // Daily intention title (e.g., "Finding Stillness")
  final String prayerText;       // Prayer content
  final String? attribution;     // Who wrote it (e.g., "A Heart's Plea")
  final String soundscapeTitle;  // Audio name (e.g., "Cathedral Hymns")
  final DateTime createdAt;

  DailyPrayer({
    required this.dayNumber,
    required this.date,
    required this.intention,
    required this.prayerText,
    this.attribution,
    required this.soundscapeTitle,
    required this.createdAt,
  });

  /// Convert DailyPrayer to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'date': date.toIso8601String(),
      'intention': intention,
      'prayerText': prayerText,
      'attribution': attribution,
      'soundscapeTitle': soundscapeTitle,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create DailyPrayer from JSON (from database or API)
  factory DailyPrayer.fromJson(Map<String, dynamic> json) {
    return DailyPrayer(
      dayNumber: json['dayNumber'] as int,
      date: DateTime.parse(json['date'] as String),
      intention: json['intention'] as String,
      prayerText: json['prayerText'] as String,
      attribution: json['attribution'] as String?,
      soundscapeTitle: json['soundscapeTitle'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Create a copy of this prayer with some fields replaced
  DailyPrayer copyWith({
    int? dayNumber,
    DateTime? date,
    String? intention,
    String? prayerText,
    String? attribution,
    String? soundscapeTitle,
    DateTime? createdAt,
  }) {
    return DailyPrayer(
      dayNumber: dayNumber ?? this.dayNumber,
      date: date ?? this.date,
      intention: intention ?? this.intention,
      prayerText: prayerText ?? this.prayerText,
      attribution: attribution ?? this.attribution,
      soundscapeTitle: soundscapeTitle ?? this.soundscapeTitle,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'DailyPrayer(dayNumber: $dayNumber, intention: $intention)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyPrayer &&
          runtimeType == other.runtimeType &&
          dayNumber == other.dayNumber &&
          intention == other.intention;

  @override
  int get hashCode => dayNumber.hashCode ^ intention.hashCode;
}

