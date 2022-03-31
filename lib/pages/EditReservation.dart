// ignore: file_names
// ignore_for_file: file_names

import 'package:ehet_alem/pages/EditProfile.dart';
import 'package:ehet_alem/pages/StartUpPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'ProfilePage.dart';

class EditReservation extends StatefulWidget {

  String plateNumber;
  EditReservation({required this.plateNumber});

  @override
  _EditReservationState createState() => _EditReservationState(plateNumber);
}

class _EditReservationState extends State<EditReservation> {

  String plateNumber;
  _EditReservationState(this.plateNumber);

  final branches = ['Branch 1','Branch 2','Branch 3','Branch 4','Branch 5','Branch 6'];
  final duration = ['hours', 'days'];
  String? duration_value = 'hours';
  String? value;
  String price = "25";

  String _selectedTime = '8:00 AM';
  DateTime dateTime = DateTime(2022,12,24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            icon: Icon(Icons.account_circle_sharp)),
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
      body:SingleChildScrollView(
        child:
        Container(
          color: Col.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(30, 50, 0, 0),
                child: Text("Edit Reservation",
                  style: TextStyle(
                    color: Col.Onbackground,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                    letterSpacing: 0.1,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(25, 40, 0, 0),
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: plateNumber,
                      hintStyle: TextStyle(
                        color: Col.textfieldLabel,
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        letterSpacing: 0.1,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      labelText: "Plate Number",
                      labelStyle: TextStyle(
                        color: Col.textfieldLabel,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        letterSpacing: 0,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
                child: Container(
                  width: 300,
                  child: Text("Branch",
                    style: TextStyle(
                      color: Col.textfieldLabel,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: Container(
                  width: 300,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Col.Onsurface, width: 1),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      items: branches.map(buildMenuBranch).toList(),
                      onChanged: (value) => setState(() => this.value = value),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
                child: Container(
                  width: 300,
                  child:
                  Row(
                    children: <Widget> [
                      Text("Start time : ",
                        style: TextStyle(
                          color: Col.textfieldLabel,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Nunito',
                          letterSpacing: 0,
                        ),
                      ),
                      Container(
                        width: 170,
                        margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: RaisedButton(
                          color: Col.secondary,
                          child: Center(
                            child: Text(
                              "${dateTime.year}/${dateTime.month}/${dateTime.day} \n   $_selectedTime",
                              style: TextStyle(
                                color: Col.Onprimary,
                                fontSize: 20,
                                fontFamily: 'Nunito',
                                letterSpacing: 0.1,
                              ),
                            ),
                          ),
                          onPressed: () {
                            pickDateTime();
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Jela Bela");
        },
        backgroundColor: Col.primary,
        child: Icon(
          Icons.check,
          color: Col.Onbackground,),
      ),
    );

  }

  Future pickDateTime() async {

    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if(date == null) return;

    TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(time == null) return;

    final dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        date.hour,
        date.minute
    );

    setState(() {
      this.dateTime = dateTime;
      _selectedTime = time.format(context);
    });
  }

  DropdownMenuItem<String> buildMenuBranch(String branch) => DropdownMenuItem(value: branch,
    child: Text(branch,
      style: TextStyle(
        color: Col.Onbackground,
        fontSize: 18,
        fontFamily: 'Nunito',
        letterSpacing: 0.3,
      ),
    ),
  );
  DropdownMenuItem<String> buildMenuDuration(String duration) => DropdownMenuItem(value: duration,
    child: Text(duration,
      style: TextStyle(
        color: Col.Onbackground,
        fontSize: 18,
        fontFamily: 'Nunito',
        letterSpacing: 0.3,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
