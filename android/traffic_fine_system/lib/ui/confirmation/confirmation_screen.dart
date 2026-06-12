// lib/ui/confirmation/confirmation_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/fine.dart';
import '../../data/model/payment_response.dart';
import '../../utils/app_constants.dart';
import '../../utils/extensions.dart';

class ConfirmationScreen extends StatelessWidget {
  final Fine fine;
  final PaymentResponse paymentResponse;

  const ConfirmationScreen({
    super.key,
    required this.fine,
    required this.paymentResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              // Success icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF1B7F3E).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  size: 64,
                  color: Color(0xFF1B7F3E),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1B7F3E),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'An SMS has been sent to the issuing officer.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _DetailRow(
                        label: 'Transaction ID',
                        value: paymentResponse.transactionId ?? '—',
                        bold: true,
                      ),
                      const Divider(height: 28),
                      _DetailRow(
                        label: 'Fine Reference',
                        value: fine.referenceNumber,
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: 'Violation',
                        value: fine.categoryName,
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: 'Amount Paid',
                        value: fine.amount.toRupees(),
                        highlight: true,
                      ),
                      const SizedBox(height: 12),
                      _DetailRow(
                        label: 'Status',
                        value: paymentResponse.payment?.status ?? 'SUCCESS',
                        statusBadge: true,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'You may now retrieve your driving license\nfrom the traffic police officer.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF003087),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => context.go(AppConstants.routeMain),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003087),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool highlight;
  final bool statusBadge;

  const _DetailRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.highlight = false,
    this.statusBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        statusBadge
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B7F3E).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF1B7F3E),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              )
            : Text(
                value,
                style: TextStyle(
                  fontSize: bold ? 15 : 13,
                  fontWeight: bold || highlight
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: highlight
                      ? const Color(0xFF1B7F3E)
                      : const Color(0xFF1A1A2E),
                ),
              ),
      ],
    );
  }
}
