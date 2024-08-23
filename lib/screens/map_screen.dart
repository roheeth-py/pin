import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  MapScreen(
      {this.latLng = const LatLng(13.0843, 80.2705),
      this.isSelecting = true,
      this.title = "Select Location",
      super.key});
  LatLng latLng;
  bool isSelecting;
  String title;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: widget.isSelecting,
        actions: (widget.isSelecting)
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      widget.latLng,
                    );
                  },
                  icon: const Icon(Icons.check_rounded),
                ),
              ]
            : [],
      ),
      body: Hero(
        tag: "obj1",
        child: FlutterMap(
          options: MapOptions(
            initialZoom: 19,
            minZoom: 5,
            initialCenter: widget.latLng,
            onTap: widget.isSelecting
                ? (position, latlng) {
                    setState(() {
                      widget.latLng = latlng;
                    });
                  }
                : null,
          ),
          children: [
            TileLayer(
              retinaMode: true,
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: widget.latLng,
                  child: const Icon(
                    Icons.location_pin,
                    size: 48,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
