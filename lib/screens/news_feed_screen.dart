import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/bookmark_provider.dart';
import 'webview_screen.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  List articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    const apiKey = 'df3dcd79093c449d95a765adc0026cc2';
    final url = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey');

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          articles = data['articles'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        debugPrint('Failed to load news, status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error fetching news: $e");
    }
  }

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
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("NEWS",style: TextStyle(
          fontWeight: FontWeight.bold
        ),)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        color: theme.primaryColor,
        onRefresh: fetchNews,
        child: articles.isEmpty
            ? Center(
          child: Text(
            "No news available at the moment.",
            style: theme.textTheme.bodyLarge,
          ),
        )
            : ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: articles.length,
          separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 16, endIndent: 16),
          itemBuilder: (context, index) {
            final article = articles[index];
            final isBookmarked =
            bookmarkProvider.isBookmarked(article['url']);

            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  if (article['url'] != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            WebviewScreen(url: article['url']),
                      ),
                    );
                  }
                },
                child: Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  clipBehavior: Clip.hardEdge,
                  shadowColor: Colors.black45,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image with gradient overlay for readability
                      Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: article['urlToImage'] != null
                                ? FadeInImage.assetNetwork(
                              placeholder:
                              'assets/placeholder.png',
                              image: article['urlToImage'],
                              fit: BoxFit.cover,
                              imageErrorBuilder:
                                  (_, __, ___) =>
                                  Container(
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                                : Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.image,
                                    size: 60,
                                    color: Colors.grey),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.5)
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              article['title'] ?? 'No Title',
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleLarge
                                  ?.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),

                            const SizedBox(height: 8),

                            // Description
                            Text(
                              article['description'] ??
                                  'No Description',
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(
                                  color: Colors.grey[800]),
                            ),

                            const SizedBox(height: 12),

                            // Source, Date, Bookmark row
                            Row(
                              children: [
                                // Source chip
                                if (article['source']?['name'] !=
                                    null)
                                  Chip(
                                    backgroundColor:
                                    theme.primaryColorLight,
                                    label: Text(
                                      article['source']['name'],
                                      style: theme
                                          .textTheme.bodySmall
                                          ?.copyWith(
                                          fontStyle:
                                          FontStyle.italic,
                                          color:
                                          theme.primaryColor),
                                    ),
                                  )
                                else
                                  Text(
                                    'Unknown source',
                                    style: theme.textTheme.bodySmall
                                        ?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                const Spacer(),

                                // Date
                                Text(
                                  formatDate(
                                      article['publishedAt'] ?? ''),
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(
                                      fontStyle:
                                      FontStyle.italic,
                                      color: Colors.grey[600]),
                                ),

                                const SizedBox(width: 8),

                                // Animated Bookmark Icon
                                AnimatedSwitcher(
                                  duration:
                                  const Duration(milliseconds: 300),
                                  child: IconButton(
                                    key: ValueKey<bool>(isBookmarked),
                                    icon: Icon(
                                      isBookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: isBookmarked
                                          ? Colors.orange
                                          : Colors.grey[400],
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      if (isBookmarked) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Already bookmarked!")),
                                        );
                                      } else {
                                        bookmarkProvider
                                            .addBookmark(article);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                              Text("Bookmarked!")),
                                        );
                                      }
                                    },
                                    tooltip: isBookmarked
                                        ? 'Bookmarked'
                                        : 'Add to bookmarks',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
