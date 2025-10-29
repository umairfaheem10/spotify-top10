import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ✅ only the base domain, NOT the full API path
  static const String baseUrl = 'https://spotify-top10.vercel.app';

  static Future<List<dynamic>> fetchTop10() async {
    final response = await http.get(Uri.parse('$baseUrl/api/top10'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load top 10 artists');
    }
  }
}
