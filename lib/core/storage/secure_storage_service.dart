import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _tokenKey = 'access_token';

  static Future<void> saveToken(String token) async {
    if (token.isEmpty) return;
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> readToken() {
    return _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() {
    return _storage.delete(key: _tokenKey);
  }
}
