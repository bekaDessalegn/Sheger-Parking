// import 'dart:convert';
//
// import 'package:http/http.dart' as http;
// import 'package:sheger_parking/models/ReservationDetails.dart';
//
// class BooksApi {
//   static Future<List<Book>> getBooks(String query) async {
//     final url = Uri.parse(
//         'http://10.4.109.57:5000/token:qwhu67fv56frt5drfx45e/reservations');
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       final List books = json.decode(response.body);
//
//       return books.map((json) => Book.fromJson(json)).where((book) {
//         final reservationPlateNumberLower = book.reservationPlateNumber.toLowerCase();
//         final branchLower = book.branch.toLowerCase();
//         final searchLower = query.toLowerCase();
//
//         return reservationPlateNumberLower.contains(searchLower) ||
//             branchLower.contains(searchLower);
//       }).toList();
//     } else {
//       throw Exception();
//     }
//   }
// }
