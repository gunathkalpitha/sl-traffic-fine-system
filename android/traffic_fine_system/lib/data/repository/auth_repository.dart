// lib/data/repository/auth_repository.dart
import 'package:dio/dio.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import '../network/api_service.dart';
import '../local/token_manager.dart';

class AuthRepository {
  final ApiService _apiService;
  final TokenManager _tokenManager;

  AuthRepository(this._apiService, this._tokenManager);

  Future<LoginResponse> login(String username, String password) async {
    try {
      // Mock login for development (testing credentials)
      // Username is converted to uppercase in login screen: "sl1234" → "SL1234"
      if (username == 'SL1234' && password == '1234') {
        final mockResponse = LoginResponse(
          accessToken: 'mock_token_dev_12345',
          tokenType: 'Bearer',
          expiresIn: 3600,
          officerName: 'Test Officer',
          badgeNumber: 'SL1234',
          district: 'Western Province',
        );
        await _tokenManager.saveToken(mockResponse.accessToken);
        await _tokenManager.saveOfficerInfo(
          name: mockResponse.officerName,
          badge: mockResponse.badgeNumber,
          district: mockResponse.district,
        );
        return mockResponse;
      }

      // Real API call (when backend is ready)
      final response = await _apiService.login(
        LoginRequest(username: username, password: password),
      );
      await _tokenManager.saveToken(response.accessToken);
      await _tokenManager.saveOfficerInfo(
        name: response.officerName,
        badge: response.badgeNumber,
        district: response.district,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> logout() async {
    await _tokenManager.clearAll();
  }

  Future<bool> isLoggedIn() => _tokenManager.isLoggedIn();

  Exception _handleDioError(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return Exception('Invalid credentials. Please try again.');
      case 403:
        return Exception('Access denied. Contact administrator.');
      default:
        return Exception(e.message ?? 'Network error. Please try again.');
    }
  }
}
