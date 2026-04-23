/// Represents a single day's complete spiritual content in the 365-day journey.
class DailyDevotion {
  final int dayNumber;           // 1-365
  final DateTime date;           // Date of the devotion
  final String verse;            // Bible verse text
  final String verseReference;   // e.g., "Jeremiah 29:11"
  final String title;            // Devotion title (e.g., "Finding Stillness")
  final String meditationText;   // Main meditation content
  final String quote;            // Highlighted quote for the day
  final String thoughtForDay;    // Actionable thought/prayer
  final String audioTitle;       // Ambient soundscape name (e.g., "Cathedral Hymns")
  final String? imageUrl;        // Optional image URL
  final DateTime createdAt;      // When this devotion was created

  DailyDevotion({
    required this.dayNumber,
    required this.date,
    required this.verse,
    required this.verseReference,
    required this.title,
    required this.meditationText,
    required this.quote,
    required this.thoughtForDay,
    required this.audioTitle,
    this.imageUrl,
    required this.createdAt,
  });

  /// Convert DailyDevotion to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'date': date.toIso8601String(),
      'verse': verse,
      'verseReference': verseReference,
      'title': title,
      'meditationText': meditationText,
      'quote': quote,
      'thoughtForDay': thoughtForDay,
      'audioTitle': audioTitle,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create DailyDevotion from JSON (from database or API)
  factory DailyDevotion.fromJson(Map<String, dynamic> json) {
    return DailyDevotion(
      dayNumber: json['dayNumber'] as int,
      date: DateTime.parse(json['date'] as String),
      verse: json['verse'] as String,
      verseReference: json['verseReference'] as String,
      title: json['title'] as String,
      meditationText: json['meditationText'] as String,
      quote: json['quote'] as String,
      thoughtForDay: json['thoughtForDay'] as String,
      audioTitle: json['audioTitle'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Create a copy of this devotion with some fields replaced
  DailyDevotion copyWith({
    int? dayNumber,
    DateTime? date,
    String? verse,
    String? verseReference,
    String? title,
    String? meditationText,
    String? quote,
    String? thoughtForDay,
    String? audioTitle,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return DailyDevotion(
      dayNumber: dayNumber ?? this.dayNumber,
      date: date ?? this.date,
      verse: verse ?? this.verse,
      verseReference: verseReference ?? this.verseReference,
      title: title ?? this.title,
      meditationText: meditationText ?? this.meditationText,
      quote: quote ?? this.quote,
      thoughtForDay: thoughtForDay ?? this.thoughtForDay,
      audioTitle: audioTitle ?? this.audioTitle,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'DailyDevotion(dayNumber: $dayNumber, title: $title)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyDevotion &&
          runtimeType == other.runtimeType &&
          dayNumber == other.dayNumber &&
          title == other.title;

  @override
  int get hashCode => dayNumber.hashCode ^ title.hashCode;
}

