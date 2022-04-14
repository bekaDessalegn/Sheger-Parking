// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors, unnecessary_null_comparison

import 'package:sheger_parking/models/register_request_model.dart';
import 'package:sheger_parking/pages/HomePage.dart';
import 'package:sheger_parking/pages/LoginPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sheger_parking/services/api_service.dart';

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

  String? fullName;
  String? email;
  String? phoneNumber;
  String? plateNumber;
  String? password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Col.background,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 0, 0),
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
                    padding: EdgeInsets.fromLTRB(15, 20, 0, 0),
                    child: Text(
                      Strings.signup,
                      style: TextStyle(
                        color: Col.Onbackground,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 50, 25, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        onChanged: (value){
                          fullName = value;
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
                        onChanged: (value){
                          phoneNumber = value;
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
                        onChanged: (value){
                          plateNumber = value;
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
                          labelText: "Plate Number",
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
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                    child: Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        onChanged: (value){
                          password = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "This field can not be empty";
                          } else if (value.length <= 6) {
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
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(""),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 50, 25, 0),
                    child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Col.primary,
                        child: Text(
                          isDataEntered ? "Verify" : "Register",
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
                            setState(() {
                              isDataEntered = !isDataEntered;
                            });
                            setState(() {
                              isProcessing = true;
                            });
                            if (!isDataEntered) {
                              _formKey.currentState!.save();
                              RegisterRequest model = RegisterRequest(
                                  fullName: fullName!,
                                  phone: phoneNumber!,
                                  email: email!,
                                  passwordHash: password!,
                                  defaultPlateNumber: plateNumber!);

                              APIService.register(model).then((response) {
                                if(response.email != null || response.fullName != null || response.passwordHash != null || response.defaultPlateNumber != null || response.phone != null){
                                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                }
                              });
                            }
                          } else {
                            print("Enter fields");
                          }
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              isProcessing = false;
                            });
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(25, 20, 25, 40),
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
                                  text: "Already have an account?"),
                              TextSpan(
                                  style: TextStyle(
                                    color: Col.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                    letterSpacing: 0.3,
                                  ),
                                  text: " Login",
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
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
