import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../screens/map_screen.dart';

class LocationPickerWidget extends StatefulWidget {
  LocationPickerWidget({required this.func, super.key});
  void Function(LatLng location) func;

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  LocationData? loc;
  LatLng? ll;

  void getCurrentLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      loc = _locationData;
      ll = LatLng(loc!.latitude!, loc!.longitude!);
      widget.func(ll!);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text("No Location Added"),
    );

    if (ll != null) {
      content = FlutterMap(
        options: MapOptions(
          initialZoom: 19,
          minZoom: 5,
          initialCenter: ll!,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            retinaMode: true,
            // Other options you might want to customize
          ),
          MarkerLayer(markers: [
            Marker(
              point: ll!,
              child: const Icon(
                Icons.location_pin,
                size: 32,
              ),
            ),
          ])
        ],
      );
    }

    return Column(
      children: [
        Container(
            clipBehavior: Clip.hardEdge,
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: content),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                getCurrentLocation();
              },
              icon: const Icon(Icons.my_location_rounded),
              label: const Text("Current Location"),
            ),
            OutlinedButton.icon(
              onPressed: () async {
                LatLng result  = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return MapScreen();
                    },
                  ),
                );

                widget.func(result);
                setState(() {
                  ll = LatLng(result.latitude, result.longitude);
                });
              },
              icon: const Icon(Icons.map),
              label: const Text("Select Location"),
            ),
          ],
        ),
      ],
    );
  }
}
