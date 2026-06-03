import 'package:intl/intl.dart';

/// Represents a user's personal journal entry tied to a devotion.
class JournalEntry {
  final int id;
  final int verseId; // Reference to the verse/day
  final String content; // User's reflection text
  final DateTime createdAt;
  final bool isPrayed; // Whether user marked prayer as completed

  JournalEntry({
    int? id,
    required this.verseId,
    required this.content,
    required this.createdAt,
    this.isPrayed = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch;

  // Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verseId': verseId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'isPrayed': isPrayed ? 1 : 0,
    };
  }

  // Create from JSON
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      verseId: json['verseId'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      isPrayed: json['isPrayed'] == 1,
    );
  }

  // Format date for display
  String getFormattedDate() {
    return DateFormat('MMM d, yyyy').format(createdAt);
  }

  // Create a copy with modified fields
  JournalEntry copyWith({
    int? id,
    int? verseId,
    String? content,
    DateTime? createdAt,
    bool? isPrayed,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      verseId: verseId ?? this.verseId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isPrayed: isPrayed ?? this.isPrayed,
    );
  }
}

