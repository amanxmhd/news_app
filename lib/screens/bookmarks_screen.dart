import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/bookmark_provider.dart';
import '../widgets/article_tile.dart';

/// Screen to display and manage bookmarked articles.
class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  /// Shows a confirmation dialog before deleting a bookmark.
  Future<void> _confirmDelete(BuildContext context, VoidCallback onDelete) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Bookmark'),
        content: const Text('Are you sure you want to remove this bookmark?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[700])),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(ctx).pop(true);
            },
            child: Text('Remove', style: TextStyle(color: Colors.orange.shade700)),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      onDelete();
    }
  }

  /// Widget shown when there are no bookmarks saved.
  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bookmark_border, size: 72, color: Colors.orange),
            ),
            const SizedBox(height: 24),
            Text(
              'No bookmarks yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start bookmarking your favorite articles to read them later.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevation: 5,
        backgroundColor: Colors.white,
        centerTitle: false,
        foregroundColor: Colors.orange.shade700,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
        ),
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, bookmarkProvider, _) {
          final bookmarks = bookmarkProvider.bookmarkedArticles;

          if (bookmarks.isEmpty) {
            return _buildEmptyState(context);
          }

          return RefreshIndicator(
            color: Colors.orange.shade700,
            onRefresh: () async {
              // TODO: Add real refresh logic if needed
              await Future.delayed(const Duration(milliseconds: 400));
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              itemCount: bookmarks.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Header showing total bookmarks count
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        Icon(Icons.bookmark, size: 28, color: Colors.orange.shade700),
                        const SizedBox(width: 12),
                        Text(
                          '${bookmarks.length} saved articles',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final article = bookmarks[index - 1];

                return Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 4,
                  shadowColor: Colors.orange.shade200.withOpacity(0.4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: Colors.orange.shade100.withOpacity(0.5),
                    highlightColor: Colors.transparent,
                    child: ArticleTile(
                      article: article,
                      onDelete: () => _confirmDelete(context, () {
                        bookmarkProvider.removeBookmark(article['url']);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Bookmark removed'),
                            backgroundColor: Colors.grey.shade900,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
