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



  // Fetch user profile details
  Future<Map<String, dynamic>> getProfileDetails() async {
    try {
      final response = await _apiService.get(
        ApiConstants.profileDetails, 
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to fetch profile details: $e');
    }
  }

  // Fetch cashflow status
  Future<Map<String, dynamic>> getCashflowStatus() async {
    try {
      final response = await _apiService.get(
        ApiConstants.cashflowStatus,
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to fetch cashflow status: $e');
    }
  }

  // Fetch financial summary
  Future<Map<String, dynamic>> getFinancialSummary() async {
    try {
      final response = await _apiService.get(
        ApiConstants.financialSummary,
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to fetch financial summary: $e');
    }
  }

  // Send message to chatbot
  Future<Map<String, dynamic>> sendChatbotMessage(String message) async {
    try {
      print('Sending message to chatbot: $message');
      final payload = {'userMessage': message};
      print('Payload: $payload');
      
      final response = await _apiService.post(
        ApiConstants.chatbotChat,
        payload,
        requiresAuth: true,
      );

      print('Chatbot response: $response');
      return response;
    } catch (e) {
      print('Chatbot service error: $e');
      throw Exception('Failed to send chatbot message: $e');
    }
  }

  // Create transaction
  Future<Map<String, dynamic>> createTransaction({
    required String type,
    required double amount,
    required String description,
    required String category,
    required String date,
    List<String>? tags,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.transactions,
        {
          'type': type,
          'amount': amount,
          'description': description,
          'category': category,
          'date': date,
          'tags': tags ?? [],
        },
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to create transaction: $e');
    }
  }


  // Get all transactions
  Future<Map<String, dynamic>> getAllTransactions() async {
    try {
      final response = await _apiService.get(
        ApiConstants.transactions,
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  // Delete transaction
  Future<Map<String, dynamic>> deleteTransaction(String transactionId) async {
    try {
      final response = await _apiService.delete(
        '${ApiConstants.transactions}/$transactionId',
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  // Get analytics insights
  Future<Map<String, dynamic>> getInsights() async {
    try {
      final response = await _apiService.get(
        ApiConstants.insights,
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      throw Exception('Failed to fetch insights: $e');
    }
  }
}
