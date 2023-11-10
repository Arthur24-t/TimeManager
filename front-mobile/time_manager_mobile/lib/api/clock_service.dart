import 'dart:convert';
import 'package:http/http.dart' as http;

class ClockService {
  static const String baseUrl = "http://10.17.72.124:4000";

  static Future<Map<String, dynamic>> createClock(
      Map<String, Map<String, Object>> clockData,
      String xsrfToken,
      String token,
      String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/clocks/$userId'),
      body: json.encode(clockData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'cookie': 'csrf_token=$xsrfToken',
      },
    );
    return json.decode(response.body);
  }
}
