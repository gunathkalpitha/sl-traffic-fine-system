// lib/data/repository/auth_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../local/token_manager.dart';
import '../model/user_role.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  final TokenManager _tokenManager;

  AuthRepository(this._supabase, this._tokenManager);

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String licenseNumber,
    required String phoneNumber,
  }) async {
    try {
      final AuthResponse res = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'license_number': licenseNumber.toUpperCase(),
          'role': 'USER',
        },
      );

      final user = res.user;
      if (user == null) throw Exception('Signup failed');

      await _supabase.from('profiles').upsert({
        'id': user.id,
        'full_name': fullName,
        'license_number': licenseNumber.toUpperCase(),
        'email': email,
        'phone_number': phoneNumber,
        'role': 'USER',
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

  Future<UserRole> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final profileResponse = await _supabase
            .from('profiles')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();

        if (profileResponse == null) {
          throw Exception('User profile not found. Please register through the app.');
        }

        final role = UserRole.fromString(profileResponse['role']) ?? UserRole.user;

        await _tokenManager.saveToken(response.session?.accessToken ?? '');
        await _tokenManager.saveUserRole(role);
        
        if (role == UserRole.user) {
          await _tokenManager.saveUserInfo(
            name: profileResponse['full_name'],
            email: profileResponse['email'],
            licenseNumber: profileResponse['license_number'],
          );
        } else if (role == UserRole.officer) {
          await _tokenManager.saveOfficerInfo(
            name: profileResponse['full_name'],
            badge: profileResponse['license_number'],
            district: 'Not Assigned',
          );
        }

        return role;
      }
      throw Exception('Authentication failed');
    } on AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      if (e.toString().contains('profile not found')) rethrow;
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
