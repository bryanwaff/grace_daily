import 'package:flutter/material.dart';
import 'package:grace_daily/data/repositories/repositories.dart';
import 'package:grace_daily/data/models/models.dart';

/// Provider for managing devotion state
class DevotionProvider extends ChangeNotifier {
  final DevotionRepository _repository;
  DailyDevotion? _currentDevotion;
  bool _isLoading = false;
  String? _error;

  DevotionProvider({DevotionRepository? repository})
      : _repository = repository ?? DevotionRepository();

  // Getters
  DailyDevotion? get currentDevotion => _currentDevotion;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load today's devotion
  Future<void> loadTodaysDevotion() async {
    _setLoading(true);
    try {
      _currentDevotion = await _repository.getTodaysDevotion();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load devotion: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load a specific devotion by day number
  Future<void> loadDevotion(int dayNumber) async {
    _setLoading(true);
    try {
      _currentDevotion = await _repository.getDevotion(dayNumber);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load devotion: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Save a devotion
  Future<bool> saveDevotion(DailyDevotion devotion) async {
    try {
      final success = await _repository.saveDevotion(devotion);
      if (success) {
        _currentDevotion = devotion;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to save devotion: $e';
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

/// Provider for managing prayer state
class PrayerProvider extends ChangeNotifier {
  final PrayerRepository _repository;
  DailyPrayer? _currentPrayer;
  bool _isLoading = false;
  String? _error;

  PrayerProvider({PrayerRepository? repository})
      : _repository = repository ?? PrayerRepository();

  // Getters
  DailyPrayer? get currentPrayer => _currentPrayer;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Load today's prayer
  Future<void> loadTodaysPrayer() async {
    _setLoading(true);
    try {
      _currentPrayer = await _repository.getTodaysPrayer();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load prayer: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Load a specific prayer by day number
  Future<void> loadPrayer(int dayNumber) async {
    _setLoading(true);
    try {
      _currentPrayer = await _repository.getPrayer(dayNumber);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load prayer: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Save a prayer
  Future<bool> savePrayer(DailyPrayer prayer) async {
    try {
      final success = await _repository.savePrayer(prayer);
      if (success) {
        _currentPrayer = prayer;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to save prayer: $e';
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

/// Provider for managing user progress state
class UserProgressProvider extends ChangeNotifier {
  final UserProgressRepository _repository;
  UserProgress? _userProgress;
  bool _isLoading = false;
  String? _error;
  String _userId = 'default_user';

  UserProgressProvider({UserProgressRepository? repository})
      : _repository = repository ?? UserProgressRepository();

  // Getters
  UserProgress? get userProgress => _userProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentDay => _userProgress?.currentDayNumber ?? 1;
  int get totalCompleted => _userProgress?.totalDaysCompleted ?? 0;
  double get completionPercentage => (totalCompleted / 365) * 100;

  /// Set user ID and initialize progress
  Future<void> setUserId(String userId) async {
    _userId = userId;
    await loadUserProgress();
  }

  /// Load user progress
  Future<void> loadUserProgress() async {
    _setLoading(true);
    try {
      var progress = await _repository.getUserProgress(_userId);
      if (progress == null) {
        await _repository.initializeUserProgress(_userId);
        progress = await _repository.getUserProgress(_userId);
      }
      _userProgress = progress;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load progress: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Mark a day as completed
  Future<bool> markDayCompleted(int dayNumber) async {
    try {
      final success = await _repository.markDayCompleted(_userId, dayNumber);
      if (success) {
        await loadUserProgress(); // Refresh after update
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to mark day completed: $e';
      notifyListeners();
      return false;
    }
  }

  /// Check if a day is completed
  Future<bool> isDayCompleted(int dayNumber) async {
    return await _repository.isDayCompleted(_userId, dayNumber);
  }

  /// Update last access date
  Future<void> updateLastAccessDate() async {
    try {
      await _repository.updateLastAccessDate(_userId);
      await loadUserProgress();
    } catch (e) {
      print('Error updating last access date: $e');
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStatistics() async {
    try {
      return await _repository.getUserStatistics(_userId);
    } catch (e) {
      _error = 'Failed to get statistics: $e';
      notifyListeners();
      return {};
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

/// Provider for managing journal entries
class JournalProvider extends ChangeNotifier {
  final JournalRepository _repository;
  List<JournalEntry> _entries = [];
  bool _isLoading = false;
  String? _error;
  String _userId = 'default_user';

  JournalProvider({JournalRepository? repository})
      : _repository = repository ?? JournalRepository();

  // Getters
  List<JournalEntry> get entries => _entries;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Set user ID and load entries
  Future<void> setUserId(String userId) async {
    _userId = userId;
    await loadUserEntries();
  }

  /// Load all user journal entries
  Future<void> loadUserEntries() async {
    _setLoading(true);
    try {
      _entries = await _repository.getUserEntries(_userId);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load journal entries: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  /// Save a reflection for a day
  Future<bool> saveReflection(int dayNumber, String reflection) async {
    try {
      final success =
          await _repository.saveReflection(_userId, dayNumber, reflection);
      if (success) {
        await loadUserEntries(); // Refresh the list
      }
      return success;
    } catch (e) {
      _error = 'Failed to save reflection: $e';
      notifyListeners();
      return false;
    }
  }

  /// Mark prayer as completed
  Future<bool> markPrayerCompleted(int dayNumber) async {
    try {
      final success = await _repository.markPrayerCompleted(_userId, dayNumber);
      if (success) {
        await loadUserEntries(); // Refresh the list
      }
      return success;
    } catch (e) {
      _error = 'Failed to mark prayer: $e';
      notifyListeners();
      return false;
    }
  }

  /// Get entry for a specific day
  Future<JournalEntry?> getEntryForDay(int dayNumber) async {
    try {
      return await _repository.getEntryForDay(_userId, dayNumber);
    } catch (e) {
      _error = 'Failed to get entry: $e';
      notifyListeners();
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

