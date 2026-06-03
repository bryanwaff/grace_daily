import 'package:share_plus/share_plus.dart';
import 'package:grace_daily/core/models/verse.dart';
import 'package:grace_daily/core/models/journal_entry.dart';

/// Service to handle content sharing via native platform dialogues.
class ShareService {
  /// Share a specific daily devotion verse.
  static Future<void> shareVerse(Verse verse) async {
    final text = '''
✨ Daily Verse from Grace Daily ✨

"${verse.text}"
— ${verse.reference}

Theme: ${verse.title}

*Daily Thought:*
${verse.thoughtForTheDay}

Download Grace Daily to read more. 🙏
''';
    // ignore: deprecated_member_use
    await Share.share(text, subject: 'Grace Daily Devotion');
  }

  /// Share a journal entry alongside the verse reference.
  static Future<void> shareReflection(JournalEntry entry, Verse verse) async {
    final text = '''
📝 My Grace Daily Reflection

Verse: "${verse.text}"
— ${verse.reference}

*My Reflection:*
"${entry.content}"

${entry.isPrayed ? '🙏 Prayed today!' : ''}
''';
    // ignore: deprecated_member_use
    await Share.share(text, subject: 'My Reflection - Grace Daily');
  }
}
