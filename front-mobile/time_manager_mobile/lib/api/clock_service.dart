import 'dart:convert';
import 'package:http/http.dart' as http;

class ClockService {
  static const String baseUrl = "http://timemanager.freeboxos.fr:4000";

  static Future<Map<String, dynamic>> createClock(
      dynamic clockData, String xsrfToken, String token, String userId) async {
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
