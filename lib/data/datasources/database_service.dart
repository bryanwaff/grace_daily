import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:grace_daily/data/models/models.dart';

/// Database service for managing all SQLite operations.
/// Handles creation, migrations, and CRUD operations for all data models.
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  /// Get the database instance, initializing if necessary
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'grace_daily.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create all required tables
  Future<void> _createTables(Database db, int version) async {
    // Create daily_devotions table
    await db.execute('''
      CREATE TABLE daily_devotions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dayNumber INTEGER UNIQUE NOT NULL,
        date TEXT NOT NULL,
        verse TEXT NOT NULL,
        verseReference TEXT NOT NULL,
        title TEXT NOT NULL,
        meditationText TEXT NOT NULL,
        quote TEXT NOT NULL,
        thoughtForDay TEXT NOT NULL,
        audioTitle TEXT,
        imageUrl TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT
      )
    ''');

    // Create daily_prayers table
    await db.execute('''
      CREATE TABLE daily_prayers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dayNumber INTEGER UNIQUE NOT NULL,
        date TEXT NOT NULL,
        intention TEXT NOT NULL,
        prayerText TEXT NOT NULL,
        attribution TEXT,
        soundscapeTitle TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create journal_entries table
    await db.execute('''
      CREATE TABLE journal_entries (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        dayNumber INTEGER NOT NULL,
        dateCreated TEXT NOT NULL,
        reflection TEXT,
        prayerMarked INTEGER DEFAULT 0,
        markedAt TEXT,
        tags TEXT
      )
    ''');

    // Create user_progress table
    await db.execute('''
      CREATE TABLE user_progress (
        userId TEXT PRIMARY KEY,
        currentDayNumber INTEGER DEFAULT 1,
        lastAccessDate TEXT NOT NULL,
        totalDaysCompleted INTEGER DEFAULT 0,
        completedDays TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT
      )
    ''');

    // Create user_settings table
    await db.execute('''
      CREATE TABLE user_settings (
        userId TEXT PRIMARY KEY,
        notificationsEnabled INTEGER DEFAULT 1,
        notificationTime TEXT DEFAULT '06:00',
        theme TEXT DEFAULT 'light',
        createdAt TEXT NOT NULL,
        updatedAt TEXT
      )
    ''');
  }

  /// Handle database upgrades/migrations
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Add migration logic here if database schema changes in future versions
  }

  /// Close the database
  Future<void> closeDatabase() async {
    _database?.close();
    _database = null;
  }

  /// Clear all data (use with caution!)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('daily_devotions');
    await db.delete('daily_prayers');
    await db.delete('journal_entries');
    await db.delete('user_progress');
    await db.delete('user_settings');
  }

  // ============ DAILY DEVOTIONS ============

  /// Insert a daily devotion
  Future<int> insertDevotion(DailyDevotion devotion) async {
    final db = await database;
    return db.insert(
      'daily_devotions',
      devotion.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Insert multiple devotions
  Future<void> insertDevotions(List<DailyDevotion> devotions) async {
    final db = await database;
    final batch = db.batch();
    for (final devotion in devotions) {
      batch.insert(
        'daily_devotions',
        devotion.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  /// Get devotion by day number
  Future<DailyDevotion?> getDevotion(int dayNumber) async {
    final db = await database;
    final result = await db.query(
      'daily_devotions',
      where: 'dayNumber = ?',
      whereArgs: [dayNumber],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return DailyDevotion.fromJson(result.first);
  }

  /// Get all devotions
  Future<List<DailyDevotion>> getAllDevotions() async {
    final db = await database;
    final result = await db.query('daily_devotions');
    return result.map(DailyDevotion.fromJson).toList();
  }

  /// Get devotions for a date range
  Future<List<DailyDevotion>> getDevotionsByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await database;
    final result = await db.query(
      'daily_devotions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
    );
    return result.map(DailyDevotion.fromJson).toList();
  }

  /// Update a devotion
  Future<int> updateDevotion(DailyDevotion devotion) async {
    final db = await database;
    return db.update(
      'daily_devotions',
      devotion.toJson(),
      where: 'dayNumber = ?',
      whereArgs: [devotion.dayNumber],
    );
  }

  /// Delete a devotion
  Future<int> deleteDevotion(int dayNumber) async {
    final db = await database;
    return db.delete(
      'daily_devotions',
      where: 'dayNumber = ?',
      whereArgs: [dayNumber],
    );
  }

  // ============ DAILY PRAYERS ============

  /// Insert a daily prayer
  Future<int> insertPrayer(DailyPrayer prayer) async {
    final db = await database;
    return db.insert(
      'daily_prayers',
      prayer.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Insert multiple prayers
  Future<void> insertPrayers(List<DailyPrayer> prayers) async {
    final db = await database;
    final batch = db.batch();
    for (final prayer in prayers) {
      batch.insert(
        'daily_prayers',
        prayer.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  /// Get prayer by day number
  Future<DailyPrayer?> getPrayer(int dayNumber) async {
    final db = await database;
    final result = await db.query(
      'daily_prayers',
      where: 'dayNumber = ?',
      whereArgs: [dayNumber],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return DailyPrayer.fromJson(result.first);
  }

  /// Get all prayers
  Future<List<DailyPrayer>> getAllPrayers() async {
    final db = await database;
    final result = await db.query('daily_prayers');
    return result.map(DailyPrayer.fromJson).toList();
  }

  /// Update a prayer
  Future<int> updatePrayer(DailyPrayer prayer) async {
    final db = await database;
    return db.update(
      'daily_prayers',
      prayer.toJson(),
      where: 'dayNumber = ?',
      whereArgs: [prayer.dayNumber],
    );
  }

  /// Delete a prayer
  Future<int> deletePrayer(int dayNumber) async {
    final db = await database;
    return db.delete(
      'daily_prayers',
      where: 'dayNumber = ?',
      whereArgs: [dayNumber],
    );
  }

  // ============ JOURNAL ENTRIES ============

  /// Insert a journal entry
  Future<int> insertJournalEntry(JournalEntry entry) async {
    final db = await database;
    return db.insert(
      'journal_entries',
      entry.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get journal entry by ID
  Future<JournalEntry?> getJournalEntry(String id) async {
    final db = await database;
    final result = await db.query(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return JournalEntry.fromJson(result.first);
  }

  /// Get journal entries for a user
  Future<List<JournalEntry>> getUserJournalEntries(String userId) async {
    final db = await database;
    final result = await db.query(
      'journal_entries',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'dateCreated DESC',
    );
    return result.map(JournalEntry.fromJson).toList();
  }

  /// Get journal entry for a specific user and day
  Future<JournalEntry?> getJournalEntryForDay(
      String userId, int dayNumber) async {
    final db = await database;
    final result = await db.query(
      'journal_entries',
      where: 'userId = ? AND dayNumber = ?',
      whereArgs: [userId, dayNumber],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return JournalEntry.fromJson(result.first);
  }

  /// Update a journal entry
  Future<int> updateJournalEntry(JournalEntry entry) async {
    final db = await database;
    return db.update(
      'journal_entries',
      entry.toJson(),
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  /// Delete a journal entry
  Future<int> deleteJournalEntry(String id) async {
    final db = await database;
    return db.delete(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============ USER PROGRESS ============

  /// Insert or update user progress
  Future<int> insertUserProgress(UserProgress progress) async {
    final db = await database;
    return db.insert(
      'user_progress',
      progress.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get user progress
  Future<UserProgress?> getUserProgress(String userId) async {
    final db = await database;
    final result = await db.query(
      'user_progress',
      where: 'userId = ?',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return UserProgress.fromJson(result.first);
  }

  /// Update user progress
  Future<int> updateUserProgress(UserProgress progress) async {
    final db = await database;
    return db.update(
      'user_progress',
      progress.toJson(),
      where: 'userId = ?',
      whereArgs: [progress.userId],
    );
  }

  /// Delete user progress
  Future<int> deleteUserProgress(String userId) async {
    final db = await database;
    return db.delete(
      'user_progress',
      where: 'userId = ?',
      whereArgs: [userId],
    );
  }
}

