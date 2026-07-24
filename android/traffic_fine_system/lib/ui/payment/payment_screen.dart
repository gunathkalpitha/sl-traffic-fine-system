import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:lottie/lottie.dart';
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

class _PaymentScreenState extends ConsumerState<PaymentScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _laserController;
  final _formKey = GlobalKey<FormState>();
  
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _isSimulatingQR = false;
  String _qrSimulationMessage = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _laserController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _laserController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  Future<void> _processCreditCardPayment() async {
    context.hideKeyboard();
    if (!_formKey.currentState!.validate()) return;

    await ref.read(paymentViewModelProvider.notifier).processPayment(
      fineReferenceNumber: widget.fine.referenceNumber,
      fineCategoryId: widget.fine.categoryId,
      paymentMethod: 'CREDIT_CARD',
      cardNumber: _cardNumberController.text,
      cardHolderName: _cardHolderController.text,
      expiryDate: _expiryController.text,
      cvv: _cvvController.text,
    );
  }

  Future<void> _simulateLankaQR() async {
    setState(() {
      _isSimulatingQR = true;
      _qrSimulationMessage = "Waiting for LankaQR Scan...";
    });

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    setState(() => _qrSimulationMessage = "Verifying Payment...");
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    await ref.read(paymentViewModelProvider.notifier).processPayment(
      fineReferenceNumber: widget.fine.referenceNumber,
      fineCategoryId: widget.fine.categoryId,
      paymentMethod: 'LANKA_QR',
      cardNumber: '',
      cardHolderName: 'LankaQR User',
      expiryDate: '',
      cvv: '',
    );

    if (mounted) setState(() => _isSimulatingQR = false);
  }

  void _showSuccessOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
              const SizedBox(height: 20),
              const Text(
                'Payment Successful!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF003087)),
              ),
              const SizedBox(height: 12),
              Text(
                'Fine ${widget.fine.referenceNumber} has been cleared.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go(AppConstants.routeUserDashboard);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003087)),
                  child: const Text('Back to Dashboard', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentViewModelProvider);
    final isProcessing = state.maybeWhen(processing: () => true, orElse: () => false);

    ref.listen<PaymentState>(paymentViewModelProvider, (_, state) {
      state.whenOrNull(
        success: (_) => _showSuccessOverlay(),
        error: (msg) => context.showSnackBar(msg, isError: true),
      );
    });

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
        title: const Text('Secure Payment', style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
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
                        Expanded(
                          flex: 2,
                          child: _FineDetail(
                            label: 'Ref No.',
                            value: widget.fine.referenceNumber,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 3,
                          child: _FineDetail(
                            label: 'Location',
                            value: widget.fine.location,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: _FineDetail(
                            label: 'Amount',
                            value: widget.fine.amount.toRupees(),
                            highlight: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF003087),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.credit_card, size: 18), SizedBox(width: 8), Text('Credit Card')])),
                  Tab(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.qr_code_scanner, size: 18), SizedBox(width: 8), Text('Lanka QR')])),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 450,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCreditCardTab(isProcessing),
                  _buildLankaQRTab(isProcessing),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCardTab(bool isProcessing) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _cardHolderController,
            decoration: const InputDecoration(labelText: 'Cardholder Name', prefixIcon: Icon(Icons.person_outline)),
            validator: ValidationUtils.validateCardHolder,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16), _CardNumberFormatter()],
            decoration: const InputDecoration(labelText: 'Card Number', prefixIcon: Icon(Icons.credit_card), hintText: '0000 0000 0000 0000'),
            validator: ValidationUtils.validateCardNumber,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4), _ExpiryFormatter()],
                  decoration: const InputDecoration(labelText: 'Expiry Date', hintText: 'MM/YY'),
                  validator: ValidationUtils.validateExpiry,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                  decoration: const InputDecoration(labelText: 'CVV/CVC'),
                  validator: ValidationUtils.validateCvv,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isProcessing ? null : _processCreditCardPayment,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003087), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
              child: isProcessing
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('Pay ${widget.fine.amount.toRupees()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLankaQRTab(bool isProcessing) {
    if (_isSimulatingQR || isProcessing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.network('https://assets9.lottiefiles.com/packages/lf20_kz9pjc9x.json', height: 150),
            const SizedBox(height: 24),
            Text(_qrSimulationMessage.isEmpty ? "Processing..." : _qrSimulationMessage, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF003087))),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 3),
            borderRadius: BorderRadius.circular(16),
            color: Colors.yellow.shade50,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    color: Colors.red,
                    child: const Text('LANKAQR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  ),
                  const SizedBox(height: 12),
                  QrImageView(
                    data: 'lankaqr://pay?ref=${widget.fine.referenceNumber}&amt=${widget.fine.amount}',
                    version: QrVersions.auto,
                    size: 180.0,
                  ),
                  const SizedBox(height: 8),
                  const Text('Scan to Pay via any Bank App', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
              AnimatedBuilder(
                animation: _laserController,
                builder: (context, child) {
                  return Positioned(
                    top: 40 + (160 * _laserController.value),
                    child: Container(
                      width: 180,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.8), blurRadius: 8, spreadRadius: 2)],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('Scan the QR code using your banking app\nto complete the payment securely.', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: _simulateLankaQR,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF003087), width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Simulate Scan & Authorize', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003087))),
          ),
        ),
      ],
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: highlight ? Colors.amber.shade300 : Colors.white,
            fontSize: highlight ? 15 : 13,
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return newValue.copyWith(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    if (text.length == 2 && oldValue.text.length == 1) text = '$text/';
    return newValue.copyWith(text: text, selection: TextSelection.collapsed(offset: text.length));
  }
}
