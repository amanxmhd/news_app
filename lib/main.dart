import 'package:flutter/material.dart';
import 'package:news_app/providers/article_provider.dart';
import 'package:news_app/providers/bookmark_provider.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/login_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(const NewsApp());
}

/// Root widget of the app with multi-provider setup.
class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ArticleProvider>(
          create: (_) => ArticleProvider(),
        ),
        ChangeNotifierProvider<BookmarkProvider>(
          create: (_) => BookmarkProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
