// lib/data/network/retrofit_client.dart
import 'package:dio/dio.dart';
import '../local/token_manager.dart';
import 'api_service.dart';
import 'auth_interceptor.dart';
import '../../utils/app_constants.dart';

class RetrofitClient {
  static ApiService create(TokenManager tokenManager) {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokenManager),
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    ]);

    return ApiService(dio);
  }
}
