import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_teste/geolocator_api.dart';

void main() => runApp(MapPage());

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;
  Set<Marker> markers = Set<Marker>();
  double lat = -11.396453;
  double long = -37.411528;
  ValueNotifier<LatLng> position;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    position = ValueNotifier<LatLng>(LatLng(lat, long));
    determinePosition().then((value) => position.value = LatLng(value.latitude, value.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: TextField(
            onSubmitted: (val) {
              lat = -11.396453;
              long = -37.411528;

              LatLng newPosition = LatLng(lat, long);
              mapController.moveCamera(CameraUpdate.newLatLng(newPosition));

             
                position.value = newPosition;
            },
          ),
        ),
        body: Container(child:
          ValueListenableBuilder<LatLng>(
            valueListenable:  position,
            builder: (BuildContext context, LatLng value, Widget child) {
               final Marker marker = Marker(
                  markerId: new MarkerId("123456"),
                  position: value,
                  infoWindow: InfoWindow(
                    title: "Casa De Ruan",
                    snippet: "Santa Luzia/SE",
                  ));
                markers.add(marker);
              return GoogleMap(
            onMapCreated: _onMapCreated,
            onCameraMove: (data) {
              print(data);
            },
            onTap: (position) {
              print(position);
            },
            initialCameraPosition: CameraPosition(
              target: value,
              zoom: 11.0,
            ),
            markers: markers,
          );}
        ),
      ),
    )
    );
  }
}
