import 'package:flutter/material.dart';

class PeriodSummaryCard extends StatelessWidget {
  final String period;
  final String dateRange;
  final int totalIncome;
  final int totalExpenses;
  final int netAmount;
  final int totalTransactions;
  final double averagePerTransaction;

  const PeriodSummaryCard({
    super.key,
    required this.period,
    required this.dateRange,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netAmount,
    required this.totalTransactions,
    required this.averagePerTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Period Summary ($period)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),

          // Data rows
          _buildDataRow(
            label: 'Date Range:',
            value: dateRange,
            valueColor: const Color(0xFF64748B),
            backgroundColor: Colors.white,
            isFirst: true,
          ),
          _buildDataRow(
            label: 'Total Income:',
            value: '₦${_formatCurrency(totalIncome)}',
            valueColor: const Color(0xFF059669),
            backgroundColor: const Color(0xFFF0FDF4),
          ),
          _buildDataRow(
            label: 'Total Expenses:',
            value: '₦${_formatCurrency(totalExpenses)}',
            valueColor: const Color(0xFFDC2626),
            backgroundColor: const Color(0xFFFEF2F2),
          ),
          _buildDataRow(
            label: 'Net Amount:',
            value: '₦${_formatCurrency(netAmount)}',
            valueColor: const Color(0xFF059669),
            backgroundColor: const Color(0xFFF0FDF4),
          ),
          _buildDataRow(
            label: 'Total Transactions:',
            value: totalTransactions.toString(),
            valueColor: const Color(0xFF2563EB),
            backgroundColor: const Color(0xFFEFF6FF),
          ),
          _buildDataRow(
            label: 'Average per Transaction:',
            value: '₦${_formatCurrency(averagePerTransaction.toInt())}',
            valueColor: const Color(0xFF7C3AED),
            backgroundColor: const Color(0xFFF3E8FF),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow({
    required String label,
    required String value,
    required Color valueColor,
    required Color backgroundColor,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: isFirst ? const Radius.circular(0) : Radius.zero,
          topRight: isFirst ? const Radius.circular(0) : Radius.zero,
          bottomLeft: isLast ? const Radius.circular(16) : Radius.zero,
          bottomRight: isLast ? const Radius.circular(16) : Radius.zero,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF374151),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

// Usage example
class PeriodSummaryExample extends StatelessWidget {
  const PeriodSummaryExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: const PeriodSummaryCard(
            period: '30d',
            dateRange: '9/19/2025 - 10/19/2025',
            totalIncome: 50000,
            totalExpenses: 0,
            netAmount: 50000,
            totalTransactions: 1,
            averagePerTransaction: 50000.0,
          ),
        ),
      ),
    );
  }
}
