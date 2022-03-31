// ignore: file_names
// ignore_for_file: file_names

import 'package:ehet_alem/pages/HomePage.dart';
import 'package:ehet_alem/pages/LoginPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _secureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Col.background,
      body:ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
            child: Text(Strings.app_title,
              style: TextStyle(
                color: Col.primary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
                letterSpacing: 0.3,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Text("PARKING",
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Nunito',
                letterSpacing: 0.3,
              ),
            ),
          ),
          Container(
            color: Col.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Text(Strings.signup,
                    style: TextStyle(
                      color: Col.Onbackground,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(25, 50, 0, 0),
                  child: Container(
                    width: 300,
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "",
                        hintStyle: TextStyle(
                          color: Col.textfieldLabel,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          letterSpacing: 0.1,
                        ),
                        labelText: "Full Name",
                        labelStyle: TextStyle(
                          color: Col.textfieldLabel,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          letterSpacing: 0,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                  child: Container(
                    width: 300,
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "",
                        hintStyle: TextStyle(
                          color: Col.textfieldLabel,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          letterSpacing: 0.1,
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          color: Col.textfieldLabel,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          letterSpacing: 0,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                  child: Container(
                    width: 300,
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "",
                        hintStyle: TextStyle(
                          color: Col.textfieldLabel,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          letterSpacing: 0.1,
                        ),
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                          color: Col.textfieldLabel,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          letterSpacing: 0,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                  child: Container(
                    width: 300,
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "",
                        hintStyle: TextStyle(
                          color: Col.textfieldLabel,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          letterSpacing: 0.1,
                        ),
                        labelText: "Plate Number",
                        labelStyle: TextStyle(
                          color: Col.textfieldLabel,
                          fontSize: 14,
                          fontFamily: 'Nunito',
                          letterSpacing: 0,
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                  child: Container(
                    width: 300,
                    alignment: Alignment.center,
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Col.textfieldLabel,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            letterSpacing: 0.1,
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Col.textfieldLabel,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            letterSpacing: 0,
                          ),
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(onPressed: () {
                            setState(() {
                              _secureText = !_secureText;
                            });
                          },
                            icon: Icon(_secureText == true ? Icons.visibility : Icons.visibility_off),
                          )
                      ),
                      obscureText: _secureText,
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(25, 50, 0, 0),
                  child: Container(
                    width: 300,
                    child: RaisedButton(
                      color: Col.primary,
                      child: Text("Register",
                        style: TextStyle(
                          color: Col.Onprimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                          letterSpacing: 0.3,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                      },
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(25, 20, 0, 40),
                  child: Container(
                    width: 300,
                    child:Center(child:
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              style: TextStyle(
                                color: Col.Onbackground,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                              text: "Already have an account?"
                          ),
                          TextSpan(
                              style: TextStyle(
                                color: Col.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                              text: " Login",
                              recognizer: TapGestureRecognizer()..onTap = (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                              }
                          ),
                        ],
                      ),
                    ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],

      ),
    );
  }
}
