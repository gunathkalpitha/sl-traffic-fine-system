// lib/data/local/token_manager.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/user_role.dart';

class TokenManager {
  static const _tokenKey = 'jwt_access_token';
  static const _userRoleKey = 'user_role';
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_name';
  static const _userEmailKey = 'user_email';
  static const _officerBadgeKey = 'officer_badge';
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

  Future<void> saveUserRole(UserRole role) async {
    await _storage.write(key: _userRoleKey, value: role.value);
  }

  Future<UserRole> getUserRole() async {
    final roleStr = await _storage.read(key: _userRoleKey);
    return UserRole.fromString(roleStr) ?? UserRole.user;
  }

  // For officers
  Future<void> saveOfficerInfo({
    required String name,
    required String badge,
    required String district,
  }) async {
    await _storage.write(key: _userNameKey, value: name);
    await _storage.write(key: _officerBadgeKey, value: badge);
    await _storage.write(key: _districtKey, value: district);
    await saveUserRole(UserRole.officer);
  }

  // For users/drivers
  Future<void> saveUserInfo({
    required String name,
    required String email,
    required String licenseNumber,
  }) async {
    await _storage.write(key: _userNameKey, value: name);
    await _storage.write(key: _userEmailKey, value: email);
    await _storage.write(key: _userIdKey, value: licenseNumber);
    await saveUserRole(UserRole.user);
  }

  Future<Map<String, String?>> getUserInfo() async {
    return {
      'name': await _storage.read(key: _userNameKey),
      'email': await _storage.read(key: _userEmailKey),
      'licenseNumber': await _storage.read(key: _userIdKey),
    };
  }

  Future<Map<String, String?>> getOfficerInfo() async {
    return {
      'name': await _storage.read(key: _userNameKey),
      'badge': await _storage.read(key: _officerBadgeKey),
      'district': await _storage.read(key: _districtKey),
    };
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
