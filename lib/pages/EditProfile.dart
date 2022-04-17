// ignore: file_names
// ignore_for_file: file_names

import 'package:sheger_parking/pages/StartUpPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Col.background,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 8,
        toolbarHeight: 70,
        leading: IconButton(
          color: Col.Onbackground,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
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
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)),
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
                  "Edit Profile",
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
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Full Name",
                      labelStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                        color: Col.textfieldLabel,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "FirstName LastName",
                      hintStyle: TextStyle(
                        fontSize: 21,
                        fontFamily: "Nunito",
                        letterSpacing: 0.1,
                        color: Col.Onbackground,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 25, 0, 0),
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                        color: Col.textfieldLabel,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "exapmle@gmail.com",
                      hintStyle: TextStyle(
                        fontSize: 21,
                        fontFamily: "Nunito",
                        letterSpacing: 0.1,
                        color: Col.Onbackground,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 25, 0, 0),
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Phone Number",
                      labelStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                        color: Col.textfieldLabel,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "+251900000000",
                      hintStyle: TextStyle(
                        fontSize: 21,
                        fontFamily: "Nunito",
                        letterSpacing: 0.1,
                        color: Col.Onbackground,
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 25, 0, 0),
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 3),
                      labelText: "Plate Number",
                      labelStyle: TextStyle(
                        fontSize: 17,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                        color: Col.textfieldLabel,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "254867",
                      hintStyle: TextStyle(
                        fontSize: 21,
                        fontFamily: "Nunito",
                        letterSpacing: 0.1,
                        color: Col.Onbackground,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Col.primary,
        child: Icon(
          Icons.check,
          color: Col.Onbackground,
        ),
      ),
    );
  }
}
