import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sheger_parking/constants/strings.dart';
import 'package:sheger_parking/pages/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheger_parking/widget/notifications.dart';
import 'package:sheger_parking/pages/Reservations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersive,
  );
  AwesomeNotifications().initialize(
    'resource://drawable/ic_launcher',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        channelDescription: '',
      ),
    ],
  );
  runApp(MyApp());
}

Future getCurrentLocation() async {
  var position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  Strings.lat = position.latitude;
  Strings.longs = position.longitude;
}
Future fetchToNotify() async{
  List<String> notified = [];
  while (true) {
    if(Strings.userId != false){
    final reservationDetails = await ReservationsState.getReservationDetails();
    reservationDetails.forEach((element) {
      var startTimeInM = element.startingTime / 60000;
      var durationInM = element.duration * 60;
      var endTimeInM = startTimeInM + durationInM;
      var currentTimestampInM = DateTime.now().millisecondsSinceEpoch / 60000;
      var minutesLeft = endTimeInM - currentTimestampInM;
      if (minutesLeft>=0 && minutesLeft <= 10 && !notified.contains(element.id)) {
        notified.add(element.id);
        createNotification(element.branchName);
      }
    });
    }
    await Future.delayed(Duration(seconds: 10));
  }
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    fetchToNotify();
    getCurrentLocation();
    return MaterialApp(
      title: 'Sheger Parking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
