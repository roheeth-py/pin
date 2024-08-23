import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_point/models/place_model.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "pinPoint.db"),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE user_places (id TEXT PRIMARY KEY , title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)");
    },
    version: 1,
  );
  return db;
}

class PlaceProviderNotifier extends StateNotifier<List<PlaceModel>> {
  PlaceProviderNotifier() : super([]);

  Future<void> loadPlace() async {
    final db = await _getDatabase();
    final data = await db.query('user_places');
    final places = data.map(
      (e) {
        return PlaceModel(
          e['title'] as String,
          File(e["image"] as String),
          PlaceLocation(
              e['lat'] as double, e['lng'] as double, e['address'] as String,),
          id: e["id"] as String,
        );
      },
    ).toList();

    state = places;
  }

  void addPlace(PlaceModel place) async {
    state = [place, ...state];

    final db = await _getDatabase();
    db.insert("user_places", {
      "id": place.id,
      "title": place.title,
      "image": place.picture.path,
      "lat": place.location.lat,
      "lng": place.location.long,
      "address": place.location.address,
    });
  }
}

final placeProvider =
    StateNotifierProvider<PlaceProviderNotifier, List<PlaceModel>>((ref) {
  return PlaceProviderNotifier();
});
