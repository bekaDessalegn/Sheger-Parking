// ignore_for_file: file_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:sheger_parking/constants/colors.dart';

class NoReservation extends StatelessWidget {
  const NoReservation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "no reservations yet ...",
        style: TextStyle(
          color: Col.Onsurface,
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'Nunito',
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
