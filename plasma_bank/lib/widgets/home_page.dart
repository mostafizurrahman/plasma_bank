import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/covid_data_helper.dart';
import 'package:plasma_bank/network/person_handler.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/imgur_handler.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/widgets/stateful/accounts_widget.dart';
import 'package:plasma_bank/widgets/stateful/profile_info.dart';
import 'package:plasma_bank/widgets/stateful/switch_widget.dart';
import 'package:plasma_bank/widgets/stateless/collector_widget.dart';
import 'package:plasma_bank/widgets/stateless/coronavirus_widget.dart';
import 'package:plasma_bank/widgets/stateless/donor_widget.dart';
import 'package:plasma_bank/widgets/stateless/home_plasma_widget.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'messaging/message_list_widget.dart';
import 'stateful/home_widget.dart';
import 'verification_widget.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageWidget> {
  BehaviorSubject<int> _segmentBehavior = BehaviorSubject();
  BehaviorSubject _loginBehavior = BehaviorSubject();
  final _bottomNavigationBehavior = BehaviorSubject<int>();

  final _downloader = CovidDataHelper();
  final _db = FirebaseRepositories();
  bool visible = false;

//  StreamSubscription _verifySubscription;
//  StreamSubscription _loginSubscriptoin;
  @override
  void initState() {
    super.initState();
    donorHandler.verifyEmailBehavior.listen(_openLoginWidget);
//    _loginSubscriptoin = donorHandler.loginEmailBehavior.listen((value) { })
//    donorHandler.readLoginData(this._loginBehavior);
  }

//  _closeVerification(){
//    _verifySubscription.cancel();
//  }

  _openLoginWidget(final String value) async {
    if (value != null && value.isNotEmpty) {
      final _data = {
        '\"email\"': '\"$value\"',
        '\"codes\"': '\"${donorHandler.identifier}\"',
        '\"channel\"': '\"${deviceInfo.appPlatform}\"',
        '\"pkg_name\"': '\"${deviceInfo.appBundleID}\"',
      };
      debugPrint(
          "_______________________________________________________$value ___________________________________");

      WidgetProvider.loading(context);
      final _handler = ImgurHandler();
      _handler.sendCode(_data).then(_onCodeSend).catchError(_onError);
    }
  }

  _onCodeSend(final _response) {
    Navigator.pop(context);
    if (_response is String) {
      if (_response == 'success') {
        this._bottomNavigationBehavior.sink.add(4);
        this._segmentBehavior.sink.add(1);
        this._loginBehavior.sink.add(donorHandler.verificationEmail);
      }
    }
  }

  _onError(_error) {
    Navigator.pop(context);
    final _email = (this._loginBehavior.value ?? '').toString();
    Future.delayed(Duration(microseconds: 300), () {
      WidgetTemplate.message(context,
          'Could not send the verification code to the email $_email. Please! Try again later.');
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_bottomNavigationBehavior != null) {
      _bottomNavigationBehavior.close();
    }
    if (!_segmentBehavior.isClosed) {
      _segmentBehavior.close();
    }

    if (!_loginBehavior.isClosed) {
      _loginBehavior.close();
    }
  }

  @override
  Widget build(BuildContext context) {
//    Navigator.pop(context);
//    donorHandler.readDeviceList();
    return StreamBuilder(
      stream: this._bottomNavigationBehavior.stream,
      initialData: 2,
      builder: (_context, _snap) {
        Widget _widget = Container(
          color: Colors.blue,
        );
        if (_snap.data == 2) {
          _widget = HomeWidget();
        } else if (_snap.data == 0) {
          _widget = _getDonateScreen(_context);
        } else if (_snap.data == 1) {
          _widget = _getCollectScreen(_context);
        } else if (_snap.data == 3) {
          _widget = _getMessageWidget();
        } else if (_snap.data == 4) {
          _widget = _getSettingsWidget(_context, displayData.navHeight);
        }

        return Container(
          color: Colors.white,
          child: Scaffold(
            backgroundColor:
                _snap.data == 0 ? AppStyle.greyBackground() : Colors.white,
            body: Container(
              color: _snap.data == 0 ? AppStyle.greyBackground() : Colors.white,
              child: SingleChildScrollView(
                child: _widget,
              ),
            ),
            bottomNavigationBar: StreamBuilder(
              stream: this._bottomNavigationBehavior.stream,
              initialData: 2,
              builder: (_context, _snap) {
                return Container(
                  height: displayData.navHeight,
                  decoration: AppStyle.bottomNavigatorBox(),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: WidgetProvider.navigators(
                        _context, _snap.data, _onNavigationButtonTap),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

//  _openBloodRequest() {

//    else {
//      _openAddress(isBlood: true);
//    }
//  }

  Widget _getSettingsWidget(
      BuildContext _context, final double _navigatorHeight) {
    return Container(
      width: displayData.width,
      height: displayData.height - _navigatorHeight,
      child: Padding(
        padding: EdgeInsets.only(top: displayData.top),
        child: StreamBuilder<int>(
          initialData: 0,
          stream: this._segmentBehavior.stream,
          builder: (context, snapshot) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                CupertinoSegmentedControl(
                  pressedColor: AppStyle.theme().withAlpha(50),
                  selectedColor: AppStyle.theme(),
                  borderColor: AppStyle.theme(),
                  unselectedColor: Colors.transparent,
                  onValueChanged: (value) {
                    this._segmentBehavior.sink.add(value);
                  },
                  groupValue: snapshot.data,
                  children: loadTabs(),
                ),
                SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: snapshot.data == 0
                      ? _getAccountListWidget()
                      : snapshot.data == 1
                          ? _getLoginWidget()
                          : snapshot.data == 2
                              ? _getSwitchAccount()
                              : Container(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _getSwitchAccount() {
    return Container(
      width: displayData.width,
      height: displayData.height * 0.75,
      child: SwitchWidget(_onSwitched, _onLogout, _onLoginProfile),
    );
  }

  _onLoginProfile() {
    _bottomNavigationBehavior.sink.add(1);
  }

  Widget _getAccountListWidget() {
    return AccountsWidget(_openLoginWidget);
  }

  Widget _getLoginWidget() {
    return StreamBuilder(
      stream: _loginBehavior.stream,
      initialData: donorHandler.loginEmailBehavior.value,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data is String) {
            return Container(
              width: displayData.width,
              height: displayData.height * 0.75,
              child:
                  VerificationWidget(snapshot.data, _onVerifiedOTP, _resendOTP),
            );
          }
          if (snapshot.data is BloodDonor) {
            return ProfileInfoWidget(snapshot.data);
          }
        }
        return Container(
          child: Center(
            child: Text('NO ACCOUNT TO VERIFY'),
          ),
          width: displayData.width,
        );
      },
    );
  }

  Map<int, Widget> loadTabs() {
    final map = new Map<int, Widget>();
    final String _middle =
        donorHandler.loginEmail != null && donorHandler.loginEmail.isNotEmpty
            ? 'PROFILE'
            : 'VERIFY';
    List _data = ['ACCOUNTS', _middle, 'LOGIN', 'APP ☲'];
    int _selected = this._segmentBehavior.value ?? 0;

    for (int i = 0; i < _data.length; i++) {
//putIfAbsent takes a key and a function callback that has return a value to that key.
// In our example, since the Map is of type <int,Widget> we have to return widget.
      map.putIfAbsent(
        i,
        () => Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            _data[i],
            style: TextStyle(
                fontSize: 10,
                color: _selected == i ? Colors.white : AppStyle.theme()),
          ),
        ),
      );
    }
    return map;
  }

  Widget _getCollectScreen(BuildContext _context) {
    if (!this.visible) {
      Future.delayed(Duration(microseconds: 600), () {
        this.visible = true;
        this._bottomNavigationBehavior.sink.add(1);
      });
    }
    return CollectorWidget(this.visible, this._openPage);
  }

  Widget _getDonateScreen(BuildContext _context) {
    if (!this.visible) {
      Future.delayed(Duration(microseconds: 600), () {
        this.visible = true;
        this._bottomNavigationBehavior.sink.add(0);
      });
    }
    return DonorWidget(this.visible, this._openPage);
  }

  Widget _getMessageWidget() {
    if (!this.visible) {
      Future.delayed(Duration(microseconds: 600), () {
        this.visible = true;
        this._bottomNavigationBehavior.sink.add(3);
      });
    }
    return MessageListWidget(_onLoginSelectedLogin);
  }

  _onLoginSelectedLogin() {
    this._bottomNavigationBehavior.sink.add(4);
    this._segmentBehavior.sink.add(2);
  }

//  _registerDonorTap(final bool isRegistration) async {
//    if (isRegistration) {
//      _openAddress();
////      Navigator.pushNamed(context, AppRoutes.pageLocateTerms);
//      //star registration
//    } else {
//      Navigator.pushNamed(context, AppRoutes.pageFilterDonor,
//          arguments: {'is_donor': true});
//
//      //display donor list
//    }
//  }

  _onProgress(File _dataFile) {
    this._downloader.readCovidJSON(_dataFile);
  }

  _onTapDonor(final bool _isBloodDonor) {}

  _onNavigationButtonTap(int i) {
    visible = false;
    this._bottomNavigationBehavior.sink.add(i);
  }

//  _onCollectTap(bool isCollection) {
//    if (isCollection) {
//      this._openAddress(isBloodTaker: true);
//      //register collection
//    } else {
//      this._openAddress(isBloodTaker: false, isBlood: false);
////      Navigator.pushNamed(context, AppRoutes.pageFilterDonor,
////          arguments: {'is_donor': false});
////      _openAddress(isBloodTaker: true);
////      sdfs
////      Navigator.pushNamed(context, AppRoutes.pageBloodTaker);
//      //show previous list
//    }
//  }

  _onLoginTaped() {
    debugPrint('please login to collector');
  }

  StreamSubscription _loginSubscription;
  _onVerifiedOTP() {
    if (_loginSubscription != null) {
      _loginSubscription.cancel();
    }
    donorHandler.setLoginEmail(donorHandler.verificationEmail);
    _loginSubscription = donorHandler.loginEmailBehavior.listen((value) {
      this._loginBehavior.sink.add(value);
      this._segmentBehavior.sink.add(1);
      donorHandler.setVerificationEmail(null, false);
    });
  }

  _resendOTP() {
    this._openLoginWidget(donorHandler.verificationEmail);
  }

  _onLogout() {
    final String _email = donorHandler.loginEmail;
    donorHandler.setLoginEmail(null);
    this._loginBehavior.sink.add(null);
    WidgetTemplate.message(
        context, "The account associated with $_email is logout successfully!");
  }

  _onSwitched(String _email) async {
    bool _isDonor = await donorHandler.isEmailRegisteredAsDonor(_email);
    donorHandler.setVerificationEmail(_email, _isDonor);
  }

  _openPage(FilterPageType _pageType) async {
    final bool _isFiltering = [
      FilterPageType.FILTER_DONOR,
      FilterPageType.FILTER_REQUEST,
      FilterPageType.FILTER_COLLECTOR
    ].contains(_pageType);
    if (donorHandler.loginEmail == null && _isFiltering) {
      WidgetTemplate.message(
        context,
        'you are not logged in, please login as blood donor or blood collector then continue',
        onActionTap: () {
          Navigator.pop(context);
          this._bottomNavigationBehavior.sink.add(4);
          this._segmentBehavior.sink.add(2);
        },
      );
      return;
    }

    WidgetProvider.loading(context);
    final _countryList =
        await locationProvider.getCountryList().catchError((_error) {
      return null;
    });
    Navigator.pop(context);
    final Map _map = {
      'login_tap': _onLoginTaped,
      'country_list': _countryList,
      'page_type': _pageType
    };
    final _route = _isFiltering
        ? AppRoutes.pageFilterDonor
        : FilterPageType.DONOR == _pageType
            ? AppRoutes.pageAddressData
            : FilterPageType.COLLECTOR == _pageType
                ? AppRoutes.pageBloodTaker
                : AppRoutes.pagePostBlood;
    if (_countryList != null) {
      Future.delayed(Duration(milliseconds: 100), () {
        Navigator.pushNamed(context, _route, arguments: _map);
      });
    }
  }
}
