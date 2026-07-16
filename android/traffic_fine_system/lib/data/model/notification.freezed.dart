// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FineNotification _$FineNotificationFromJson(Map<String, dynamic> json) {
  return _FineNotification.fromJson(json);
}

/// @nodoc
mixin _$FineNotification {
  String get id => throw _privateConstructorUsedError;
  String get referenceNumber => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get driverName => throw _privateConstructorUsedError;
  String get driverLicense => throw _privateConstructorUsedError;
  String get vehicleNumber => throw _privateConstructorUsedError;
  double get amount => throw _privateConstructorUsedError;
  DateTime get issuedDateTime => throw _privateConstructorUsedError;
  String get locationIssued => throw _privateConstructorUsedError;
  bool get isPaid => throw _privateConstructorUsedError;
  DateTime? get paidDateTime => throw _privateConstructorUsedError;
  String get violationDetails => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FineNotificationCopyWith<FineNotification> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FineNotificationCopyWith<$Res> {
  factory $FineNotificationCopyWith(
          FineNotification value, $Res Function(FineNotification) then) =
      _$FineNotificationCopyWithImpl<$Res, FineNotification>;
  @useResult
  $Res call(
      {String id,
      String referenceNumber,
      String categoryId,
      String categoryName,
      String driverName,
      String driverLicense,
      String vehicleNumber,
      double amount,
      DateTime issuedDateTime,
      String locationIssued,
      bool isPaid,
      DateTime? paidDateTime,
      String violationDetails});
}

/// @nodoc
class _$FineNotificationCopyWithImpl<$Res, $Val extends FineNotification>
    implements $FineNotificationCopyWith<$Res> {
  _$FineNotificationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNumber = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? driverName = null,
    Object? driverLicense = null,
    Object? vehicleNumber = null,
    Object? amount = null,
    Object? issuedDateTime = null,
    Object? locationIssued = null,
    Object? isPaid = null,
    Object? paidDateTime = freezed,
    Object? violationDetails = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      referenceNumber: null == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      driverName: null == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String,
      driverLicense: null == driverLicense
          ? _value.driverLicense
          : driverLicense // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleNumber: null == vehicleNumber
          ? _value.vehicleNumber
          : vehicleNumber // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      issuedDateTime: null == issuedDateTime
          ? _value.issuedDateTime
          : issuedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      locationIssued: null == locationIssued
          ? _value.locationIssued
          : locationIssued // ignore: cast_nullable_to_non_nullable
              as String,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      paidDateTime: freezed == paidDateTime
          ? _value.paidDateTime
          : paidDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      violationDetails: null == violationDetails
          ? _value.violationDetails
          : violationDetails // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FineNotificationImplCopyWith<$Res>
    implements $FineNotificationCopyWith<$Res> {
  factory _$$FineNotificationImplCopyWith(_$FineNotificationImpl value,
          $Res Function(_$FineNotificationImpl) then) =
      __$$FineNotificationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String referenceNumber,
      String categoryId,
      String categoryName,
      String driverName,
      String driverLicense,
      String vehicleNumber,
      double amount,
      DateTime issuedDateTime,
      String locationIssued,
      bool isPaid,
      DateTime? paidDateTime,
      String violationDetails});
}

/// @nodoc
class __$$FineNotificationImplCopyWithImpl<$Res>
    extends _$FineNotificationCopyWithImpl<$Res, _$FineNotificationImpl>
    implements _$$FineNotificationImplCopyWith<$Res> {
  __$$FineNotificationImplCopyWithImpl(_$FineNotificationImpl _value,
      $Res Function(_$FineNotificationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? referenceNumber = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? driverName = null,
    Object? driverLicense = null,
    Object? vehicleNumber = null,
    Object? amount = null,
    Object? issuedDateTime = null,
    Object? locationIssued = null,
    Object? isPaid = null,
    Object? paidDateTime = freezed,
    Object? violationDetails = null,
  }) {
    return _then(_$FineNotificationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      referenceNumber: null == referenceNumber
          ? _value.referenceNumber
          : referenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      categoryName: null == categoryName
          ? _value.categoryName
          : categoryName // ignore: cast_nullable_to_non_nullable
              as String,
      driverName: null == driverName
          ? _value.driverName
          : driverName // ignore: cast_nullable_to_non_nullable
              as String,
      driverLicense: null == driverLicense
          ? _value.driverLicense
          : driverLicense // ignore: cast_nullable_to_non_nullable
              as String,
      vehicleNumber: null == vehicleNumber
          ? _value.vehicleNumber
          : vehicleNumber // ignore: cast_nullable_to_non_nullable
              as String,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as double,
      issuedDateTime: null == issuedDateTime
          ? _value.issuedDateTime
          : issuedDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      locationIssued: null == locationIssued
          ? _value.locationIssued
          : locationIssued // ignore: cast_nullable_to_non_nullable
              as String,
      isPaid: null == isPaid
          ? _value.isPaid
          : isPaid // ignore: cast_nullable_to_non_nullable
              as bool,
      paidDateTime: freezed == paidDateTime
          ? _value.paidDateTime
          : paidDateTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      violationDetails: null == violationDetails
          ? _value.violationDetails
          : violationDetails // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FineNotificationImpl implements _FineNotification {
  const _$FineNotificationImpl(
      {required this.id,
      required this.referenceNumber,
      required this.categoryId,
      required this.categoryName,
      required this.driverName,
      required this.driverLicense,
      required this.vehicleNumber,
      required this.amount,
      required this.issuedDateTime,
      required this.locationIssued,
      required this.isPaid,
      this.paidDateTime,
      required this.violationDetails});

  factory _$FineNotificationImpl.fromJson(Map<String, dynamic> json) =>
      _$$FineNotificationImplFromJson(json);

  @override
  final String id;
  @override
  final String referenceNumber;
  @override
  final String categoryId;
  @override
  final String categoryName;
  @override
  final String driverName;
  @override
  final String driverLicense;
  @override
  final String vehicleNumber;
  @override
  final double amount;
  @override
  final DateTime issuedDateTime;
  @override
  final String locationIssued;
  @override
  final bool isPaid;
  @override
  final DateTime? paidDateTime;
  @override
  final String violationDetails;

  @override
  String toString() {
    return 'FineNotification(id: $id, referenceNumber: $referenceNumber, categoryId: $categoryId, categoryName: $categoryName, driverName: $driverName, driverLicense: $driverLicense, vehicleNumber: $vehicleNumber, amount: $amount, issuedDateTime: $issuedDateTime, locationIssued: $locationIssued, isPaid: $isPaid, paidDateTime: $paidDateTime, violationDetails: $violationDetails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FineNotificationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.referenceNumber, referenceNumber) ||
                other.referenceNumber == referenceNumber) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.driverName, driverName) ||
                other.driverName == driverName) &&
            (identical(other.driverLicense, driverLicense) ||
                other.driverLicense == driverLicense) &&
            (identical(other.vehicleNumber, vehicleNumber) ||
                other.vehicleNumber == vehicleNumber) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.issuedDateTime, issuedDateTime) ||
                other.issuedDateTime == issuedDateTime) &&
            (identical(other.locationIssued, locationIssued) ||
                other.locationIssued == locationIssued) &&
            (identical(other.isPaid, isPaid) || other.isPaid == isPaid) &&
            (identical(other.paidDateTime, paidDateTime) ||
                other.paidDateTime == paidDateTime) &&
            (identical(other.violationDetails, violationDetails) ||
                other.violationDetails == violationDetails));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      referenceNumber,
      categoryId,
      categoryName,
      driverName,
      driverLicense,
      vehicleNumber,
      amount,
      issuedDateTime,
      locationIssued,
      isPaid,
      paidDateTime,
      violationDetails);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FineNotificationImplCopyWith<_$FineNotificationImpl> get copyWith =>
      __$$FineNotificationImplCopyWithImpl<_$FineNotificationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FineNotificationImplToJson(
      this,
    );
  }
}

abstract class _FineNotification implements FineNotification {
  const factory _FineNotification(
      {required final String id,
      required final String referenceNumber,
      required final String categoryId,
      required final String categoryName,
      required final String driverName,
      required final String driverLicense,
      required final String vehicleNumber,
      required final double amount,
      required final DateTime issuedDateTime,
      required final String locationIssued,
      required final bool isPaid,
      final DateTime? paidDateTime,
      required final String violationDetails}) = _$FineNotificationImpl;

  factory _FineNotification.fromJson(Map<String, dynamic> json) =
      _$FineNotificationImpl.fromJson;

  @override
  String get id;
  @override
  String get referenceNumber;
  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  String get driverName;
  @override
  String get driverLicense;
  @override
  String get vehicleNumber;
  @override
  double get amount;
  @override
  DateTime get issuedDateTime;
  @override
  String get locationIssued;
  @override
  bool get isPaid;
  @override
  DateTime? get paidDateTime;
  @override
  String get violationDetails;
  @override
  @JsonKey(ignore: true)
  _$$FineNotificationImplCopyWith<_$FineNotificationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
