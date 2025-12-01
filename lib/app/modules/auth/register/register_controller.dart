import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cashflow/app/data/models/user_model.dart';
import 'package:cashflow/app/data/services/auth_service.dart';
import 'package:cashflow/app/data/services/storage_service.dart';

class RegisterController extends GetxController {
  // Services
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  
  // Current step in multi-step form
  var currentStep = 0.obs;
  
  // Form keys for validation
  final personalInfoFormKey = GlobalKey<FormState>();
  final businessInfoFormKey = GlobalKey<FormState>();
  final preferencesFormKey = GlobalKey<FormState>();
  
  // Personal Information Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneNumberController = TextEditingController();
  
  // Business Information Controllers
  final businessNameController = TextEditingController();
  final locationController = TextEditingController();
  final startingCapitalController = TextEditingController();
  final monthlyRevenueController = TextEditingController();
  final monthlyExpensesController = TextEditingController();
  final currentBalanceController = TextEditingController();
  final targetGrowthController = TextEditingController();
  
  // Observables for dropdowns and switches
  var selectedCurrency = 'USD'.obs;
  var selectedBusinessType = ''.obs;
  var selectedPrimaryGoal = ''.obs;
  var whatsappEnabled = false.obs;
  var whatsappAlerts = false.obs;
  var emailReports = false.obs;
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  
  // Loading state
  var isLoading = false.obs;
  
  // Currency options
  final List<String> currencies = [
    'USD', 'EUR', 'GBP', 'NGN', 'KES', 'GHS', 'ZAR', 'INR', 'JPY', 'CNY'
  ];
  
  // Business type options
  final List<String> businessTypes = [
    'Retail',
    'Wholesale',
    'Service',
    'Manufacturing',
    'E-commerce',
    'Restaurant/Food',
    'Consulting',
    'Technology',
    'Agriculture',
    'Other'
  ];
  
  // Primary goal options
  final List<String> primaryGoals = [
    'Increase Revenue',
    'Reduce Expenses',
    'Improve Cash Flow',
    'Expand Business',
    'Pay Off Debt',
    'Build Savings',
    'Track Transactions',
    'Financial Planning'
  ];

  @override
  void onInit() {
    super.onInit();
    // Set default values
    currentBalanceController.text = '0.00';
    _loadDraftData();
  }

  @override
  void onClose() {
    _saveDraft(); // Save draft before closing
    // Dispose controllers
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneNumberController.dispose();
    businessNameController.dispose();
    locationController.dispose();
    startingCapitalController.dispose();
    monthlyRevenueController.dispose();
    monthlyExpensesController.dispose();
    currentBalanceController.dispose();
    targetGrowthController.dispose();
    super.onClose();
  }

  // Load saved draft data
  Future<void> _loadDraftData() async {
    final draftData = await _storageService.getObject('registration_draft');
    if (draftData != null) {
      nameController.text = draftData['name'] ?? '';
      emailController.text = draftData['email'] ?? '';
      phoneNumberController.text = draftData['phone'] ?? '';
      selectedCurrency.value = draftData['currency'] ?? 'USD';
      businessNameController.text = draftData['businessName'] ?? '';
      locationController.text = draftData['location'] ?? '';
      selectedBusinessType.value = draftData['businessType'] ?? '';
      selectedPrimaryGoal.value = draftData['primaryGoal'] ?? '';
      currentStep.value = draftData['currentStep'] ?? 0;
    }
  }

  // Save draft data
  Future<void> _saveDraft() async {
    final draftData = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneNumberController.text,
      'currency': selectedCurrency.value,
      'businessName': businessNameController.text,
      'location': locationController.text,
      'businessType': selectedBusinessType.value,
      'primaryGoal': selectedPrimaryGoal.value,
      'currentStep': currentStep.value,
    };
    await _storageService.saveObject('registration_draft', draftData);
  }

  // Clear draft after successful registration
  Future<void> _clearDraft() async {
    await _storageService.remove('registration_draft');
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // Validate email format
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 4) {
      return 'Password must be at least 4 characters';
    }
    return null;
  }

  // Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Validate phone number
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Generic required field validator
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Validate numeric field
  String? validateNumeric(String? value, String fieldName, {bool required = false}) {
    if (value == null || value.isEmpty) {
      return required ? '$fieldName is required' : null;
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  // Move to next step
  void nextStep() {
    bool isValid = false;
    
    switch (currentStep.value) {
      case 0:
        isValid = personalInfoFormKey.currentState?.validate() ?? false;
        break;
      case 1:
        isValid = businessInfoFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        isValid = preferencesFormKey.currentState?.validate() ?? false;
        break;
    }

    if (isValid) {
      if (currentStep.value < 2) {
        currentStep.value++;
        _saveDraft(); // Save progress
      } else {
        // Final step - submit registration
        submitRegistration();
      }
    }
  }

  // Move to previous step
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  // Submit registration
  Future<void> submitRegistration() async {
    try {
      isLoading.value = true;

      // Create user model
      final user = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phoneNumber: phoneNumberController.text.trim(),
        currency: selectedCurrency.value,
        whatsappEnabled: whatsappEnabled.value,
        isSetupComplete: true,
        businessName: businessNameController.text.trim().isNotEmpty 
            ? businessNameController.text.trim() 
            : null,
        businessType: selectedBusinessType.value.isNotEmpty 
            ? selectedBusinessType.value 
            : null,
        location: locationController.text.trim().isNotEmpty 
            ? locationController.text.trim() 
            : null,
        startingCapital: startingCapitalController.text.isNotEmpty 
            ? double.tryParse(startingCapitalController.text) 
            : null,
        monthlyRevenue: monthlyRevenueController.text.isNotEmpty 
            ? double.tryParse(monthlyRevenueController.text) 
            : null,
        monthlyExpenses: monthlyExpensesController.text.isNotEmpty 
            ? double.tryParse(monthlyExpensesController.text) 
            : null,
        primaryGoal: selectedPrimaryGoal.value.isNotEmpty 
            ? selectedPrimaryGoal.value 
            : null,
        targetGrowth: targetGrowthController.text.isNotEmpty 
            ? double.tryParse(targetGrowthController.text) 
            : null,
        whatsappAlerts: whatsappAlerts.value,
        emailReports: emailReports.value,
        currentBalance: currentBalanceController.text.isNotEmpty 
            ? double.tryParse(currentBalanceController.text) ?? 0.0 
            : 0.0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Call registration API
      final response = await _authService.register(user);
      
      // Clear draft after successful registration
      await _clearDraft();
      
      // Show success message
      _showAwesomeSnackbar(
        title: 'Success!',
        message: response['message'] ?? 'Registration successful!',
        contentType: ContentType.success,
      );

      // Navigate to home
      Get.offAllNamed('/main');

    } catch (e) {
      _showAwesomeSnackbar(
        title: 'Error!',
        message: e.toString().replaceAll('Exception: ', ''),
        contentType: ContentType.failure,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Skip optional steps
  void skipBusinessInfo() {
    currentStep.value = 2;
    _saveDraft(); // Save progress
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
