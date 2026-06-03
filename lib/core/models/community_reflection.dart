import 'package:intl/intl.dart';

/// Represents a shared anonymous comment or reflection posted by a community member.
class CommunityReflection {
  final String id;
  final int verseId;
  final String content;
  final String author;
  final DateTime createdAt;

  CommunityReflection({
    required this.id,
    required this.verseId,
    required this.content,
    required this.author,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'verseId': verseId,
      'content': content,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CommunityReflection.fromJson(Map<String, dynamic> json) {
    return CommunityReflection(
      id: json['id'] ?? '',
      verseId: json['verseId'] ?? 0,
      content: json['content'] ?? '',
      author: json['author'] ?? 'Anonymous Soul',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  String getFormattedDate() {
    return DateFormat('MMM d, h:mm a').format(createdAt);
  }
}
