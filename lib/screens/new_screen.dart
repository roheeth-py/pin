import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:pin_point/models/place_model.dart';
import 'package:pin_point/providers/place_provider.dart';

import '../widgets/imagepicker_widget.dart';
import '../widgets/locationpicker_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;

class NewScreen extends ConsumerWidget {
  final _finalForm = GlobalKey<FormState>();

  String placeName = "";
  LatLng? location;
  File? image;

  NewScreen({super.key});

  void getImage(File sImage) {
    image = sImage;
  }

  void getLocation(LatLng loc) {
    location = loc;
  }

  void onSave(WidgetRef ref, BuildContext context) async {
    if (_finalForm.currentState!.validate()) {
      _finalForm.currentState!.save();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          location!.latitude, location!.longitude);
      final place = placemarks[0];
      String address =
          "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
      final appDir = await syspath.getApplicationDocumentsDirectory();
      final fileName = path.basename(image!.path);
      final copiedImage = await image!.copy('${appDir.path}/$fileName');

      ref.read(placeProvider.notifier).addPlace(
            PlaceModel(
                placeName,
                copiedImage,
                PlaceLocation(
                  location!.latitude,
                  location!.longitude,
                  address,
                )),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Point"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Form(
              key: _finalForm,
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: "Point Name",
                  suffixIcon: Icon(
                    Icons.place_outlined,
                    size: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                initialValue: placeName,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please provide a place name";
                  }
                  return null;
                },
                onSaved: (value) {
                  placeName = value!;
                },
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus!.unfocus();
                },
              ),
            ),
            const SizedBox(height: 20), // Add spacing between form and widgets
            ImagePickerWidget(func: getImage),
            const SizedBox(height: 20), // Add spacing between widgets
            LocationPickerWidget(
              func: getLocation,
            ),
            const SizedBox(height: 20), // Add spacing before the button
            ElevatedButton.icon(
              onPressed: () {
                if (image == null || location == null) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: const Text(
                              "Please select an image and pick a location."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Okay"),
                            ),
                          ],
                        );
                      });
                  return;
                }
                onSave(ref, context);
              },
              icon: const Icon(Icons.add_location),
              label: const Text("Save Point"),
            )
          ],
        ),
      ),
    );
  }
}
