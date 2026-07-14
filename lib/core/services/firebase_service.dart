import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grace_daily/core/models/verse.dart';
import 'package:grace_daily/core/models/journal_entry.dart';
import 'package:grace_daily/core/models/user_progress.dart';

/// Service to handle all Firebase Cloud operations (Firestore & Auth).
class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- Authentication ---

  /// Signs in the user anonymously to ensure they have a unique Cloud ID.
  Future<User?> signInAnonymously() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      print('Firebase Auth Error: $e');
      return null;
    }
  }

  User? get currentUser => _auth.currentUser;

  // --- Verse Library (Admin/Cloud Hosted) ---

  /// Fetches all devotions from the cloud with robust type-safety and fallback defaults.
  /// Uses a snapshot metadata check to ensure data comes fresh from the live server.
  Future<List<Verse>> fetchVersesFromCloud() async {
    try {
      final snapshot = await _db.collection('verses').orderBy('id').get();
      
      // If the snapshot came from the local Firestore offline cache rather than the live server,
      // we skip syncing to prevent overwriting the SQLite cache with stale Firestore cache.
      if (snapshot.metadata.isFromCache) {
        print('Firestore returned cached documents. Skipping sync to prevent cache reversion.');
        return [];
      }

      final verses = <Verse>[];
      for (final doc in snapshot.docs) {
        try {
          final data = doc.data();
          final id = data['id'];
          if (id == null) {
            print('Skipping cloud document ${doc.id} because "id" is null/missing');
            continue;
          }

          verses.add(Verse(
            id: id is int ? id : (int.tryParse(id.toString()) ?? 0),
            text: data['text']?.toString() ?? '',
            reference: data['reference']?.toString() ?? '',
            title: data['title']?.toString() ?? '',
            reflection: data['reflection']?.toString() ?? '',
            thoughtForTheDay: data['thoughtForTheDay']?.toString() ?? '',
            dailyIntention: data['dailyIntention']?.toString() ?? '',
            prayerText: data['prayerText']?.toString() ?? '',
            isBookmarked: false,
          ));
        } catch (innerError) {
          print('Error parsing cloud document ${doc.id}: $innerError');
        }
      }
      return verses;
    } catch (e) {
      print('Error fetching cloud verses: $e');
      return [];
    }
  }

  // --- User Data Syncing ---

  /// Syncs user progress to the cloud.
  Future<void> syncUserProgress(UserProgress progress) async {
    final user = currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).set({
        'progress': progress.toJson(),
        'lastSync': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error syncing progress: $e');
    }
  }

  /// Syncs a single journal entry to the cloud.
  Future<void> syncJournalEntry(JournalEntry entry) async {
    final user = currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).collection('journal').doc(entry.id.toString()).set(
        entry.toJson(),
        SetOptions(merge: true),
      );
    } catch (e) {
      print('Error syncing journal: $e');
    }
  }

  /// Fetches the global prayer count (aggregated on server via Cloud Functions).
  Future<int> getGlobalPrayerCount() async {
    try {
      final doc = await _db.collection('stats').doc('global').get();
      return doc.data()?['totalPrayers'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // --- Database Seeding (Admin Only) ---

  /// Seeds the Firestore 'verses' collection from a provided list.
  /// Use this only during initial setup.
  Future<void> seedVerses(List<Verse> verses) async {
    final batch = _db.batch();
    
    for (final verse in verses) {
      final docRef = _db.collection('verses').doc(verse.id.toString());
      batch.set(docRef, {
        'id': verse.id,
        'text': verse.text,
        'reference': verse.reference,
        'title': verse.title,
        'reflection': verse.reflection,
        'thoughtForTheDay': verse.thoughtForTheDay,
        'dailyIntention': verse.dailyIntention,
        'prayerText': verse.prayerText,
      });
    }

    try {
      await batch.commit();
      print('Cloud Library Seeded successfully.');
    } catch (e) {
      print('Error seeding verses: $e');
    }
  }

  /// Initializes the global stats document.
  Future<void> initializeGlobalStats() async {
    try {
      await _db.collection('stats').doc('global').set({
        'totalPrayers': 0,
      }, SetOptions(merge: false));
      print('Global stats initialized.');
    } catch (e) {
      print('Error initializing stats: $e');
    }
  }
}
