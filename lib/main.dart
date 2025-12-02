import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Иницијализирај нотификации (локалните нотификации работат без Firebase)
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  // Закажи дневна нотификација
  await notificationService.scheduleDailyRecipeNotification();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const CategoriesScreen(),
    );
  }
}
