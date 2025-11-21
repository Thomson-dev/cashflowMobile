import 'package:cashflow/app/core/constants/api_constants.dart';
import 'package:cashflow/app/data/models/user_model.dart';
import 'package:cashflow/app/data/services/api_service.dart';
import 'package:cashflow/app/data/services/storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // Register user
  Future<Map<String, dynamic>> register(UserModel user) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        user.toJson(),
      );
     print(response);
      // Save token if provided
      if (response['token'] != null) {
        await _storageService.saveToken(response['token']);
        await _storageService.setLoggedIn(true);
      }

      // Save user data if provided
      if (response['user'] != null) {
        await _storageService.saveUserData(response['user']);
      }

      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Login user
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        {
          'email': email,
          'password': password,
        },
      );

      // Save token
      if (response['token'] != null) {
        await _storageService.saveToken(response['token']);
        await _storageService.setLoggedIn(true);
      }

      // Save user data
      if (response['user'] != null) {
        await _storageService.saveUserData(response['user']);
      }

      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      // Call logout endpoint
      await _apiService.post(
        ApiConstants.logout,
        {},
        requiresAuth: true,
      );
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      // Clear local storage
      await _storageService.clearAll();
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  // Get current user
  Future<Map<String, dynamic>?> getCurrentUser() async {
    return await _storageService.getUserData();
  }

  // Refresh token
  Future<void> refreshToken() async {
    try {
      final response = await _apiService.post(
        ApiConstants.refreshToken,
        {},
        requiresAuth: true,
      );

      if (response['token'] != null) {
        await _storageService.saveToken(response['token']);
      }
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }
}
