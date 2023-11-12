import 'dart:convert';
import 'package:http/http.dart' as http;

class WorkingTimeService {
  static const String baseUrl = "http://timemanager.freeboxos.fr:4000";

  static Future<Map<String, dynamic>> createWorkingTime(
      Map<String, Map<String, Object>> workingTimeData,
      String xsrfToken,
      String token,
      String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/workingtimes/$userId'),
      body: json.encode(workingTimeData),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'cookie': 'csrf_token=$xsrfToken',
      },
    );
    return json.decode(response.body);
  }

  static Future<List<dynamic>> getWorkingTime(
      String xsrfToken, String token, String userId) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/api/workingtimes/$userId?start=2023-01-12 12:45:14&end=2023-12-12 12:45:14'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'cookie': 'csrf_token=$xsrfToken',
      },
    );
    return json.decode(response.body)['data'];
  }
}
