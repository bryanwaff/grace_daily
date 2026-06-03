import 'package:flutter/material.dart';
import 'package:grace_daily/core/models/journal_entry.dart';
import 'package:grace_daily/core/services/grace_daily_database.dart';
import 'package:grace_daily/core/services/firebase_service.dart';

/// Manages user journal entries and personal reflections with Cloud Sync.
class JournalProvider extends ChangeNotifier {
  final GraceDailyDatabase _db = GraceDailyDatabase();
  final FirebaseService _firebase = FirebaseService();

  List<JournalEntry> _allEntries = [];
  Map<int, List<JournalEntry>> _entriesByVerse = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<JournalEntry> get allEntries => _allEntries;
  Map<int, List<JournalEntry>> get entriesByVerse => _entriesByVerse;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all journal entries
  Future<void> loadAllEntries() async {
    try {
      _isLoading = true;
      notifyListeners();

      _allEntries = await _db.getAllJournalEntries();
      
      // In background, sync any unsynced entries if needed
      _syncAllToCloud();

      _error = null;
    } catch (e) {
      _error = 'Error loading journal entries: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Syncs all local entries to the cloud.
  Future<void> _syncAllToCloud() async {
    for (final entry in _allEntries) {
      await _firebase.syncJournalEntry(entry);
    }
  }

  // Load entries for a specific verse
  Future<void> loadEntriesForVerse(int verseId) async {
    try {
      _isLoading = true;
      notifyListeners();

      _entriesByVerse[verseId] = await _db.getJournalEntriesByVerseId(verseId);
      _error = null;
    } catch (e) {
      _error = 'Error loading entries for verse: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save a new journal entry
  Future<void> saveEntry(int verseId, String content, {bool isPrayed = false}) async {
    try {
      final entry = JournalEntry(
        verseId: verseId,
        content: content,
        createdAt: DateTime.now(),
        isPrayed: isPrayed,
      );

      await _db.insertJournalEntry(entry);
      _allEntries.insert(0, entry);
      
      if (_entriesByVerse.containsKey(verseId)) {
        _entriesByVerse[verseId]!.insert(0, entry);
      }

      _error = null;
      notifyListeners();

      // Sync to cloud immediately in the background so network latency
      // doesn't block the UI update or main flow.
      _firebase.syncJournalEntry(entry).catchError((e) {
        debugPrint('Error syncing journal entry: $e');
      });
    } catch (e) {
      _error = 'Error saving entry: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  // Update an existing entry
  Future<void> updateEntry(JournalEntry entry) async {
    try {
      await _db.updateJournalEntry(entry);
      
      final index = _allEntries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _allEntries[index] = entry;
      }

      final verseEntries = _entriesByVerse[entry.verseId];
      if (verseEntries != null) {
        final verseIndex = verseEntries.indexWhere((e) => e.id == entry.id);
        if (verseIndex != -1) {
          verseEntries[verseIndex] = entry;
        }
      }

      _error = null;
      notifyListeners();

      // Sync updated entry to cloud in the background
      _firebase.syncJournalEntry(entry).catchError((e) {
        debugPrint('Error syncing updated journal entry: $e');
      });
    } catch (e) {
      _error = 'Error updating entry: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  // Delete an entry
  Future<void> deleteEntry(int entryId) async {
    try {
      await _db.deleteJournalEntry(entryId);
      
      _allEntries.removeWhere((e) => e.id == entryId);
      
      for (final verseEntries in _entriesByVerse.values) {
        verseEntries.removeWhere((e) => e.id == entryId);
      }

      // Note: In a real cloud app, we'd also flag as deleted in Firestore
      // For now, we focus on uploading active data.

      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Error deleting entry: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  // Get total entries count
  int get totalEntries => _allEntries.length;

  // Get total prayers marked
  int get totalPrayers => _allEntries.where((e) => e.isPrayed).length;
}
