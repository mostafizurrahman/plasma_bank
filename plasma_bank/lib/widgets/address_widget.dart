import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import '../widgets/base_widget.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/stateful/data_picker_widget.dart';

class AddressWidget extends BaseWidget {
  AddressWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    return _AddressState();
  }
}

class _AddressState extends State<AddressWidget> {
  bool skipPopup = false;

//  final TextEditingController _zipController = TextEditingController();
  final TextConfig _countryConfig = TextConfig('country');

  final TextConfig _countryCodeConfig = TextConfig('code');
  final TextConfig _regionConfig = TextConfig('region/state');
  final TextConfig _cityConfig = TextConfig('city/county/division');
  final TextConfig _streetConfig = TextConfig('street/locality');
  final TextConfig _zipConfig = TextConfig('zip/po');
  final TextConfig _houseConfig = TextConfig('house/other');
  ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    _setLocation();
  }

  _setLocation() {
    final _city = locationProvider.gpsCity;
    this._countryConfig.controller.text = _city.fullName;
    this._countryCodeConfig.controller.text = _city.countryName;
    this._regionConfig.controller.text = _city.regionName;
    this._cityConfig.controller.text = _city.cityName;
    this._streetConfig.controller.text = _city.street + ", " + _city.subStreet;
    this._zipConfig.controller.text = _city.postalCode;
  }

  @override
  Widget build(BuildContext context) {
    final _padding = MediaQuery.of(context).padding.bottom;
    final _width = MediaQuery.of(context).size.width;
    debugPrint(_padding.toString());

//    Navigator.pop(context);
    return Container(
      color: AppStyle.greyBackground(),
      child: Padding(
        padding: EdgeInsets.only(bottom: _padding),
        child: Scaffold(
          appBar: WidgetProvider.appBar('Address', actions: [
            Padding(
              padding: EdgeInsets.only(right: 24.0),
              child: GestureDetector(
                onTap: _setLocation,
                child: Icon(
                  Icons.refresh,
                  color: AppStyle.theme(),
                  size: 26.0,
                ),
              ),
            ),
          ]),
          body: Container(
            width: _width,
//            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Container(
                height: 470,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
//                    color: Colors.blueAccent,
                    height: 570,
                    width: _width - _padding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 32, bottom: 32),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                          ),
                        ),
                        _getCountry(),
                        _getRegion(),
                        _getCity(),
                        _geStreet(),
                        WidgetTemplate.getTextField(this._houseConfig,
                            maxLen: 30,
                            isReadOnly: false,
                            showCursor: true, onTap: () {
                          if(this._scrollController.offset == 0.0){
                            Future.delayed(Duration(seconds: 1), () {
                              _scrollController.animateTo(150.0,
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            });
                          }
                        }, onEditingDone: () {
                          Future.delayed(Duration(seconds: 1), () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _scrollController.animateTo(0.0,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease);
                          });
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: WidgetProvider.button(
            _saveAddress,
            "NEXT",
            context,
          ),
        ),
      ),
    );
  }

  _saveAddress() {}

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
            onTap: () {
              if(this._scrollController.offset == 0.0){
                Future.delayed(Duration(seconds: 1), () {
                  _scrollController.animateTo(150.0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                });
              }
            },
            onEditingDone: () {
              Future.delayed(Duration(seconds: 1), () {
                FocusScope.of(context).requestFocus(FocusNode());
                _scrollController.animateTo(0.0,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              });
            },
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
            onTap: () {
              if(this._scrollController.offset == 0.0){
                Future.delayed(Duration(seconds: 1), () {
                  _scrollController.animateTo(150.0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                });
              }
            },
            onEditingDone: () {
              Future.delayed(Duration(seconds: 1), () {
                FocusScope.of(context).requestFocus(FocusNode());
                _scrollController.animateTo(0.0,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              });
            },
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
            onTap: () {
              _openCountryList();
            },
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
    WidgetProvider.loading(context);
    final _code = this._countryCodeConfig.controller.text;
    String _state = this._regionConfig.controller.text.toLowerCase();
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
}
