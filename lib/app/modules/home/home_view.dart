import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Enhanced Dashboard with best UX practices
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Pull to refresh logic
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (replaces SliverAppBar)
                  _HomeHeader(
                    getGreeting: _getGreeting,
                    onSearch: () => Get.toNamed('/search'),
                    onNotifications: () => Get.toNamed('/notifications'),
                  ),
                  const SizedBox(height: 20),

                  // Featured Balance Card (Hero)
                  _FeaturedBalanceCard(
                    currentBalance: 10000,
                  ),
                  const SizedBox(height: 20),

                  // Income & Expense Row
                  Row(
                    children: [
                      Expanded(
                        child: _CompactMetricCard(
                          title: ' Monthly Income',
                          value: ' ₦0',
                          change: '+8.2%',
                          isPositive: true,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _CompactMetricCard(
                          title: 'Monthly Expenses',
                          value: ' ₦0',
                          change: '+15.1%',
                          isPositive: false,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Health Score Banner
                  _HealthScoreBanner(
                    currentBalance: 10000,
                    dailyBurnRate: 0,
                    daysRemaining: 999,
                    indicator: 'green',
                    phrase: "You're doing great! You have 999 days of runway.",
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
                  _RecentTransactionsList(),
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

  void _showAddTransactionSheet() {
    Get.bottomSheet(
      const AddTransactionSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

// Header widget to replace SliverAppBar
class _HomeHeader extends StatelessWidget {
  final String Function() getGreeting;
  final VoidCallback onSearch;
  final VoidCallback onNotifications;

  const _HomeHeader({
    required this.getGreeting,
    required this.onSearch,
    required this.onNotifications,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              getGreeting(),
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF6B7280),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF374151), // lighter black
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        Row(
          children: [
            _HeaderIconButton(icon: Icons.search, onTap: onSearch),
            const SizedBox(width: 8),
            _NotificationBadge(count: 3, onTap: onNotifications),
          ],
        ),
      ],
    );
  }
}

// Featured Balance Card (Hero Card)
class _FeaturedBalanceCard extends StatelessWidget {
  final double currentBalance;

  const _FeaturedBalanceCard({
    required this.currentBalance,
  });

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
            '₦${currentBalance.toStringAsFixed(0)}',
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

// Health Score Banner
class _HealthScoreBanner extends StatelessWidget {
  final double currentBalance;
  final double dailyBurnRate;
  final int daysRemaining;
  final String indicator;
  final String phrase;

  const _HealthScoreBanner({
    required this.currentBalance,
    required this.dailyBurnRate,
    required this.daysRemaining,
    required this.indicator,
    required this.phrase,
  });

  Color getColor() {
    switch (indicator.toLowerCase()) {
      case 'green':
        return const Color(0xFF10B981);
      case 'yellow':
        return const Color(0xFFF59E0B);
      case 'red':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData getIcon() {
    switch (indicator.toLowerCase()) {
      case 'green':
        return Icons.check_circle;
      case 'yellow':
        return Icons.warning;
      case 'red':
        return Icons.error;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: getColor().withOpacity(0.3), width: 2),
       
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: getColor().withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  getIcon(),
                  color: getColor(),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Financial Health',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      phrase,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[200], height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _HealthMetric(
                label: 'Balance',
                value: '₦${currentBalance.toStringAsFixed(0)}',
                icon: Icons.account_balance_wallet,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[200],
              ),
              _HealthMetric(
                label: 'Daily Burn',
                value: dailyBurnRate > 0 
                    ? '₦${dailyBurnRate.toStringAsFixed(0)}'
                    : '₦0',
                icon: Icons.local_fire_department,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.grey[200],
              ),
              _HealthMetric(
                label: 'Runway',
                value: daysRemaining >= 999 
                    ? '999+ days' 
                    : '$daysRemaining days',
                icon: Icons.trending_up,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _HealthMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6B7280)),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF374151),
              fontFamily: 'Poppins',
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

// Recent Transactions List
class _RecentTransactionsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TransactionItem(
          title: 'Sales Revenue',
          category: 'Income',
          amount: 45000,
          isIncome: true,
          date: 'Today, 2:30 PM',
          icon: Icons.trending_up,
        ),
        _TransactionItem(
          title: 'Office Supplies',
          category: 'Expenses',
          amount: 12500,
          isIncome: false,
          date: 'Yesterday',
          icon: Icons.shopping_bag,
        ),
        _TransactionItem(
          title: 'Client Payment',
          category: 'Income',
          amount: 85000,
          isIncome: true,
          date: 'Oct 13',
          icon: Icons.account_balance_wallet,
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final String title;
  final String category;
  final double amount;
  final bool isIncome;
  final String date;
  final IconData icon;

  const _TransactionItem({
    required this.title,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  isIncome ? const Color(0xFFD1FAE5) : const Color(0xFFFEE2E2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color:
                  isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151), // lighter black
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$category • $date',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isIncome ? '+' : '-'}₦${amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color:
                  isIncome ? const Color(0xFF10B981) : const Color(0xFFEF4444),
              fontFamily: 'Poppins',
            ),
          ),
        ],
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

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: const Color(0xFF1F2937), size: 20),
      ),
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const _NotificationBadge({required this.count, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Center(
              child: Icon(
                Icons.notifications_outlined,
                color: Color(0xFF1F2937),
                size: 20,
              ),
            ),
            if (count > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count > 9 ? '9+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
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
