import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000/api/top10';
  // 👆 use 10.0.2.2 instead of localhost for Android Emulator

  static Future<List<dynamic>> fetchTop10() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top 10');
    }
  }
}
