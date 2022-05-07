import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sheger_parking/api/reservations_api.dart';
import 'package:sheger_parking/constants/colors.dart';
import 'package:sheger_parking/models/ReservationDetails.dart';
import 'package:sheger_parking/widget/search_widget.dart';
import 'package:http/http.dart' as http;

class FilterNetworkListPage extends StatefulWidget {
  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<FilterNetworkListPage> {
  List<Book> books = [];
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

  static Future<List<Book>> getBooks(String query) async {
    final url = Uri.parse(
        'http://10.4.109.57:5000/token:qwhu67fv56frt5drfx45e/clients/6271835d3c51e34e83c59c8a/reservations');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List books = json.decode(response.body);

      return books.map((json) => Book.fromJson(json)).where((book) {
        final reservationPlateNumberLower = book.reservationPlateNumber.toLowerCase();
        final branchLower = book.branch.toLowerCase();
        final searchLower = query.toLowerCase();

        return reservationPlateNumberLower.contains(searchLower) ||
            branchLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception();
    }
  }

  Future init() async {
    final books = await getBooks(query);

    setState(() => this.books = books);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];

                  return buildBook(book);
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Title or Author Name',
        onChanged: searchBook,
      );

  Future searchBook(String query) async => debounce(() async {
        final books = await getBooks(query);

        if (!mounted) return;

        setState(() {
          this.query = query;
          this.books = books;
        });
      });

  Widget buildBook(Book book) => GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ReservationDetailsPage(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationId, reservationPlateNumber: reservationPlateNumber, branch: branch, startTime: startTime, slot: slot, price: price, duration: duration, parked: parked)));
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Card(
                    color: Colors.grey[100],
                    elevation: 8,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 8, 0, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: [
                              Align(
                                child: IconButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             EditReservation(id: id, fullName: fullName, phone: phone, email: email, passwordHash: passwordHash, defaultPlateNumber: defaultPlateNumber, reservationId: reservationId, reservationPlateNumber: reservationPlateNumber, branch: branch, startTime: startTime)));
                                  },
                                  icon: Icon(Icons.edit),
                                  iconSize: 25,
                                ),
                                alignment: Alignment.topRight,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    0, 15, 0, 0),
                                child: Text(
                                  "Reservation at ${book.branch}",
                                  style: TextStyle(
                                    color: Col.Onbackground,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Nunito',
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Description 1",
                            style: TextStyle(
                              color: Col.Onbackground,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              letterSpacing: 0.3,
                            ),
                          ),
                          Text(
                            "Description 2",
                            style: TextStyle(
                              color: Col.Onbackground,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito',
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  ),
                ),
              );
}
