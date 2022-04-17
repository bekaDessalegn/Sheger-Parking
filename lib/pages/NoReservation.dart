// ignore_for_file: file_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoReservation extends StatelessWidget {
  const NoReservation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: SvgPicture.asset('images/noReservation.svg'),
        width: 280,
        height: 400,
      ),
    );
  }
}
