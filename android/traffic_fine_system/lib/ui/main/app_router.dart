// lib/ui/main/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/fine.dart';
import '../../data/model/payment_response.dart';
import '../../utils/app_constants.dart';
import '../splash/splash_screen.dart';
import '../login/user_login_screen.dart';
import '../login/user_registration_screen.dart';
import '../user/user_dashboard.dart';
import '../fine/fine_entry_screen.dart';
import '../payment/payment_screen.dart';
import '../confirmation/confirmation_screen.dart';

final appRouter = GoRouter(
  initialLocation: AppConstants.routeSplash,
  routes: [
    GoRoute(
      path: AppConstants.routeSplash,
      builder: (_, __) => const SplashScreen(),
    ),
    // Driver/User Routes
    GoRoute(
      path: AppConstants.routeUserLogin,
      builder: (_, __) => const UserLoginScreen(),
    ),
    GoRoute(
      path: AppConstants.routeUserRegister,
      builder: (_, __) => const UserRegistrationScreen(),
    ),
    GoRoute(
      path: AppConstants.routeUserDashboard,
      builder: (_, __) => const UserDashboard(),
    ),
    GoRoute(
      path: AppConstants.routeFineEntry,
      builder: (_, __) => const FineEntryScreen(),
    ),
    GoRoute(
      path: AppConstants.routePayment,
      builder: (context, state) {
        final fine = state.extra as Fine?;
        if (fine == null) {
          return const Scaffold(
            body: Center(child: Text('Invalid fine data')),
          );
        }
        return PaymentScreen(fine: fine);
      },
    ),
    GoRoute(
      path: AppConstants.routeConfirmation,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null || extra['fine'] == null || extra['payment'] == null) {
          return const Scaffold(
            body: Center(child: Text('Invalid confirmation data')),
          );
        }
        return ConfirmationScreen(
          fine: extra['fine'] as Fine,
          paymentResponse: extra['payment'] as PaymentResponse,
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.error}')),
  ),
);
