
import 'package:cashflow/app/data/services/init_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';





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
