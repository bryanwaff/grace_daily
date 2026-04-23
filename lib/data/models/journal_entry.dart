/// Represents a user's personal reflection and prayer record for a specific day.
class JournalEntry {
  final String id;               // Unique identifier
  final String userId;           // User who created this entry
  final int dayNumber;           // Associated devotion day (1-365)
  final DateTime dateCreated;
  final String? reflection;      // User's written reflection
  final bool prayerMarked;       // Whether user marked as "prayed"
  final DateTime? markedAt;      // When prayer was marked complete
  final List<String>? tags;      // Optional tags for organization

  JournalEntry({
    required this.id,
    required this.userId,
    required this.dayNumber,
    required this.dateCreated,
    this.reflection,
    this.prayerMarked = false,
    this.markedAt,
    this.tags,
  });

  /// Convert JournalEntry to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'dayNumber': dayNumber,
      'dateCreated': dateCreated.toIso8601String(),
      'reflection': reflection,
      'prayerMarked': prayerMarked ? 1 : 0,
      'markedAt': markedAt?.toIso8601String(),
      'tags': tags != null ? tags!.join(',') : null,
    };
  }

  /// Create JournalEntry from JSON (from database)
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'] as String,
      userId: json['userId'] as String,
      dayNumber: json['dayNumber'] as int,
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      reflection: json['reflection'] as String?,
      prayerMarked: (json['prayerMarked'] as int?) == 1,
      markedAt: json['markedAt'] != null
          ? DateTime.parse(json['markedAt'] as String)
          : null,
      tags: json['tags'] != null
          ? (json['tags'] as String).split(',')
          : null,
    );
  }

  /// Create a copy of this entry with some fields replaced
  JournalEntry copyWith({
    String? id,
    String? userId,
    int? dayNumber,
    DateTime? dateCreated,
    String? reflection,
    bool? prayerMarked,
    DateTime? markedAt,
    List<String>? tags,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      dayNumber: dayNumber ?? this.dayNumber,
      dateCreated: dateCreated ?? this.dateCreated,
      reflection: reflection ?? this.reflection,
      prayerMarked: prayerMarked ?? this.prayerMarked,
      markedAt: markedAt ?? this.markedAt,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() =>
      'JournalEntry(id: $id, dayNumber: $dayNumber, prayerMarked: $prayerMarked)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntry &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

