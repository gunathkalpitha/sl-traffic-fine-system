// lib/data/model/login_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,
    required String tokenType,
    required int expiresIn,
    required String officerName,
    required String badgeNumber,
    required String district,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
