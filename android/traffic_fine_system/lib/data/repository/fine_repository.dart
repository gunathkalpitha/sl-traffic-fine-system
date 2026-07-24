import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/fine.dart';

class FineRepository {
  final SupabaseClient _supabase;

  FineRepository(this._supabase);

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

  Future<List<Fine>> getMyFines() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final List<dynamic> data = await _supabase
          .from('fines')
          .select()
          .or('driver_id.eq.${user.id},driver_email.eq.${user.email}')
          .order('issued_date', ascending: false);

      return data.map((json) => Fine.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load fines');
    }
  }
}
