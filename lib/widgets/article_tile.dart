import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ArticleTile extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback? onDelete;

  const ArticleTile({
    super.key,
    required this.article,
    this.onDelete,
  });

  String formatDate(String date) {
    try {
      DateTime dt = DateTime.parse(date);
      return DateFormat('d MMM yyyy').format(dt);
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.orange.shade200,
      color: Colors.orange.shade50, // subtle light orange background
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Handle tile tap
        },
        splashColor: Colors.orange.withOpacity(0.2),
        highlightColor: Colors.orange.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: article['urlToImage'] != null
                      ? Image.network(
                    article['urlToImage'],
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                          color: Colors.orange.shade400,
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.orange.shade100,
                      child: Icon(Icons.broken_image,
                          color: Colors.orange.shade300, size: 32),
                    ),
                  )
                      : Container(
                    color: Colors.orange.shade100,
                    child: Icon(Icons.image,
                        color: Colors.orange.shade300, size: 32),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      article['title'] ?? 'No Title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.orange.shade900,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Description
                    Text(
                      article['description'] ?? 'No Description',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.orange.shade700,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Source and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          article['source']?['name'] ?? 'Unknown',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        Text(
                          formatDate(article['publishedAt'] ?? ''),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.orange.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete icon with subtle button style
              IconButton(
                icon: Icon(Icons.delete_outline, color: Colors.orange.shade700),
                onPressed: onDelete,
                tooltip: 'Remove Bookmark',
                splashRadius: 24,
                splashColor: Colors.orange.shade100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
