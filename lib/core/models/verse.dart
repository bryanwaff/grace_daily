/// Represents a daily verse/devotion in the Grace Daily app.
class Verse {
  final int id; // Day number (1-365)
  final String text; // The verse text
  final String reference; // E.g., "Jeremiah 29:11"
  final String title; // Theme title
  final String reflection; // Devotion/meditation text
  final String thoughtForTheDay; // Daily thought
  final String dailyIntention; // Prayer intention
  final String prayerText; // Full prayer text
  final bool isBookmarked;

  Verse({
    required this.id,
    required this.text,
    required this.reference,
    required this.title,
    required this.reflection,
    required this.thoughtForTheDay,
    required this.dailyIntention,
    required this.prayerText,
    this.isBookmarked = false,
  });

  // Create a copy with modified fields
  Verse copyWith({
    int? id,
    String? text,
    String? reference,
    String? title,
    String? reflection,
    String? thoughtForTheDay,
    String? dailyIntention,
    String? prayerText,
    bool? isBookmarked,
  }) {
    return Verse(
      id: id ?? this.id,
      text: text ?? this.text,
      reference: reference ?? this.reference,
      title: title ?? this.title,
      reflection: reflection ?? this.reflection,
      thoughtForTheDay: thoughtForTheDay ?? this.thoughtForTheDay,
      dailyIntention: dailyIntention ?? this.dailyIntention,
      prayerText: prayerText ?? this.prayerText,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  // Convert to JSON for database storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'reference': reference,
      'title': title,
      'reflection': reflection,
      'thoughtForTheDay': thoughtForTheDay,
      'dailyIntention': dailyIntention,
      'prayerText': prayerText,
      'isBookmarked': isBookmarked ? 1 : 0,
    };
  }

  // Create from JSON
  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'],
      text: json['text'],
      reference: json['reference'],
      title: json['title'],
      reflection: json['reflection'],
      thoughtForTheDay: json['thoughtForTheDay'],
      dailyIntention: json['dailyIntention'],
      prayerText: json['prayerText'],
      isBookmarked: json['isBookmarked'] == 1,
    );
  }
}

