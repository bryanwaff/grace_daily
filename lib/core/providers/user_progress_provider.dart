import 'package:flutter/material.dart';
import 'package:grace_daily/core/models/user_progress.dart';
import 'package:grace_daily/core/services/grace_daily_database.dart';
import 'package:grace_daily/core/services/notification_service.dart';
import 'package:grace_daily/core/services/firebase_service.dart';
import 'package:intl/intl.dart';

/// Manages user's progress, streaks, and statistics with Cloud Sync.
class UserProgressProvider extends ChangeNotifier {
  final GraceDailyDatabase _db = GraceDailyDatabase();
  final FirebaseService _firebase = FirebaseService();

  UserProgress? _progress;
  bool _isLoading = true;
  String? _error;
  int _globalPrayerCount = 0;

  // Getters
  UserProgress? get progress => _progress;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get globalPrayerCount => _globalPrayerCount;

  // Convenience getters
  int get currentStreak => _progress?.currentStreak ?? 0;
  int get longestStreak => _progress?.longestStreak ?? 0;
  int get totalCompletions => _progress?.totalCompletions ?? 0;
  bool get completedToday => _progress?.completedToday ?? false;

  // Initialize and load progress
  Future<void> initializeProgress() async {
    try {
      _isLoading = true;
      notifyListeners();

      _progress = await _db.getUserProgress();
      _progress ??= UserProgress();

      // Background sync with cloud
      _syncWithCloud();
      _fetchGlobalStats();

      _error = null;
    } catch (e) {
      _error = 'Error loading progress: $e';
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _syncWithCloud() async {
    if (_progress != null) {
      await _firebase.syncUserProgress(_progress!);
    }
  }

  Future<void> _fetchGlobalStats() async {
    _globalPrayerCount = await _firebase.getGlobalPrayerCount();
    notifyListeners();
  }

  // Mark devotion as completed today
  Future<void> completeDevotionToday() async {
    if (_progress == null) {
      await initializeProgress();
    }
    if (_progress == null) return;

    try {
      if (!_progress!.completedToday) {
        _progress = _progress!.markCompletedToday();
        await _db.updateUserProgress(_progress!);
        
        // Notify listeners immediately so the UI reflects completion instantly
        notifyListeners();

        // Push to cloud in the background so that network latency/offline state
        // doesn't block the UI transition or make the app feel frozen.
        _firebase.syncUserProgress(_progress!).catchError((e) {
          debugPrint('Error syncing progress to cloud: $e');
        });

        // Trigger streak milestone notification in the background
        if (_progress!.notificationsEnabled) {
          NotificationService.showMilestoneNotification(
            streakCount: _progress!.currentStreak,
          ).catchError((e) {
            debugPrint('Error showing milestone notification: $e');
          });
        }
      }
    } catch (e) {
      _error = 'Error completing devotion: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  // Reset streak
  Future<void> resetStreak() async {
    if (_progress == null) return;

    try {
      _progress = _progress!.copyWith(
        currentStreak: 0,
        completionMap: {},
      );
      await _db.updateUserProgress(_progress!);
      
      // Notify listeners immediately
      notifyListeners();

      // Push to cloud in the background
      _firebase.syncUserProgress(_progress!).catchError((e) {
        debugPrint('Error syncing reset streak: $e');
      });
    } catch (e) {
      _error = 'Error resetting streak: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }

  // Get completion percentage for current month
  double get monthCompletionPercentage {
    if (_progress == null) return 0;

    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    int completedDays = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final dateStr = DateFormat('yyyy-MM-dd').format(
        DateTime(now.year, now.month, day),
      );
      if (_progress!.completionMap[dateStr] == true) {
        completedDays++;
      }
    }

    return completedDays / daysInMonth;
  }

  // Get completion data for heatmap (last N days)
  Map<String, bool> getCompletionDataForDays(int days) {
    if (_progress == null) return {};

    final result = <String, bool>{};
    final now = DateTime.now();

    for (int i = 0; i < days; i++) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      result[dateStr] = _progress!.completionMap[dateStr] ?? false;
    }

    return result;
  }

  // Check if user completed devotion on a specific date
  bool isCompletedOnDate(DateTime date) {
    if (_progress == null) return false;
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return _progress!.completionMap[dateStr] ?? false;
  }

  // Get days since app joined
  int get daysSinceJoined {
    if (_progress?.joinDate == null) return 0;
    return DateTime.now().difference(_progress!.joinDate!).inDays;
  }

  // Phase 2 Notification Getters & Setters
  bool get notificationsEnabled => _progress?.notificationsEnabled ?? false;
  int get notificationHour => _progress?.notificationHour ?? 8;
  int get notificationMinute => _progress?.notificationMinute ?? 0;

  Future<void> updateNotificationSettings(bool enabled, int hour, int minute) async {
    if (_progress == null) return;

    try {
      _progress = _progress!.copyWith(
        notificationsEnabled: enabled,
        notificationHour: hour,
        notificationMinute: minute,
      );
      await _db.updateUserProgress(_progress!);
      
      // Notify listeners immediately
      notifyListeners();

      // Sync settings in the background
      _firebase.syncUserProgress(_progress!).catchError((e) {
        debugPrint('Error syncing notification settings: $e');
      });

      if (enabled) {
        NotificationService.requestPermissions().then((_) {
          NotificationService.scheduleDailyReminder(
            hour: hour,
            minute: minute,
          );
        }).catchError((e) {
          debugPrint('Error setting up daily reminders: $e');
        });
      } else {
        NotificationService.cancelNotifications().catchError((e) {
          debugPrint('Error cancelling reminders: $e');
        });
      }
    } catch (e) {
      _error = 'Error updating notification settings: $e';
      debugPrint(_error);
      notifyListeners();
    }
  }
}
