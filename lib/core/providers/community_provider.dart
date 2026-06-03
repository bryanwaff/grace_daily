import 'package:flutter/material.dart';
import 'package:grace_daily/core/models/community_reflection.dart';
import 'package:grace_daily/core/services/grace_daily_database.dart';

class CommunityProvider extends ChangeNotifier {
  final GraceDailyDatabase _db = GraceDailyDatabase();

  List<CommunityReflection> _reflections = [];
  bool _isLoading = false;
  String? _error;

  List<CommunityReflection> get reflections => _reflections;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadReflections(int verseId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _reflections = await _db.getCommunityReflections(verseId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> shareReflection(int verseId, String content, String author) async {
    final reflection = CommunityReflection(
      id: '', // Firestore will generate this
      verseId: verseId,
      content: content,
      author: author.isEmpty ? 'Anonymous Soul' : author,
      createdAt: DateTime.now(),
    );

    try {
      await _db.insertCommunityReflection(reflection);
      // Optionally reload or just insert at the top
      _reflections.insert(0, reflection);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> _leaderboard = [];
  List<Map<String, dynamic>> get leaderboard => _leaderboard;

  Future<void> loadLeaderboard() async {
    try {
      _leaderboard = await _db.getAnonymousLeaderboard();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading leaderboard: $e');
    }
  }
}
