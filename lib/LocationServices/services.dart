import 'dart:async';

import 'package:helath_care/LocationServices/locationmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

import 'locationmodel.dart';

class LocationService with ChangeNotifier {
  UserLocation _currentLocation= UserLocation(latitude:545, longitude:544);
  var location = Location();
  bool loading = false;


  StreamController<UserLocation> _locationController =StreamController<UserLocation>.broadcast();
  Stream<UserLocation> get locationStream => _locationController.stream;

  LocationService() {

    // Request permission to use location
    location.requestPermission().then((granted) {
      if (granted != null) {
        // If granted listen to the onLocationChanged stream and emit over our controller
        location.onLocationChanged().listen((locationData) {
          if (locationData != null) {
            _locationController.add(UserLocation(
              latitude: locationData.latitude,
              longitude: locationData.longitude,
            ));
          }
        });
      }
    });
  }

  Future<UserLocation> getLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = UserLocation(
        latitude: userLocation.latitude,
        longitude: userLocation.longitude,
      );
    } on Exception catch (e) {
      print('Could not get location: ${e.toString()}');
    }
    return _currentLocation;
  }


}

