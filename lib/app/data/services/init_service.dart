import 'package:cashflow/app/data/services/storage_service.dart';
import 'package:cashflow/app/routes/app_routes.dart';

class InitService {
  final StorageService _storageService = StorageService();

  // Get initial route based on login status
  Future<String> getInitialRoute() async {
    final isLoggedIn = await _storageService.isLoggedIn();
    final token = await _storageService.getToken();

    if (isLoggedIn && token != null) {
      // User is logged in, go to home
      return AppRoutes.main;
    } else {
      // User is not logged in, go to welcome
      return AppRoutes.welcome;
    }
  }

  // Get current user data
  Future<Map<String, dynamic>?> getCurrentUser() async {
    return await _storageService.getUserData();
  }

  // Initialize app preferences
  Future<void> initializePreferences() async {
    // Load saved preferences
    final currency = await _storageService.getString('currency');
    final darkMode = await _storageService.getBool('dark_mode');
    
    // Set defaults if not found
    if (currency == null) {
      await _storageService.saveString('currency', 'USD');
    }
    if (darkMode == null) {
      await _storageService.saveBool('dark_mode', false);
    }
  }
}
