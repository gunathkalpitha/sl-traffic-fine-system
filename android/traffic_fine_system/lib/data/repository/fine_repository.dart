// lib/data/repository/fine_repository.dart
import 'package:dio/dio.dart';
import '../model/fine.dart';
import '../network/api_service.dart';

class FineRepository {
  final ApiService _apiService;

  FineRepository(this._apiService);

  Future<Fine> getFineDetails({
    required String referenceNumber,
    required String categoryId,
  }) async {
    try {
      return await _apiService.getFineDetails(referenceNumber, categoryId);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 404:
          throw Exception('Fine not found. Check the reference number and category.');
        case 400:
          throw Exception('Invalid fine details provided.');
        default:
          throw Exception('Failed to retrieve fine details. Try again.');
      }
    }
  }
}

// lib/data/repository/payment_repository.dart
import '../model/payment_request.dart';
import '../model/payment_response.dart';

class PaymentRepository {
  final ApiService _apiService;

  PaymentRepository(this._apiService);

  Future<PaymentResponse> processPayment(PaymentRequest request) async {
    try {
      return await _apiService.processPayment(request);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 402:
          throw Exception('Payment declined. Check card details and try again.');
        case 409:
          throw Exception('This fine has already been paid.');
        default:
          throw Exception('Payment failed. Please try again.');
      }
    }
  }

  Future<PaymentResponse> getPaymentStatus(String paymentId) async {
    try {
      return await _apiService.getPaymentStatus(paymentId);
    } on DioException catch (e) {
      throw Exception('Could not fetch payment status: ${e.message}');
    }
  }
}
