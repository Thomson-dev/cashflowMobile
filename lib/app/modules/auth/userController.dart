import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cashflow/app/data/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService();
  
  // Profile data
  final userProfile = Rxn<Map<String, dynamic>>();
  final isLoading = true.obs;
  final currentBalance = 0.0.obs;
  final userName = 'User'.obs;

  // Cashflow status data
  final cashflowStatus = Rxn<Map<String, dynamic>>();
  final isCashflowLoading = false.obs;
  final dailyBurnRate = 0.0.obs;
  final daysRemaining = 0.obs;
  final indicator = 'green'.obs;
  final phrase = ''.obs;

  // Financial summary data
  final financialSummary = Rxn<Map<String, dynamic>>();
  final isFinancialLoading = false.obs;
  final monthlyIncome = 0.0.obs;
  final monthlyExpenses = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchCashflowStatus();
    fetchFinancialSummary();
    
    // Listen for changes to userProfile and update reactive variables
    ever(userProfile, (_) {
      _updateProfileData();
    });

    // Listen for changes to cashflow status
    ever(cashflowStatus, (_) {
      _updateCashflowData();
    });

    // Listen for changes to financial summary
    ever(financialSummary, (_) {
      _updateFinancialData();
    });
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading(true);
      final profile = await _authService.getProfileDetails();
      userProfile(profile);
      _updateProfileData();
    } catch (e) {
      print('Error fetching profile: $e');
      _showAwesomeSnackbar(
        title: 'Error!',
        message: 'Failed to load profile: $e',
        contentType: ContentType.failure,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCashflowStatus() async {
    try {
      isCashflowLoading(true);
      final status = await _authService.getCashflowStatus();
      print('Cashflow status response: $status');
      cashflowStatus(status);
      _updateCashflowData();
    } catch (e) {
      print('Error fetching cashflow status: $e');
      _showAwesomeSnackbar(
        title: 'Error!',
        message: 'Failed to load cashflow status: $e',
        contentType: ContentType.failure,
      );
    } finally {
      isCashflowLoading(false);
    }
  }

  Future<void> fetchFinancialSummary() async {
    try {
      isFinancialLoading(true);
      final summary = await _authService.getFinancialSummary();
      
      print('Financial summary response: $summary');
      financialSummary(summary);
      _updateFinancialData();
    } catch (e) {
      print('Error fetching financial summary: $e');
      _showAwesomeSnackbar(
        title: 'Error!',
        message: 'Failed to load financial summary: $e',
        contentType: ContentType.failure,
      );
    } finally {
      isFinancialLoading(false);
    }
  }

  void _updateProfileData() {
    final profile = userProfile.value;
    if (profile != null) {
      // Extract from nested user object
      var user = profile['user'] ?? profile;
      
      // Get starting capital from businessSetup
      var balance = user['businessSetup']?['startingCapital'];
      // Fallback to currentBalance if startingCapital not found
      if (balance == null) {
        balance = user['currentBalance'];
      }
      currentBalance.value = (balance as num?)?.toDouble() ?? 0.0;
      
      var name = user['name'];
      userName.value = name ?? 'User';
      
      print('Updated - Balance: ${currentBalance.value}, Name: ${userName.value}');
    }
  }

  void _updateCashflowData() {
    final status = cashflowStatus.value;
    if (status != null) {
      dailyBurnRate.value = (status['dailyBurnRate'] as num?)?.toDouble() ?? 0.0;
      daysRemaining.value = status['daysRemaining'] as int? ?? 0;
      indicator.value = status['indicator'] ?? 'green';
      phrase.value = status['phrase'] ?? '';
      
      print('Updated Cashflow - Burn Rate: ${dailyBurnRate.value}, Days Remaining: ${daysRemaining.value}, Indicator: ${indicator.value}');
    }
  }

  void _updateFinancialData() {
    final summary = financialSummary.value;
    if (summary != null) {
      monthlyIncome.value = (summary['monthlyIncome'] as num?)?.toDouble() ?? 0.0;
      monthlyExpenses.value = (summary['monthlyExpenses'] as num?)?.toDouble() ?? 0.0;
      
      print('Updated Financial - Income: ${monthlyIncome.value}, Expenses: ${monthlyExpenses.value}');
    }
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