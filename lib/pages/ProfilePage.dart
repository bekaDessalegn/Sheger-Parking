// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheger_parking/bloc/home_bloc.dart';
import 'package:sheger_parking/pages/EditProfile.dart';
import 'package:sheger_parking/pages/HomePage.dart';
import 'package:sheger_parking/pages/StartUpPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/api.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';

class ProfilePage extends StatefulWidget {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;

  ProfilePage(
      {required this.id,
      required this.fullName,
      required this.phone,
      required this.email,
      required this.passwordHash,
      required this.defaultPlateNumber});

  @override
  _ProfilePageState createState() => _ProfilePageState(
      id, fullName, phone, email, passwordHash, defaultPlateNumber);
}

class _ProfilePageState extends State<ProfilePage> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;

  _ProfilePageState(this.id, this.fullName, this.phone, this.email,
      this.passwordHash, this.defaultPlateNumber);

  Future deleteUser() async {
    var headersList = {
      'Accept': '*/*',
    };
    var url = Uri.parse('$base_url/clients/$id');

    var req = http.Request('DELETE', url);
    req.headers.addAll(headersList);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.remove("email");
      Strings.userId = false;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => StartUp()),
          (Route<dynamic> route) => false);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Col.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 1.0),
              blurRadius: 7.0,
            )
          ]),
          child: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            toolbarHeight: 60,
            leading: IconButton(
              color: Col.Onbackground,
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                            create: (context) => CurrentIndexBloc(),
                            child: HomePage(
                                id: id,
                                fullName: fullName,
                                phone: phone,
                                email: email,
                                passwordHash: passwordHash,
                                defaultPlateNumber: defaultPlateNumber))),
                    (Route<dynamic> route) => false);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              "Profile",
              style: TextStyle(
                color: Col.blackColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Nunito',
                letterSpacing: 0.3,
              ),
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0)),
                gradient: LinearGradient(
                    colors: [Colors.white, Colors.white],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Col.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Center(
                child: Icon(
                  Icons.person_outline,
                  size: 110,
                  color: Col.blackColor,
                ),
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: Divider(
                    color: Col.primary,
                    thickness: 1.4,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Full Name",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  fullName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Email",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  email,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Phone Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  phone,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Plate Number",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text(
                  defaultPlateNumber,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  child: Divider(
                    color: Col.primary,
                    thickness: 1.4,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                child: Text(
                  "Actions",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 5, 0, 0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                                id: id,
                                fullName: fullName,
                                phone: phone,
                                email: email,
                                passwordHash: passwordHash,
                                defaultPlateNumber: defaultPlateNumber)));
                  },
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  child: Text(
                    "Edit profile",
                    style: TextStyle(
                      color: Col.linkColor,
                      fontSize: 18,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Sheger Parking",
                              style: TextStyle(
                                color: Col.Onbackground,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                            ),
                            content: Text(
                              "Do you want to Log out",
                              style: TextStyle(
                                color: Col.Onbackground,
                                fontSize: 20,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                            ),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(AlertDialog());
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  final SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  sharedPreferences.remove("email");
                                  Strings.userId = false;
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => StartUp()),
                                      (Route<dynamic> route) => false);
                                },
                                child: Text(
                                  "Log out",
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                            elevation: 10.0,
                          );
                        });
                  },
                  child: Text(
                    "Log out",
                    style: TextStyle(
                      color: Col.linkColor,
                      fontSize: 18,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(40, 0, 0, 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerLeft),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Sheger Parking",
                              style: TextStyle(
                                color: Col.Onbackground,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                            ),
                            content: Text(
                              "Your Account is going to be deleted ?",
                              style: TextStyle(
                                color: Col.Onbackground,
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                            ),
                            actions: [
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop(AlertDialog());
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                              FlatButton(
                                onPressed: () async {
                                  deleteUser();
                                },
                                child: Text(
                                  "Delete account",
                                  style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 0.3,
                                      color: Col.deleteColor),
                                ),
                              ),
                            ],
                            elevation: 10.0,
                          );
                        });
                  },
                  child: Text(
                    "Delete account",
                    style: TextStyle(
                      color: Col.deleteColor,
                      fontSize: 18,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
