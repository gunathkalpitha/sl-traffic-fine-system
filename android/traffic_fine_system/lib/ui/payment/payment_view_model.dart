// lib/ui/payment/payment_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/model/payment_request.dart';
import '../../data/model/payment_response.dart';
import '../../data/repository/payment_repository.dart';
import '../../utils/providers.dart';
import '../../utils/network_utils.dart';

part 'payment_view_model.freezed.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.initial() = _Initial;
  const factory PaymentState.processing() = _Processing;
  const factory PaymentState.success(PaymentResponse response) = _Success;
  const factory PaymentState.error(String message) = _Error;
}

class PaymentViewModel extends StateNotifier<PaymentState> {
  final PaymentRepository _paymentRepository;

  PaymentViewModel(this._paymentRepository)
      : super(const PaymentState.initial());

  Future<void> processPayment({
    required String fineReferenceNumber,
    required String fineCategoryId,
    required String paymentMethod,
    required String cardNumber,
    required String cardHolderName,
    required String expiryDate,
    required String cvv,
  }) async {
    state = const PaymentState.processing();
    try {
      final request = PaymentRequest(
        fineReferenceNumber: fineReferenceNumber,
        fineCategoryId: fineCategoryId,
        paymentMethod: paymentMethod,
        cardNumber: cardNumber.replaceAll(' ', ''),
        cardHolderName: cardHolderName,
        expiryDate: expiryDate,
        cvv: cvv,
      );
      final response = await _paymentRepository.processPayment(request);
      state = PaymentState.success(response);
    } catch (e) {
      state = PaymentState.error(NetworkUtils.getErrorMessage(e));
    }
  }

  void reset() => state = const PaymentState.initial();
}

final paymentViewModelProvider =
    StateNotifierProvider<PaymentViewModel, PaymentState>(
  (ref) => PaymentViewModel(ref.watch(paymentRepositoryProvider)),
);
