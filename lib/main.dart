import 'package:cashflow/app/modules/home/home_view.dart';
import 'package:cashflow/app/data/services/init_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/main/main_layout.dart';
import 'app/routes/app_routes.dart';
import 'app/routes/app_pages.dart';

// Import other screens as needed

class MainNavigationController extends GetxController {
  var selectedIndex = 0.obs;

  void onTabTapped(int index) {
    selectedIndex.value = index;
  }
}

class MainNavigationView extends StatelessWidget {
  MainNavigationView({Key? key}) : super(key: key);

  final MainNavigationController controller = Get.put(
    MainNavigationController(),
  );

  final List<Widget> pages = [
    HomeScreen(),
    // Add your other screens here, e.g.:
    // TransactionsScreen(),
    // AnalyticsScreen(),
    // ProfileScreen(),
    Center(child: Text('Other Tab')), // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.onTabTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Transactions',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  final initService = InitService();
  await initService.initializePreferences();
  final initialRoute = await initService.getInitialRoute();
  
  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Cash Flow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}
