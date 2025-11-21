import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cashflow/app/core/constants/api_constants.dart';
import 'package:cashflow/app/data/services/storage_service.dart';

class ApiService {
  final StorageService _storageService = StorageService();

  // GET request
  Future<Map<String, dynamic>> get(String endpoint, {bool requiresAuth = false}) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = requiresAuth 
          ? await _getAuthHeaders() 
          : ApiConstants.headers;

      final response = await http.get(url, headers: headers);
      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, 
    Map<String, dynamic> data, 
    {bool requiresAuth = false}
  ) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = requiresAuth 
          ? await _getAuthHeaders() 
          : ApiConstants.headers;

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to send data: $e');
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, 
    Map<String, dynamic> data, 
    {bool requiresAuth = true}
  ) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = requiresAuth 
          ? await _getAuthHeaders() 
          : ApiConstants.headers;

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to update data: $e');
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = requiresAuth 
          ? await _getAuthHeaders() 
          : ApiConstants.headers;

      final response = await http.delete(url, headers: headers);
      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return jsonDecode(response.body);
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        throw Exception('Unauthorized');
      case 403:
        throw Exception('Forbidden');
      case 404:
        throw Exception('Not found');
      case 500:
        throw Exception('Server error');
      default:
        throw Exception('Error: ${response.statusCode}');
    }
  }

  // Get authenticated headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _storageService.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }
    return ApiConstants.authHeaders(token);
  }
}
