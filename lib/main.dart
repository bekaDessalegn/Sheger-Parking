import 'package:sheger_parking/pages/BranchesPage.dart';
import 'package:sheger_parking/pages/EditProfile.dart';
import 'package:sheger_parking/pages/EditReservation.dart';
import 'package:sheger_parking/pages/HomePage.dart';
import 'package:sheger_parking/pages/LoginPage.dart';
import 'package:sheger_parking/pages/ProfilePage.dart';
import 'package:sheger_parking/pages/ReservationDetailsPage.dart';
import 'package:sheger_parking/pages/ReservationPage.dart';
import 'package:sheger_parking/pages/SignUpPage.dart';
import 'package:sheger_parking/pages/StartUpPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersive,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sheger Parking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/' : (context) => const StartUp(),
      },
    );
  }
}
