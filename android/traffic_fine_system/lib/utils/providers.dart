// lib/utils/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/local/token_manager.dart';
import '../data/network/api_service.dart';
import '../data/network/retrofit_client.dart';
import '../data/repository/auth_repository.dart';
import '../data/repository/fine_repository.dart';
import '../data/repository/payment_repository.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

final tokenManagerProvider = Provider<TokenManager>(
  (ref) => TokenManager(ref.watch(secureStorageProvider)),
);

final apiServiceProvider = Provider<ApiService>(
  (ref) => RetrofitClient.create(ref.watch(tokenManagerProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(apiServiceProvider),
    ref.watch(tokenManagerProvider),
  ),
);

final fineRepositoryProvider = Provider<FineRepository>(
  (ref) => FineRepository(ref.watch(apiServiceProvider)),
);

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepository(ref.watch(apiServiceProvider)),
);
