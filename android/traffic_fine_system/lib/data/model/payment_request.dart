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
