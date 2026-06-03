import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:grace_daily/core/models/verse.dart';
import 'package:grace_daily/core/models/journal_entry.dart';
import 'package:grace_daily/core/models/user_progress.dart';

/// Database service for local persistence of verses, journals, and user progress.
class GraceDailyDatabase {
  static final GraceDailyDatabase _instance = GraceDailyDatabase._internal();
  static Database? _database;

  // Web in-memory fallbacks to prevent SQLite crashes on Web
  final List<Map<String, dynamic>> _webVerses = [];
  final List<Map<String, dynamic>> _webJournalEntries = [];
  Map<String, dynamic>? _webUserProgress;

  factory GraceDailyDatabase() {
    return _instance;
  }

  GraceDailyDatabase._internal();

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'grace_daily.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE user_progress ADD COLUMN notificationsEnabled INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE user_progress ADD COLUMN notificationHour INTEGER DEFAULT 8');
      await db.execute('ALTER TABLE user_progress ADD COLUMN notificationMinute INTEGER DEFAULT 0');
    }
  }

  Future<void> _createTables(Database db, int version) async {
    // Verses table
    await db.execute('''
      CREATE TABLE verses(
        id INTEGER PRIMARY KEY,
        text TEXT NOT NULL,
        reference TEXT NOT NULL,
        title TEXT NOT NULL,
        reflection TEXT NOT NULL,
        quote TEXT NOT NULL,
        thoughtForTheDay TEXT NOT NULL,
        dailyIntention TEXT NOT NULL,
        prayerText TEXT NOT NULL,
        isBookmarked INTEGER DEFAULT 0
      )
    ''');

    // Journal entries table
    await db.execute('''
      CREATE TABLE journal_entries(
        id INTEGER PRIMARY KEY,
        verseId INTEGER NOT NULL,
        content TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        isPrayed INTEGER DEFAULT 0,
        FOREIGN KEY (verseId) REFERENCES verses(id)
      )
    ''');

    // User progress table (v2 includes notification settings)
    await db.execute('''
      CREATE TABLE user_progress(
        id INTEGER PRIMARY KEY,
        currentStreak INTEGER DEFAULT 0,
        longestStreak INTEGER DEFAULT 0,
        totalCompletions INTEGER DEFAULT 0,
        lastCompletionDate TEXT NOT NULL,
        joinDate TEXT,
        completionMap TEXT NOT NULL,
        notificationsEnabled INTEGER DEFAULT 0,
        notificationHour INTEGER DEFAULT 8,
        notificationMinute INTEGER DEFAULT 0
      )
    ''');

    // Insert default user progress
    await db.insert(
      'user_progress',
      {
        'id': 1,
        'currentStreak': 0,
        'longestStreak': 0,
        'totalCompletions': 0,
        'lastCompletionDate': DateTime.now().toIso8601String(),
        'joinDate': DateTime.now().toIso8601String(),
        'completionMap': '',
        'notificationsEnabled': 0,
        'notificationHour': 8,
        'notificationMinute': 0,
      },
    );
  }

  void _initWebUserProgress() {
    _webUserProgress ??= {
      'id': 1,
      'currentStreak': 0,
      'longestStreak': 0,
      'totalCompletions': 0,
      'lastCompletionDate': DateTime.now().toIso8601String(),
      'joinDate': DateTime.now().toIso8601String(),
      'completionMap': '',
      'notificationsEnabled': 0,
      'notificationHour': 8,
      'notificationMinute': 0,
    };
  }

  // ===== VERSES =====

  Future<Verse?> getVerseById(int id) async {
    if (kIsWeb) {
      final index = _webVerses.indexWhere((v) => v['id'] == id);
      return index != -1 ? Verse.fromJson(_webVerses[index]) : null;
    }
    final db = await database;
    final result = await db.query(
      'verses',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? Verse.fromJson(result.first) : null;
  }

  Future<List<Verse>> getAllVerses() async {
    if (kIsWeb) {
      return _webVerses.map((json) => Verse.fromJson(json)).toList();
    }
    final db = await database;
    final result = await db.query('verses');
    return result.map((json) => Verse.fromJson(json)).toList();
  }

  Future<List<Verse>> getBookmarkedVerses() async {
    if (kIsWeb) {
      return _webVerses
          .where((v) => v['isBookmarked'] == 1)
          .map((json) => Verse.fromJson(json))
          .toList();
    }
    final db = await database;
    final result = await db.query(
      'verses',
      where: 'isBookmarked = 1',
    );
    return result.map((json) => Verse.fromJson(json)).toList();
  }

  Future<void> insertVerse(Verse verse) async {
    if (kIsWeb) {
      final index = _webVerses.indexWhere((v) => v['id'] == verse.id);
      if (index != -1) {
        _webVerses[index] = verse.toJson();
      } else {
        _webVerses.add(verse.toJson());
      }
      return;
    }
    final db = await database;
    await db.insert('verses', verse.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertVerses(List<Verse> verses) async {
    if (kIsWeb) {
      for (final verse in verses) {
        await insertVerse(verse);
      }
      return;
    }
    final db = await database;
    await db.transaction((txn) async {
      final batch = txn.batch();
      for (final verse in verses) {
        batch.insert('verses', verse.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> replaceVerses(List<Verse> verses) async {
    if (kIsWeb) {
      _webVerses.clear();
      for (final verse in verses) {
        _webVerses.add(verse.toJson());
      }
      return;
    }
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('verses');
      final batch = txn.batch();
      for (final verse in verses) {
        batch.insert('verses', verse.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
    });
  }

  Future<void> deleteAllVerses() async {
    if (kIsWeb) {
      _webVerses.clear();
      return;
    }
    final db = await database;
    await db.delete('verses');
  }

  Future<void> toggleBookmark(int verseId) async {
    if (kIsWeb) {
      final index = _webVerses.indexWhere((v) => v['id'] == verseId);
      if (index != -1) {
        final current = _webVerses[index]['isBookmarked'] == 1;
        _webVerses[index]['isBookmarked'] = current ? 0 : 1;
      }
      return;
    }
    final db = await database;
    final verse = await getVerseById(verseId);
    if (verse != null) {
      await db.update(
        'verses',
        {'isBookmarked': verse.isBookmarked ? 0 : 1},
        where: 'id = ?',
        whereArgs: [verseId],
      );
    }
  }

  // ===== JOURNAL ENTRIES =====

  Future<JournalEntry?> getJournalEntryById(int id) async {
    if (kIsWeb) {
      final index = _webJournalEntries.indexWhere((e) => e['id'] == id);
      return index != -1 ? JournalEntry.fromJson(_webJournalEntries[index]) : null;
    }
    final db = await database;
    final result = await db.query(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? JournalEntry.fromJson(result.first) : null;
  }

  Future<List<JournalEntry>> getJournalEntriesByVerseId(int verseId) async {
    if (kIsWeb) {
      final filtered = _webJournalEntries.where((e) => e['verseId'] == verseId).toList();
      filtered.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
      return filtered.map((json) => JournalEntry.fromJson(json)).toList();
    }
    final db = await database;
    final result = await db.query(
      'journal_entries',
      where: 'verseId = ?',
      whereArgs: [verseId],
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => JournalEntry.fromJson(json)).toList();
  }

  Future<List<JournalEntry>> getAllJournalEntries() async {
    if (kIsWeb) {
      final sorted = List<Map<String, dynamic>>.from(_webJournalEntries);
      sorted.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
      return sorted.map((json) => JournalEntry.fromJson(json)).toList();
    }
    final db = await database;
    final result = await db.query(
      'journal_entries',
      orderBy: 'createdAt DESC',
    );
    return result.map((json) => JournalEntry.fromJson(json)).toList();
  }

  Future<void> insertJournalEntry(JournalEntry entry) async {
    if (kIsWeb) {
      _webJournalEntries.add(entry.toJson());
      return;
    }
    final db = await database;
    await db.insert('journal_entries', entry.toJson());
  }

  Future<void> updateJournalEntry(JournalEntry entry) async {
    if (kIsWeb) {
      final index = _webJournalEntries.indexWhere((e) => e['id'] == entry.id);
      if (index != -1) {
        _webJournalEntries[index] = entry.toJson();
      }
      return;
    }
    final db = await database;
    await db.update(
      'journal_entries',
      entry.toJson(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<void> deleteJournalEntry(int id) async {
    if (kIsWeb) {
      _webJournalEntries.removeWhere((e) => e['id'] == id);
      return;
    }
    final db = await database;
    await db.delete(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ===== USER PROGRESS =====

  Future<UserProgress?> getUserProgress() async {
    if (kIsWeb) {
      _initWebUserProgress();
      return UserProgress.fromJson(_webUserProgress!);
    }
    final db = await database;
    final result = await db.query('user_progress', where: 'id = 1');
    return result.isNotEmpty ? UserProgress.fromJson(result.first) : null;
  }

  Future<void> updateUserProgress(UserProgress progress) async {
    if (kIsWeb) {
      _webUserProgress = progress.toJson();
      return;
    }
    final db = await database;
    await db.update(
      'user_progress',
      progress.toJson(),
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  Future<void> close() async {
    if (kIsWeb) return;
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
