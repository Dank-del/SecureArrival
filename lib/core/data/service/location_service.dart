import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_appwrite_starter/core/res/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';

import 'api_service.dart';

class LocationService {
  final Client client = Client();
  final Uuid uuid = const Uuid();
  final Databases db;
  late Realtime realtime;
  late Geolocator geolocator;
  late Future<User?> account;

  LocationService._internal()
      : db = Databases(Client()
          ..setEndpoint(AppConstants.endpoint)
          ..setProject(AppConstants.projectId)) {
    geolocator = Geolocator();
    realtime = Realtime(db.client);
    account = ApiService.instance.account!.get();
  }

  static final LocationService instance = LocationService._internal();

  StreamSubscription<Position>? _positionSubscription;

  Future<void> startTracking(String userId, List<String> friends) async {
    // Check and request location permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return;
    }

    // Subscribe to location changes
    _positionSubscription?.cancel();
    _positionSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      _updateLocationInDatabase(userId, position);
      // _emitLocationUpdate(userId, friends, position);
    });
  }

  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
  }

  Future<Document> addNewTrail(double lat, lon, String eta) async {
    return await db.createDocument(
      collectionId: '64956a25ce5db54f58ca',
      documentId: uuid.v4(),
      data: {
        'eta': eta,
        'user': await account.then((value) => value?.$id),
        'lat': lat,
        'lon': lon,
      },
      databaseId: '648ec80b78d131d79ea6',
    );
  }

  Future<void> _updateLocationInDatabase(
      String userId, Position position) async {
    try {
      await db.createDocument(
        collectionId: '648ec842e50841ae046e',
        documentId: userId,
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
        databaseId: '648ec80b78d131d79ea6',
      );
    } catch (e) {
      await db.updateDocument(
        collectionId: '648ec842e50841ae046e',
        documentId: userId,
        data: {
          'latitude': position.latitude,
          'longitude': position.longitude,
        },
        databaseId: '648ec80b78d131d79ea6',
      );
    }
  }
}
