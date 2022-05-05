// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:convert';

import 'package:sheger_parking/models/User.dart';
import 'package:sheger_parking/pages/HomePage.dart';
import 'package:sheger_parking/pages/SignUpPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/colors.dart';
import '../constants/strings.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _secureText = true;
  bool isLoading = false;

  String? response;

  final _formKey = GlobalKey<FormState>();

  Future save() async{
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('http://10.4.109.57:5000/token:qwhu67fv56frt5drfx45e/clients/login');

    var body = {
      "phone": user.phone,
      "passwordHash": user.passwordHash
    };
    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    setState(() {
      response = res.reasonPhrase;
    });

    if (res.statusCode >= 200 && res.statusCode < 300) {
      var data = json.decode(resBody);
      String id = data["id"].toString();
      String fullName = data["fullName"].toString();
      String phone = data["phone"].toString();
      String email = data["email"].toString();
      String passwordHash = data["passwordHash"].toString();
      String defaultPlateNumber = data["defaultPlateNumber"].toString();
      // var content = json.decode(resBody);
      // phone = content["phone"].toString();
      // passwordHash = content["passwordHash"].toString();
      print(resBody);
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber)));
    }
    else {
      print(res.reasonPhrase);
    }
  }

  User user = User('', '', '', '', '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Col.background,
      body: SingleChildScrollView(
        child: Container(
          color: Col.background,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 40, 0, 0),
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
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Text(
                    "PARKING",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15, 40, 0, 0),
                  child: Text(
                    Strings.login,
                    style: TextStyle(
                      color: Col.Onbackground,
                      fontSize: 60,
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
                      controller: TextEditingController(text: user.phone),
                      onChanged: (value){
                        user.phone = value;
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
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                  child: Container(
                    alignment: Alignment.center,
                    child: TextFormField(
                      controller: TextEditingController(text: user.passwordHash),
                      onChanged: (value){
                        user.passwordHash = value;
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
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _secureText = !_secureText;
                              });
                            },
                            icon: Icon(
                              _secureText == true
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Col.Onbackground,
                            ),
                          )),
                      obscureText: _secureText,
                    ),
                  ),
                ),
                (response == "Not Found") ?
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 25),
                  child: Text("One of the credentials is incorrect",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                  ),
                  ),
                ) : Text(""),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 65, 25, 0),
                  child: Container(
                    width: double.infinity,
                    child: RaisedButton(
                      color: Col.primary,
                      child: Text(
                        "Login",
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
                        if (_formKey.currentState!.validate()) {
                          save();
                        }
                      }
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                  child: Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Forgot Password ?",
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
                                  FlatButton(
                                    onPressed: () async {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      await Future.delayed(Duration(seconds: 3),
                                          () {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });

                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              child: Container(
                                                height: 200,
                                                child: Padding(
                                                  padding: EdgeInsets.all(12.0),
                                                  child: isLoading
                                                      ? Center(
                                                          child: Container(
                                                            height: 70,
                                                            child: Column(
                                                              children: [
                                                                CircularProgressIndicator(
                                                                  color: Col
                                                                      .primary,
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                                Text(
                                                                    "$isLoading"),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Text(
                                                                "Email Sent",
                                                                style:
                                                                    TextStyle(
                                                                  color: Col
                                                                      .Onbackground,
                                                                  fontSize: 20,
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  letterSpacing:
                                                                      0,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              child: Text(
                                                                "Code has been sent to your email.",
                                                                style:
                                                                    TextStyle(
                                                                  color: Col
                                                                      .textfieldLabel,
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'Nunito',
                                                                  letterSpacing:
                                                                      0,
                                                                ),
                                                              ),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(2),
                                                                child:
                                                                    RaisedButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                  child: Text(
                                                                    "Ok",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Col
                                                                          .Onbackground,
                                                                      fontSize:
                                                                          16,
                                                                      fontFamily:
                                                                          'Nunito',
                                                                      letterSpacing:
                                                                          0,
                                                                    ),
                                                                  ),
                                                                  color: Col
                                                                      .secondary,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ),
                                              ),
                                            );
                                          });
                                    },
                                    child: Text(
                                      "Submit",
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
                      child: Text(
                        "Forgot password",
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
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 50, 25, 0),
                  child: Container(
                    width: double.infinity,
                    child: Center(
                      child: RichText(
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
                                text: "Don’t have an account?"),
                            TextSpan(
                                style: TextStyle(
                                  color: Col.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Nunito',
                                  letterSpacing: 0.3,
                                ),
                                text: " SignUp",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignUpPage()));
                                  }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loading() async {
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }
}
