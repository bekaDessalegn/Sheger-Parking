// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheger_parking/pages/EditProfile.dart';
import 'package:sheger_parking/pages/HomePage.dart';
import 'package:sheger_parking/pages/StartUpPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';

class ProfilePage extends StatefulWidget {

  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  ProfilePage({required this.id, required this.fullName, required this.phone, required this.email, required this.passwordHash, required this.defaultPlateNumber});

  @override
  _ProfilePageState createState() => _ProfilePageState(id, fullName, phone, email, passwordHash, defaultPlateNumber);
}

class _ProfilePageState extends State<ProfilePage> {

  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  _ProfilePageState(this.id, this.fullName, this.phone, this.email, this.passwordHash, this.defaultPlateNumber);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Col.background,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 4.0,
        toolbarHeight: 70,
        leading: IconButton(
          color: Col.Onbackground,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber)));
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              color: Col.Onbackground,
              padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
              iconSize: 40,
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
                              final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                              sharedPreferences.remove("email");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StartUp()));
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
              icon: Icon(Icons.logout)),
        ],
        title: Text(
          Strings.app_title,
          style: TextStyle(
            color: Col.Onsurface,
            fontSize: 28,
            fontWeight: FontWeight.bold,
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
                colors: [Col.secondary, Col.secondary],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Col.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: Text(
                  "Profile",
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: Text(
                  "Full Name",
                  style: TextStyle(
                    color: Col.Onsurface,
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
                    color: Col.Onbackground,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Divider(
                color: Col.Onbackground,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Email",
                  style: TextStyle(
                    color: Col.Onsurface,
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
                    color: Col.Onbackground,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Divider(
                color: Col.Onbackground,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Phone Number",
                  style: TextStyle(
                    color: Col.Onsurface,
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
                    color: Col.Onbackground,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Divider(
                color: Col.Onbackground,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text(
                  "Plate Number",
                  style: TextStyle(
                    color: Col.Onsurface,
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
                    color: Col.Onbackground,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Divider(
                color: Col.Onbackground,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditProfilePage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber)));
        },
        backgroundColor: Col.primary,
        child: Icon(
          Icons.edit,
          color: Col.Onbackground,
        ),
      ),
    );
  }

  // Widget clientFullName(List<User> users){
  //   final user = users[0];
  //   return Text(
  //       user.fullName,
  //       style: TextStyle(
  //         color: Col.Onbackground,
  //         fontSize: 22,
  //         fontWeight: FontWeight.bold,
  //         fontFamily: 'Nunito',
  //         letterSpacing: 0.3,
  //       ),
  //     );
  // }
}
