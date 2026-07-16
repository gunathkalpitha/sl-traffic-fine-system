// lib/data/repository/auth_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../local/token_manager.dart';
import '../model/user_role.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  final TokenManager _tokenManager;

  AuthRepository(this._supabase, this._tokenManager);

  /// Sign up a new driver (Always sets role to USER)
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String licenseNumber,
    required String phoneNumber,
  }) async {
    try {
      // 1. Create user in Supabase Auth with metadata
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'license_number': licenseNumber.toUpperCase(),
          'role': 'USER', // Hardcoded as USER for this registration flow
        },
      );

      final user = res.user;
      if (user == null) throw Exception('Signup failed');

      // 2. Create entry in our profiles table
      await _supabase.from('profiles').upsert({
        'id': user.id,
        'full_name': fullName,
        'license_number': licenseNumber.toUpperCase(),
        'email': email,
        'phone_number': phoneNumber,
        'role': 'USER', // Ensure database role is USER
      });
    } on AuthException catch (e) {
      if (e.message.contains('rate_limit')) {
        throw Exception('Too many attempts. Please wait a few minutes.');
      }
      throw Exception(e.message);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// Login and check user role
  Future<UserRole> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        // Fetch profile data to verify role
        final profile = await _supabase
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .single();

        final role = UserRole.fromString(profile['role']) ?? UserRole.user;

        // Save session and info
        await _tokenManager.saveToken(response.session?.accessToken ?? '');
        await _tokenManager.saveUserRole(role);
        
        if (role == UserRole.user) {
          await _tokenManager.saveUserInfo(
            name: profile['full_name'],
            email: profile['email'],
            licenseNumber: profile['license_number'],
          );
        } else if (role == UserRole.officer) {
          await _tokenManager.saveOfficerInfo(
            name: profile['full_name'],
            badge: profile['license_number'], // Using license number field as badge for officers
            district: 'Not Assigned',
          );
        }

        return role;
      }
      throw Exception('Login failed');
    } catch (e) {
      throw Exception('Login failed: Invalid email or password');
    }
  }

  Future<void> logout() async {
    await _supabase.auth.signOut();
    await _tokenManager.clearAll();
  }

  Future<bool> isLoggedIn() async {
    return _supabase.auth.currentSession != null;
  }
}
