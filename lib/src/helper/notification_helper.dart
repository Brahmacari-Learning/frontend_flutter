import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init(
    void Function(NotificationResponse) onDidReceiveNotificationResponse,
  ) async {
    const androidInitializationSettings =
        AndroidInitializationSettings('vedanta_logo');
    const iOSInitializationSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await _notification.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);

    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    await _checkAndRequestNotificationPermission();
  }

  static Future<void> _checkAndRequestNotificationPermission() async {
    if (Platform.isAndroid || Platform.isIOS) {
      if (await Permission.notification.isDenied) {
        await Permission.notification.request();
      }
    }
  }

  static scheduleNotification(
    String title,
    String body,
    DateTime scheduledDateTime,
    int idDoa,
    int idNotification,
  ) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      scheduledDateTime.year,
      scheduledDateTime.month,
      scheduledDateTime.day,
      scheduledDateTime.hour,
      scheduledDateTime.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    var androidDetails = const AndroidNotificationDetails(
        'important_notification', 'My Channel',
        importance: Importance.max,
        priority: Priority.max,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction('lihat', 'Lihat', showsUserInterface: true)
        ],
        playSound: true,
        sound: RawResourceAndroidNotificationSound('test_alarm'));

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notification.zonedSchedule(
      idNotification,
      title,
      body,
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: idDoa.toString(),
    );
  }

  // cancel notification
  static cancel(int id) async {
    await _notification.cancel(id);
  }
}
