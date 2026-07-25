import 'package:freezed_annotation/freezed_annotation.dart';
import 'payment.dart';

part 'payment_response.freezed.dart';
part 'payment_response.g.dart';

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
