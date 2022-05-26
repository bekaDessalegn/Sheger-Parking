import 'package:sheger_parking/pages/SplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//public server url - https://api-shegerparking.loca.lt
//online server url - https://shegerparking.herokuapp.com
//local server url - http://10.5.197.136:5000

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
      home : SplashScreen(),
    );
  }
}
