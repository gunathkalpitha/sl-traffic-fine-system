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

  /// Login for drivers/users with license number and password
  Future<LoginResponse> login(String licenseNumber, String password) async {
    try {
      // Mock login for development (testing credentials)
      // License number is converted to uppercase in login screen: "dl1234567" → "DL1234567"
      if (licenseNumber == 'DL1234567' && password == '1234') {
        final mockResponse = LoginResponse(
          accessToken: 'mock_token_user_12345',
          tokenType: 'Bearer',
          expiresIn: 3600,
          driverName: 'John Doe',
          licenseNumber: 'DL1234567',
          email: 'john.doe@example.com',
        );
        await _tokenManager.saveToken(mockResponse.accessToken);
        await _tokenManager.saveUserInfo(
          name: mockResponse.driverName,
          email: mockResponse.email,
          licenseNumber: mockResponse.licenseNumber,
        );
        return mockResponse;
      }

      // Real API call (when backend is ready)
      final response = await _apiService.login(
        LoginRequest(username: licenseNumber, password: password),
      );
      await _tokenManager.saveToken(response.accessToken);
      await _tokenManager.saveUserInfo(
        name: response.driverName,
        email: response.email,
        licenseNumber: response.licenseNumber,
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
        return Exception('Invalid license number or password. Please try again.');
      case 403:
        return Exception('Access denied. Please contact support.');
      default:
        return Exception(e.message ?? 'Network error. Please try again.');
    }
  }
}
