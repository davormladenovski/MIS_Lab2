import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as _tz;
import 'package:timezone/data/latest_all.dart' as _tz_data;
import 'dart:math';
import 'meal_service.dart';
import 'favorites_service.dart';

// Firebase imports - опционални (може да се додадат подоцна)
// Локалните нотификации работат без Firebase

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final MealService _mealService = MealService();

  bool _initialized = false;

  // Иницијализирај ги нотификациите
  Future<void> initialize() async {
    if (_initialized) return;

    // Иницијализирај локални нотификации
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Прашај за дозвола за нотификации
    await _requestPermissions();

    // Забелешка: Firebase Messaging може да се додаде подоцна
    // Локалните нотификации работат без Firebase

    _initialized = true;
  }

  // Прашај за дозвола за нотификации
  Future<void> _requestPermissions() async {
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'channel_id',
            'Recipe Notifications',
            description: 'Notifications for daily recipe reminders',
            importance: Importance.high,
          ),
        );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }


  // Обработи клик на локална нотификација
  void _onNotificationTapped(NotificationResponse response) {
    // Може да се додаде навигација до рецепт
  }

  // Прикажи локална нотификација
  Future<void> _showLocalNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'Recipe Notifications',
      channelDescription: 'Notifications for daily recipe reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      Random().nextInt(1000),
      title,
      body,
      details,
    );
  }

  // Закажи дневна нотификација за рандом рецепт
  Future<void> scheduleDailyRecipeNotification() async {
    try {
      // Иницијализирај timezone data
      try {
        _tz_data.initializeTimeZones();
      } catch (e) {
        // Ако веќе е иницијализирано, продолжи
      }
      
      final location = _tz.getLocation('Europe/Skopje');
      
      // Закажи нотификација за 18:00 секој ден
      final now = _tz.TZDateTime.now(location);
      var scheduledTime = _tz.TZDateTime(
        location,
        now.year,
        now.month,
        now.day,
        18,
        0,
      );

      // Ако е веќе поминато денес, закажи за утре
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }

      // Земи рандом рецепт
      try {
        final recipe = await _mealService.getRandomRecipe();
        
        await _localNotifications.zonedSchedule(
          Random().nextInt(1000),
          'Рецепт на денот! 🍽️',
          'Денес ви препорачуваме: ${recipe.strMeal}',
          scheduledTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'Recipe Notifications',
              channelDescription: 'Notifications for daily recipe reminders',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      } catch (e) {
        // Ако не успее да се земе рецепт, прикажи општа нотификација
        await _localNotifications.zonedSchedule(
          Random().nextInt(1000),
          'Рецепт на денот! 🍽️',
          'Отворете ја апликацијата за да видите рандом рецепт',
          scheduledTime,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id',
              'Recipe Notifications',
              channelDescription: 'Notifications for daily recipe reminders',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    } catch (e) {
      // Ако не успее да се закаже нотификација, игнорирај ја грешката
      debugPrint('Failed to schedule notification: $e');
    }
  }

  // Прикажи нотификација веднаш (за тестирање)
  Future<void> showTestNotification() async {
    await _showLocalNotification(
      title: 'Тест нотификација',
      body: 'Ова е тест нотификација',
    );
  }

  // Прикажи дневна нотификација со рандом рецепт (за тестирање)
  Future<void> showDailyRecipeNotification(String recipeName) async {
    await _showLocalNotification(
      title: 'Рецепт на денот! 🍽️',
      body: 'Денес ви препорачуваме: $recipeName',
    );
  }
}

