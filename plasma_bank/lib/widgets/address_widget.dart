import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import '../widgets/base_widget.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/base/base_state.dart';

class AddressWidget extends BaseWidget {
  AddressWidget(Map arguments) : super(arguments);
  @override
  State<StatefulWidget> createState() {
    return _AddressState();
  }
}

class _AddressState extends BaseKeyboardState<AddressWidget> {
  bool skipPopup = false;
  final TextConfig _countryConfig = TextConfig('country');

  final TextConfig _countryCodeConfig = TextConfig('code');
  final TextConfig _regionConfig = TextConfig('region/state');
  final TextConfig _cityConfig = TextConfig('city/county/division');
  final TextConfig _streetConfig = TextConfig('street/locality', maxLen: 100);
  final TextConfig _zipConfig = TextConfig('zip/po', isDigit: true, maxLen: 6);
  final TextConfig _houseConfig = TextConfig('house/other', maxLen: 75);

  @override
  void initState() {
    super.initState();
    _setLocation();
  }

  _setLocation() {
    final _city = locationProvider.gpsCity;
    if (_city != null) {
      this._countryConfig.controller.text = _city.fullName ?? '';
      this._countryCodeConfig.controller.text = _city.countryName ?? '';
      this._regionConfig.controller.text = _city.regionName ?? '';
      this._cityConfig.controller.text = _city.cityName ?? '';
      this._streetConfig.controller.text =
          _city.street + ", " + _city.subStreet;
      this._zipConfig.controller.text = _city.postalCode ?? '';
      this._houseConfig.controller.text = _city.house ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    skipPopup = false;
    return super.build(context);
  }

  _errorMessage(final TextConfig _config) {
    super.setError(_config);
  }

  _onError(final _error) {
    this.skipPopup = false;
  }

  @override
  onSubmitData() async {
    WidgetProvider.loading(context);
    FocusScope.of(context).requestFocus(FocusNode());

    bool popLoading = true;
    final _zip = this._zipConfig.controller.text;
    final _countryCode = this._countryCodeConfig.controller.text;

    final _country = this._countryConfig.controller.text;
    final _state = this._regionConfig.controller.text;
    final _city = this._cityConfig.controller.text;
    final _road = this._streetConfig.controller.text;
    final _house = this._houseConfig.controller.text;
    if (_country.isEmpty) {
      _errorMessage(this._countryConfig);
    } else if (_state.isEmpty) {
      _errorMessage(this._regionConfig);
    } else if (_city.isEmpty) {
      _errorMessage(this._cityConfig);
    } else if (_road.isEmpty) {
      _errorMessage(_streetConfig);
    } else if (_zip.isEmpty) {
      _errorMessage(_zipConfig);
    } else if (_house.isEmpty) {
      _errorMessage(_houseConfig);
    } else {
      final _zipData = await locationProvider
          .getZipData(_zip, _countryCode)
          .catchError(_onError);
      final _addressMap = {
        'country': _country,
        'code': _countryCode,
        'state': LocationProvider.clearCasedPlace(_state),
        'city': _city,
        'street': _road,
        'zip': _zip,
        'house': _house,
        'is_valid_postal': _zipData != null,
      };

//        final _address = Address.fromMap(_addressMap);
      popLoading = false;
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        AppRoutes.pagePersonData,
        arguments: {'address': _addressMap},
      );
    }
    if (popLoading) {
      Navigator.pop(context);
    }
  }

  _onChangedStreet(String value) {}

  _onChangedZip(String value) {}

  Widget _geStreet() {
    return Row(
      children: [
        Expanded(
          child: WidgetTemplate.getCustomTextField(
            this._streetConfig,
            () => super.onTextFieldTapped(this._streetConfig),
          ),
        ),
        SizedBox(
          width: AppStyle.PADDING_S,
        ),

        //locationProvider.gpsCity
        Container(
          width: 65,
          child: WidgetTemplate.getCustomTextField(
            this._zipConfig,
            () => super.onTextFieldTapped(this._zipConfig),
          ),
        ),
      ],
    );
  }

  Widget _getCity() {
    return WidgetTemplate.getTextField(_cityConfig, onTap: _openCityList);
  }

  Widget _getRegion() {
    return WidgetTemplate.getTextField(_regionConfig, onTap: _openRegionList);
  }

  Widget _getCountry() {
    return Row(
      children: [
        Expanded(
          child: WidgetTemplate.getTextField(
            this._countryConfig,
            onTap: _openCountryList,
          ),
        ),
        SizedBox(
          width: AppStyle.PADDING_S,
        ),
        Container(
          width: 60,
          child: WidgetTemplate.getTextField(this._countryCodeConfig,
              isReadOnly: true),
        ),
      ],
    );
  }

  _openCountryList() {
    if (this.skipPopup) return;
    this.skipPopup = true;
    final _countryList = this.widget.getData('country_list');
    WidgetProvider.openLocationPopUp(context, _countryList, _onCountrySelected,
        _onPopupClosed, 'PICK YOUR COUNTRY');
  }

  _openRegionList() async {
    WidgetProvider.loading(context);
    final _name = this._countryConfig.controller.text;
    final _code = this._countryCodeConfig.controller.text;
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

  _openCityList() async {
    final _code = this._countryCodeConfig.controller.text;
    String _state = this._regionConfig.controller.text.toLowerCase();
    if (_state.isEmpty) {
      FocusScope.of(context).requestFocus(this._regionConfig.focusNode);
      return;
    }

    WidgetProvider.loading(context);
    _state = LocationProvider.clearPlace(_state);

    final _region = Region(countryName: _code, regionName: _state);
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

  _onCountrySelected(final _data) {
    this.skipPopup = false;
    if (_data is Country) {
      this._countryConfig.controller.text = _data.countryName;
      this._countryCodeConfig.controller.text = _data.countryCode.toUpperCase();
      this._regionConfig.controller.text = '';
      this._cityConfig.controller.text = '';
//      this._streetConfig.controller.text = '';
//      this._zipConfig.controller.text = '';
    }
  }

  _onPopupClosed() {
    this.skipPopup = false;
//    FocusScope.of(context).requestFocus(FocusNode());
  }

  ///OVERRIDEN METHODS

  @override
  String getAppBarTitle() {
    return 'Address';
  }

  @override
  List<Widget> getLeftActionItems() {
    return [
      Padding(
        padding: EdgeInsets.only(right: AppStyle.PADDING),
        child: GestureDetector(
          onTap: _setLocation,
          child: Icon(
            Icons.refresh,
            color: AppStyle.theme(),
            size: AppStyle.ICON_SIZE_S,
          ),
        ),
      ),
    ];
  }

  @override
  Widget getSingleChildContent() {
    return Container(
      height: super.getContentHeight(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 24, bottom: 12),
            child: Row(
              children: [
                WidgetProvider.circledIcon(
                  Icon(
                    Icons.place,
                    color: AppStyle.theme(),
                    size: 25,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  'ENTER ADDRESS',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: AppStyle.fontBold,
                  ),
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          ),
          _getCountry(),
          _getRegion(),
          _getCity(),
          _geStreet(),
          WidgetTemplate.getCustomTextField(
            this._houseConfig,
                () => super.onTextFieldTapped(this._houseConfig),
          ),
        ],
      ),
    );
  }
}
