import 'package:dio/dio.dart';
import '../model/payment_request.dart';
import '../model/payment_response.dart';
import '../network/api_service.dart';

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
