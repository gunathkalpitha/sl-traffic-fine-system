// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FineImpl _$$FineImplFromJson(Map<String, dynamic> json) => _$FineImpl(
      referenceNumber: json['referenceNumber'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      amount: (json['amount'] as num).toDouble(),
      violationDescription: json['violationDescription'] as String,
      officerName: json['officerName'] as String,
      officerBadge: json['officerBadge'] as String,
      issuedDate: json['issuedDate'] as String,
      location: json['location'] as String,
      status: json['status'] as String? ?? 'PENDING',
    );

Map<String, dynamic> _$$FineImplToJson(_$FineImpl instance) =>
    <String, dynamic>{
      'referenceNumber': instance.referenceNumber,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'amount': instance.amount,
      'violationDescription': instance.violationDescription,
      'officerName': instance.officerName,
      'officerBadge': instance.officerBadge,
      'issuedDate': instance.issuedDate,
      'location': instance.location,
      'status': instance.status,
    };
