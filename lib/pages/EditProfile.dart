// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'dart:convert';

import 'package:sheger_parking/pages/ProfilePage.dart';
import 'package:sheger_parking/pages/StartUpPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditProfilePage extends StatefulWidget {

  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  EditProfilePage({required this.id, required this.fullName, required this.phone, required this.email, required this.passwordHash, required this.defaultPlateNumber});

  @override
  _EditProfilePageState createState() => _EditProfilePageState(id, fullName, phone, email, passwordHash, defaultPlateNumber);
}

class _EditProfilePageState extends State<EditProfilePage> {

  String id, fullName, phone, email, passwordHash, defaultPlateNumber;
  _EditProfilePageState(this.id, this.fullName, this.phone, this.email, this.passwordHash, this.defaultPlateNumber);

  final _formKey = GlobalKey<FormState>();

  Future edit() async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('http://10.4.109.57:5000/token:qwhu67fv56frt5drfx45e/clients/${id}');

    var body = {
      "fullName": fullName,
      "phone": phone,
      "email": email,
      "defaultPlateNumber": defaultPlateNumber
    };
    var req = http.Request('PATCH', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber)));
      print(resBody);
    }
    else {
      print(res.reasonPhrase);
    }
  }

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
          child: Form(
            key: _formKey,
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
                  padding: EdgeInsets.fromLTRB(25, 60, 25, 0),
                  child: Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: TextEditingController(text: fullName),
                      onChanged: (value){
                        fullName = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field can not be empty";
                        }
                        else {
                          return null;
                        }
                      },
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
                          hintText: fullName,
                          hintStyle: TextStyle(
                            fontSize: 21,
                            fontFamily: "Nunito",
                            letterSpacing: 0.1,
                            color: Col.Onbackground,
                          )
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 30, 25, 0),
                  child: Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: TextEditingController(text: email),
                      onChanged: (value){
                        email = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field can not be empty";
                        } else if (RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value)) {
                          return null;
                        } else {
                          return "Please enter valid email";
                        }
                      },
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
                          hintText: email,
                          hintStyle: TextStyle(
                            fontSize: 21,
                            fontFamily: "Nunito",
                            letterSpacing: 0.1,
                            color: Col.Onbackground,
                          )
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 30, 25, 0),
                  child: Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: TextEditingController(text: phone),
                      onChanged: (value){
                        phone = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field can not be empty";
                        }
                        else {
                          return null;
                        }
                      },
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
                          hintText: phone,
                          hintStyle: TextStyle(
                            fontSize: 21,
                            fontFamily: "Nunito",
                            letterSpacing: 0.1,
                            color: Col.Onbackground,
                          )
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 30, 25, 0),
                  child: Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: TextEditingController(text: defaultPlateNumber),
                      onChanged: (value){
                        defaultPlateNumber = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "This field can not be empty";
                        }
                        else {
                          return null;
                        }
                      },
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
                          hintText: defaultPlateNumber,
                          hintStyle: TextStyle(
                            fontSize: 21,
                            fontFamily: "Nunito",
                            letterSpacing: 0.1,
                            color: Col.Onbackground,
                          )
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            edit();
          }
        },
        backgroundColor: Col.primary,
        child: Icon(
          Icons.check,
          color: Col.Onbackground,
        ),
      ),
    );
  }
}
