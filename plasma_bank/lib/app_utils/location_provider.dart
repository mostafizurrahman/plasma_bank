import 'dart:convert';

import 'package:flutter/cupertino.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:plasma_bank/network/api_client.dart';
import 'package:plasma_bank/network/auth.dart';
import 'package:plasma_bank/network/models/zip_data.dart';

import '../network/auth.dart';
//import 'package:restcountries/restcountries.dart';

class LocationProvider {
//  final _geoLocator = Geolocator();

//  GeolocationStatus _geolocationStatus;
//  GeolocationStatus get status => _geolocationStatus;
//  Placemark _place;
//  Placemark get place => _place;

  City gpsCity;
//
//  Future<GeolocationStatus> updateLocation() async {
//    var _status = await _geoLocator.checkGeolocationPermissionStatus();
//    this._geolocationStatus = _status;
//    if (_status == GeolocationStatus.granted ||
//        _status == GeolocationStatus.unknown) {
//      final _position = await _geoLocator.getCurrentPosition(
//          desiredAccuracy: LocationAccuracy.medium);
//      if (_position != null) {
//        List<Placemark> _placeMark = await _geoLocator
//            .placemarkFromCoordinates(_position.latitude, _position.longitude)
//            .catchError((final _error) {
//          debugPrint('why');
//          return null;
//        });
//        if (_placeMark == null) {
//          return GeolocationStatus.unknown;
//        }
//        final _mark = _placeMark.first;
//        String _state = _mark.administrativeArea ?? "";
//        if (_state != null) {
//          if (_state.length == 2) {
//            _state = Region._getUSState(
//                _state, (_mark.isoCountryCode ?? "bd").toUpperCase());
//          }
//        }
//        if (_mark != null) {
//          this._place = _mark;
//          final _map = {
//            'country': _mark.isoCountryCode ?? 'bd',
//            'region': _state,
//            'city': _mark.subAdministrativeArea ?? '',
//            'latitude': _mark.position.latitude ?? '0',
//            'longitude': _mark.position.longitude ?? '0',
//          };
//
//          final _city = City.fromJson(_map);
//          _city.postalCode = _mark.postalCode;
//          _city.fullName = _mark.country;
//          _city.street = _mark.thoroughfare;
//          _city.subStreet = _mark.subThoroughfare;
//          _city.house = _mark.subLocality;
//          this.gpsCity = _city;
//          debugPrint(_mark.country);
//          debugPrint(_mark.postalCode);
//          debugPrint(_mark.name);
//          debugPrint(_mark.thoroughfare);
//          debugPrint(_mark.isoCountryCode);
//          debugPrint(_mark.administrativeArea);
//          debugPrint(_mark.subLocality);
//        }
//      }
//    }
//
//    return _status;
//  }

  static final _location = LocationProvider._internal();
  LocationProvider._internal();
  factory LocationProvider() {
    return _location;
  }

  final List<Country> _countryList = List();
  Future<List<Country>> getCountryList() async {
    if (_countryList.length > 0) {
      return _countryList;
    }
    final _client = ApiClient();
    final String _url = this.getUrl();
    final List _data = await _client.getGlobList(_url);
    if (_data == null) {
      final String _url = this.getUrl(isNext: true);
      final List _nextData = await _client.getGlobList(_url);
      if(_nextData != null){
        for (final _item in _nextData) {
          Country _c = tryCast(_item);
          _countryList.add(_c);
        }
        return _countryList;
      }
      return List<Country>();
    }
    for (final _item in _data) {
      Country _c = tryCast(_item);
      _countryList.add(_c);
    }
    return _countryList;
  }




  Map<String, List<Region>> _regionMap = Map();

  Future<List<Region>> getRegionList(final Country country) async {

    if(_regionMap != null && _regionMap.isNotEmpty){
      if(_regionMap.keys.contains(country.countryCode)){
        return _regionMap[country.countryCode];
      }
    }
    final _client = ApiClient();
    final String _url = this.getUrl(country: country);
    final _response = await _client.getGlobList(_url, region: true);
    final List<Region> _data = List();
    if (_response == null) {
      final String _url = this.getUrl(country: country, isNext: true);
      final List _nextData = await _client.getGlobList(_url, region: true);
      if(_nextData != null){
        for (final _item in _nextData) {
          Region _c = tryCast(_item);
          _data.add(_c);
        }
        if(_data.isNotEmpty){
          _regionMap[country.countryCode] = _data;
        }
        return _data;
      }
    }
    for (final _item in _response) {
      Region _c = tryCast(_item);
      _data.add(_c);
    }
    if(_data.isNotEmpty){
      _regionMap[country.countryCode] = _data;
    }
    return _data;
  }

  T tryCast<T>(dynamic x, {T fallback}) {
    try {
      return (x as T);
    } on CastError catch (e) {
      print('CastError when trying to cast $x to $T!');
      return fallback;
    }
  }


  Map<String, List<City>> _cityMap = Map();

  Future<List<City>> getCityList(final Region region) async {
    String _regionName = "${region.countryName}_${region.regionName}";
    if(_cityMap != null && _cityMap.isNotEmpty){
      if(_cityMap.keys.contains(_regionName)){
        return _cityMap[_regionName];
      }
    }
    final _client = ApiClient();
    final String _url = this.getUrl(region: region);
    final _response = await _client.getGlobList(_url, city: true);
    //check the list empty or not
    final _cityList = List<City>();
    if (_response == null || _response.isEmpty) {
      final String _url = this.getUrl(region: region, isNext: true);
      final List _nextData = await _client.getGlobList(_url, city: true);
      if(_nextData != null){
        for (final _item in _nextData) {
          City _c = tryCast(_item);
          _cityList.add(_c);
        }
        if(_cityList.isNotEmpty){
          _cityMap[_regionName] = _cityList;
        }
        return _cityList;
      }
      return _cityList;
    } else {
      for (final _item in _response) {
        City _c = tryCast(_item);
        _cityList.add(_c);
      }
    }
    if(_response.isNotEmpty){
      _cityMap[_regionName] = _response;
    }
    return _cityList;
  }

  String getUrl({Region region, Country country, bool isNext = false}) {
    final _key = isNext ? Auth.RegionKey_1 : Auth.RegionKey;
    if (country != null) {
      return "http://battuta.medunes.net/api/region/${country.countryCode}/all/?key=$_key";
    }
    if (region != null) {
      return "http://battuta.medunes.net/api/city/${region.countryName}/search/?region=${region.regionName}&key=$_key";
    }
    return "http://battuta.medunes.net/api/country/all/?key=$_key";
  }

  Future<ZipData> getZipData(final String zipCode, String countryCode) async {
    // verify required params are set

    // create path and map variables
    String path =
        "https://community-zippopotamus.p.rapidapi.com/$countryCode/$zipCode";

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {
      "x-rapidapi-host": "community-zippopotamus.p.rapidapi.com",
      "x-rapidapi-key": Auth.ZIP_KEY,
    };
    Map<String, String> formParams = {};

    String contentType = "application/json";
    List<String> authNames = [];
    final _client = ApiClient();
    var response = await _client.invokeAPI(path, 'GET', queryParams, null,
        headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      final map = json.decode(response.body);
      if (map is Map) {
        return _client.deserialize(response.body, 'ZipData') as ZipData;
      }
    }
    return null;
  }

  static String clearPlace(String _place) {
    String _state = _place;

    if (_state.contains('union state of')) {
      _state = _state.toLowerCase().replaceAll('union state of', '');
    }
    if (_state.contains('state of')) {
      _state = _state.toLowerCase().replaceAll('state of', '');
    }

    if (_state.contains('state')) {
      _state = _state.toLowerCase().replaceAll('state', '');
    }
    if (_state.contains('province')) {
      _state = _state.toLowerCase().replaceAll('province', '');
    }
    if (_state.contains('division')) {
      _state = _state.replaceAll('division', '');
    }
    if (_state.contains('district')) {
      _state = _state.replaceAll('district', '');
    }
    return _state;
  }

  static String clearCasedPlace(String _place) {
    if (_place.contains('Union State Of ')) {
      return _place.replaceAll('Union State Of', '');
    }
    if (_place.contains('Union State of ')) {
      return _place.replaceAll('Union State of', '');
    }

    if (_place.contains('District Of ')) {
      return _place.replaceAll('District Of', '');
    }
    if (_place.contains('District of ')) {
      return _place.replaceAll('District of', '');
    }
    if (_place.contains('District ')) {
      return _place.replaceAll('District ', '');
    }
    if (_place.contains(' District')) {
      return _place.replaceAll(' District', '');
    }
    if (_place.contains('State Of ')) {
      return _place.replaceAll('State Of ', '');
    }
    if (_place.contains('State of ')) {
      return _place.replaceAll('State of ', '');
    }
    if (_place.contains('State ')) {
      return _place.replaceAll('State ', '');
    }
    if (_place.contains(' State')) {
      return _place.replaceAll(' State', '');
    }
    if (_place.contains('Division Of ')) {
      return _place.replaceAll('Division Of ', '');
    }
    if (_place.contains('Division of')) {
      return _place.replaceAll('Division of ', '');
    }
    if (_place.contains('Division ')) {
      return _place.replaceAll('Division ', '');
    }
    if (_place.contains(' Division')) {
      return _place.replaceAll(' Division', '');
    }

//    if(_place.contains('state')){
//      return _place.replaceAll('Union State Of', '');
//    }if(_place.contains('Union State Of')){
//      return _place.replaceAll('Union State Of', '');
//    }
//    if(_place.contains('Union State Of')){
//      return _place.replaceAll('Union State Of', '');
//    }
//    if(_place.contains('Union State Of')){
//      return _place.replaceAll('Union State Of', '');
//    }
//    if(_place.contains('Union State Of')){
//      return _place.replaceAll('Union State Of', '');
//    }

    return _place;
  }
}

final LocationProvider locationProvider = LocationProvider();

class Country {
  final String countryName;
  final String countryCode;
  String flag = '';
  Country({this.countryName, this.countryCode});
  factory Country.fromJson(Map<String, dynamic> _json) {
    final _country = Country(
      countryCode: _json['code'],
      countryName: _json['name'],
    );
    _country._setFlag();
    return _country;
  }

  _setFlag() {
    int base = 127397;
    List<int> units = List();

    for (final _data in this.countryCode.toUpperCase().codeUnits) {
      units.add(_data + base);
    }
    this.flag = String.fromCharCodes(units);
    debugPrint(this.flag);
  }
}

class Region {
  final String countryName;
  final String regionName;
  Region({this.countryName, this.regionName});

  factory Region.fromJson(Map<String, dynamic> _json) {
    String _region = _json['region'];
    String _country = _json['country'];

    if (_region.length == 2) {
      _region = Region._getUSState(_region, _country);
    }
    return Region(
      regionName: _region,
      countryName: _country,
    );
  }

  static String _getUSState(final regionName, final String country) {
    if (country.toUpperCase() == 'US') {
      final _map = {
        'Alabama': 'AL',
        'Alaska': 'AK',
        'Arizona': 'AZ',
        'Arkansas': 'AR',
        'California': 'CA',
        'Colorado': 'CO',
        'Connecticut': 'CT',
        'Delaware': 'DE',
        'Florida': 'FL',
        'Georgia': 'GA',
        'Hawaii': 'HI',
        'Idaho': 'ID',
        'Illinois': 'IL',
        'Indiana': 'IN',
        'Iowa': 'IA',
        'Kansas': 'KS',
        'Kentucky': 'KY',
        'Louisiana': 'LA',
        'Maine': 'ME',
        'Maryland': 'MD',
        'Massachusetts': 'MA',
        'Michigan': 'MI',
        'Minnesota': 'MN',
        'Mississippi': 'MS',
        'Missouri': 'MO',
        'Montana': 'MT',
        'Nebraska': 'NE',
        'Nevada': 'NV',
        'New Hampshire': 'NH',
        'New Jersey': 'NJ',
        'New Mexico': 'NM',
        'New York': 'NY',
        'North Carolina': 'NC',
        'North Dakota': 'ND',
        'Ohio': 'OH',
        'Oklahoma': 'OK',
        'Oregon': 'OR',
        'Pennsylvania': 'PA',
        'Rhode Island': 'RI',
        'South Carolina': 'SC',
        'South Dakota': 'SD',
        'Tennessee': 'TN',
        'Texas': 'TX',
        'Utah': 'UT',
        'Vermont': 'VT',
        'Virginia': 'VA',
        'Washington': 'WA',
        'West Virginia': 'WV',
        'Wisconsin': 'WI',
        'Wyoming': 'WY',
      };
      String _data = regionName;
      _map.forEach((key, value) {
        if (value == regionName) {
          _data = key;
        }
      });
      return _data;
    }
    return regionName;
  }
}

class City {
  String street;
  String house;
  String subStreet;
  String postalCode;
  String fullName;
  final String countryName;
  final String regionName;
  final String cityName;
  final String latitude;
  final String longitude;

  City(
      {this.countryName,
      this.regionName,
      this.cityName,
      this.latitude,
      this.longitude});
  factory City.fromJson(Map<String, dynamic> _json) {
    final _city = City(
      regionName: _json['region'],
      countryName: _json['country'],
      cityName: _json['city'],
      latitude: _json['latitude'].toString(),
      longitude: _json['longitude'].toString(),
    );
    return _city;
  }
}
