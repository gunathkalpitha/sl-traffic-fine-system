// lib/utils/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/local/token_manager.dart';
import '../data/repository/auth_repository.dart';
import '../data/repository/fine_repository.dart';
import '../data/repository/payment_repository.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (_) => const FlutterSecureStorage(),
);

final tokenManagerProvider = Provider<TokenManager>(
  (ref) => TokenManager(ref.watch(secureStorageProvider)),
);

final supabaseProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    ref.watch(supabaseProvider),
    ref.watch(tokenManagerProvider),
  ),
);

final fineRepositoryProvider = Provider<FineRepository>(
  (ref) => FineRepository(ref.watch(supabaseProvider)),
);

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepository(ref.watch(supabaseProvider)),
);
