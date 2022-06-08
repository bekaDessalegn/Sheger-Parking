// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sheger_parking/constants/api.dart';
import 'package:sheger_parking/pages/BranchMap.dart';

import '../constants/colors.dart';
import 'package:sheger_parking/models/BranchDetails.dart';
import 'package:http/http.dart' as http;

class BranchesPage extends StatefulWidget {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;

  BranchesPage(
      {required this.id,
      required this.fullName,
      required this.phone,
      required this.email,
      required this.passwordHash,
      required this.defaultPlateNumber});

  @override
  _BranchesPageState createState() => _BranchesPageState(
      id, fullName, phone, email, passwordHash, defaultPlateNumber);
}

class _BranchesPageState extends State<BranchesPage> {
  String id, fullName, phone, email, passwordHash, defaultPlateNumber;

  _BranchesPageState(this.id, this.fullName, this.phone, this.email,
      this.passwordHash, this.defaultPlateNumber);

  bool isLoading = false;

  List<BranchDetails> branches = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }

    debouncer = Timer(duration, callback);
  }

  static Future<List<BranchDetails>> getBranchDetails(String query) async {
    final url = Uri.parse('${base_url}/branches');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List branchDetails = json.decode(response.body);

      return branchDetails
          .map((json) => BranchDetails.fromJson(json))
          .where((branchDetail) {
        final branchNameLower = branchDetail.name.toLowerCase();
        final branchIdLower = branchDetail.id.toLowerCase();
        final searchLower = query.toLowerCase();

        return branchNameLower.contains(searchLower) ||
            branchIdLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  Future init() async {
    setState(() {
      isLoading = true;
    });

    final branchDetails = await getBranchDetails(query);

    setState(() => this.branches = branchDetails);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
      return ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          scrollbars: false,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
              // maxHeight: viewportConstraints.maxHeight*2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20),
                  child: Text(
                    "The nearest",
                    style: TextStyle(
                      color: Col.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Col.blackColor,
                    elevation: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        gradient: LinearGradient(
                            colors: [Col.locationgradientColor, Col.blackColor],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 15, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.location_on,
                              size: 80,
                              color: Col.primary,
                            ),
                            Expanded(
                              child: Row(),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                // Stack(
                                //   children: [
                                // Align(
                                //   child: IconButton(
                                //     onPressed: () {
                                //       Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   EditReservation(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationDetail.id, reservationPlateNumber: reservationDetail.reservationPlateNumber, branch: reservationDetail.branch, branchName: reservationDetail.branchName, startTime: reservationDetail.startingTime)));
                                //     },
                                //     icon: Icon(Icons.edit),
                                //     iconSize: 25,
                                //   ),
                                //   alignment: Alignment.topRight,
                                // ),
                                Text(
                                  "Nifas Silk Lafto",
                                  style: TextStyle(
                                    color: Col.whiteColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                                //     ),
                                // ],
                                Text(
                                  "200 Slots",
                                  style: TextStyle(
                                    color: Col.whiteColor,
                                    fontSize: 20,
                                    fontFamily: 'Nunito',
                                  ),
                                ),

                                Text(
                                  "20 birr/hour",
                                  style: TextStyle(
                                    color: Col.whiteColor,
                                    fontSize: 20,
                                    fontFamily: 'Nunito',
                                  ),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BranchMap()));
                                  },
                                  child: Text(
                                    "See on map",
                                    style: TextStyle(
                                      color: Col.linkColor,
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: Size(50, 30),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      alignment: Alignment.centerLeft),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10, left: 20),
                  child: Text(
                    "All branches",
                    style: TextStyle(
                      color: Col.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
                 isLoading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: branches.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final branchDetail = branches[index];

                            return Padding(
                              padding: EdgeInsets.fromLTRB(30, 0, 30, 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: Col.blackColor,
                                elevation: 8,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      // Stack(
                                      //   children: [
                                      // Align(
                                      //   child: IconButton(
                                      //     onPressed: () {
                                      //       Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //               builder: (context) =>
                                      //                   EditReservation(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationDetail.id, reservationPlateNumber: reservationDetail.reservationPlateNumber, branch: reservationDetail.branch, branchName: reservationDetail.branchName, startTime: reservationDetail.startingTime)));
                                      //     },
                                      //     icon: Icon(Icons.edit),
                                      //     iconSize: 25,
                                      //   ),
                                      //   alignment: Alignment.topRight,
                                      // ),
                                      Center(
                                        child: Text(
                                          "${branchDetail.name}",
                                          style: TextStyle(
                                            color: Col.whiteColor,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        //     ),
                                        // ],
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                // "$formattedStartTime - $formattedFinishTime",
                                                "${branchDetail.capacity} Slots ",
                                                style: TextStyle(
                                                  color: Col.whiteColor,
                                                  fontSize: 20,
                                                  fontFamily: 'Nunito',
                                                ),
                                              ),
                                              Text(
                                                // "$formattedStartTime - $formattedFinishTime",
                                                "|",
                                                style: TextStyle(
                                                  color: Col.primary,
                                                  fontSize: 20,
                                                  fontFamily: 'Nunito',
                                                ),
                                              ),
                                              Text(
                                                // "$formattedStartTime - $formattedFinishTime",
                                                " ${branchDetail.pricePerHour} birr/hour",
                                                style: TextStyle(
                                                  color: Col.whiteColor,
                                                  fontSize: 20,
                                                  fontFamily: 'Nunito',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BranchMap()));
                                          },
                                          child: Text(
                                            "See on map",
                                            style: TextStyle(
                                              color: Col.linkColor,
                                              fontSize: 16,
                                              fontFamily: 'Nunito',
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size(50, 30),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              alignment: Alignment.centerLeft),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              ),
                            );

                            //   Padding(
                            //     padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            //     child: Card(
                            //       color: Colors.grey[100],
                            //       elevation: 8,
                            //       child: Padding(
                            //         padding: EdgeInsets.fromLTRB(10, 8, 0, 8),
                            //         child: Column(
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: <Widget>[
                            //             Stack(
                            //               children: [
                            //                 Align(
                            //                   child: IconButton(
                            //                     onPressed: () {
                            //                       Navigator.push(
                            //                           context,
                            //                           MaterialPageRoute(
                            //                               builder: (context) => BranchMap()));
                            //                     },
                            //                     icon: Icon(Icons.location_on),
                            //                     iconSize: 25,
                            //                   ),
                            //                   alignment: Alignment.topRight,
                            //                 ),
                            //                 Padding(
                            //                   padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            //                   child: Text(
                            //                     "${branchDetail.name}",
                            //                     style: TextStyle(
                            //                       color: Col.Onbackground,
                            //                       fontSize: 20,
                            //                       fontWeight: FontWeight.bold,
                            //                       fontFamily: 'Nunito',
                            //                       letterSpacing: 0.3,
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ],
                            //             ),
                            //             RichText(
                            //               text: TextSpan(
                            //                 children: [
                            //                   TextSpan(
                            //                       style: TextStyle(
                            //                         color: Col.Onbackground,
                            //                         fontSize: 18,
                            //                         fontWeight: FontWeight.w700,
                            //                         fontFamily: 'Nunito',
                            //                         letterSpacing: 0.3,
                            //                       ),
                            //                       text: "Price per hour : "),
                            //                   TextSpan(
                            //                     style: TextStyle(
                            //                       color: Col.Onbackground,
                            //                       fontSize: 18,
                            //                       fontFamily: 'Nunito',
                            //                       letterSpacing: 0.3,
                            //                     ),
                            //                     text: "${branchDetail.pricePerHour}",
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             RichText(
                            //               text: TextSpan(
                            //                 children: [
                            //                   TextSpan(
                            //                       style: TextStyle(
                            //                         color: Col.Onbackground,
                            //                         fontSize: 18,
                            //                         fontWeight: FontWeight.w700,
                            //                         fontFamily: 'Nunito',
                            //                         letterSpacing: 0.3,
                            //                       ),
                            //                       text: "Capacity : "),
                            //                   TextSpan(
                            //                     style: TextStyle(
                            //                       color: Col.Onbackground,
                            //                       fontSize: 18,
                            //                       fontFamily: 'Nunito',
                            //                       letterSpacing: 0.3,
                            //                     ),
                            //                     text: "${branchDetail.capacity}",
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //             RichText(
                            //               text: TextSpan(
                            //                 children: [
                            //                   TextSpan(
                            //                       style: TextStyle(
                            //                         color: Col.Onbackground,
                            //                         fontSize: 18,
                            //                         fontWeight: FontWeight.w700,
                            //                         fontFamily: 'Nunito',
                            //                         letterSpacing: 0.3,
                            //                       ),
                            //                       text: "Description : "),
                            //                   TextSpan(
                            //                       style: TextStyle(
                            //                         color: Col.Onbackground,
                            //                         fontSize: 18,
                            //                         fontFamily: 'Nunito',
                            //                         letterSpacing: 0.3,
                            //                       ),
                            //                       text: "${branchDetail.description}",
                            //                       ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //       margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            //     ),
                            // );
                          },
                        ),
              ],
              //   ),
              // ),
            ),
          ),
        ),
      );
    });
  }

// Widget buildCard(String branchName) => Padding(
//   padding: EdgeInsets.all(10),
//   child: Card(
//     child: ExpandablePanel(
//       header:Padding(padding: EdgeInsets.fromLTRB(10, 3, 0, 8),
//         child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Row(
//             children: [
//               Text(
//                 branchName,
//                 style: TextStyle(
//                   color: Col.Onbackground,
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Nunito',
//                   letterSpacing: 0.1,
//                 ),
//               ),
//               IconButton(onPressed: (){},
//                 icon: Icon(Icons.location_on),
//                 color: Colors.blue,
//                 iconSize: 30,
//               padding: EdgeInsets.fromLTRB(10, 0, 0, 0),),
//             ],
//           ),
//           Text("Branch 5",
//             style: TextStyle(
//               color: Col.Onbackground,
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'Nunito',
//               letterSpacing: 0.1,
//             ),
//           ),
//         ],
//       ),
//       ),
//       collapsed: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//         child: Row(
//         children: <Widget>[
//           Text("Parking is the act of stopping",
//             style: TextStyle(
//               color: Col.Onbackground,
//               fontSize: 18,
//               fontFamily: 'Nunito',
//               letterSpacing: 0.1,
//             ),
//           ),
//         ],
//       ),
//       ),
//         expanded:Column(
//           children: <Widget>[
//             Text("Parking is the act of stopping and disengaging a vehicle and leaving it unoccupied. Parking on one or both sides of a road is often permitted, though sometimes with restrictions. Some buildings have parking facilities for use of the buildings' users. Countries and local governments have rules[1] for design and use of parking spaces.",
//               style: TextStyle(
//                 color: Col.Onbackground,
//                 fontSize: 18,
//                 fontFamily: 'Nunito',
//                 letterSpacing: 0.1,
//               ),
//             ),
//           ],
//         ),
//     ),
//   ),
// );

}

/*
Stack(
        fit: StackFit.expand,
        children: <Widget>[Container(
          color: Col.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child:Padding(padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
                  child: Text("Branches",
                    style: TextStyle(
                      color: Col.Onbackground,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
              Center(child: Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                child: Container(
                  width: 300,
                  height: 500,
                  child: ListView(
                    children: [
                      buildCard(
                        'Lafto'
                      ),
                      buildCard(
                          'Lafto'
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Col.surface,
                  ),
                ),
              ),
              ),
            ],
          ),
        ),
        ],
      ),
 */
