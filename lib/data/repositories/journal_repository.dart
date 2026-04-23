import 'package:grace_daily/data/datasources/database_service.dart';
import 'package:grace_daily/data/models/models.dart';

/// Repository for managing user journal entries.
/// Handles all journal-related data operations.
class JournalRepository {
  final DatabaseService _databaseService;

  JournalRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  /// Create a new journal entry
  Future<bool> createEntry(JournalEntry entry) async {
    try {
      await _databaseService.insertJournalEntry(entry);
      return true;
    } catch (e) {
      print('Error creating journal entry: $e');
      return false;
    }
  }

  /// Get a journal entry by ID
  Future<JournalEntry?> getEntry(String id) async {
    try {
      return await _databaseService.getJournalEntry(id);
    } catch (e) {
      print('Error getting journal entry: $e');
      return null;
    }
  }

  /// Get journal entry for a specific user and day
  Future<JournalEntry?> getEntryForDay(String userId, int dayNumber) async {
    try {
      return await _databaseService.getJournalEntryForDay(userId, dayNumber);
    } catch (e) {
      print('Error getting journal entry for day: $e');
      return null;
    }
  }

  /// Get all journal entries for a user
  Future<List<JournalEntry>> getUserEntries(String userId) async {
    try {
      return await _databaseService.getUserJournalEntries(userId);
    } catch (e) {
      print('Error getting user journal entries: $e');
      return [];
    }
  }

  /// Update a journal entry
  Future<bool> updateEntry(JournalEntry entry) async {
    try {
      await _databaseService.updateJournalEntry(entry);
      return true;
    } catch (e) {
      print('Error updating journal entry: $e');
      return false;
    }
  }

  /// Save or update a reflection for a specific day
  Future<bool> saveReflection(
    String userId,
    int dayNumber,
    String reflection,
  ) async {
    try {
      final existingEntry =
          await _databaseService.getJournalEntryForDay(userId, dayNumber);

      if (existingEntry != null) {
        // Update existing entry
        final updated = existingEntry.copyWith(
          reflection: reflection,
        );
        await _databaseService.updateJournalEntry(updated);
      } else {
        // Create new entry
        final newEntry = JournalEntry(
          id: '${userId}_${dayNumber}_${DateTime.now().millisecondsSinceEpoch}',
          userId: userId,
          dayNumber: dayNumber,
          dateCreated: DateTime.now(),
          reflection: reflection,
        );
        await _databaseService.insertJournalEntry(newEntry);
      }
      return true;
    } catch (e) {
      print('Error saving reflection: $e');
      return false;
    }
  }

  /// Mark a prayer as completed
  Future<bool> markPrayerCompleted(String userId, int dayNumber) async {
    try {
      final existingEntry =
          await _databaseService.getJournalEntryForDay(userId, dayNumber);

      if (existingEntry != null) {
        final updated = existingEntry.copyWith(
          prayerMarked: true,
          markedAt: DateTime.now(),
        );
        await _databaseService.updateJournalEntry(updated);
      } else {
        final newEntry = JournalEntry(
          id: '${userId}_${dayNumber}_${DateTime.now().millisecondsSinceEpoch}',
          userId: userId,
          dayNumber: dayNumber,
          dateCreated: DateTime.now(),
          prayerMarked: true,
          markedAt: DateTime.now(),
        );
        await _databaseService.insertJournalEntry(newEntry);
      }
      return true;
    } catch (e) {
      print('Error marking prayer completed: $e');
      return false;
    }
  }

  /// Delete a journal entry
  Future<bool> deleteEntry(String id) async {
    try {
      await _databaseService.deleteJournalEntry(id);
      return true;
    } catch (e) {
      print('Error deleting journal entry: $e');
      return false;
    }
  }

  /// Get total number of reflections for a user
  Future<int> getTotalReflectionsCount(String userId) async {
    try {
      final entries = await _databaseService.getUserJournalEntries(userId);
      return entries.where((e) => e.reflection != null && e.reflection!.isNotEmpty).length;
    } catch (e) {
      print('Error getting reflections count: $e');
      return 0;
    }
  }

  /// Get total number of prayers completed by a user
  Future<int> getTotalPrayersCompletedCount(String userId) async {
    try {
      final entries = await _databaseService.getUserJournalEntries(userId);
      return entries.where((e) => e.prayerMarked).length;
    } catch (e) {
      print('Error getting prayers completed count: $e');
      return 0;
    }
  }
}

