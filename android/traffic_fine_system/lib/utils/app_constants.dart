// lib/utils/app_constants.dart
class AppConstants {
  // Replace with your actual backend URL
  static const String baseUrl = 'https://api.sltraficfines.lk/api/v1';

  // Routes
  static const String routeSplash = '/';
  static const String routeRoleSelection = '/role-selection';
  static const String routeOfficerLogin = '/officer-login';
  static const String routeUserLogin = '/user-login';
  static const String routeOfficerRegister = '/officer-register';
  static const String routeUserRegister = '/user-register';
  static const String routeOfficerDashboard = '/officer-dashboard';
  static const String routeUserDashboard = '/user-dashboard';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeMain = '/main';
  static const String routeFineEntry = '/fine-entry';
  static const String routeFineDetails = '/fine-details';
  static const String routePayment = '/payment';
  static const String routeConfirmation = '/confirmation';

  // Fine categories (mirrors backend enum)
  static const Map<String, String> fineCategories = {
    'FC001': 'Speeding',
    'FC002': 'Running Red Light',
    'FC003': 'No Helmet',
    'FC004': 'Using Mobile While Driving',
    'FC005': 'No Seat Belt',
    'FC006': 'Drunk Driving',
    'FC007': 'Illegal Parking',
    'FC008': 'Overloading',
  };

  // Payment methods
  static const String paymentVisa = 'VISA';
  static const String paymentMasterCard = 'MASTERCARD';
  static const String paymentLankaQR = 'LANKA_QR';
}
