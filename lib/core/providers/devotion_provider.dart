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
