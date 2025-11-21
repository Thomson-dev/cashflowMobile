class ApiConstants {
  // Base URL - Replace with your actual API endpoint
  static const String baseUrl = 'https://cash-flow2.vercel.app/api';
  
  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/update';
  
  // Transaction endpoints
  static const String transactions = '/transactions';
  static const String addTransaction = '/transactions/add';
  static const String updateTransaction = '/transactions/update';
  static const String deleteTransaction = '/transactions/delete';
  
  // Business endpoints
  static const String businessInfo = '/business/info';
  static const String updateBusiness = '/business/update';
  
  // Analytics endpoints
  static const String analytics = '/analytics';
  static const String reports = '/reports';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> authHeaders(String token) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
