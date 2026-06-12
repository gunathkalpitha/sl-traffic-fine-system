// lib/ui/payment/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/fine.dart';
import '../../utils/app_constants.dart';
import '../../utils/validation_utils.dart';
import '../../utils/extensions.dart';
import 'payment_view_model.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final Fine fine;

  const PaymentScreen({super.key, required this.fine});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String _selectedPaymentMethod = AppConstants.paymentVisa;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    context.hideKeyboard();
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Text(
          'Pay ${widget.fine.amount.toRupees()} for fine ${widget.fine.referenceNumber}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003087),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Pay Now',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(paymentViewModelProvider.notifier).processPayment(
          fineReferenceNumber: widget.fine.referenceNumber,
          fineCategoryId: widget.fine.categoryId,
          paymentMethod: _selectedPaymentMethod,
          cardNumber: _cardNumberController.text,
          cardHolderName: _cardHolderController.text,
          expiryDate: _expiryController.text,
          cvv: _cvvController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<PaymentState>(paymentViewModelProvider, (_, state) {
      state.whenOrNull(
        success: (response) => context.go(
          AppConstants.routeConfirmation,
          extra: {'fine': widget.fine, 'payment': response},
        ),
        error: (msg) => context.showSnackBar(msg, isError: true),
      );
    });

    final state = ref.watch(paymentViewModelProvider);
    final isProcessing = state is _Processing;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fine summary card
            Card(
              color: const Color(0xFF003087),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fine Summary',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade700,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.fine.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.fine.categoryName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.fine.violationDescription,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _FineDetail(
                          label: 'Ref No.',
                          value: widget.fine.referenceNumber,
                        ),
                        _FineDetail(
                          label: 'Location',
                          value: widget.fine.location,
                        ),
                        _FineDetail(
                          label: 'Amount',
                          value: widget.fine.amount.toRupees(),
                          highlight: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Payment Details',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF003087),
              ),
            ),
            const SizedBox(height: 4),
            // Payment method selector
            Row(
              children: [
                AppConstants.paymentVisa,
                AppConstants.paymentMasterCard,
                AppConstants.paymentLankaQR,
              ].map((method) {
                final selected = _selectedPaymentMethod == method;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, top: 12),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedPaymentMethod = method),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selected
                                ? const Color(0xFF003087)
                                : Colors.grey.shade300,
                            width: selected ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: selected
                              ? const Color(0xFF003087).withOpacity(0.07)
                              : null,
                        ),
                        child: Text(
                          method,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.normal,
                            color: selected
                                ? const Color(0xFF003087)
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Card Number',
                      prefixIcon: Icon(Icons.credit_card_rounded),
                      hintText: '0000 0000 0000 0000',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      _CardNumberFormatter(),
                    ],
                    validator: ValidationUtils.validateCardNumber,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cardHolderController,
                    decoration: const InputDecoration(
                      labelText: 'Cardholder Name',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: ValidationUtils.validateCardHolder,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _expiryController,
                          decoration: const InputDecoration(
                            labelText: 'Expiry (MM/YY)',
                            prefixIcon: Icon(Icons.calendar_today_outlined),
                            hintText: 'MM/YY',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            _ExpiryFormatter(),
                          ],
                          validator: ValidationUtils.validateExpiry,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          decoration: const InputDecoration(
                            labelText: 'CVV',
                            prefixIcon: Icon(Icons.lock_outline_rounded),
                          ),
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          validator: ValidationUtils.validateCvv,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _pay(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: isProcessing ? null : _pay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B7F3E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isProcessing
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Processing...',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'Pay ${widget.fine.amount.toRupees()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_rounded, size: 14, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  'Secured by Sri Lanka Police Department',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FineDetail extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _FineDetail({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: highlight ? Colors.amber.shade300 : Colors.white,
            fontSize: highlight ? 16 : 13,
            fontWeight:
                highlight ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Input formatters
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (text.length == 2 && oldValue.text.length == 1) {
      text = '$text/';
    }
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
