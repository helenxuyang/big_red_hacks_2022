import 'package:big_red_hacks_2022/reviews.dart';
import 'package:big_red_hacks_2022/widget_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'firebase_helpers.dart';
import 'fountain.dart';
import 'login.dart';

class MapPage extends StatefulWidget {
  MapPage(this.openBottomSheet);
  final Function(bool) openBottomSheet;
  final double defaultLat = 42.449707; // PSB
  final double defaultLong = -76.4838893; // PSB
  @override
  State<StatefulWidget> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  Location location = Location();
  LatLng? currentLoc;
  Set<Marker> fountainMarkers = {};
  Fountain? selectedFountain;

  @override
  void initState() {
    super.initState();
    setCurrentLocation();
    createFountainMarkers();
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

  Marker createMarker(Fountain fountain) {
    MarkerId tempId = MarkerId(fountain.location.latitude.toString() +
        fountain.location.longitude.toString());
    const dividerDot = Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      child: Icon(
        Icons.circle,
        size: 2,
      ),
    );
    return Marker(
        markerId: tempId,
        position:
            LatLng(fountain.location.latitude, fountain.location.longitude),
        onTap: () {
          setState(() {
            selectedFountain = fountain;
          });
          widget.openBottomSheet(true);
          Scaffold.of(context)
              .showBottomSheet(
                (context) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                                color: Colors.grey, width: 50, height: 2),
                          ),
                          const SizedBox(height: 24),
                          Flexible(
                            child: Text(
                              'Fountain in ' + fountain.buildingName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Text('0.1 miles'), // TODO use real distance
                              dividerDot,
                              buildStars(4.5),
                              const Text('(12)'), // TODO implement reviews
                              dividerDot,
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: fountain.isFunctional
                                    ? const [
                                        Icon(Icons.check_circle_outline,
                                            color: Colors.green, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          'Functional',
                                          style: TextStyle(
                                            color: Colors.green,
                                          ),
                                        )
                                      ]
                                    : const [
                                        Icon(Icons.cancel_outlined,
                                            color: Colors.redAccent, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          'Broken',
                                          style: TextStyle(
                                            color: Colors.redAccent,
                                          ),
                                        )
                                      ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Location: ' + fountain.locationDescription,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Row(children: [
                            OutlinedButton(
                              onPressed: () {
                                User? user = Provider.of<CurrentUserInfo>(
                                        context,
                                        listen: false)
                                    .user;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ReviewsPage(fountain, user),
                                  ),
                                );
                              },
                              child: Row(
                                children: const [
                                  Icon(Icons.reviews, size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    'Reviews',
                                    style: TextStyle(color: Colors.blueAccent),
                                  )
                                ],
                              ),
                              style: OutlinedButton.styleFrom(
                                  primary: Colors.blueAccent,
                                  side: const BorderSide(
                                      color: Colors.blueAccent)),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                // TODO: implement fountain functional/broken
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Thanks for reporting the status of this fountain!')));
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.handyman, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Report ' +
                                        (fountain.isFunctional
                                            ? 'broken'
                                            : 'fixed'),
                                    style: const TextStyle(
                                        color: Colors.redAccent),
                                  )
                                ],
                              ),
                              style: OutlinedButton.styleFrom(
                                  primary: Colors.redAccent,
                                  side: const BorderSide(
                                      color: Colors.redAccent)),
                            ),
                          ])
                        ],
                      ),
                    ),
                  );
                },
                elevation: 8.0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
              )
              .closed
              .whenComplete(() => widget.openBottomSheet(false));
        });
  }

  Future<void> createFountainMarkers() async {
    List<Fountain> fountains = await Helpers.getAllFountains();
    print(fountains);
    setState(() {
      fountainMarkers = fountains.map((f) => createMarker(f)).toSet();
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
