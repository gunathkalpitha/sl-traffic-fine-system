// lib/ui/main/main_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/model/notification.dart';
import '../../utils/app_constants.dart';
import '../../utils/providers.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late List<FineNotification> notifications;

  @override
  void initState() {
    super.initState();
    _initializeMockNotifications();
  }

  void _initializeMockNotifications() {
    notifications = [
      FineNotification(
        id: '1',
        referenceNumber: 'REF-2024-001',
        categoryId: 'FC001',
        categoryName: 'Speeding',
        driverName: 'John Doe',
        driverLicense: 'DL1234567',
        vehicleNumber: 'CAR-2024',
        amount: 5000.00,
        issuedDateTime: DateTime.now().subtract(const Duration(hours: 2)),
        locationIssued: 'Colombo Fort',
        isPaid: false,
        violationDetails: 'Driving at 85 km/h in 60 km/h zone',
      ),
      FineNotification(
        id: '2',
        referenceNumber: 'REF-2024-002',
        categoryId: 'FC003',
        categoryName: 'No Helmet',
        driverName: 'Jane Smith',
        driverLicense: 'DL9876543',
        vehicleNumber: 'BIKE-123',
        amount: 2500.00,
        issuedDateTime: DateTime.now().subtract(const Duration(hours: 5)),
        locationIssued: 'Mount Lavinia',
        isPaid: true,
        paidDateTime: DateTime.now().subtract(const Duration(hours: 1)),
        violationDetails: 'Rider not wearing helmet',
      ),
    ];
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(authRepositoryProvider).logout();
      if (mounted) context.go(AppConstants.routeLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF003087),
        foregroundColor: Colors.white,
        title: const Text(
          'SL Traffic Fines',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                tooltip: 'Notifications',
                onPressed: _showNotifications,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${notifications.where((n) => !n.isPaid).length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          setState(() => _initializeMockNotifications());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOfficerCard(),
                const SizedBox(height: 24),
                _buildStatisticsSection(),
                const SizedBox(height: 28),
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF003087),
                  ),
                ),
                const SizedBox(height: 16),
                _buildActionCard(
                  icon: Icons.receipt_long_rounded,
                  label: 'Issue Fine',
                  subtitle: 'Enter fine details for on-the-spot payment',
                  color: const Color(0xFF003087),
                  onTap: () => context.go(AppConstants.routeFineEntry),
                ),
                const SizedBox(height: 12),
                _buildActionCard(
                  icon: Icons.search_rounded,
                  label: 'Search Fine',
                  subtitle: 'Look up fine details by reference number',
                  color: Colors.green.shade700,
                  onTap: () => context.go(AppConstants.routeFineEntry),
                ),
                const SizedBox(height: 12),
                _buildActionCard(
                  icon: Icons.history_rounded,
                  label: 'History',
                  subtitle: 'View fines issued today',
                  color: Colors.orange.shade700,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOfficerCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [const Color(0xFF003087), Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              child: const Icon(
                Icons.badge_rounded,
                size: 32,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Officer Details',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Test Officer',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Badge: SL1234 | District: Western Province',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    final totalFines = notifications.length;
    final unpaidFines = notifications.where((n) => !n.isPaid).length;
    final totalAmount = notifications.fold<double>(
      0,
      (sum, n) => sum + (n.isPaid ? n.amount : 0),
    );

    return Row(
      children: [
        _buildStatCard('Total Issued', '$totalFines', Colors.blue.shade700),
        const SizedBox(width: 12),
        _buildStatCard('Unpaid', '$unpaidFines', Colors.red.shade700),
        const SizedBox(width: 12),
        _buildStatCard(
          'Collected',
          'Rs ${totalAmount.toStringAsFixed(0)}',
          Colors.green.shade700,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF003087),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color.withValues(alpha: 0.12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Fine Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (_, index) {
                final notif = notifications[index];
                return _buildNotificationTile(notif);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(FineNotification notif) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: notif.isPaid
              ? Colors.green.withValues(alpha: 0.1)
              : Colors.red.withValues(alpha: 0.1),
        ),
        child: Icon(
          notif.isPaid ? Icons.check_circle : Icons.warning,
          color: notif.isPaid ? Colors.green : Colors.red,
        ),
      ),
      title: Text(
        'Ref: ${notif.referenceNumber}',
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '${notif.driverName} - ${notif.categoryName}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        'Rs ${notif.amount}',
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF003087),
        ),
      ),
      onTap: () => _showNotificationDetails(notif),
    );
  }

  void _showNotificationDetails(FineNotification notif) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Fine Details - ${notif.referenceNumber}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Driver Name', notif.driverName),
              _buildDetailRow('License', notif.driverLicense),
              _buildDetailRow('Vehicle', notif.vehicleNumber),
              _buildDetailRow('Category', notif.categoryName),
              _buildDetailRow('Amount', 'Rs ${notif.amount}'),
              _buildDetailRow('Issued', _formatDateTime(notif.issuedDateTime)),
              _buildDetailRow('Location', notif.locationIssued),
              _buildDetailRow('Details', notif.violationDetails),
              _buildDetailRow(
                'Status',
                notif.isPaid ? 'PAID' : 'PENDING',
                isStatus: true,
                isPaid: notif.isPaid,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {bool isStatus = false, bool isPaid = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: isPaid
                    ? Colors.green.withValues(alpha: 0.1)
                    : Colors.red.withValues(alpha: 0.1),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isPaid ? Colors.green : Colors.red,
                  fontSize: 11,
                ),
              ),
            )
          else
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
