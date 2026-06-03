import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grace_daily/core/models/verse.dart';
import 'package:grace_daily/core/models/journal_entry.dart';
import 'package:grace_daily/core/models/user_progress.dart';
import 'package:grace_daily/core/models/community_reflection.dart';

/// Database service using Cloud Firestore directly (no local SQLite/sqflite).
class GraceDailyDatabase {
  static final GraceDailyDatabase _instance = GraceDailyDatabase._internal();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  factory GraceDailyDatabase() {
    return _instance;
  }

  GraceDailyDatabase._internal();

  // Helper to get the current authenticated user's ID
  String? get _userId => _auth.currentUser?.uid;

  // ===== VERSES =====

  Future<Verse?> getVerseById(int id) async {
    try {
      final doc = await _firestore.collection('verses').doc(id.toString()).get();
      if (!doc.exists) return null;
      
      final isBookmarked = await _isVerseBookmarked(id);
      final verse = Verse.fromJson(doc.data()!);
      return verse.copyWith(isBookmarked: isBookmarked);
    } catch (e) {
      print('Error getting verse by id: $e');
      return null;
    }
  }

  Future<List<Verse>> getAllVerses() async {
    try {
      final snapshot = await _firestore.collection('verses').orderBy('id').get();
      final bookmarkedIds = await _getBookmarkedVerseIds();

      return snapshot.docs.map((doc) {
        final verse = Verse.fromJson(doc.data());
        return verse.copyWith(isBookmarked: bookmarkedIds.contains(verse.id));
      }).toList();
    } catch (e) {
      print('Error getting all verses: $e');
      return [];
    }
  }

  Future<List<Verse>> getBookmarkedVerses() async {
    try {
      final bookmarkedIds = await _getBookmarkedVerseIds();
      if (bookmarkedIds.isEmpty) return [];

      final all = await getAllVerses();
      return all.where((v) => bookmarkedIds.contains(v.id)).toList();
    } catch (e) {
      print('Error getting bookmarked verses: $e');
      return [];
    }
  }

  Future<void> insertVerse(Verse verse) async {
    try {
      // Exclude isBookmarked when saving global verse to cloud
      final data = verse.toJson();
      data.remove('isBookmarked');
      await _firestore.collection('verses').doc(verse.id.toString()).set(data, SetOptions(merge: true));
    } catch (e) {
      print('Error inserting verse: $e');
    }
  }

  Future<void> insertVerses(List<Verse> verses) async {
    try {
      final batch = _firestore.batch();
      for (final verse in verses) {
        final docRef = _firestore.collection('verses').doc(verse.id.toString());
        final data = verse.toJson();
        data.remove('isBookmarked');
        batch.set(docRef, data, SetOptions(merge: true));
      }
      await batch.commit();
    } catch (e) {
      print('Error inserting verses batch: $e');
    }
  }

  Future<void> replaceVerses(List<Verse> verses) async {
    // For cloud, we insert or merge rather than delete the whole global collection, 
    // to keep it safe for all users.
    await insertVerses(verses);
  }

  Future<void> deleteAllVerses() async {
    // Safeguard or delete if requested (admin only typically)
    print('deleteAllVerses skipped on Cloud database for safety.');
  }

  Future<void> toggleBookmark(int verseId) async {
    final uid = _userId;
    if (uid == null) return;

    try {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('bookmarks')
          .doc(verseId.toString());

      final doc = await docRef.get();
      if (doc.exists) {
        await docRef.delete();
      } else {
        await docRef.set({
          'bookmarked': true,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error toggling bookmark: $e');
    }
  }

  // Helper: check if a specific verse is bookmarked by current user
  Future<bool> _isVerseBookmarked(int verseId) async {
    final uid = _userId;
    if (uid == null) return false;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookmarks')
          .doc(verseId.toString())
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Helper: get set of bookmarked verse IDs for current user
  Future<Set<int>> _getBookmarkedVerseIds() async {
    final uid = _userId;
    if (uid == null) return {};

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookmarks')
          .get();
      return snapshot.docs.map((doc) => int.tryParse(doc.id) ?? 0).toSet();
    } catch (e) {
      print('Error getting bookmarked IDs: $e');
      return {};
    }
  }

  // ===== JOURNAL ENTRIES =====

  Future<JournalEntry?> getJournalEntryById(int id) async {
    final uid = _userId;
    if (uid == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('journal')
          .doc(id.toString())
          .get();
      return doc.exists ? JournalEntry.fromJson(doc.data()!) : null;
    } catch (e) {
      print('Error getting journal entry: $e');
      return null;
    }
  }

  Future<List<JournalEntry>> getJournalEntriesByVerseId(int verseId) async {
    final uid = _userId;
    if (uid == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('journal')
          .where('verseId', isEqualTo: verseId)
          .get();

      final entries = snapshot.docs.map((doc) => JournalEntry.fromJson(doc.data())).toList();
      entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return entries;
    } catch (e) {
      print('Error getting journal entries for verse: $e');
      return [];
    }
  }

  Future<List<JournalEntry>> getAllJournalEntries() async {
    final uid = _userId;
    if (uid == null) return [];

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('journal')
          .get();

      final entries = snapshot.docs.map((doc) => JournalEntry.fromJson(doc.data())).toList();
      entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return entries;
    } catch (e) {
      print('Error getting all journal entries: $e');
      return [];
    }
  }

  Future<void> insertJournalEntry(JournalEntry entry) async {
    final uid = _userId;
    if (uid == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('journal')
          .doc(entry.id.toString())
          .set(entry.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error inserting journal entry: $e');
    }
  }

  Future<void> updateJournalEntry(JournalEntry entry) async {
    await insertJournalEntry(entry);
  }

  Future<void> deleteJournalEntry(int id) async {
    final uid = _userId;
    if (uid == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('journal')
          .doc(id.toString())
          .delete();
    } catch (e) {
      print('Error deleting journal entry: $e');
    }
  }

  // ===== USER PROGRESS =====

  Future<UserProgress?> getUserProgress() async {
    final uid = _userId;
    if (uid == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['progress'] != null) {
          return UserProgress.fromJson(Map<String, dynamic>.from(data['progress']));
        }
      }
      return null;
    } catch (e) {
      print('Error getting user progress: $e');
      return null;
    }
  }

  Future<void> updateUserProgress(UserProgress progress) async {
    final uid = _userId;
    if (uid == null) return;

    try {
      await _firestore.collection('users').doc(uid).set({
        'progress': progress.toJson(),
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating user progress: $e');
    }
  }

  // ===== COMMUNITY REFLECTIONS =====

  Future<List<CommunityReflection>> getCommunityReflections(int verseId) async {
    try {
      final snapshot = await _firestore
          .collection('community_reflections')
          .where('verseId', isEqualTo: verseId)
          .orderBy('createdAt', descending: true)
          .limit(20)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CommunityReflection.fromJson({...data, 'id': doc.id});
      }).toList();
    } catch (e) {
      print('Error getting community reflections: $e');
      return [];
    }
  }

  Future<void> insertCommunityReflection(CommunityReflection reflection) async {
    try {
      await _firestore
          .collection('community_reflections')
          .add(reflection.toJson());
    } catch (e) {
      print('Error inserting community reflection: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAnonymousLeaderboard() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .orderBy('progress.totalCompletions', descending: true)
          .limit(5)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final progress = data['progress'] as Map<String, dynamic>? ?? {};
        return {
          'name': 'Soul #${doc.id.substring(0, 4)}',
          'streak': progress['currentStreak'] ?? 0,
          'total': progress['totalCompletions'] ?? 0,
        };
      }).toList();
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }

  Future<void> close() async {
    // No-op for Firestore
  }
}
