// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FineNotificationImpl _$$FineNotificationImplFromJson(
        Map<String, dynamic> json) =>
    _$FineNotificationImpl(
      id: json['id'] as String,
      referenceNumber: json['referenceNumber'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      driverName: json['driverName'] as String,
      driverLicense: json['driverLicense'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      amount: (json['amount'] as num).toDouble(),
      issuedDateTime: DateTime.parse(json['issuedDateTime'] as String),
      locationIssued: json['locationIssued'] as String,
      isPaid: json['isPaid'] as bool,
      paidDateTime: json['paidDateTime'] == null
          ? null
          : DateTime.parse(json['paidDateTime'] as String),
      violationDetails: json['violationDetails'] as String,
    );

Map<String, dynamic> _$$FineNotificationImplToJson(
        _$FineNotificationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'referenceNumber': instance.referenceNumber,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'driverName': instance.driverName,
      'driverLicense': instance.driverLicense,
      'vehicleNumber': instance.vehicleNumber,
      'amount': instance.amount,
      'issuedDateTime': instance.issuedDateTime.toIso8601String(),
      'locationIssued': instance.locationIssued,
      'isPaid': instance.isPaid,
      'paidDateTime': instance.paidDateTime?.toIso8601String(),
      'violationDetails': instance.violationDetails,
    };
