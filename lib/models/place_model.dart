import 'dart:io';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  PlaceLocation(
    this.lat,
    this.long,
    this.address,
  );

  final double lat;
  final double long;
  final String address;
}

class PlaceModel {
  PlaceModel(
    this.title, this.picture, this.location, {String? id}
  ) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File picture;
  final PlaceLocation location;
}
