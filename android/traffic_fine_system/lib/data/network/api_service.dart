// lib/data/network/api_service.dart
import 'package:dio/dio.dart';
import '../model/fine.dart';
import '../model/login_request.dart';
import '../model/login_response.dart';
import '../model/payment_request.dart';
import '../model/payment_response.dart';

class ApiService {
  final Dio _dio;
  final String baseUrl;

  ApiService(this._dio, {this.baseUrl = ''}) {
    if (baseUrl.isNotEmpty) {
      _dio.options.baseUrl = baseUrl;
    }
  }

  // Auth
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Fine
  Future<Fine> getFineDetails(
    String referenceNumber,
    String categoryId,
  ) async {
    try {
      final response = await _dio.get(
        '/fines/$referenceNumber',
        queryParameters: {'categoryId': categoryId},
      );
      return Fine.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Payment
  Future<PaymentResponse> processPayment(PaymentRequest request) async {
    try {
      final response = await _dio.post(
        '/payments',
        data: request.toJson(),
      );
      return PaymentResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaymentResponse> getPaymentStatus(String paymentId) async {
    try {
      final response = await _dio.get('/payments/$paymentId');
      return PaymentResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
