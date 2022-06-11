// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors, unnecessary_null_comparison

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sheger_parking/bloc/home_bloc.dart';
import 'package:sheger_parking/constants/api.dart';
import 'package:sheger_parking/models/User.dart';
import 'package:sheger_parking/pages/HomePage.dart';
import 'package:sheger_parking/pages/LoginPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/colors.dart';
import '../constants/strings.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _secureText = true;
  bool isDataEntered = false;
  bool isProcessing = false;
  late String verificationCode;
  String? hashedPassword;

  Future verify() async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${base_url}/clients/signup');

    var body = {
      "fullName": user.fullName,
      "phone": user.phone,
      "email": user.email,
      "passwordHash": hashedPassword,
      "defaultPlateNumber": user.defaultPlateNumber
    };

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      var verificationCode = json.decode(resBody);
      print(verificationCode["emailVerificationCode"]);
      this.verificationCode = verificationCode["emailVerificationCode"].toString();
      setState(() {
        isDataEntered = !isDataEntered;
      });
      print(resBody);
    }
    else {
      print(res.reasonPhrase);
    }
  }

  Future save() async {
    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json'
    };
    var url = Uri.parse('${base_url}/clients');

    var body = {
      "fullName": user.fullName,
      "phone": user.phone,
      "email": user.email,
      "passwordHash": hashedPassword,
      "defaultPlateNumber": user.defaultPlateNumber
    };
    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();
    final resBody = await res.stream.bytesToString();

    if (res.statusCode >= 200 && res.statusCode < 300) {
      var data = json.decode(resBody);
      String id = data["id"].toString();
      String fullName = data["fullName"].toString();
      String phone = data["phone"].toString();
      String email = data["email"].toString();
      String passwordHash = data["passwordHash"].toString();
      String defaultPlateNumber = data["defaultPlateNumber"].toString();
      Strings.userId = id;

      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString("id", id);
      sharedPreferences.setString("fullName", fullName);
      sharedPreferences.setString("phone", phone);
      sharedPreferences.setString("email", email);
      sharedPreferences.setString("passwordHash", passwordHash);
      sharedPreferences.setString("defaultPlateNumber", defaultPlateNumber);
      print(resBody);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BlocProvider(
          create: (context) => CurrentIndexBloc(),
          child: HomePage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber))));
    }
    else {
      print(res.reasonPhrase);
      print(resBody);
    }
  }

  User user = User('', '', '', '', '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Col.background,
      body: ListView(
        children: [
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
          Container(
            color: Col.background,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 35, 0, 0),
                    child: Text(
                      Strings.signup,
                      style: TextStyle(
                        color: Col.Onbackground,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: TextEditingController(text: user.fullName),
                        onChanged: (value){
                          user.fullName = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field can not be empty";
                          }
                          return null;
                        },
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
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: TextEditingController(text: user.email),
                        onChanged: (value){
                          user.email = value;
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
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
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
                          else if (RegExp(
                              r"^(?:[+0]9)?[0-9]{10}$")
                              .hasMatch(value)) {
                            return null;
                          }
                          else {
                            return "Please enter valid phone number";
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Format: 0987654321",
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
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: TextEditingController(text: user.defaultPlateNumber),
                        onChanged: (value){
                          user.defaultPlateNumber = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field can not be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "",
                          hintStyle: TextStyle(
                            color: Col.textfieldLabel,
                            fontSize: 14,
                            fontFamily: 'Nunito',
                            letterSpacing: 0.1,
                          ),
                          labelText: "Default Plate Number",
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
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        controller: TextEditingController(text: user.passwordHash),
                        onChanged: (value){
                          var bytes = utf8.encode(value);
                          var sha512 = sha256.convert(bytes);
                          var hashedPassword = sha512.toString();
                          this.hashedPassword = hashedPassword;
                          user.passwordHash = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field can not be empty";
                          } else if (value.length < 6) {
                            return "Password should be at least 6 characters";
                          }
                          return null;
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
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
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
                  isProcessing
                      ? Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Col.primary,
                        strokeWidth: 2,
                      ),
                    ),
                  )
                      : isDataEntered
                      ? Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                    child: Column(
                      children: [
                        Text(
                          "Verification code has been sent to your email",
                          style: TextStyle(
                            color: Col.Onbackground,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito',
                            letterSpacing: 0.1,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This field can not be empty";
                              }else if(value != verificationCode){
                                return "Please enter the correct verification code";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "",
                              hintStyle: TextStyle(
                                color: Col.textfieldLabel,
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.1,
                              ),
                              labelText: "Verification Code",
                              labelStyle: TextStyle(
                                color: Col.textfieldLabel,
                                fontSize: 14,
                                fontFamily: 'Nunito',
                                letterSpacing: 0,
                              ),
                              border: OutlineInputBorder(),
                              errorBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.red),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  )
                      : Text(""),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                    child: Container(
                      width: double.infinity,
                      child: isDataEntered ? RaisedButton(
                        color: Col.primary,
                        child: Text(
                          "Verify",
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
                            // setState(() {
                            //   isProcessing = true;
                            // });
                          } else {
                            print("Enter fields");
                          }
                          // Future.delayed(Duration(seconds: 6), () {
                          //   setState(() {
                          //     isProcessing = false;
                          //   });
                          // });
                        },
                      ) : RaisedButton(
                      color: Col.primary,
                      child: Text(
                        "Sign up",
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
                          verify();
                          // setState(() {
                          //   isDataEntered = !isDataEntered;
                          // });
                          setState(() {
                            isProcessing = true;
                          });
                          // if (!isDataEntered) {
                          //   save();
                          // }
                        } else {
                          print("Enter fields");
                        }
                        Future.delayed(Duration(seconds: 6), () {
                          setState(() {
                            isProcessing = false;
                          });
                        });
                      },
                    ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 10, 25, 40),
                    child: Container(
                      width: double.infinity,
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  style: TextStyle(
                                    color: Col.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                    letterSpacing: 0.3,
                                  ),
                                  text: "Already have an account?"),
                              TextSpan(
                                  style: TextStyle(
                                    color: Col.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                    letterSpacing: 0.3,
                                  ),
                                  text: " Sign in",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginPage()));
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
        ],
      ),
    );
  }
}
