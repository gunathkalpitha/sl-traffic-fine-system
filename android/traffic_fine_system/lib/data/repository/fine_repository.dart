// lib/data/repository/fine_repository.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/fine.dart';

class FineRepository {
  final SupabaseClient _supabase;

  FineRepository(this._supabase);

  /// Fetch fine details by reference number and category for the lookup screen
  Future<Fine> getFineDetails({
    required String referenceNumber,
    required String categoryId,
  }) async {
    try {
      final data = await _supabase
          .from('fines')
          .select()
          .eq('reference_number', referenceNumber)
          .eq('category_id', categoryId)
          .single();

      return Fine.fromJson(data);
    } catch (e) {
      throw Exception('Fine not found. Please check the reference number and category.');
    }
  }

  /// Fetch all fines for the currently logged in driver
  Future<List<Fine>> getMyFines() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final List<dynamic> data = await _supabase
          .from('fines')
          .select()
          .eq('driver_id', userId)
          .order('issued_date', ascending: false);

      return data.map((json) => Fine.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load fines');
    }
  }
}
