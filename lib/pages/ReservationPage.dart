// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors


import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/strings.dart';
import 'package:time_picker_widget/time_picker_widget.dart';

import 'ProfilePage.dart';

class ReservationPage extends StatefulWidget {

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {

  final branches = ['Branch 1','Branch 2','Branch 3','Branch 4','Branch 5','Branch 6'];
  final duration = ['hours', 'days'];
  String? duration_value = 'hours';
  String? value;
  String price = "25";

  DateTime dateTime = DateTime(2022, 3, 21, 4, 0);

  String plateNumber = "256542";

  @override
  Widget build(BuildContext context) {

    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    child: Text("Reservation",
                      style: TextStyle(
                        color: Col.Onbackground,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        letterSpacing: 0.1,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(25, 40, 25, 0),
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: TextField(
                        onChanged: (text){
                          plateNumber = text;
                        },
                        decoration: InputDecoration(
                          hintText: "",
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
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                    child: Container(
                      width: double.infinity,
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
                  Padding(padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                    child: Container(
                      width: double.infinity,
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
                  Padding(padding: EdgeInsets.fromLTRB(25, 20, 25, 0),
                    child: Container(
                      width: double.infinity,
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
                                  "${dateTime.year}/${dateTime.month}/${dateTime.day} \n    $hours:$minutes",
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

                  Padding(padding: EdgeInsets.fromLTRB(25, 20, 0, 0),
                    child: Container(
                      width: double.infinity,
                      child: Text("Duration",
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
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 130,
                            alignment: Alignment.center,
                            child: TextField(
                              style: TextStyle(
                                color: Col.textfieldLabel,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Nunito',
                                letterSpacing: 0,
                              ),
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Col.Onsurface, width: 1),
                            ),
                          ),
                          Container(
                            width: 120,
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: duration_value,
                                isExpanded: true,
                                items: duration.map(buildMenuDuration).toList(),
                                onChanged: (duration_value) => setState(() => this.duration_value = duration_value),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Col.Onsurface, width: 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                    child:
                    Center(child: RaisedButton(onPressed: () {
                      print("Jela Bela");
                    },
                      padding: EdgeInsets.all(15),
                      color: Col.primary,
                      child: Text(
                        'Pay : $price birr',
                        style: TextStyle(
                          color: Col.Onbackground,
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          letterSpacing: 0.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );

  }

  // Future pickDateTime() async {
  //
  //   DateTime? date = await showDatePicker(
  //       context: context,
  //       initialDate: DateTime.now(),
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime(2100));
  //   if(date == null) return;
  //
  //   TimeOfDay? time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
  //   if(time == null) return;
  //
  //   final dateTime = DateTime(
  //     date.year,
  //     date.month,
  //     date.day,
  //     date.hour,
  //     date.minute
  //   );
  //
  //   setState(() {
  //     this.dateTime = dateTime;
  //     _selectedTime = time.format(context);
  //   });
  // }

  // Future<void> _openTimePicker(BuildContext context) async {
  //   final TimeOfDay? t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
  //
  //   if(t != null){
  //     setState(() {
  //       _selectedTime = t.format(context);
  //     });
  //   }
  // }

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
  
  Future<DateTime?> pickDate() => showDatePicker(context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1991),
      lastDate: DateTime(2050));

  Future<TimeOfDay?> pickTime() => showCustomTimePicker(
      context: context,
      // It is a must if you provide selectableTimePredicate
      onFailValidation: (context) => print('Unavailable selection'),
      initialTime: TimeOfDay(hour: 6, minute: 0),
      selectableTimePredicate: (time) =>
          time!.minute == 0);

  Future pickDateTime() async {
    DateTime? date = await pickDate();
    if (date == null) return;

    TimeOfDay? time = await pickTime();
    if (time == null) return;

    final dateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute
    );
   setState(() {
     this.dateTime = dateTime;
   });
  }

}
