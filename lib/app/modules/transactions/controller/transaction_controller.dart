import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cashflow/app/data/services/auth_service.dart';

class TransactionController extends GetxController {
  final AuthService _authService = AuthService();
  
  // Reactive list of transactions
  final transactions = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final isRefreshing = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }
  
  // Fetch all transactions
  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      
      final response = await _authService.getAllTransactions();
      
      // Assuming response has a 'transactions' key - adjust based on your API
      if (response['transactions'] != null) {
        transactions.value = List<Map<String, dynamic>>.from(
          response['transactions'] as List
        );
      } else if (response is List) {
        // If API returns array directly
        transactions.value = List<Map<String, dynamic>>.from(response as List);
      }
    } catch (e) {
      _showAwesomeSnackbar(
        title: 'Error!',
        message: 'Failed to fetch transactions: ${e.toString().replaceAll('Exception: ', '')}',
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  // Refresh transactions (for pull-to-refresh)
  Future<void> refreshTransactions() async {
    try {
      isRefreshing.value = true;
      await fetchTransactions();
    } finally {
      isRefreshing.value = false;
    }
  }
  
  // Get transactions by type
  List<Map<String, dynamic>> getTransactionsByType(String type) {
    return transactions.where((t) => t['type'] == type).toList();
  }
  
  // Get income transactions
  List<Map<String, dynamic>> get incomeTransactions {
    return getTransactionsByType('income');
  }
  
  // Get expense transactions
  List<Map<String, dynamic>> get expenseTransactions {
    return getTransactionsByType('expense');
  }
  
  // Calculate total income
  double get totalIncome {
    return incomeTransactions.fold(
      0.0,
      (sum, t) => sum + (t['amount'] as num).toDouble(),
    );
  }
  
  // Calculate total expenses
  double get totalExpenses {
    return expenseTransactions.fold(
      0.0,
      (sum, t) => sum + (t['amount'] as num).toDouble(),
    );
  }
  
  // Calculate balance
  double get balance {
    return totalIncome - totalExpenses;
  }
  
  // Add transaction locally after creation
  void addTransaction(Map<String, dynamic> transaction) {
    transactions.insert(0, transaction);
  }
  
  // Remove transaction locally
  void removeTransaction(String transactionId) {
    transactions.removeWhere((t) => t['_id'] == transactionId);
  }

  // Delete transaction from API
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _authService.deleteTransaction(transactionId);
      
      // Remove from local list
      removeTransaction(transactionId);
      
      _showAwesomeSnackbar(
        title: 'Success!',
        message: 'Transaction deleted successfully',
        contentType: ContentType.success,
      );
    } catch (e) {
      _showAwesomeSnackbar(
        title: 'Error!',
        message: 'Failed to delete transaction: ${e.toString().replaceAll('Exception: ', '')}',
        contentType: ContentType.failure,
      );
    }
  }
  
  // Clear all transactions
  void clearTransactions() {
    transactions.clear();
  }

  // Show awesome snackbar
  void _showAwesomeSnackbar({
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      );
      ScaffoldMessenger.of(Get.context!)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    });
  }
}
