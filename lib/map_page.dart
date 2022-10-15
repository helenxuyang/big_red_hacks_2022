import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  final double defaultLat = 42.449707;
  final double defaultLong = -76.4838893;
  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng? currentLoc;
  Set<Marker> fountainMarkers = {};

  @override
  void initState() {
    super.initState();
    setCurrentLocation();
    fetchWaterFountainMarkers();
  }

  Future<bool> locationPermissionsGranted() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<void> onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  Future<void> setCurrentLocation() async {
    if (await locationPermissionsGranted()) {
      LocationData loc = await location.getLocation();
      print('loc ' + loc.latitude.toString() + ' ' + loc.longitude.toString());

      setState(() {
        currentLoc = LatLng(loc.latitude ?? widget.defaultLat,
            loc.longitude ?? widget.defaultLong);
      });
    } else {
      print('no permissions');
      setState(() {
        currentLoc = const LatLng(42.449707, -76.4838893); // default to PSB
      });
    }
  }

  Future<void> fetchWaterFountainMarkers() async {
    MarkerId tempId = const MarkerId('temp');
    setState(() {
      fountainMarkers.add(Marker(
        markerId: tempId,
        position: const LatLng(42.4532, -76.4794),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    print('google map build');
    print(currentLoc);
    print(fountainMarkers);

    if (currentLoc == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return GoogleMap(
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: currentLoc!,
        zoom: 15.0,
      ),
      markers: fountainMarkers,
    );
  }
}
