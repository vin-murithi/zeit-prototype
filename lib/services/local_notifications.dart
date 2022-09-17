import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  //1. Create an instance of the notification plugin
  static final _localNotifications = FlutterLocalNotificationsPlugin();

  //2. Initialize settings to provide to the notification service.
  Future<void> initialize() async {
    //2.1. Create android initialization object
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('mipmap/ic_launcher');

    //2.2. Create iOS initialization object
    IOSInitializationSettings iOSInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          onDidReceiveLocalNotification, //When notification received
    );

    //2.3. Create InitializationSettings object
    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    //2.4. Initialize the notification plugin using settings object
    await _localNotifications.initialize(settings,
        onSelectNotification:
            onSelectNotification //When notification is selected
        );
  }

  //3. Create callback methods for receiving and selecting notifications

  //3.2. Callback for received notification
  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  //3.2. Callback for selected notification
  void onSelectNotification(String? payload) {
    if (payload != null) {
      print('payload: $payload');
    }
  }

  //4. Create notification details object that defines notifications for both android and iOS
  Future<NotificationDetails> _notificationDetails() async {
    //For androind 6 params
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: false,
    );
    // For iOS
    const IOSNotificationDetails iOSNotificationDetails =
        IOSNotificationDetails();

    //Return NotificationDetails for both in one object
    return const NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);
  }

  //5. Create method that displays the actuall notification
  Future<void> showLocalNotification({
    int id = 0,
    required String title,
    required String body,
    String? payload,
  }) async {
    //Initialize settings
    await initialize();
    //Get Notification details
    final notificationDetails = await _notificationDetails();
    //Show the notification using the LocalNotificationPlugin object
    await _localNotifications.show(id, title, body, notificationDetails,
        payload: payload);
  }
}
