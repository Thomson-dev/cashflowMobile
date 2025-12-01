// Recent Transactions List
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cashflow/app/modules/transactions/controller/transaction_controller.dart';

class RecentTransactionsList extends StatelessWidget {
  final TransactionController controller = Get.put(TransactionController());

  RecentTransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: CircularProgressIndicator(
              color: Color(0xFF10B981),
            ),
          ),
        );
      }

      if (controller.transactions.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontFamily: 'Poppins',
              ),
            ),
          ),
        );
      }

      // Show only last 5 transactions
      final recentTransactions = controller.transactions.take(5).toList();

      return Column(
        children: recentTransactions.map((transaction) {
          final isIncome = transaction['type'] == 'income';
          final amount = (transaction['amount'] as num).toDouble();
          final description = transaction['description'] ?? 'No description';
          final category = transaction['category'] ?? 'Uncategorized';
          final date = transaction['date'] ?? '';

          return Dismissible(
            key: Key(transaction['_id']),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              controller.deleteTransaction(transaction['_id']);
            },
            child: _TransactionItem(
              title: description,
              category: category,
              amount: amount,
              isIncome: isIncome,
              date: _formatDate(date),
              icon: _getIcon(category, isIncome),
            ),
          );
        }).toList(),
      );
    });
  }

  IconData _getIcon(String category, bool isIncome) {
    final categoryLower = category.toLowerCase();
    
    if (categoryLower.contains('salary') || categoryLower.contains('income')) {
      return Icons.trending_up;
    } else if (categoryLower.contains('food')) {
      return Icons.restaurant;
    } else if (categoryLower.contains('transport')) {
      return Icons.directions_car;
    } else if (categoryLower.contains('shopping')) {
      return Icons.shopping_bag;
    } else if (categoryLower.contains('bills')) {
      return Icons.receipt_long;
    } else if (categoryLower.contains('health')) {
      return Icons.local_hospital;
    }
    
    return isIncome ? Icons.account_balance_wallet : Icons.shopping_bag;
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final dateOnly = DateTime(date.year, date.month, date.day);

      if (dateOnly == today) {
        return 'Today';
      } else if (dateOnly == yesterday) {
        return 'Yesterday';
      } else {
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        return '${months[date.month - 1]} ${date.day}';
      }
    } catch (e) {
      return dateStr;
    }
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
                    fontSize: 14,
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