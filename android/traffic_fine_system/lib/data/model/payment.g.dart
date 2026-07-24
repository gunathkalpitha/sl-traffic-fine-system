// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PaymentImpl _$$PaymentImplFromJson(Map<String, dynamic> json) =>
    _$PaymentImpl(
      paymentId: json['paymentId'] as String,
      fineReferenceNumber: json['fineReferenceNumber'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      transactionId: json['transactionId'] as String,
      paidAt: json['paidAt'] as String,
      status: json['status'] as String? ?? 'SUCCESS',
    );

Map<String, dynamic> _$$PaymentImplToJson(_$PaymentImpl instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'fineReferenceNumber': instance.fineReferenceNumber,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'transactionId': instance.transactionId,
      'paidAt': instance.paidAt,
      'status': instance.status,
    };
