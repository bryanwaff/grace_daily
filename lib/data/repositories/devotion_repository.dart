import 'package:grace_daily/data/datasources/database_service.dart';
import 'package:grace_daily/data/models/models.dart';

/// Repository for managing daily devotion data.
/// Abstracts the data access layer and provides a clean API for the UI.
class DevotionRepository {
  final DatabaseService _databaseService;

  DevotionRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  /// Get devotion for today (based on current date)
  Future<DailyDevotion?> getTodaysDevotion() async {
    final now = DateTime.now();
    final dayOfYear = int.parse(now.difference(DateTime(now.year)).inDays.toString()) + 1;
    // Ensure dayOfYear is between 1 and 365
    final dayNumber = dayOfYear > 365 ? 365 : dayOfYear;
    return getDevotion(dayNumber);
  }

  /// Get a specific devotion by day number (1-365)
  Future<DailyDevotion?> getDevotion(int dayNumber) async {
    try {
      return await _databaseService.getDevotion(dayNumber);
    } catch (e) {
      print('Error getting devotion: $e');
      return null;
    }
  }

  /// Get all devotions
  Future<List<DailyDevotion>> getAllDevotions() async {
    try {
      return await _databaseService.getAllDevotions();
    } catch (e) {
      print('Error getting all devotions: $e');
      return [];
    }
  }

  /// Get next unread devotion for a user based on their progress
  Future<DailyDevotion?> getNextDevotion(int currentDay) async {
    try {
      final nextDay = (currentDay % 365) + 1;
      return await getDevotion(nextDay);
    } catch (e) {
      print('Error getting next devotion: $e');
      return null;
    }
  }

  /// Save devotion to local database
  Future<bool> saveDevotion(DailyDevotion devotion) async {
    try {
      await _databaseService.insertDevotion(devotion);
      return true;
    } catch (e) {
      print('Error saving devotion: $e');
      return false;
    }
  }

  /// Save multiple devotions (batch insert)
  Future<bool> saveDevotions(List<DailyDevotion> devotions) async {
    try {
      await _databaseService.insertDevotions(devotions);
      return true;
    } catch (e) {
      print('Error saving devotions: $e');
      return false;
    }
  }

  /// Check if devotion exists for a specific day
  Future<bool> devotionExists(int dayNumber) async {
    try {
      final devotion = await _databaseService.getDevotion(dayNumber);
      return devotion != null;
    } catch (e) {
      print('Error checking devotion existence: $e');
      return false;
    }
  }

  /// Get number of available devotions
  Future<int> getAvailableDevotionCount() async {
    try {
      final devotions = await _databaseService.getAllDevotions();
      return devotions.length;
    } catch (e) {
      print('Error getting devotion count: $e');
      return 0;
    }
  }
}

