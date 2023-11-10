import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<String?> getXSRF() async {
    return await _storage.read(key: 'xsrf');
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'idUser');
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  Future<String?> getEmail() async {
    return await _storage.read(key: 'email');
  }

  Future<List<dynamic>>getTimeData() async {
    String? data = await _storage.read(key: 'timeData');
    if (data != null) {
      List<dynamic> decodedData = json.decode(data);
      return decodedData;
    }
    return [];
  }

  Future<void> writeToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> writeXSRF(String cookie) async {
    await _storage.write(key: 'xsrf', value: cookie);
  }

  Future<void> writeUserId(String id) async {
    await _storage.write(key: 'idUser', value: id);
  }

  Future<void> writeUsername(String username) async {
    await _storage.write(key: 'username', value: username);
  }

  Future<void> writeEmail(String email) async {
    await _storage.write(key: 'email', value: email);
  }

  void writeTimeData(List<dynamic> timeData) async {
    await _storage.write(key: 'timeData', value: json.encode(timeData));
  }

  Future<void> clearData() async {
    await _storage.deleteAll();
  }

  void clearTimeData() async {
    await _storage.delete(key: 'timeData');
  }
}
