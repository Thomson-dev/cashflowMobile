import 'package:cashflow/app/modules/auth/login/login_screen.dart';
import 'package:cashflow/app/modules/auth/register/register_view.dart';
import 'package:cashflow/app/modules/auth/userController.dart';
import 'package:cashflow/app/modules/main/main_layout.dart';
import 'package:cashflow/app/modules/chatbot/chatbot_view.dart';
import 'package:cashflow/app/modules/settings/settings_view.dart';
import 'package:get/get.dart';
import '../modules/home/home_view.dart';

import '../modules/auth/welcome_screen.dart';


import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.welcome;

  static final pages = [
    GetPage(
      name: AppRoutes.welcome,
      page: () => WelcomeScreen(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(), // You'll need to create this
    ),
    GetPage(
      name: AppRoutes.home,
      page: () {
        Get.put(ProfileController());
        return HomeScreen();
      },
    ),
    GetPage(
      name: AppRoutes.main,
      page: () {
        Get.put(ProfileController());
        return MainLayout();
      },
    ),
    GetPage(
      name: AppRoutes.chatbot,
      page: () => ChatbotView(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsView(),
    ),
    // Add more GetPages here as you create more screens
    // GetPage(
    //   name: AppRoutes.transactions,
    //   page: () => TransactionsView(),
    // ),
    // GetPage(
    //   name: AppRoutes.analytics,
    //   page: () => AnalyticsView(),
    // ),
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => ProfileView(),
    // ),
  ];
}
