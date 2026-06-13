// lib/ui/user/user_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_constants.dart';
import '../../utils/extensions.dart';
import '../../utils/providers.dart';

class UserDashboard extends ConsumerStatefulWidget {
  const UserDashboard({super.key});

  @override
  ConsumerState<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends ConsumerState<UserDashboard> {
  String userName = '';
  String userEmail = '';
  String licenseNumber = '';
  int pendingFines = 2;
  int paidFines = 1;
  double totalPending = 7500.00;
  int notificationCount = 2;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final tokenManager = ref.read(tokenManagerProvider);
    final info = await tokenManager.getUserInfo();
    setState(() {
      userName = info['name'] ?? 'User';
      userEmail = info['email'] ?? '';
      licenseNumber = info['licenseNumber'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
        title: const Text('My Fines', style: TextStyle(fontWeight: FontWeight.w700)),
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  context.showSnackBar('3 new fine notifications');
                },
              ),
              if (notificationCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$notificationCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                await ref.read(tokenManagerProvider).clearAll();
                if (context.mounted) context.go(AppConstants.routeUserLogin);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with gradient
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF003087),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        child: const Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userEmail,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'License: $licenseNumber',
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      _HeaderStat(title: 'Pending', value: '$pendingFines'),
                      const SizedBox(width: 16),
                      _HeaderStat(title: 'Paid', value: '$paidFines'),
                      const SizedBox(width: 16),
                      _HeaderStat(title: 'Due', value: 'Rs. ${totalPending.toStringAsFixed(0)}'),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pay Fine Action
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: InkWell(
                      onTap: () => _showPayFineDialog(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: const Color(0xFF003087).withValues(alpha: 0.12),
                              child: const Icon(Icons.payment_outlined, color: Color(0xFF003087)),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pay Your Fine',
                                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Enter fine reference to pay online',
                                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pending Fines
                  const Text(
                    'Pending Fines',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF003087)),
                  ),
                  const SizedBox(height: 12),
                  _FineCard(
                    referenceNumber: 'REF-2024-001',
                    category: 'Speeding',
                    amount: 5000.00,
                    issuedDate: 'Today at 2:30 PM',
                    location: 'Colombo Fort',
                    status: 'PENDING',
                    onTap: () => context.go(AppConstants.routePayment),
                  ),
                  const SizedBox(height: 12),
                  _FineCard(
                    referenceNumber: 'REF-2024-002',
                    category: 'No Helmet',
                    amount: 2500.00,
                    issuedDate: '2 days ago',
                    location: 'Maharagama',
                    status: 'PENDING',
                    onTap: () => context.go(AppConstants.routePayment),
                  ),
                  const SizedBox(height: 24),

                  // Paid Fines
                  const Text(
                    'Paid Fines',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF003087)),
                  ),
                  const SizedBox(height: 12),
                  _FineCard(
                    referenceNumber: 'REF-2024-003',
                    category: 'Illegal Parking',
                    amount: 3000.00,
                    issuedDate: 'Last week',
                    location: 'Galle Face Green',
                    status: 'PAID',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPayFineDialog(BuildContext context) {
    final referenceController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Enter Fine Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: referenceController,
              decoration: const InputDecoration(
                labelText: 'Fine Reference Number',
                hintText: 'e.g. REF-2024-001',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category ID',
                hintText: 'e.g. FC001',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.showSnackBar('Fine fetched successfully');
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String title;
  final String value;

  const _HeaderStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _FineCard extends StatelessWidget {
  final String referenceNumber;
  final String category;
  final double amount;
  final String issuedDate;
  final String location;
  final String status;
  final VoidCallback? onTap;

  const _FineCard({
    required this.referenceNumber,
    required this.category,
    required this.amount,
    required this.issuedDate,
    required this.location,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = status == 'PAID';
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: isPaid ? Colors.green : Colors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          referenceNumber,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          category,
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isPaid ? Colors.green.withValues(alpha: 0.12) : Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: isPaid ? Colors.green : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                      Text(
                        'Rs. ${amount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Issued', style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
                      Text(issuedDate, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                location,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
