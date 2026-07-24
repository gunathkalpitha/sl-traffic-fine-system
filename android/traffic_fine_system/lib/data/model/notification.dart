// lib/data/model/notification.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class FineNotification with _$FineNotification {
  const factory FineNotification({
    required String id,
    required String referenceNumber,
    required String categoryId,
    required String categoryName,
    required String driverName,
    required String driverLicense,
    required String vehicleNumber,
    required double amount,
    required DateTime issuedDateTime,
    required String locationIssued,
    required bool isPaid,
    DateTime? paidDateTime,
    required String violationDetails,
  }) = _FineNotification;

  factory FineNotification.fromJson(Map<String, dynamic> json) =>
      _$FineNotificationFromJson(json);
}
