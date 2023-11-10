import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:time_manager_mobile/storage/local_storage.dart';

class UserService {
  static const String baseUrl = "http://10.17.72.124:4000";

  static Future<Map<String, dynamic>> getUserByEmailAndUsername(
      String token) async {
    final response = await http.get(Uri.parse('$baseUrl/api/users'),
        headers: {'Authorization': 'Bearer $token'});
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> getUserById(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/api/users/$userId'));
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> createUser(
      SecureStorageService secureStorageService,
      Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: json.encode(userData),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final cookies = response.headers['set-cookie'];
    secureStorageService.writeXSRF(cookies!);
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> loginUser(
      SecureStorageService secureStorageService,
      Map<String, dynamic> credentials) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: json.encode(credentials),
      headers: {'Content-Type': 'application/json'},
    );
    final cookies = response.headers['set-cookie'];
    if (cookies != null) {
      final xsrfToken = extractXsrfToken(cookies);
      secureStorageService.writeXSRF(xsrfToken);
    }
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> modifyUser(
      int userId, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/users/$userId'),
      body: json.encode(userData),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }

  static Future<void> deleteUser(int userId) async {
    await http.delete(Uri.parse('$baseUrl/api/users/$userId'));
  }

  static Future<Map<String, dynamic>> addUserToTeam(
      int userId, int teamId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/$userId/teams/$teamId'),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }

  static Future<void> deleteUserFromTeam(int userId, int teamId) async {
    await http.delete(Uri.parse('$baseUrl/api/users/$userId/teams/$teamId'));
  }

  static Future<Map<String, dynamic>> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/api/users'));
    return json.decode(response.body);
  }

  static String extractXsrfToken(String cookies) {
    final cookieParts = cookies.split(';');
    for (var cookie in cookieParts) {
      if (cookie.trim().startsWith('csrf_token=')) {
        return cookie.split('=')[1];
      }
    }
    throw Exception('CSRF token not found in cookies');
  }
}
