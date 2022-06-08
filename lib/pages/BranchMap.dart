// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sheger_parking/constants/colors.dart';
import 'package:sheger_parking/constants/strings.dart';

class BranchMap extends StatefulWidget {
  const BranchMap({Key? key}) : super(key: key);

  @override
  _BranchMapState createState() => _BranchMapState();
}

class _BranchMapState extends State<BranchMap> {

  late double lat = 0.0;
  late double longs = 0.0;

  late GoogleMapController _googleMapController;

   Set<Polyline>_polyline={};

  List<LatLng> latlng = [];

  PolylinePoints polylinePoints = PolylinePoints();

  Marker destination = Marker(
      markerId: MarkerId('Destination'),
      infoWindow: const InfoWindow(title: "Destination"),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed),
      position: LatLng(8.9831, 38.8101));

  void getCurrentLocation() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      longs = position.longitude;
    });

    // List<PointLatLng> result = await polylinePoints?.getRouteBetweenCoordinates(
    //     "AIzaSyB7Zz6YPYhozN0Ve28OVol3tnvXOK1hGow",
    //     lat,
    //     longs,
    //     destination.position.latitude,
    //     destination.position.longitude);
    // if(result.isNotEmpty){
    //   // loop through all PointLatLng points and convert them
    //   // to a list of LatLng, required by the Polyline
    //   result.forEach((PointLatLng point){
    //     latlng.add(
    //         LatLng(point.latitude, point.longitude));
    //   });
    // }
    // setState(() {
    //   // create a Polyline instance
    //   // with an id, an RGB color and the list of LatLng pairs
    //   Polyline polyline = Polyline(
    //       polylineId: PolylineId(LatLng(lat, longs).toString()),
    //       color: Color.fromARGB(255, 40, 122, 198),
    //       points: latlng
    //   );
    //
    //   // add the constructed polyline as a set of points
    //   // to the polyline set, which will eventually
    //   // end up showing up on the map
    //   _polyline.add(polyline);
    // });

    _polyline.add(Polyline(
      polylineId: PolylineId(LatLng(lat, longs).toString()),
      visible: true,
      width: 3,
      //latlng is List<LatLng>
      points: latlng,
      color: Colors.blue,
    ));

    latlng.add(LatLng(lat, longs));
    latlng.add(destination.position);

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    print("Latitiude : $lat and Longitude : $longs");
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 7.0,
        toolbarHeight: 70,
        leading: IconButton(
          color: Col.Onbackground,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          "Branch Map",
          style: TextStyle(
            color: Col.blackColor,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'Nunito',
            letterSpacing: 0.3,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0)),
            gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter),
          ),
        ),
      ),
      body: (lat == 0.0 && longs == 0.0) ? Center(child: CircularProgressIndicator(),) : Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(8.9806, 38.7578),
              zoom: 13.5,
            ),
            onMapCreated: (controller) => _googleMapController = controller,
            markers: {
              Marker(
                  markerId: MarkerId('origin'),
                  infoWindow: const InfoWindow(title: "Origin"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                  position: LatLng(lat, longs)),
              destination
            },
            polylines:_polyline,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        onPressed: () {
          _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(lat, longs),
                zoom: 13.5,
              ),
            ),
          );
          print("Latitiude : $lat and Longitude : $longs");
        },
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

}
