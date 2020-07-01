import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plasma_bank/network/api_client.dart';
import 'package:plasma_bank/network/auth.dart';
//import 'package:restcountries/restcountries.dart';

class LocationProvider {
  final _geoLocator = Geolocator();

  GeolocationStatus _geolocationStatus;
  GeolocationStatus get status => _geolocationStatus;
  Placemark _place;
  Placemark get place => _place;

  City gpsCity;

  Future<GeolocationStatus> updateLocation() async {
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
          final _map = {
            'country': _mark.isoCountryCode ?? 'bd',
            'region': _mark.administrativeArea ?? '',
            'city': _mark.subAdministrativeArea ?? '',
            'latitude': _mark.position.latitude,
            'longitude': _mark.position.longitude,
          };

          final _city = City.fromJson(_map);
          _city.postalCode = _mark.postalCode;
          _city.fullName = _mark.country;
          _city.street = _mark.thoroughfare;
          _city.subStreet = _mark.subThoroughfare;
          this.gpsCity = _city;
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

    return _status;
  }

  static final _location = LocationProvider._internal();
  LocationProvider._internal();
  factory LocationProvider() {
    return _location;
  }

  Future<List<Country>> getCountryList() async {
    final _client = ApiClient();
    final String _url = this.getUrl();
    final _response = await _client.getGlobList(_url);
    return _response;
  }

  Future<List<Country>> getRegionList(final Country country) async {
    final _client = ApiClient();
    final String _url = this.getUrl(country: country);
    final _response = await _client.getGlobList(_url, region: true);
    return _response;
  }

  Future<List<Country>> getCityList(final Region region) async {
    final _client = ApiClient();
    final String _url = this.getUrl(region: region);
    final _response = await _client.getGlobList(_url, city: true);
    return _response;
  }

  String getUrl({Region region, Country country}) {
    final _key = Auth.RegionKey;
    if (country != null) {
      return "http://battuta.medunes.net/api/region/${country.countryCode}/all/?key=$_key";
    }
    if (region != null) {
      return "http://battuta.medunes.net/api/city/${region.countryName}/search/?region=${region.regionName}&key=$_key";
    }
    return "http://battuta.medunes.net/api/country/all/?key=$_key";
  }
}

final LocationProvider locationProvider = LocationProvider();

class Country {
  final String countryName;
  final String countryCode;
  Country({this.countryName, this.countryCode});
  factory Country.fromJson(Map<String, dynamic> _json) {
    return Country(
      countryCode: _json['code'],
      countryName: _json['name'],
    );
  }
}

class Region {
  final String countryName;
  final String regionName;
  Region({this.countryName, this.regionName});
  factory Region.fromJson(Map<String, dynamic> _json) {
    return Region(
      regionName: _json['region'],
      countryName: _json['country'],
    );
  }
}

class City {
  String street;
  String subStreet;
  String postalCode;
  String fullName;
  final String countryName;
  final String regionName;
  final String cityName;
  final double latitude;
  final double longitude;

  City(
      {this.countryName,
      this.regionName,
      this.cityName,
      this.latitude,
      this.longitude});
  factory City.fromJson(Map<String, dynamic> _json) {
    return City(
      regionName: _json['region'],
      countryName: _json['country'],
      cityName: _json['city'],
      latitude: _json['latitude'],
      longitude: _json['longitude'],
    );
  }
}
