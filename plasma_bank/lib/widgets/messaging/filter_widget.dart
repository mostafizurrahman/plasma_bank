import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/widgets/base_widget.dart';

class FilterData {
  String bloodGroup;
  //String donationDate;
  String code;
  String region;
  String city;
  String zipCode;
  String fullName;
  String areaName;
  String roadName;
}

class FilterWidget extends BaseWidget {
  FilterWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FilterState();
  }
}

class _FilterState extends State<FilterWidget> {
  final TextConfig _countryConfig = TextConfig('country');

  final TextConfig _regionConfig = TextConfig('region/state');
  final TextConfig _cityConfig = TextConfig('city/county/division');
  final TextConfig _streetConfig = TextConfig('street/locality');
  final TextConfig _zipConfig = TextConfig('zip/po', isDigit: true);
  final TextConfig _bloodConfig = TextConfig('blood group');

  @override
  Widget build(BuildContext context) {

//    Navigator.pop(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: WidgetProvider.getBackAppBar(context,
              title: 'FILTER BLOOD DONOR'),
//          backgroundColor: Colors.blueGrey,
          body: Container(
//            height: 700,
            width: displayData.width,
//            color: Colors.green,
            child: SingleChildScrollView(
              child: Container(
                height: 720,
                width: displayData.width,
                color: Colors.white,
                child: //
                    Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'You need to enter country, state and locality information to see the specific donor list. It will help you to filter out the unnecessary donors.',
                        textAlign: TextAlign.justify,
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      _getCountry(),
                      _getRegion(),
                      _getCity(),
                      _geStreet(),


                      SizedBox(height: 24,),
                      SizedBox(
                        width: displayData.width - 48,
                        height: 45,
                        child: RaisedButton(
                          color: AppStyle.theme(),
                          onPressed: _readCurrentLocation,
                          child: Text(
                            'READ MY CURRENT LOCATION',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 12, ),
                        child: Divider(),
                      ),


                      SizedBox(height: 24,),
                      Text(
                        'You can also search or filter donor depending on specific blood group.',
                        textAlign: TextAlign.justify,
                      ),

                      WidgetTemplate.getTextField(
                        _bloodConfig,
                        maxLen: 15,
                        isReadOnly: true,
                        onTap: () {
                          List _data = [
                            'A+',
                            'B+',
                            'AB+',
                            'O+',
                            'A-',
                            'B-',
                            'AB-',
                            'O-'
                          ];
                          WidgetProvider.openLocationPopUp(
                              context,
                              _data,
                              (_data) => _bloodConfig.controller.text =
                                  _data.toString(),
                              _onPopupClosed,
                              'SELECT BLOOD GROUP');
                        },
                      ),
                      SizedBox(height: 12,),
                      SizedBox(
                        width: displayData.width - 48,
                        height: 45,
                        child: RaisedButton(
                          color: AppStyle.theme(),
                          onPressed: _startFiltering,
                          child: Text(
                            'SEARCH DONOR',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getRegion() {
    return WidgetTemplate.getTextField(_regionConfig, onTap: _openRegionList);
  }

  Widget _getCity() {
    return WidgetTemplate.getTextField(_cityConfig, onTap: _openCityList);
  }

  _openCityList() async {
    String _state = this._regionConfig.controller.text.toLowerCase();
    if (_state.isEmpty) {
      FocusScope.of(context).requestFocus(this._regionConfig.focusNode);
      return;
    }

    WidgetProvider.loading(context);
    _state = LocationProvider.clearPlace(_state);

    final _region = Region(countryName: _code, regionName: _state);
    _state = _state.toUpperCase();
    final _dataList = await locationProvider.getCityList(_region);
    Navigator.pop(context);
    if (_dataList != null) {
      Future.delayed(
        Duration(milliseconds: 100),
        () {
          WidgetProvider.openLocationPopUp(context, _dataList, _onCitySelected,
              _onPopupClosed, "PLACE OF $_state");
        },
      );
    }
  }

  _openRegionList() async {
    WidgetProvider.loading(context);
    final _name = this._countryConfig.controller.text;

    final Country _country = Country(countryName: _name, countryCode: _code);
    final _originList = await locationProvider.getRegionList(_country);
    Navigator.pop(context);
    if (_originList != null) {
      Future.delayed(
        Duration(milliseconds: 100),
        () {
          WidgetProvider.openLocationPopUp(context, _originList,
              _onRegionSelected, _onPopupClosed, "PLACE OF $_name");
        },
      );
    }
  }

  Widget _getCountry() {
    return WidgetTemplate.getTextField(
      this._countryConfig,
      onTap: _openCountryList,
    );
  }

  _openCountryList() async {
    WidgetProvider.loading(context);
    final _countryList =
        await locationProvider.getCountryList().catchError((_error) {
      return null;
    });
    WidgetProvider.openLocationPopUp(context, _countryList, _onCountrySelected,
        _onPopupClosed, 'PICK YOUR COUNTRY');
    Navigator.pop(context);
  }

  String _code = '';
  _onCountrySelected(final _data) {
    if (_data is Country) {
      this._countryConfig.controller.text = _data.countryName;
      this._code = _data.countryCode.toUpperCase();
      this._regionConfig.controller.text = '';
      this._cityConfig.controller.text = '';
//      this._streetConfig.controller.text = '';
//      this._zipConfig.controller.text = '';
    }
  }

  _onRegionSelected(final _data) {
    if (_data is Region) {
      this._regionConfig.controller.text = _data.regionName;
      this._cityConfig.controller.text = '';
//      this._streetConfig.controller.text = '';
//      this._zipConfig.controller.text = '';
    }
  }

  _onCitySelected(final _data) {
    if (_data is City) {
      this._cityConfig.controller.text = _data.cityName;
//      this._streetConfig.controller.text = '';
//      this._zipConfig.controller.text = '';
    }
  }

  _onPopupClosed() {}

  Widget _geStreet() {
    return Row(
      children: [
        Expanded(
          child: WidgetTemplate.getTextField(
            this._streetConfig,
            isReadOnly: false,
            showCursor: true,
            maxLen: 50,
          ),
        ),
        SizedBox(
          width: AppStyle.PADDING_S,
        ),

        //locationProvider.gpsCity
        Container(
          width: 60,
          child: WidgetTemplate.getTextField(
            this._zipConfig,
            isReadOnly: false,
            showCursor: true,
          ),
        ),
      ],
    );
  }

  _startFiltering() {
//    Navigator.pop(context);
    if (_code == '') {
      WidgetTemplate.message(
          context, 'enter the country, where you are looking for the blood!');
      return;
    }
    if (_regionConfig.controller.text.isEmpty) {
      WidgetTemplate.message(
          context, 'enter the region, where you are looking for the blood!');
      return;
    }
    if (_cityConfig.controller.text.isEmpty) {
      WidgetTemplate.message(context,
          'enter the city/county, where you are looking for the blood!');
      return;
    }

    final FilterData _data = FilterData();

    _data.code = _code;
    _data.region =
        LocationProvider.clearCasedPlace(_regionConfig.controller.text);
    _data.city = _cityConfig.controller.text;
    _data.zipCode = _zipConfig.controller.text;
    _data.bloodGroup = _bloodConfig.controller.text;
    _data.areaName = _streetConfig.controller.text;
    Navigator.pushNamed(context, AppRoutes.pageDonorList,
        arguments: {'filter_data': _data});
//    _onFilterSelected(_data);
  }

  _readCurrentLocation() async {
    WidgetProvider.loading(context);
    final _status = await locationProvider.updateLocation();
    if (_status == GeolocationStatus.denied) {
      Navigator.pop(context);

      WidgetTemplate.message(context,
          'location permission is denied! please, go to app settings and provide location permission to create your account.',
          actionTitle: 'open app settings',
          actionIcon: Icon(
            Icons.settings,
            color: Colors.white,
          ), onActionTap: () {
            Navigator.pop(context);
            AppSettings.openAppSettings();
          });
    } else {
      final _city = locationProvider.gpsCity;
      if (_city != null) {
        this._countryConfig.controller.text = _city.fullName ?? '';
        this._regionConfig.controller.text = _city.regionName ?? '';
        this._cityConfig.controller.text = _city.cityName ?? '';
        this._streetConfig.controller.text =
            _city.street + ", " + _city.subStreet;
        this._code = _city.countryName;
        this._zipConfig.controller.text = _city.postalCode ?? '';

      }
      Navigator.pop(context);
    }

  }
}
