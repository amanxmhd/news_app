import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _bookmarkedArticles = [];

  List<Map<String, dynamic>> get bookmarkedArticles => _bookmarkedArticles;

  BookmarkProvider() {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> saved = prefs.getStringList('bookmarks') ?? [];
      final List<Map<String, dynamic>> loaded = [];
      for (var e in saved) {
        try {
          final decoded = jsonDecode(e);
          if (decoded is Map<String, dynamic>) {
            loaded.add(decoded);
          }
        } catch (_) {
          // Skip invalid JSON entries safely
          continue;
        }
      }
      _bookmarkedArticles = loaded;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading bookmarks: $e');
      }
    }
  }

  Future<void> addBookmark(Map<String, dynamic> article) async {
    final url = article['url'];
    if (url == null) return; // Safety check: skip if no URL

    if (_bookmarkedArticles.any((a) => a['url'] == url)) return;
    _bookmarkedArticles.add(article);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> removeBookmark(String url) async {
    _bookmarkedArticles.removeWhere((article) => article['url'] == url);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> encoded =
      _bookmarkedArticles.map((e) => jsonEncode(e)).toList();
      await prefs.setStringList('bookmarks', encoded);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving bookmarks: $e');
      }
    }
  }

  bool isBookmarked(String url) {
    return _bookmarkedArticles.any((article) => article['url'] == url);
  }
}
