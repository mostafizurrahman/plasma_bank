import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/models/abstract_person.dart';
import 'package:plasma_bank/network/person_handler.dart';
import 'package:plasma_bank/widgets/base/base_state.dart';
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

class _FilterState extends BaseKeyboardState<FilterWidget> {
  final TextConfig _countryConfig = TextConfig('country');

  final TextConfig _regionConfig = TextConfig('region/state');
  final TextConfig _cityConfig = TextConfig('city/county/division');
  final TextConfig _bloodConfig = TextConfig('blood group');

  bool isDonorFilter;
  @override
  Widget build(BuildContext context) {
//    Navigator.pop(context);
    return super.build(context);
//    return Container(
//      color: Colors.white,
//      child: SafeArea(
//        child: Scaffold(
//          appBar: WidgetProvider.getBackAppBar(context,
//              title: 'FILTER BLOOD DONOR'),
////          backgroundColor: Colors.blueGrey,
//          body: Container(
////            height: 700,
//            width: displayData.width,
////            color: Colors.green,
//            child: SingleChildScrollView(
//              child: ,
//            ),
//          ),
//        ),
//      ),
//    );
  }


  onPersonSet(final Person _loginPerson){

    this._countryConfig.controller.text = _loginPerson.address.country;
    this._code  = _loginPerson.address.code;
    this._regionConfig.controller.text = _loginPerson.address.state;
    this._cityConfig.controller.text = _loginPerson.address.city;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.isDonorFilter = this.widget.getData('is_donor') ?? false;
  }

  @override
  String getActionTitle() {
    // TODO: implement getActionTitle
    if(this.isDonorFilter) {
      return 'SEARCH DONOR';
    }
    return 'SEARCH BLOOD SEEKER';
  }

  @override
  onSubmitData() {
    _startFiltering();
  }
  @override
  String getAppBarTitle() {
    // TODO: implement getAppBarTitle
    if(this.isDonorFilter) {
      return 'FILTER BLOOD DONOR';
    }
    return 'FILTER SEEKERS';
  }

  @override
  Widget getSingleChildContent() {
    final double _contentHeight = super.getContentHeight();
    return Container(
      height: _contentHeight < 720 ? 720 : _contentHeight,
      width: displayData.width,
//      color: Colors.white,
      child: //
          Column(
            children: <Widget>[
              SizedBox(height: 24,),
              Text(
                'You need to enter country, state and locality information to see the specific person list. It will help you to filter out the unnecessary persons.',
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 12,
              ),
              _getCountry(),
              _getRegion(),
              _getCity(),
              SizedBox(height: 24,),

              Text(
                'You can also search or filter persons depending on specific blood group.',
                textAlign: TextAlign.justify,
              ),
              WidgetProvider.bloodGroupWidget(context, _bloodConfig),
              SizedBox(
                height: 12,
              ),

            ],
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
    String _country = this._countryConfig.controller.text;
    if(_country.isEmpty){
      FocusScope.of(context).requestFocus(this._countryConfig.focusNode);
      return;
    }
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
    final _name = this._countryConfig.controller.text;
    if (_name.isEmpty) {
      FocusScope.of(context).requestFocus(_countryConfig.focusNode);
      return;
    }
    WidgetProvider.loading(context);

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
    Navigator.pop(context);
    WidgetProvider.openLocationPopUp(context, _countryList, _onCountrySelected,
        _onPopupClosed, 'PICK YOUR COUNTRY');
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



  _startFiltering() {
//    Navigator.pop(context);
    if (_code == '') {
      WidgetTemplate.message(
          context, 'enter the country, where you are looking for donor/collector!');
      return;
    }
    if (_regionConfig.controller.text.isEmpty) {
      WidgetTemplate.message(
          context, 'enter the region, where you are looking for donor/collector!');
      return;
    }
    if (_cityConfig.controller.text.isEmpty) {
      WidgetTemplate.message(context,
          'enter the city/county, where you are looking for the blood or willing to give blood!');
      return;
    }

    final FilterData _data = FilterData();

    _data.code = _code;
    _data.region =
        LocationProvider.clearCasedPlace(_regionConfig.controller.text);
    _data.city = LocationProvider.clearCasedPlace(_cityConfig.controller.text);
    _data.bloodGroup = _bloodConfig.controller.text;
    Navigator.pushNamed(context, AppRoutes.pageDonorList,
        arguments: {'filter_data': _data, 'is_donor' : this.isDonorFilter, 'is_blood': widget.getData('is_blood')});
//    _onFilterSelected(_data);
  }

  _readCurrentLocation() async {
//    WidgetProvider.loading(context);
//    final _status = await locationProvider.updateLocation();
//    if (_status == GeolocationStatus.denied) {
//      Navigator.pop(context);
//
//      WidgetTemplate.message(context,
//          'location permission is denied! please, go to app settings and provide location permission to create your account.',
//          actionTitle: 'open app settings',
//          actionIcon: Icon(
//            Icons.settings,
//            color: Colors.white,
//          ), onActionTap: () {
//            Navigator.pop(context);
//            AppSettings.openAppSettings();
//          });
//    } else {
//      final _city = locationProvider.gpsCity;
//      if (_city != null) {
//        this._countryConfig.controller.text = _city.fullName ?? '';
//        this._regionConfig.controller.text = _city.regionName ?? '';
//        this._cityConfig.controller.text = _city.cityName ?? '';
//        this._streetConfig.controller.text =
//            _city.street + ", " + _city.subStreet;
//        this._code = _city.countryName;
//        this._zipConfig.controller.text = _city.postalCode ?? '';
//
//      }
//      Navigator.pop(context);
//    }
  }
}
