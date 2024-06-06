import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final _notification = FlutterLocalNotificationsPlugin();

  static init() async {
    _notification.initialize(const InitializationSettings(
        android: AndroidInitializationSettings('vedanta_logo'),
        iOS: DarwinInitializationSettings()));
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static scheduleNotification(
    String title,
    String body,
    DateTime scheduledDateTime,
    int idDoa,
  ) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
        tz.local,
        scheduledDateTime.year,
        scheduledDateTime.month,
        scheduledDateTime.day,
        scheduledDateTime.hour,
        scheduledDateTime.minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    var androidDetails = const AndroidNotificationDetails(
      'important_notification',
      'My Channel',
      importance: Importance.max,
      priority: Priority.max,
    );

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _notification.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: idDoa.toString(),
    );
  }
}
