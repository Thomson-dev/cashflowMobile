import 'package:get/get.dart';
import 'package:cashflow/app/data/services/auth_service.dart';

class ChatbotController extends GetxController {
  final messages = <Map<String, dynamic>>[].obs;
  final suggestions = <String>[].obs;
  final isLoading = false.obs;
  final aiAvailable = true.obs;
  final AuthService _authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    // Add a welcome message
    messages.add({
      'text': 'Hello! I\'m your AI Financial Assistant. How can I help you today?',
      'isUser': false,
      'suggestions': [
        'What\'s my current financial status?',
        'Show recent transactions',
        'Give me cash flow tips',
      ],
    });
  }

  void sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    messages.insert(0, {
      'text': text,
      'isUser': true,
    });
    suggestions.clear();

    // Call API
    isLoading.value = true;
    try {
      final response = await _authService.sendChatbotMessage(text);
      
      // Safely convert suggestions to List<String>
      List<String> suggestionsList = [];
      if (response['suggestions'] != null) {
        final suggestionsData = response['suggestions'];
        if (suggestionsData is List) {
          suggestionsList = suggestionsData.map((s) => s.toString()).toList();
        }
      }
      
      messages.insert(0, {
        'text': response['response'] ?? 'No response',
        'isUser': false,
        'suggestions': suggestionsList,
      });
      suggestions.assignAll(suggestionsList);
      aiAvailable.value = response['aiAvailable'] ?? true;
    } catch (e) {
      print('Chatbot Error: $e');
      messages.insert(0, {
        'text': 'Sorry, I encountered an error. Please try again. Error: $e',
        'isUser': false,
        'suggestions': [],
      });
    } finally {
      isLoading.value = false;
    }
  }

}
