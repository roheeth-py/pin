import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:pin_point/models/place_model.dart';
import 'package:pin_point/screens/map_screen.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen(this.data, {super.key});
  final PlaceModel data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data.title),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image.file(
            data.picture,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                    tag: "obj1",
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: const ShapeDecoration(
                        shape: CircleBorder(),
                      ),
                      height: 140,
                      width: 140,
                      child: FlutterMap(
                        options: MapOptions(
                          onTap: (pos, ll) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) {
                                return MapScreen(
                                  title: data.location.address,
                                  isSelecting: false,
                                  latLng: LatLng(
                                      data.location.lat, data.location.long),
                                );
                              },
                            ));
                          },
                          initialZoom: 16,
                          minZoom: 5,
                          interactionOptions: const InteractionOptions(
                            flags: InteractiveFlag.pinchZoom,
                          ),
                          initialCenter:
                              LatLng(data.location.lat, data.location.long),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            retinaMode: true,
                            // Other options you might want to customize
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(
                                    data.location.lat, data.location.long),
                                child: const Icon(
                                  Icons.location_pin,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    data.location.address,
                    style: const TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
