// lib/data/model/fine.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fine.freezed.dart';
part 'fine.g.dart';

@freezed
class Fine with _$Fine {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Fine({
    required String referenceNumber,
    required String categoryId,
    required String categoryName,
    required double amount,
    required String violationDescription,
    required String officerName,
    required String officerBadge,
    required String issuedDate,
    required String location,
    String? driverEmail,
    @Default('PENDING') String status,
  }) = _Fine;

  factory Fine.fromJson(Map<String, dynamic> json) => _$FineFromJson(json);
}
