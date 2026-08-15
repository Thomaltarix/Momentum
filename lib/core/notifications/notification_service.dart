import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

// Overridden in main() with an already-initialized instance — see the
// `init()` call there. The default here only exists so tests/tools that
// don't override it still get a valid (uninitialized) instance instead of
// a runtime error.
final Provider<NotificationService> notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

// Thin wrapper around the OS notification APIs: init, schedule, cancel.
// No knowledge of routines, streaks, or copy — that logic lives in
// features/routines/data (Phase 2), which calls this.
class NotificationService {
  NotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
    'momentum_routines',
    'Routines',
    channelDescription: 'Scheduled reminders for daily routines',
    importance: Importance.high,
    priority: Priority.high,
  );

  Future<void> init() async {
    tz_data.initializeTimeZones();
    final TimezoneInfo localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone.identifier));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings: settings);
  }

  Future<bool> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final bool? granted =
        await androidPlugin?.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> scheduleDailyAt({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOf(hour, minute),
      notificationDetails: const NotificationDetails(android: _androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id: id);

  Future<void> cancelAll() => _plugin.cancelAll();

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
