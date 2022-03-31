// ignore: file_names
// ignore_for_file: file_names

import 'package:ehet_alem/pages/LoginPage.dart';
import 'package:ehet_alem/pages/SignUpPage.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StartUp extends StatelessWidget {
  const StartUp({Key? key}) : super(key: key);

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
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
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
              Text("PARKING",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  letterSpacing: 0.3,
                ),
              ),
              Container(
              child: SvgPicture.asset('images/Parking-amico.svg'),
                width: 280,
                height: 400,
              ),
              Text(Strings.app_title_desc,
                style: TextStyle(
                  color: Col.Onbackground,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                children: <Widget>[
                  Padding(padding: EdgeInsets.fromLTRB(40, 60, 0, 0),
                  child:RaisedButton(
                    color: Col.primary,
                    child: Text("Login",
                      style: TextStyle(
                        color: Col.Onprimary,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        letterSpacing: 0.3,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
    ),
                  Padding(padding: EdgeInsets.fromLTRB(50, 60, 0, 0),
                    child:RaisedButton(
                      color: Col.primary,
                      child: Text(Strings.signup,
                        style: TextStyle(
                          color: Col.Onprimary,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                          letterSpacing: 0.3,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
