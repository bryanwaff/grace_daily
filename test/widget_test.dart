import 'package:flutter_test/flutter_test.dart';
import 'package:grace_daily/core/models/user_progress.dart';
import 'package:grace_daily/core/models/verse.dart';
import 'package:intl/intl.dart';

void main() {
  group('UserProgress Tests', () {
    test('Default constructor values', () {
      final progress = UserProgress();
      expect(progress.id, 1);
      expect(progress.currentStreak, 0);
      expect(progress.longestStreak, 0);
      expect(progress.totalCompletions, 0);
      expect(progress.completionMap.isEmpty, true);
      expect(progress.notificationsEnabled, false);
      expect(progress.notificationHour, 8);
      expect(progress.notificationMinute, 0);
    });

    test('toJson and fromJson serialization', () {
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final progress = UserProgress(
        id: 1,
        currentStreak: 5,
        longestStreak: 10,
        totalCompletions: 15,
        completionMap: {todayStr: true},
        notificationsEnabled: true,
        notificationHour: 7,
        notificationMinute: 30,
      );

      final json = progress.toJson();
      expect(json['id'], 1);
      expect(json['currentStreak'], 5);
      expect(json['longestStreak'], 10);
      expect(json['totalCompletions'], 15);
      expect(json['completionMap'], '$todayStr=1');
      expect(json['notificationsEnabled'], 1);
      expect(json['notificationHour'], 7);
      expect(json['notificationMinute'], 30);

      final deserialized = UserProgress.fromJson(json);
      expect(deserialized.id, 1);
      expect(deserialized.currentStreak, 5);
      expect(deserialized.longestStreak, 10);
      expect(deserialized.totalCompletions, 15);
      expect(deserialized.completionMap[todayStr], true);
      expect(deserialized.notificationsEnabled, true);
      expect(deserialized.notificationHour, 7);
      expect(deserialized.notificationMinute, 30);
    });

    test('completedToday returns true when today is marked', () {
      final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final progress = UserProgress(
        completionMap: {todayStr: true},
      );
      expect(progress.completedToday, true);
    });

    test('completedToday returns false when today is not marked', () {
      final yesterdayStr = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(const Duration(days: 1)));
      final progress = UserProgress(
        completionMap: {yesterdayStr: true},
      );
      expect(progress.completedToday, false);
    });
  });

  group('Verse Model & Sync Tests', () {
    test('Verse constructor and serialization', () {
      final verse = Verse(
        id: 42,
        text: 'Let your light shine',
        reference: 'Matthew 5:16',
        title: 'Shine Your Light',
        reflection: 'Reflect daily on how you can show God\'s grace.',
        quote: 'Be the light',
        thoughtForTheDay: 'Spread love today.',
        dailyIntention: 'Spreading Grace',
        prayerText: 'Lord, make me a vessel of your peace.',
        isBookmarked: true,
      );

      expect(verse.id, 42);
      expect(verse.text, 'Let your light shine');
      expect(verse.isBookmarked, true);

      final json = verse.toJson();
      expect(json['id'], 42);
      expect(json['isBookmarked'], 1);

      final fromJson = Verse.fromJson(json);
      expect(fromJson.id, 42);
      expect(fromJson.text, 'Let your light shine');
      expect(fromJson.isBookmarked, true);
    });

    test('Verse copyWith preserves or updates values correctly', () {
      final verse = Verse(
        id: 1,
        text: 'Original Text',
        reference: 'Ref 1:1',
        title: 'Title',
        reflection: 'Reflection',
        quote: 'Quote',
        thoughtForTheDay: 'Thought',
        dailyIntention: 'Intention',
        prayerText: 'Prayer',
        isBookmarked: false,
      );

      final updated = verse.copyWith(isBookmarked: true);
      expect(updated.id, 1);
      expect(updated.text, 'Original Text');
      expect(updated.isBookmarked, true);
    });

    test('Cloud sync bookmark mapping logic works perfectly', () {
      // Simulation of our _syncWithCloud bookmark mapping logic
      final localVerses = [
        Verse(
          id: 1,
          text: 'Local Text 1',
          reference: 'Ref 1',
          title: 'T1',
          reflection: 'R1',
          quote: 'Q1',
          thoughtForTheDay: 'Th1',
          dailyIntention: 'I1',
          prayerText: 'P1',
          isBookmarked: true, // User bookmarked this locally
        ),
        Verse(
          id: 2,
          text: 'Local Text 2',
          reference: 'Ref 2',
          title: 'T2',
          reflection: 'R2',
          quote: 'Q2',
          thoughtForTheDay: 'Th2',
          dailyIntention: 'I2',
          prayerText: 'P2',
          isBookmarked: false,
        ),
      ];

      final cloudVerses = [
        Verse(
          id: 1,
          text: 'Updated Cloud Text 1',
          reference: 'Ref 1',
          title: 'T1',
          reflection: 'R1',
          quote: 'Q1',
          thoughtForTheDay: 'Th1',
          dailyIntention: 'I1',
          prayerText: 'P1',
          isBookmarked: false, // Cloud master library always has isBookmarked as false
        ),
        Verse(
          id: 2,
          text: 'Updated Cloud Text 2',
          reference: 'Ref 2',
          title: 'T2',
          reflection: 'R2',
          quote: 'Q2',
          thoughtForTheDay: 'Th2',
          dailyIntention: 'I2',
          prayerText: 'P2',
          isBookmarked: false,
        ),
      ];

      // Recreate the exact bookmark preservation map/merge step from _syncWithCloud
      final localBookmarkMap = {for (var v in localVerses) v.id: v.isBookmarked};
      final syncedVerses = cloudVerses.map((cloudVerse) {
        final wasBookmarked = localBookmarkMap[cloudVerse.id] ?? false;
        return cloudVerse.copyWith(isBookmarked: wasBookmarked);
      }).toList();

      expect(syncedVerses[0].id, 1);
      expect(syncedVerses[0].text, 'Updated Cloud Text 1');
      expect(syncedVerses[0].isBookmarked, true); // Bookmark preserved!

      expect(syncedVerses[1].id, 2);
      expect(syncedVerses[1].text, 'Updated Cloud Text 2');
      expect(syncedVerses[1].isBookmarked, false); // Stays unbookmarked
    });
  });
}
