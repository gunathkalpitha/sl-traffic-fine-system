// lib/data/model/payment.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
class Payment with _$Payment {
  const factory Payment({
    required String paymentId,
    required String fineReferenceNumber,
    required double amount,
    required String paymentMethod,
    required String transactionId,
    required String paidAt,
    @Default('SUCCESS') String status,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);
}
