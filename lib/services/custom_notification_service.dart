import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notification = FlutterLocalNotificationsPlugin();

class CustomNotificationService{

  Future<void> initializeTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> initializeNotification() async{
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    await notification.initialize(initializationSettings);
  }

  Future<bool> addNotification({
    // required DateTime alarmTime,
    required String alarmTimeStr,

    required int medicineId,

    required String title,
    required String body,
  }) async {
    //if false?
    if( !await permissionNotification){
      // show native setting page
      return false;
    }

    // exception
    final now = tz.TZDateTime.now(tz.local);

    final alarmTime = DateFormat('HH:mm').parse(alarmTimeStr);

    // 이전 날짜는 예약되지않게
    final day = (alarmTime.hour < now.hour ||
        alarmTime.hour == now.hour && alarmTime.minute <= now.minute)
        ? now.day + 1 : now.day;

    // id casting
    String alarmTimeId = alarmTimeStr.replaceAll(':', '');
    alarmTimeId = medicineId.toString() + alarmTimeId; // 1 + 08:00 => 10800

    // add schedule notification, id value is must be unique
    final details = _notificationDetails(alarmTimeId, title : title, body: body);

    await notification.zonedSchedule(int.parse(alarmTimeId), title, body, tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      day,
      alarmTime.hour,
      alarmTime.minute,
    ), details,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time);

      return true;
  }

  NotificationDetails _notificationDetails(String id, { required String title, required String body}){
    final android = AndroidNotificationDetails(
        id, title, channelDescription: body, importance: Importance.max, priority: Priority.max);

    const ios = IOSNotificationDetails();

    return NotificationDetails(android: android, iOS: ios);
  }

  Future<bool> get permissionNotification async {
    if(Platform.isAndroid){
      return true;
    }
    if(Platform.isIOS){
      return await notification.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }
    // android iOS 둘다 아닐경우 false
    return false;
  }
}

