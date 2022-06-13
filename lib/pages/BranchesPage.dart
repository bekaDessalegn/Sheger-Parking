// ignore: file_names
// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sheger_parking/constants/api.dart';
import 'package:sheger_parking/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

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

  String location = "8.9831, 38.8101";

  bool onLoading = true;

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

  var url = "https://www.google.com/maps/dir/9.040721,38.762947/8.9622,38.7259";

  void launchUrl(String branchLocation) async {
    List splittedBranchLocation = branchLocation.split(",");
    double desLat = double.parse(splittedBranchLocation[0]);
    double desLong = double.parse(splittedBranchLocation[1]);
    if (await canLaunch(
        "https://www.google.com/maps/dir/${Strings.lat},${Strings.longs}/$desLat,$desLong")) {
      await launch(
          "https://www.google.com/maps/dir/${Strings.lat},${Strings.longs}/$desLat,$desLong");
    } else {
      throw 'Could not launch google maps';
    }
  }

  List<BranchDetails> sortByLocation(
      String currentLocation, List<BranchDetails> branches) {
    List<double> currentLoc = currentLocation
        .split(",")
        .map((location) => double.parse(location))
        .toList();
    branches.sort(((a, b) {
      List<double> locA = a.location
          .split(",")
          .map((location) => double.parse(location))
          .toList();
      List<double> locB = b.location
          .split(",")
          .map((location) => double.parse(location))
          .toList();
      double distA = sqrt(
          pow(locA[0] - currentLoc[0], 2) + pow(locA[1] - currentLoc[1], 2));
      double distB = sqrt(
          pow(locB[0] - currentLoc[0], 2) + pow(locB[1] - currentLoc[1], 2));
      return distA.compareTo(distB);
    }));
    return branches;
  }

  Future<List<BranchDetails>> getBranchDetails(String query) async {
    final url = Uri.parse('${base_url}/branches');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List branchDetailsJson = json.decode(response.body);

      List<BranchDetails> branchDetails = branchDetailsJson
          .map((json) => BranchDetails.fromJson(json))
          .where((branchDetail) {
        final branchNameLower = branchDetail.name.toLowerCase();
        final branchIdLower = branchDetail.id.toLowerCase();
        final searchLower = query.toLowerCase();

        return branchNameLower.contains(searchLower) ||
            branchIdLower.contains(searchLower);
      }).toList();

      return sortByLocation("${Strings.lat}, ${Strings.longs}", branchDetails);
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
      onLoading = false;
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
        child: onLoading
            ? Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Col.primary,
                  ),
                ))
            : SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0)),
                              gradient: LinearGradient(
                                  colors: [
                                    Col.locationgradientColor,
                                    Col.blackColor
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 15, 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 80,
                                    color: Col.primary,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          branches[0].name,
                                          overflow: TextOverflow.fade,
                                          maxLines: 1,
                                          softWrap: false,
                                          style: TextStyle(
                                            color: Col.whiteColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        Text(
                                          "${branches[0].capacity} Slots",
                                          style: TextStyle(
                                            color: Col.whiteColor,
                                            fontSize: 20,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        Text(
                                          "${branches[0].pricePerHour} birr/hour",
                                          style: TextStyle(
                                            color: Col.whiteColor,
                                            fontSize: 20,
                                            fontFamily: 'Nunito',
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            launchUrl(branches[0].location);
                                          },
                                          child: Text(
                                            "See on map",
                                            style: TextStyle(
                                              color: Col.linkColor,
                                              fontSize: 18,
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
                                      ],
                                    ),
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
                                      padding:
                                          EdgeInsets.fromLTRB(0, 16, 0, 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "${branchDetail.name}",
                                              style: TextStyle(
                                                color: Col.whiteColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Nunito',
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${branchDetail.capacity} Slots ",
                                                    style: TextStyle(
                                                      color: Col.whiteColor,
                                                      fontSize: 20,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                  Text(
                                                    "|",
                                                    style: TextStyle(
                                                      color: Col.primary,
                                                      fontSize: 20,
                                                      fontFamily: 'Nunito',
                                                    ),
                                                  ),
                                                  Text(
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
                                                launchUrl(
                                                    branchDetail.location);
                                              },
                                              child: Text(
                                                "See on map",
                                                style: TextStyle(
                                                  color: Col.linkColor,
                                                  fontSize: 18,
                                                  fontFamily: 'Nunito',
                                                ),
                                              ),
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: Size(50, 30),
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                  alignment:
                                                      Alignment.centerLeft),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ),
      );
    });
  }
}
