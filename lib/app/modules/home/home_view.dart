import 'package:cashflow/app/modules/home/widget/header.dart';
import 'package:cashflow/app/modules/home/widget/healthScore.dart';
import 'package:cashflow/app/modules/auth/userController.dart';
import 'package:cashflow/app/modules/home/widget/recentTrancation.dart';
import 'package:cashflow/app/modules/transactions/controller/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Enhanced Dashboard with best UX practices

String _formatCurrency(double amount) {
  return amount
      .toStringAsFixed(0)
      .replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final ProfileController profileController = Get.find<ProfileController>();
    final TransactionController transcontroller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFF10B981), // Custom spinner color (green)
          backgroundColor: Colors.white, // Spinner background
          displacement: 40, // Distance from top
          strokeWidth: 3, // Thickness of spinner
          onRefresh: () async {
            await Future.wait([
              profileController.fetchUserProfile(),
              profileController.fetchCashflowStatus(),
              profileController.fetchFinancialSummary(),
              transcontroller.fetchTransactions(),
             
            ]);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (replaces SliverAppBar)
                  HomeHeader(
                    getGreeting: _getGreeting,
                    onSearch: () => Get.toNamed('/search'),
                    onNotifications: () => Get.toNamed('/notifications'),
                  ),
                  const SizedBox(height: 20),

                  // Featured Balance Card (Hero)
                  Obx(
                    () => _FeaturedBalanceCard(
                      currentBalance: profileController.currentBalance.value,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Income & Expense Row
                  // Display monthly income and expenses
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _CompactMetricCard(
                          title: 'Monthly Income',
                          value:
                              '₦${_formatCurrency(profileController.monthlyIncome.value)}',
                          change: '+8.2%',
                          isPositive: true,
                          color: const Color(0xFF10B981),
                        ),
                        _CompactMetricCard(
                          title: 'Monthly Expenses',
                          value:
                              '₦${_formatCurrency(profileController.monthlyExpenses.value)}',
                          change: '+15.1%',
                          isPositive: false,
                          color: const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Health Score Banner
                  // In your widget, wrap with Obx
                  Obx(
                    () => HealthScoreBanner(
                      dailyBurnRate: profileController.dailyBurnRate.value,
                      daysRemaining: profileController.daysRemaining.value,
                      indicator: profileController.indicator.value,
                      phrase: profileController.phrase.value,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Quick Actions
                  _SectionHeader(
                    title: 'Quick Actions',
                    action: 'See All',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 16),
                  _QuickActionsGrid(),
                  const SizedBox(height: 28),

                  // Recent Transactions
                  _SectionHeader(
                    title: 'Recent Transactions',
                    action: 'View All',
                    onActionTap: () => Get.toNamed('/transactions'),
                  ),
                  const SizedBox(height: 16),

                  RecentTransactionsList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

// Featured Balance Card (Hero Card)
class _FeaturedBalanceCard extends StatelessWidget {
  final double currentBalance;

  const _FeaturedBalanceCard({required this.currentBalance});

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color.fromARGB(255, 21, 22, 22), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.visibility, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      'Hide',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '₦${_formatCurrency(currentBalance)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '+12.5% from last month',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Compact Metric Card
class _CompactMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool isPositive;
  final Color color;

  const _CompactMetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Subtle background wave (placeholder)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: 0.18,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          // Card content
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                      color: isPositive ? Colors.white : Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      change,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Quick Actions Grid
class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.camera_alt_outlined,
            title: 'Snap Book',
            subtitle: 'AI Extract',
            useWhiteBg: true,
            onTap: () => Get.toNamed('/snap-book'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.upload_file,
            title: 'Import CSV',
            subtitle: 'Bulk Add',
            useWhiteBg: true,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool useWhiteBg;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.useWhiteBg = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: useWhiteBg ? const Color(0xFF374151) : Colors.white,
              size: 24,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: useWhiteBg ? Color(0xFF374151) : Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color:
                    useWhiteBg ? Colors.black54 : Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}





// Helper Widgets
class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onActionTap;

  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF374151), // lighter black
            fontFamily: 'Poppins',
          ),
        ),
        GestureDetector(
          onTap: onActionTap,
          child: Text(
            action,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF10B981),
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }
}

// Add Transaction Bottom Sheet
class AddTransactionSheet extends StatelessWidget {
  const AddTransactionSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: const Center(child: Text('Add Transaction Form Here')),
    );
  }
}
