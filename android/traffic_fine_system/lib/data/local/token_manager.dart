// lib/data/local/token_manager.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static const _tokenKey = 'jwt_access_token';
  static const _officerNameKey = 'officer_name';
  static const _badgeNumberKey = 'badge_number';
  static const _districtKey = 'district';

  final FlutterSecureStorage _storage;

  TokenManager(this._storage);

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveOfficerInfo({
    required String name,
    required String badge,
    required String district,
  }) async {
    await _storage.write(key: _officerNameKey, value: name);
    await _storage.write(key: _badgeNumberKey, value: badge);
    await _storage.write(key: _districtKey, value: district);
  }

  Future<Map<String, String?>> getOfficerInfo() async {
    return {
      'name': await _storage.read(key: _officerNameKey),
      'badge': await _storage.read(key: _badgeNumberKey),
      'district': await _storage.read(key: _districtKey),
    };
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
