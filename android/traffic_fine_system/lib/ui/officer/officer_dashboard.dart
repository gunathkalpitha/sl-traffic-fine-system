// lib/ui/officer/officer_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_constants.dart';
import '../../utils/extensions.dart';
import '../../utils/providers.dart';

class OfficerDashboard extends ConsumerStatefulWidget {
  const OfficerDashboard({super.key});

  @override
  ConsumerState<OfficerDashboard> createState() => _OfficerDashboardState();
}

class _OfficerDashboardState extends ConsumerState<OfficerDashboard> {
  String officerName = '';
  String badge = '';
  String district = '';
  int todaysFines = 5;
  double todaysCollection = 15500.00;

  @override
  void initState() {
    super.initState();
    _loadOfficerInfo();
  }

  Future<void> _loadOfficerInfo() async {
    final tokenManager = ref.read(tokenManagerProvider);
    final info = await tokenManager.getOfficerInfo();
    setState(() {
      officerName = info['name'] ?? 'Officer';
      badge = info['badge'] ?? '';
      district = info['district'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
        title: const Text('Officer Portal', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
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
                if (context.mounted) context.go(AppConstants.routeRoleSelection);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Officer Info Card
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFF003087).withValues(alpha: 0.12),
                          child: const Icon(Icons.badge_outlined, size: 40, color: Color(0xFF003087)),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                officerName,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text('Badge: $badge', style: TextStyle(color: Colors.grey.shade600)),
                              const SizedBox(height: 4),
                              Text('District: $district', style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stats Row
            Row(
              children: [
                _StatCard(
                  title: "Today's Fines",
                  value: '$todaysFines',
                  icon: Icons.receipt_outlined,
                ),
                const SizedBox(width: 16),
                _StatCard(
                  title: "Today's Collection",
                  value: 'Rs. ${todaysCollection.toStringAsFixed(2)}',
                  icon: Icons.attach_money_outlined,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFF003087)),
            ),
            const SizedBox(height: 16),

            // Issue Fine Button
            _ActionButton(
              icon: Icons.receipt_long_rounded,
              label: 'Issue Fine On-the-Spot',
              subtitle: 'Create & collect fine immediately',
              onTap: () => context.go(AppConstants.routeFineEntry),
            ),
            const SizedBox(height: 12),

            // View Issued Fines Button
            _ActionButton(
              icon: Icons.history,
              label: 'View Issued Fines',
              subtitle: 'Check all fines issued today',
              onTap: () => context.showSnackBar('View issued fines - Coming soon'),
            ),
            const SizedBox(height: 12),

            // Collected Fines Button
            _ActionButton(
              icon: Icons.check_circle_outline,
              label: 'Collected Fines',
              subtitle: 'View all collected payments',
              onTap: () => context.showSnackBar('Collected fines - Coming soon'),
            ),
            const SizedBox(height: 24),

            // Recent Fines Section
            const Text(
              'Recent Issued Fines',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF003087)),
            ),
            const SizedBox(height: 12),
            _RecentFineItem(
              referenceNumber: 'REF-2024-001',
              category: 'Speeding',
              driver: 'John Doe',
              amount: 5000.00,
              status: 'Pending',
            ),
            _RecentFineItem(
              referenceNumber: 'REF-2024-002',
              category: 'No Helmet',
              driver: 'Jane Smith',
              amount: 2500.00,
              status: 'Paid',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: const Color(0xFF003087)),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF003087).withValues(alpha: 0.12),
                child: Icon(icon, color: const Color(0xFF003087)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentFineItem extends StatelessWidget {
  final String referenceNumber;
  final String category;
  final String driver;
  final double amount;
  final String status;

  const _RecentFineItem({
    required this.referenceNumber,
    required this.category,
    required this.driver,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isPaid = status == 'Paid';
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.receipt, size: 40, color: const Color(0xFF003087).withValues(alpha: 0.5)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(referenceNumber, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('$category • $driver', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Rs. ${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPaid ? Colors.green.withValues(alpha: 0.12) : Colors.orange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isPaid ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
