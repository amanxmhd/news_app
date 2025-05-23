import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = 'df3dcd79093c449d95a765adc0026cc2';
  static const String _baseUrl = 'https://newsapi.org/v2';

  Future<List<dynamic>> fetchTopHeadlines() async {
    final url = Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['articles'];
    } else {
      throw Exception('Failed to load news: ${response.statusCode}');
    }
  }
}
