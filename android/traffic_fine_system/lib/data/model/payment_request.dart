// lib/data/model/payment_request.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_request.freezed.dart';
part 'payment_request.g.dart';

@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required String fineReferenceNumber,
    required String fineCategoryId,
    required String paymentMethod,
    required String cardNumber,
    required String cardHolderName,
    required String expiryDate,
    required String cvv,
  }) = _PaymentRequest;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) =>
      _$PaymentRequestFromJson(json);
}

// lib/data/model/payment_response.dart
@freezed
class PaymentResponse with _$PaymentResponse {
  const factory PaymentResponse({
    required bool success,
    required String message,
    String? paymentId,
    String? transactionId,
    Payment? payment,
  }) = _PaymentResponse;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      _$PaymentResponseFromJson(json);
}
