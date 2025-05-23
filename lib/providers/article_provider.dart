import 'package:flutter/material.dart';
import '../models/article_model.dart';

class ArticleProvider extends ChangeNotifier {
  List<Article> _allArticles = [];
  List<Article> _filteredArticles = [];
  bool isLoading = false;

  List<Article> get articles => _filteredArticles;

  Future<void> fetchArticles() async {
    isLoading = true;
    notifyListeners();

    // Dummy data for testing
    _allArticles = [
      Article(
        title: "Test Article",
        description: "This is a test article description.",
        url: "https://example.com",
        sourceName: "Example Source",
        publishedAt: DateTime.now(),
      ),
    ];

    _filteredArticles = _allArticles;
    isLoading = false;
    notifyListeners();
  }

  void filterArticles(String query) {
    if (query.isEmpty) {
      _filteredArticles = _allArticles;
    } else {
      final lowerQuery = query.toLowerCase();
      _filteredArticles = _allArticles.where((article) {
        return (article.title?.toLowerCase().contains(lowerQuery) ?? false) ||
            (article.description?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    }
    notifyListeners();
  }
}
