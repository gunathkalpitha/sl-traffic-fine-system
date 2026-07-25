import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/payment_request.dart';
import '../model/payment_response.dart';

class PaymentRepository {
  final SupabaseClient _supabase;

  PaymentRepository(this._supabase);

  Future<PaymentResponse> processPayment(PaymentRequest request) async {
    try {
      final fineData = await _supabase
          .from('fines')
          .select('status')
          .eq('reference_number', request.fineReferenceNumber)
          .single();

      if (fineData['status'] == 'PAID') {
        throw Exception('This fine has already been paid.');
      }

      final paymentId = 'PAY-${DateTime.now().millisecondsSinceEpoch}';
      
      await _supabase.from('payments').insert({
        'payment_id': paymentId,
        'fine_reference': request.fineReferenceNumber,
        'payment_method': request.paymentMethod,
        'card_holder': request.cardHolderName,
        'status': 'SUCCESS',
      });

      await _supabase
          .from('fines')
          .update({'status': 'PAID'})
          .eq('reference_number', request.fineReferenceNumber);

      return PaymentResponse(
        success: true,
        message: 'Payment processed successfully',
        paymentId: paymentId,
      );
    } catch (e) {
      if (e.toString().contains('already been paid')) rethrow;
      return PaymentResponse(
        success: false,
        message: 'Payment failed: ${e.toString()}',
      );
    }
  }

  Future<PaymentResponse> getPaymentStatus(String paymentId) async {
    try {
      final data = await _supabase
          .from('payments')
          .select()
          .eq('payment_id', paymentId)
          .single();

      return PaymentResponse(
        success: data['status'] == 'SUCCESS',
        message: 'Payment status: ${data['status']}',
        paymentId: data['payment_id'],
      );
    } catch (e) {
      return const PaymentResponse(
        success: false,
        message: 'Could not fetch payment status',
      );
    }
  }
}
