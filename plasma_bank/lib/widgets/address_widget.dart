import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/models/abstract_person.dart';
import '../widgets/base_widget.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/stateful/data_picker_widget.dart';
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
  final TextConfig _streetConfig = TextConfig('street/locality');
  final TextConfig _zipConfig = TextConfig('zip/po', isDigit: true);
  final TextConfig _houseConfig = TextConfig('house/other');

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
    FocusScope.of(context).requestFocus(FocusNode());
    if (this.skipPopup) {
      return;
    }
    skipPopup = true;
    final _zip = this._zipConfig.controller.text;
    final _countryCode = this._countryCodeConfig.controller.text;

    Future.delayed(Duration(seconds: 1), () async {
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
          'state': _state,
          'city': _city,
          'street': _road,
          'zip': _zip,
          'house': _house,
          'is_valid_postal' : _zipData != null,
        };

//        final _address = Address.fromMap(_addressMap);

        Navigator.pushNamed(
          context,
          AppRoutes.pagePersonData,
          arguments: {'address': _addressMap},
        );
      }
      skipPopup = false;
    });
  }

  _onChangedStreet(String value) {}

  _onChangedZip(String value) {}

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
    this._openPopUp(
        _countryList, _onCountrySelected, _onPopupClosed, 'PICK YOUR COUNTRY');
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
          this._openPopUp(_originList, _onRegionSelected, _onPopupClosed,
              "PLACE OF $_name");
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
    _state = this._clearPlace(_state);

    final _region = Region(countryName: _code, regionName: _state);
    final _dataList = await locationProvider.getCityList(_region);
    Navigator.pop(context);
    if (_dataList != null) {
      Future.delayed(
        Duration(milliseconds: 100),
        () {
          this._openPopUp(
              _dataList, _onCitySelected, _onPopupClosed, "PLACE OF $_state");
        },
      );
    }
  }

  _onRegionSelected(final _data) {
    if (_data is Region) {
      this._regionConfig.controller.text = _data.regionName;
      this._cityConfig.controller.text = '';
      this._streetConfig.controller.text = '';
      this._zipConfig.controller.text = '';
    }
  }

  _onCitySelected(final _data) {
    if (_data is City) {
      this._cityConfig.controller.text = _data.cityName;
      this._streetConfig.controller.text = '';
      this._zipConfig.controller.text = '';
    }
  }

  _onCountrySelected(final _data) {
    this.skipPopup = false;
    if (_data is Country) {
      this._countryConfig.controller.text = _data.countryName;
      this._countryCodeConfig.controller.text = _data.countryCode.toUpperCase();
      this._regionConfig.controller.text = '';
      this._cityConfig.controller.text = '';
      this._streetConfig.controller.text = '';
      this._zipConfig.controller.text = '';
    }
  }

  _onPopupClosed() {
    this.skipPopup = false;
//    FocusScope.of(context).requestFocus(FocusNode());
  }

  _openPopUp(final _data, final _selected, final _closed, final _title) {
    Future.delayed(
      Duration(
        milliseconds: 100,
      ),
      () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => Material(
            color: Colors.transparent,
            type: MaterialType.card,
            child: WillPopScope(
              onWillPop: () async {
                return Future<bool>.value(false);
              },
              child: DataPickerWidget(
                _data,
                _selected,
                _closed,
                picketTitle: _title,
              ),
            ),
          ),
        );
      },
    );
  }

  String _clearPlace(String _place) {
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
          WidgetTemplate.getTextField(
            this._houseConfig,
            maxLen: 30,
            isReadOnly: false,
            showCursor: true,
          ),
        ],
      ),
    );
  }
}
