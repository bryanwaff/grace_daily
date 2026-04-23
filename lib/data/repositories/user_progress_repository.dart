import 'package:grace_daily/data/datasources/database_service.dart';
import 'package:grace_daily/data/models/models.dart';

/// Repository for managing user progress through the 365-day journey.
/// Tracks completion, current day, and statistics.
class UserProgressRepository {
  final DatabaseService _databaseService;

  UserProgressRepository({DatabaseService? databaseService})
      : _databaseService = databaseService ?? DatabaseService();

  /// Initialize user progress (call on first app launch)
  Future<bool> initializeUserProgress(String userId) async {
    try {
      final now = DateTime.now();
      final progress = UserProgress(
        userId: userId,
        currentDayNumber: 1,
        lastAccessDate: now,
        totalDaysCompleted: 0,
        completedDayNumbers: [],
        createdAt: now,
      );
      await _databaseService.insertUserProgress(progress);
      return true;
    } catch (e) {
      print('Error initializing user progress: $e');
      return false;
    }
  }

  /// Get user progress
  Future<UserProgress?> getUserProgress(String userId) async {
    try {
      return await _databaseService.getUserProgress(userId);
    } catch (e) {
      print('Error getting user progress: $e');
      return null;
    }
  }

  /// Update user progress
  Future<bool> updateUserProgress(UserProgress progress) async {
    try {
      await _databaseService.updateUserProgress(progress);
      return true;
    } catch (e) {
      print('Error updating user progress: $e');
      return false;
    }
  }

  /// Mark a day as completed
  Future<bool> markDayCompleted(String userId, int dayNumber) async {
    try {
      final progress = await _databaseService.getUserProgress(userId);
      if (progress == null) {
        // Initialize if doesn't exist
        await initializeUserProgress(userId);
        return markDayCompleted(userId, dayNumber);
      }

      final updatedProgress = progress.addCompletedDay(dayNumber);
      await _databaseService.updateUserProgress(updatedProgress);
      return true;
    } catch (e) {
      print('Error marking day completed: $e');
      return false;
    }
  }

  /// Get current day for user
  Future<int> getCurrentDay(String userId) async {
    try {
      final progress = await _databaseService.getUserProgress(userId);
      return progress?.currentDayNumber ?? 1;
    } catch (e) {
      print('Error getting current day: $e');
      return 1;
    }
  }

  /// Get total completed days
  Future<int> getTotalCompletedDays(String userId) async {
    try {
      final progress = await _databaseService.getUserProgress(userId);
      return progress?.totalDaysCompleted ?? 0;
    } catch (e) {
      print('Error getting completed days: $e');
      return 0;
    }
  }

  /// Get completion percentage
  Future<double> getCompletionPercentage(String userId) async {
    try {
      final completed = await getTotalCompletedDays(userId);
      return (completed / 365) * 100;
    } catch (e) {
      print('Error getting completion percentage: $e');
      return 0.0;
    }
  }

  /// Check if a specific day is completed
  Future<bool> isDayCompleted(String userId, int dayNumber) async {
    try {
      final progress = await _databaseService.getUserProgress(userId);
      return progress?.isDayCompleted(dayNumber) ?? false;
    } catch (e) {
      print('Error checking day completion: $e');
      return false;
    }
  }

  /// Get list of completed day numbers
  Future<List<int>> getCompletedDays(String userId) async {
    try {
      final progress = await _databaseService.getUserProgress(userId);
      return progress?.completedDayNumbers ?? [];
    } catch (e) {
      print('Error getting completed days list: $e');
      return [];
    }
  }

  /// Update last access date (call when user opens app)
  Future<bool> updateLastAccessDate(String userId) async {
    try {
      final progress = await _databaseService.getUserProgress(userId);
      if (progress == null) {
        await initializeUserProgress(userId);
        return updateLastAccessDate(userId);
      }

      final updated = progress.copyWith(
        lastAccessDate: DateTime.now(),
      );
      await _databaseService.updateUserProgress(updated);
      return true;
    } catch (e) {
      print('Error updating last access date: $e');
      return false;
    }
  }

  /// Get days since last access
  Future<int> getDaysSinceLastAccess(String userId) async {
    try {
      final progress = await _databaseService.getUserProgress(userId);
      if (progress == null) return 0;

      final difference = DateTime.now().difference(progress.lastAccessDate);
      return difference.inDays;
    } catch (e) {
      print('Error getting days since last access: $e');
      return 0;
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    try {
      final progress = await _databaseService.getUserProgress(userId);
      if (progress == null) return {};

      return {
        'userId': userId,
        'currentDay': progress.currentDayNumber,
        'totalCompleted': progress.totalDaysCompleted,
        'completionPercentage': (progress.totalDaysCompleted / 365) * 100,
        'lastAccessDate': progress.lastAccessDate,
        'daysStreak': await _calculateStreak(userId, progress.completedDayNumbers),
      };
    } catch (e) {
      print('Error getting user statistics: $e');
      return {};
    }
  }

  /// Calculate consecutive days streak
  Future<int> _calculateStreak(String userId, List<int> completedDays) async {
    if (completedDays.isEmpty) return 0;

    completedDays.sort();
    int streak = 1;

    for (int i = 1; i < completedDays.length; i++) {
      if (completedDays[i] == completedDays[i - 1] + 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Reset user progress (use with caution!)
  Future<bool> resetUserProgress(String userId) async {
    try {
      await _databaseService.deleteUserProgress(userId);
      await initializeUserProgress(userId);
      return true;
    } catch (e) {
      print('Error resetting user progress: $e');
      return false;
    }
  }
}

