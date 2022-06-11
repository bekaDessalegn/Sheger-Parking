
import 'package:awesome_notifications/awesome_notifications.dart';

import '../constants/uniqueId.dart';

Future<void> createNotification(String branchName) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: 'Sheger Parking',
      body: 'Your reservation at branch $branchName is expiring in 10 minutes',
      notificationLayout: NotificationLayout.BigText
      // bigPicture: 'asset://assets/notification_map.png',
      // notificationLayout: NotificationLayout.BigPicture,
    ),
  );
}