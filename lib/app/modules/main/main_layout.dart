import 'package:cashflow/app/modules/Insight/insight.dart';
import 'package:cashflow/app/modules/transactions/add_transaction/transaction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

// Import your actual screen widgets
import '../home/home_view.dart';

// If you have a custom color class, import it. Otherwise, fallback to default colors below.
// import '../../theme/colors.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Fallback colors if TColors is not available
    final Color darkColor = const Color(0xFF18181B);
    final Color accentColor = const Color(0xFF10B981);

    return Scaffold(
      body: Obx(() => _getScreen(controller.currentIndex.value)),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 60,
          elevation: 0,
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected:
              (index) => controller.currentIndex.value = index,
          backgroundColor: isDark ? darkColor : Colors.white,
          indicatorColor:
              isDark
                  ? Colors.white.withOpacity(0.1)
                  : darkColor.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(
              icon: Icon(Iconsax.home_1),
              label: 'Transactions',
            ),
            // NavigationDestination(
            //   icon: Icon(Iconsax.camera),
            //   label: 'SnapBook',
            // ),
            NavigationDestination(
              icon: Icon(Iconsax.activity),
              label: 'Insights',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.setting),
              label: 'Settings',
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        // Hide on chatbot screen itself (if you want to hide for a specific tab, e.g. Profile)
        if (controller.currentIndex.value == 4) return const SizedBox.shrink();
        return Stack(
          clipBehavior: Clip.none,
          children: [
            FloatingActionButton(
              onPressed: () => Get.to(() => const ChatbotScreen()),
              backgroundColor: const Color(0xFF10B981),
              elevation: 4,
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 26,
              ),
            ),
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFEF4444),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const TransactionForm();

      case 2:
        return const FinancialInsightsScreen();
      case 3:
        return const SettingsScreen();
      default:
        return const DashboardScreen();
    }
  }

  // _buildBottomNav is no longer needed with NavigationBar
}

class NavigationController extends GetxController {
  RxInt currentIndex = 0.obs;
}

// Minimal ChatbotScreen placeholder
class ChatbotScreen extends StatelessWidget {
  const ChatbotScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Chatbot Screen')));
}

// Placeholder screens
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Center(child: Text('Dashboard'));
}

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Transactions'));
}

class SnapBookScreen extends StatelessWidget {
  const SnapBookScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Center(child: Text('Snap Book'));
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const Center(child: Text('Settings'));
}
