// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheger_parking/pages/HomePage.dart';
import 'package:sheger_parking/pages/StartUpPage.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  String? finalEmail;
  late String id, fullName, phone, email, passwordHash, defaultPlateNumber;

  Future getValidationData() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedId = sharedPreferences.getString("id");
    var obtainedFullName = sharedPreferences.getString("fullName");
    var obtainedPhone = sharedPreferences.getString("phone");
    var obtainedEmail = sharedPreferences.getString("email");
    var obtainedPasswordHash = sharedPreferences.getString("passwordHash");
    var obtainedDefaultPlateNumber = sharedPreferences.getString("defaultPlateNumber");
    setState(() {
      finalEmail = obtainedEmail;
      id = obtainedId.toString();
      fullName = obtainedFullName.toString();
      phone = obtainedPhone.toString();
      email = obtainedEmail.toString();
      passwordHash = obtainedPasswordHash.toString();
      defaultPlateNumber = obtainedDefaultPlateNumber.toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getValidationData().whenComplete(() async {
      Timer(Duration(seconds: 3),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) =>
                  finalEmail == null ? StartUp() : HomePage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber)
              )
          )
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
          color: Colors.white,
      child: Center(
          child: Column(
            children:[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: Text(
                    Strings.app_title,
                    style: TextStyle(
                      color: Col.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Text(
                  "PARKING",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
            ]
          )
      ),
    );
  }
}
