import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:grace_daily/core/models/verse.dart';
import 'package:grace_daily/core/services/grace_daily_database.dart';
import 'package:grace_daily/core/services/firebase_service.dart';

/// Manages devotion data and verse availability.
class DevotionProvider extends ChangeNotifier {
  final GraceDailyDatabase _db = GraceDailyDatabase();
  final FirebaseService _firebase = FirebaseService();
  
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

  // Initialize and load devotions, actively syncing with Firebase Firestore
  Future<void> initializeDevotions() async {
    try {
      _isLoading = true;
      notifyListeners();

      // 1. Load from local database first (Offline-first / Instant load)
      _allVerses = await _db.getAllVerses();

      // 2. If local is empty, use bundled JSON assets first so the user gets immediate content
      if (_allVerses.isEmpty) {
        _allVerses = await _loadVersesFromAsset();
        await _db.insertVerses(_allVerses);
      }

      _updateTodayVerse();
      _isLoading = false;
      notifyListeners();

      // 3. Fetch latest data from Firebase Firestore in background to refresh and update
      _syncWithCloud();
      _error = null;
    } catch (e) {
      _error = 'Error loading devotions: $e';
      debugPrint(_error);
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Background-syncs verses from Cloud Firestore while preserving user bookmark states.
  Future<void> _syncWithCloud() async {
    try {
      final cloudVerses = await _firebase.fetchVersesFromCloud();
      if (cloudVerses.isNotEmpty) {
        // Map of current local bookmark states to preserve them during cloud merge
        final localVerses = await _db.getAllVerses();
        final localBookmarkMap = {for (var v in localVerses) v.id: v.isBookmarked};

        final syncedVerses = cloudVerses.map((cloudVerse) {
          final wasBookmarked = localBookmarkMap[cloudVerse.id] ?? false;
          return cloudVerse.copyWith(isBookmarked: wasBookmarked);
        }).toList();

        // Atomically replace all local verses with the fresh cloud data in a single transaction.
        // This prevents race conditions where the table is temporarily empty during a sync.
        await _db.replaceVerses(syncedVerses);
        
        // Refresh local memory and UI
        _allVerses = await _db.getAllVerses();
        _updateTodayVerse();
        notifyListeners();
        debugPrint('Successfully synced and cached ${cloudVerses.length} devotions from Cloud Firestore.');
      }
    } catch (e) {
      debugPrint('Cloud Firestore devotion sync skipped/failed: $e');
    }
  }

  void _updateTodayVerse() {
    if (_allVerses.isEmpty) return;
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays + 1;
    final verseIndex = (dayOfYear - 1) % _allVerses.length;
    _currentVerse = _allVerses[verseIndex];
  }

  // Helper to load 365 verses by cycling the beautifully curated JSON database
  Future<List<Verse>> _loadVersesFromAsset() async {
    try {
      final jsonString = await rootBundle.loadString('assets/verses/verses_365.json');
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      final List<dynamic> versesList = jsonMap['verses'] as List<dynamic>;
      
      final loadedVerses = <Verse>[];
      
      for (int i = 0; i < 365; i++) {
        final data = versesList[i % versesList.length] as Map<String, dynamic>;
        loadedVerses.add(
          Verse(
            id: i + 1,
            text: data['text'] as String,
            reference: data['reference'] as String,
            title: data['title'] as String,
            reflection: data['reflection'] as String,
            quote: data['quote'] as String,
            thoughtForTheDay: data['thoughtForTheDay'] as String,
            dailyIntention: data['dailyIntention'] as String,
            prayerText: data['prayerText'] as String,
            isBookmarked: false,
          ),
        );
      }
      return loadedVerses;
    } catch (e) {
      debugPrint('Error loading verses from JSON: $e. Falling back to simple generation.');
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

  // Generate fallback mock verses
  List<Verse> _generateMockVerses() {
    final mockData = [
      {
        'text': '"For I know the plans I have for you," declares the LORD,\n"plans to prosper you and not to harm you,\nplans to give you hope and a future."',
        'reference': 'Jeremiah 29:11',
        'title': 'God\'s Perfect Plan',
        'reflection': 'In the quiet moments of reflection, we often struggle with uncertainty about our future. Yet the promise in Jeremiah offers profound peace: God has a purpose for each of us.',
        'quote': '"When you cannot see the path forward, trust that you are exactly where you need to be."',
        'thoughtForTheDay': 'Take time today to reflect on how God has guided you through difficult times. His plans are always working for your good.',
        'dailyIntention': 'Finding Purpose',
        'prayerText': '"Lord, help me trust in Your plans for my life, even when I cannot see the path ahead. Grant me peace in knowing that You are guiding me toward a future filled with hope."'
      }
    ];

    final verses = <Verse>[];
    for (int i = 0; i < 365; i++) {
      final data = mockData[i % mockData.length];
      verses.add(
        Verse(
          id: i + 1,
          text: data['text'] as String,
          reference: data['reference'] as String,
          title: data['title'] as String,
          reflection: data['reflection'] as String,
          quote: data['quote'] as String,
          thoughtForTheDay: data['thoughtForTheDay'] as String,
          dailyIntention: data['dailyIntention'] as String,
          prayerText: data['prayerText'] as String,
        ),
      );
    }
    return verses;
  }
}
