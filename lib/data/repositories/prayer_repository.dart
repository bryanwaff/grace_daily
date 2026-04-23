import 'package:grace_daily/data/datasources/database_service.dart';
import 'package:grace_daily/data/models/models.dart';

/// Repository for managing daily prayer data.
/// Abstracts the data access layer and provides a clean API for the UI.
class PrayerRepository {
  final DatabaseService _databaseService;

  PrayerRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  /// Get prayer for today
  Future<DailyPrayer?> getTodaysPrayer() async {
    final now = DateTime.now();
    final dayOfYear = int.parse(now.difference(DateTime(now.year)).inDays.toString()) + 1;
    final dayNumber = dayOfYear > 365 ? 365 : dayOfYear;
    return getPrayer(dayNumber);
  }

  /// Get a specific prayer by day number (1-365)
  Future<DailyPrayer?> getPrayer(int dayNumber) async {
    try {
      return await _databaseService.getPrayer(dayNumber);
    } catch (e) {
      print('Error getting prayer: $e');
      return null;
    }
  }

  /// Get all prayers
  Future<List<DailyPrayer>> getAllPrayers() async {
    try {
      return await _databaseService.getAllPrayers();
    } catch (e) {
      print('Error getting all prayers: $e');
      return [];
    }
  }

  /// Get next prayer for a user
  Future<DailyPrayer?> getNextPrayer(int currentDay) async {
    try {
      final nextDay = (currentDay % 365) + 1;
      return await getPrayer(nextDay);
    } catch (e) {
      print('Error getting next prayer: $e');
      return null;
    }
  }

  /// Save prayer to local database
  Future<bool> savePrayer(DailyPrayer prayer) async {
    try {
      await _databaseService.insertPrayer(prayer);
      return true;
    } catch (e) {
      print('Error saving prayer: $e');
      return false;
    }
  }

  /// Save multiple prayers (batch insert)
  Future<bool> savePrayers(List<DailyPrayer> prayers) async {
    try {
      await _databaseService.insertPrayers(prayers);
      return true;
    } catch (e) {
      print('Error saving prayers: $e');
      return false;
    }
  }

  /// Check if prayer exists for a specific day
  Future<bool> prayerExists(int dayNumber) async {
    try {
      final prayer = await _databaseService.getPrayer(dayNumber);
      return prayer != null;
    } catch (e) {
      print('Error checking prayer existence: $e');
      return false;
    }
  }

  /// Get number of available prayers
  Future<int> getAvailablePrayerCount() async {
    try {
      final prayers = await _databaseService.getAllPrayers();
      return prayers.length;
    } catch (e) {
      print('Error getting prayer count: $e');
      return 0;
    }
  }
}

