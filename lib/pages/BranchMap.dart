// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
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

  final Set<Polyline>_polyline={};

  List<LatLng> latlng = [];

  Marker destination = Marker(
      markerId: const MarkerId('Destination'),
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
        elevation: 4.0,
        toolbarHeight: 70,
        leading: IconButton(
          color: Col.Onbackground,
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(
          Strings.app_title,
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
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0)),
            gradient: LinearGradient(
                colors: [Col.secondary, Col.secondary],
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
                  markerId: const MarkerId('origin'),
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
