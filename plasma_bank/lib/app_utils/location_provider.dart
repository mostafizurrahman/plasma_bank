import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider {
  final _geoLocator = Geolocator();

  GeolocationStatus _geolocationStatus;
  GeolocationStatus get status => _geolocationStatus;
  Placemark _place;
  Placemark get place => _place;
//  set Position(final _value){
//    this._position = _value;
//  }
  updateLocation() async {
    var _status = await _geoLocator.checkGeolocationPermissionStatus();
    this._geolocationStatus = _status;
    if (_status == GeolocationStatus.granted ||
        _status == GeolocationStatus.unknown) {
      final _position = await _geoLocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      if (_position != null) {
        List<Placemark> _placeMark = await _geoLocator.placemarkFromCoordinates(
            _position.latitude, _position.longitude);
        for (var _mark in _placeMark) {
          this._place = _mark;
          debugPrint(_mark.country);
          debugPrint(_mark.postalCode);
          debugPrint(_mark.name);
          debugPrint(_mark.thoroughfare);
          debugPrint(_mark.isoCountryCode);
          debugPrint(_mark.administrativeArea);
          debugPrint(_mark.subLocality);
          break;
        }
      }
    }
  }

  static final _location = LocationProvider._internal();
  LocationProvider._internal();
  factory LocationProvider() {
    return _location;
  }
}

final LocationProvider locationProvider = LocationProvider();
