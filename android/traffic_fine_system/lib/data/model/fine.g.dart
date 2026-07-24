// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FineImpl _$$FineImplFromJson(Map<String, dynamic> json) => _$FineImpl(
      referenceNumber: json['reference_number'] as String,
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      violationDescription: json['violation_description'] as String,
      officerName: json['officer_name'] as String,
      officerBadge: json['officer_badge'] as String,
      issuedDate: json['issued_date'] as String,
      location: json['location'] as String,
      driverEmail: json['driver_email'] as String?,
      status: json['status'] as String? ?? 'PENDING',
    );

Map<String, dynamic> _$$FineImplToJson(_$FineImpl instance) =>
    <String, dynamic>{
      'reference_number': instance.referenceNumber,
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'amount': instance.amount,
      'violation_description': instance.violationDescription,
      'officer_name': instance.officerName,
      'officer_badge': instance.officerBadge,
      'issued_date': instance.issuedDate,
      'location': instance.location,
      'driver_email': instance.driverEmail,
      'status': instance.status,
    };
