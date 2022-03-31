// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'package:ehet_alem/pages/EditProfile.dart';
import 'package:ehet_alem/pages/StartUpPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Col.background,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        toolbarHeight: 70,
        leading: IconButton(
          color: Col.Onbackground,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [IconButton(
            color: Col.Onbackground,
            padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
            iconSize: 40,
            onPressed: (){
              showDialog(context: context, builder: (context) {
              return AlertDialog(
                title: Text("Ehet Alem",
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
                content: Text("Do you want to Log out",
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 20,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
                actions: [
                  FlatButton(onPressed: (){
                    Navigator.of(context).pop(AlertDialog());
                  }, child: Text("Cancel",
                    style: TextStyle(
                      fontSize: 18,
                      letterSpacing: 0.3,
                    ),
                  ),
                  ),
                  FlatButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => StartUp()));
                  }, child: Text("Log out",
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
        title: Text(Strings.app_title,
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
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
            gradient: LinearGradient(
                colors: [Col.secondary,Col.secondary],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter
            ),
          ),
        ),
      ),
      body:Stack(
        fit: StackFit.expand,
        children: <Widget>[Container(
          color: Col.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                  child: Text("Profile",
                    style: TextStyle(
                      color: Col.Onbackground,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.1,
                    ),
                  ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: Text("Full Name",
                  style: TextStyle(
                    color: Col.Onsurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text("Beka Dessalegn",
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
              Padding(padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text("Email",
                  style: TextStyle(
                    color: Col.Onsurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text("bekadessu@gmail.com",
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
              Padding(padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text("Phone Number",
                  style: TextStyle(
                    color: Col.Onsurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text("+251978061901",
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
              Padding(padding: EdgeInsets.fromLTRB(30, 5, 0, 0),
                child: Text("Plate Number",
                  style: TextStyle(
                    color: Col.Onsurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Text("254867",
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage()));
        },
        backgroundColor: Col.primary,
        child: Icon(
          Icons.edit,
        color: Col.Onbackground,),
      ),
    );
  }
}
