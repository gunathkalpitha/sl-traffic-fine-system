// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PaymentRequest _$PaymentRequestFromJson(Map<String, dynamic> json) {
  return _PaymentRequest.fromJson(json);
}

/// @nodoc
mixin _$PaymentRequest {
  String get fineReferenceNumber => throw _privateConstructorUsedError;
  String get fineCategoryId => throw _privateConstructorUsedError;
  String get paymentMethod => throw _privateConstructorUsedError;
  String get cardNumber => throw _privateConstructorUsedError;
  String get cardHolderName => throw _privateConstructorUsedError;
  String get expiryDate => throw _privateConstructorUsedError;
  String get cvv => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PaymentRequestCopyWith<PaymentRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentRequestCopyWith<$Res> {
  factory $PaymentRequestCopyWith(
          PaymentRequest value, $Res Function(PaymentRequest) then) =
      _$PaymentRequestCopyWithImpl<$Res, PaymentRequest>;
  @useResult
  $Res call(
      {String fineReferenceNumber,
      String fineCategoryId,
      String paymentMethod,
      String cardNumber,
      String cardHolderName,
      String expiryDate,
      String cvv});
}

/// @nodoc
class _$PaymentRequestCopyWithImpl<$Res, $Val extends PaymentRequest>
    implements $PaymentRequestCopyWith<$Res> {
  _$PaymentRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fineReferenceNumber = null,
    Object? fineCategoryId = null,
    Object? paymentMethod = null,
    Object? cardNumber = null,
    Object? cardHolderName = null,
    Object? expiryDate = null,
    Object? cvv = null,
  }) {
    return _then(_value.copyWith(
      fineReferenceNumber: null == fineReferenceNumber
          ? _value.fineReferenceNumber
          : fineReferenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      fineCategoryId: null == fineCategoryId
          ? _value.fineCategoryId
          : fineCategoryId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      cardNumber: null == cardNumber
          ? _value.cardNumber
          : cardNumber // ignore: cast_nullable_to_non_nullable
              as String,
      cardHolderName: null == cardHolderName
          ? _value.cardHolderName
          : cardHolderName // ignore: cast_nullable_to_non_nullable
              as String,
      expiryDate: null == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String,
      cvv: null == cvv
          ? _value.cvv
          : cvv // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PaymentRequestImplCopyWith<$Res>
    implements $PaymentRequestCopyWith<$Res> {
  factory _$$PaymentRequestImplCopyWith(_$PaymentRequestImpl value,
          $Res Function(_$PaymentRequestImpl) then) =
      __$$PaymentRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fineReferenceNumber,
      String fineCategoryId,
      String paymentMethod,
      String cardNumber,
      String cardHolderName,
      String expiryDate,
      String cvv});
}

/// @nodoc
class __$$PaymentRequestImplCopyWithImpl<$Res>
    extends _$PaymentRequestCopyWithImpl<$Res, _$PaymentRequestImpl>
    implements _$$PaymentRequestImplCopyWith<$Res> {
  __$$PaymentRequestImplCopyWithImpl(
      _$PaymentRequestImpl _value, $Res Function(_$PaymentRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fineReferenceNumber = null,
    Object? fineCategoryId = null,
    Object? paymentMethod = null,
    Object? cardNumber = null,
    Object? cardHolderName = null,
    Object? expiryDate = null,
    Object? cvv = null,
  }) {
    return _then(_$PaymentRequestImpl(
      fineReferenceNumber: null == fineReferenceNumber
          ? _value.fineReferenceNumber
          : fineReferenceNumber // ignore: cast_nullable_to_non_nullable
              as String,
      fineCategoryId: null == fineCategoryId
          ? _value.fineCategoryId
          : fineCategoryId // ignore: cast_nullable_to_non_nullable
              as String,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      cardNumber: null == cardNumber
          ? _value.cardNumber
          : cardNumber // ignore: cast_nullable_to_non_nullable
              as String,
      cardHolderName: null == cardHolderName
          ? _value.cardHolderName
          : cardHolderName // ignore: cast_nullable_to_non_nullable
              as String,
      expiryDate: null == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as String,
      cvv: null == cvv
          ? _value.cvv
          : cvv // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PaymentRequestImpl implements _PaymentRequest {
  const _$PaymentRequestImpl(
      {required this.fineReferenceNumber,
      required this.fineCategoryId,
      required this.paymentMethod,
      required this.cardNumber,
      required this.cardHolderName,
      required this.expiryDate,
      required this.cvv});

  factory _$PaymentRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentRequestImplFromJson(json);

  @override
  final String fineReferenceNumber;
  @override
  final String fineCategoryId;
  @override
  final String paymentMethod;
  @override
  final String cardNumber;
  @override
  final String cardHolderName;
  @override
  final String expiryDate;
  @override
  final String cvv;

  @override
  String toString() {
    return 'PaymentRequest(fineReferenceNumber: $fineReferenceNumber, fineCategoryId: $fineCategoryId, paymentMethod: $paymentMethod, cardNumber: $cardNumber, cardHolderName: $cardHolderName, expiryDate: $expiryDate, cvv: $cvv)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentRequestImpl &&
            (identical(other.fineReferenceNumber, fineReferenceNumber) ||
                other.fineReferenceNumber == fineReferenceNumber) &&
            (identical(other.fineCategoryId, fineCategoryId) ||
                other.fineCategoryId == fineCategoryId) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.cardNumber, cardNumber) ||
                other.cardNumber == cardNumber) &&
            (identical(other.cardHolderName, cardHolderName) ||
                other.cardHolderName == cardHolderName) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.cvv, cvv) || other.cvv == cvv));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      fineReferenceNumber,
      fineCategoryId,
      paymentMethod,
      cardNumber,
      cardHolderName,
      expiryDate,
      cvv);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentRequestImplCopyWith<_$PaymentRequestImpl> get copyWith =>
      __$$PaymentRequestImplCopyWithImpl<_$PaymentRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentRequestImplToJson(
      this,
    );
  }
}

abstract class _PaymentRequest implements PaymentRequest {
  const factory _PaymentRequest(
      {required final String fineReferenceNumber,
      required final String fineCategoryId,
      required final String paymentMethod,
      required final String cardNumber,
      required final String cardHolderName,
      required final String expiryDate,
      required final String cvv}) = _$PaymentRequestImpl;

  factory _PaymentRequest.fromJson(Map<String, dynamic> json) =
      _$PaymentRequestImpl.fromJson;

  @override
  String get fineReferenceNumber;
  @override
  String get fineCategoryId;
  @override
  String get paymentMethod;
  @override
  String get cardNumber;
  @override
  String get cardHolderName;
  @override
  String get expiryDate;
  @override
  String get cvv;
  @override
  @JsonKey(ignore: true)
  _$$PaymentRequestImplCopyWith<_$PaymentRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
