import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:grace_daily/core/models/verse.dart';
import 'package:grace_daily/core/services/grace_daily_database.dart';

/// Manages devotion data and verse availability.
class DevotionProvider extends ChangeNotifier {
  final GraceDailyDatabase _db = GraceDailyDatabase();
  
  Verse? _currentVerse;
  List<Verse> _allVerses = [];
  bool _isLoading = true;
  String? _error;

  // Getters
  Verse? get currentVerse => _currentVerse;
  List<Verse> get allVerses => _allVerses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Verse> get bookmarkedVerses => _allVerses.where((v) => v.isBookmarked).toList();

  // Initialize and load devotions from Cloud Firestore
  Future<void> initializeDevotions() async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1. Load from Cloud Firestore
      _allVerses = await _db.getAllVerses();

      // 2. If empty in cloud, use bundled JSON assets first and seed them to the cloud
      if (_allVerses.isEmpty) {
        _allVerses = await _loadVersesFromAsset();
        await _db.insertVerses(_allVerses);
      }

      _updateTodayVerse();
      _isLoading = false;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Error loading devotions: $e';
      debugPrint(_error);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Forces the local JSON library to overwrite the Cloud Firestore library.
  /// Use this only when updating the master verse list.
  Future<void> forceSyncLibraryToCloud() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // 1. Load fresh from JSON
      final localVerses = await _loadVersesFromAsset();
      
      // 2. Clear local Firestore cache so we don't see old data locally
      await _db.clearCache();
      
      // 3. Push to Cloud (overwriting by ID)
      await _db.insertVerses(localVerses);
      
      // 4. Reload local state
      _allVerses = await _db.getAllVerses();
      
      _updateTodayVerse();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to sync library: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateTodayVerse() {
    if (_allVerses.isEmpty) return;
    
    // Calculate current day of the year (1-366)
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final dayOfYear = now.difference(startOfYear).inDays + 1;
    
    // Explicitly find by ID to ensure consistency between JSON and Cloud
    try {
      _currentVerse = _allVerses.firstWhere(
        (v) => v.id == dayOfYear,
        orElse: () {
          // Fallback logic if current day ID isn't found
          // Cycle through available verses as a backup
          final index = (dayOfYear - 1) % _allVerses.length;
          return _allVerses[index];
        },
      );
    } catch (e) {
      if (_allVerses.isNotEmpty) _currentVerse = _allVerses.first;
    }
  }

  // Helper to load verses directly from the JSON asset
  Future<List<Verse>> _loadVersesFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString('assets/verses/verses_365.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final List<dynamic> versesList = jsonMap['verses'] as List<dynamic>;
      
      final loadedVerses = <Verse>[];
      
      for (var data in versesList) {
        final map = data as Map<String, dynamic>;
        loadedVerses.add(
          Verse(
            id: map['id'] as int,
            text: map['text'] as String,
            reference: map['reference'] as String,
            title: map['title'] as String,
            reflection: map['reflection'] as String,
            thoughtForTheDay: map['thoughtForTheDay'] as String,
            dailyIntention: map['dailyIntention'] as String,
            prayerText: map['prayerText'] as String,
            isBookmarked: false,
          ),
        );
      }

      // If the list is shorter than 365, we can fill the rest or just leave it.
      // For now, we trust the JSON to be the master list.
      return loadedVerses;
    } catch (e) {
      debugPrint('Error loading verses from JSON: $e. Falling back to mock generation.');
      return _generateMockVerses();
    }
  }

  // Get verse by day number
  Verse? getVerseByDay(int day) {
    if (day < 1 || day > _allVerses.length) return null;
    return _allVerses[day - 1];
  }

  // Toggle bookmark
  Future<void> toggleBookmark(int verseId) async {
    try {
      await _db.toggleBookmark(verseId);
      final index = _allVerses.indexWhere((v) => v.id == verseId);
      if (index != -1) {
        _allVerses[index] = _allVerses[index].copyWith(
          isBookmarked: !_allVerses[index].isBookmarked,
        );
        if (_currentVerse?.id == verseId) {
          _currentVerse = _currentVerse?.copyWith(
            isBookmarked: !_currentVerse!.isBookmarked,
          );
        }
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error toggling bookmark: $e';
      notifyListeners();
    }
  }

  // Generate fallback mock verses only if both Cloud and JSON fail
  List<Verse> _generateMockVerses() {
    return List.generate(365, (i) => Verse(
      id: i + 1,
      text: "Verse for Day ${i + 1}",
      reference: "Reference ${i + 1}",
      title: "Title for Day ${i + 1}",
      reflection: "Meditation for Day ${i + 1}",
      thoughtForTheDay: "Thought for Day ${i + 1}",
      dailyIntention: "Intention for Day ${i + 1}",
      prayerText: "Prayer for Day ${i + 1}",
    ));
  }
}
