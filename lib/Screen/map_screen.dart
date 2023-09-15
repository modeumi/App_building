import 'dart:async';

import 'package:eat_today/Controller/Data_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class map_screen extends StatefulWidget {
  final String name;

  map_screen(this.name);

  Map_Screen createState() => Map_Screen();
}

class Map_Screen extends State<map_screen> {
  Controls controls = Controls();
  late CameraPosition cameraPosition;
  final _controller = Completer<GoogleMapController>();
  Set<Marker> markers = {};
  bool state = false;

  @override
  void initState() {
    super.initState();
    Load_page();
  }

  void Load_page() async {
    Map<String, dynamic> result_location = await controls.Get_Location();
    Set<Marker> result_maker = await controls.Get_Restaurants(widget.name);
    setState(() {
      cameraPosition = CameraPosition(target: LatLng(result_location['위도'], result_location['경도']), zoom: 15.0);
      markers = result_maker;
      state = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: state
          ? GoogleMap(
              markers: markers,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              initialCameraPosition: cameraPosition,
            )
          : Container(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
    );
  }
}
