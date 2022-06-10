
import 'package:awesome_notifications/awesome_notifications.dart';

import '../constants/uniqueId.dart';

Future<void> createNotification() async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title:
      'Sheger Parking',
      body: 'Your reservation is about to expire in 10 minutes so please go and get your fucking car out of this place',
      // bigPicture: 'asset://assets/notification_map.png',
      // notificationLayout: NotificationLayout.BigPicture,
    ),
  );
}