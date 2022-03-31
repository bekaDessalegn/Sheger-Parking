// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'package:ehet_alem/pages/HomePage.dart';
import 'package:ehet_alem/pages/SignUpPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool _secureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Col.background,
      body:Stack(
        fit: StackFit.expand,
        children: <Widget>[Container(
          color: Col.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 40, 0, 0),
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
              Padding(padding: EdgeInsets.fromLTRB(15, 40, 0, 0),
                child: Text(Strings.login,
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(25, 60, 0, 0),
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "name@example.com",
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
              Padding(padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
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
              Padding(padding: EdgeInsets.fromLTRB(25, 75, 0, 0),
                child: Container(
                  width: 300,
                  child: RaisedButton(
                    color: Col.primary,
                    child: Text("Login",
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
              Padding(padding: EdgeInsets.fromLTRB(25, 10, 0, 0),
                child: Container(
                  width: 300,
                  child: TextButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          title: Text("Forgot Password ?",
                            style: TextStyle(
                              color: Col.Onbackground,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              letterSpacing: 0.3,
                            ),
                          ),
                          content: TextField(
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
                          actions: [
                            FlatButton(onPressed: (){
                              Navigator.of(context).pop(AlertDialog());
                            }, child: Text("Submit",
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 0.3,
                              ),
                            ),
                            ),
                          ],
                          elevation: 24.0,
                        );
                      });
                    },
                    child: Text("Forgot password",
                      style: TextStyle(
                        color: Col.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                ),
                  ),
              ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(25, 80, 0, 0),
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
                            text: "Don’t have an account?"
                          ),
                          TextSpan(
                              style: TextStyle(
                                color: Col.primary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.3,
                              ),
                              text: " SignUp",
                              recognizer: TapGestureRecognizer()..onTap = (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
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
