// lib/utils/network_utils.dart
import 'package:dio/dio.dart';

class NetworkUtils {
  static String getErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timed out. Check your network.';
        case DioExceptionType.connectionError:
          return 'No internet connection.';
        default:
          final statusCode = error.response?.statusCode;
          final serverMessage =
              error.response?.data?['message'] as String?;
          return serverMessage ??
              'Error $statusCode. Please try again.';
      }
    }
    return error.toString().replaceFirst('Exception: ', '');
  }
}

// lib/utils/validation_utils.dart
class ValidationUtils {
  static String? validateFineReference(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Fine reference number is required';
    }
    if (value.trim().length < 6) {
      return 'Enter a valid fine reference number';
    }
    return null;
  }

  static String? validateCategoryId(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Fine category ID is required';
    }
    return null;
  }

  static String? validateCardNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Card number is required';
    }
    final digits = value.replaceAll(' ', '');
    if (digits.length != 16 || int.tryParse(digits) == null) {
      return 'Enter a valid 16-digit card number';
    }
    return null;
  }

  static String? validateCardHolder(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Cardholder name is required';
    }
    return null;
  }

  static String? validateExpiry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Expiry date is required';
    }
    final parts = value.split('/');
    if (parts.length != 2) return 'Format: MM/YY';
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);
    if (month == null || year == null || month < 1 || month > 12) {
      return 'Enter a valid expiry date';
    }
    return null;
  }

  static String? validateCvv(String? value) {
    if (value == null || value.trim().isEmpty) return 'CVV is required';
    if (value.length < 3 || value.length > 4) return 'Enter a valid CVV';
    return null;
  }

  static String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return 'Badge number is required';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
