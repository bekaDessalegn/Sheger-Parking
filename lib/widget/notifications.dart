
import 'package:awesome_notifications/awesome_notifications.dart';

import '../constants/uniqueId.dart';

Future<void> createNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: 'Sheger Parking',
      body: 'Your reservation at branch branch name is expiring in 10 minutes',
      // bigPicture: 'asset://assets/notification_map.png',
      // notificationLayout: NotificationLayout.BigPicture,
    ),
  );
}