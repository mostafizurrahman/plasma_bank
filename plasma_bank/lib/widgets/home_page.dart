import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/covid_data_helper.dart';
import 'package:plasma_bank/network/donor_handler.dart';
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

  @override
  void initState() {
    super.initState();
    donorHandler.donorLoginBehavior.listen(_openLoginWidget);
    donorHandler.readLoginData(this._loginBehavior);
  }

  _openLoginWidget(final String value) async {
    donorHandler.verificationEmail = value;
    final _data = {
      '\"email\"' : '\"$value\"' ,
      '\"codes\"': '\"${donorHandler.identifier}\"',
      '\"channel\"': '\"${deviceInfo.appPlatform}\"',
      '\"pkg_name\"': '\"${deviceInfo.appBundleID}\"',
    };

    WidgetProvider.loading(context);
    final _handler = ImgurHandler();
    _handler.sendCode(_data).then(_onCodeSend).catchError(_onError);
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
    var mediaQuery = MediaQuery.of(context);

    double _bottom = mediaQuery.padding.bottom;
    double _navigatorHeight = (_bottom > 0 ? 55 : 65) + _bottom;
    return StreamBuilder(
      stream: this._bottomNavigationBehavior.stream,
      initialData: 2,
      builder: (_context, _snap) {
        Widget _widget = Container(
          color: Colors.blue,
        );
        if (_snap.data == 2) {
          _widget = _getHomeScreen(_context);
        } else if (_snap.data == 0) {
          _widget = _getDonateScreen(_context);
        } else if (_snap.data == 1) {
          _widget = _getCollectScreen(_context);
        } else if (_snap.data == 3) {
        } else if (_snap.data == 4) {
          _widget = _getSettingsWidget(_context, _navigatorHeight);
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
                  height: _navigatorHeight,
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

  _getHomeScreen(BuildContext _context) {
    var mediaQuery = MediaQuery.of(context);
    double _top = mediaQuery.padding.top;
    final _height = 1340.0;
    final _width = MediaQuery.of(_context).size.width;
    final _profileWidth = _width * 0.2;
    final _profileHeight = _profileWidth * 4 / 3.0;
    return Container(
      width: _width,
      height: _height,
      child: Padding(
        padding: EdgeInsets.only(
            left: 24, right: 24, top: (_top + 24.0), bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CoronavirusWidget(this._db.getGlobalCovidData(), _width),
            HomePlasmaWidget(_profileHeight, _onTapDonor),
            HomePlasmaWidget(_profileHeight, _onTapDonor, isBloodDonor: true),
          ],
        ),
      ),
    );
  }

  Widget _getSettingsWidget(
      BuildContext _context, final double _navigatorHeight) {
    double _top = MediaQuery.of(_context).padding.top;
    final _height = MediaQuery.of(_context).size.height;
    final _width = MediaQuery.of(_context).size.width;
    return Container(
      width: _width,
      height: _height - _navigatorHeight,
      child: Padding(
        padding: EdgeInsets.only(top: _top),
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
                Expanded(
                  child: snapshot.data == 0
                      ? _getAccountListWidget()
                      : snapshot.data == 1
                          ? _getLoginWidget()
                          : snapshot.data == 2 ? _getSwitchAccount() : Container(),
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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      child: SwitchWidget(_onSwitched, _onLogout),
    );
  }

  Widget _getAccountListWidget() {
    return AccountsWidget(_openLoginWidget);
  }

  Widget _getLoginWidget() {
    return StreamBuilder(
      stream: _loginBehavior.stream,
      initialData: donorHandler.loginDonor,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data is String) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              child: VerificationWidget(snapshot.data, _onVerifiedOTP, _resendOTP ),
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
          width: MediaQuery.of(context).size.width,
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
    return CollectorWidget(this.visible, _onCollectTap);
  }

  Widget _getDonateScreen(BuildContext _context) {
    if (!this.visible) {
      Future.delayed(Duration(microseconds: 600), () {
        this.visible = true;
        this._bottomNavigationBehavior.sink.add(0);
      });
    }
    return DonorWidget(this.visible, _registerDonorTap);
  }

  Widget _getMessageWidget() {
    if (!this.visible) {
      Future.delayed(Duration(microseconds: 600), () {
        this.visible = true;
        this._bottomNavigationBehavior.sink.add(0);
      });
    }
  }

  _registerDonorTap(final bool isRegistration) async {
    if (isRegistration) {
      _openRegistration();
//      Navigator.pushNamed(context, AppRoutes.pageLocateTerms);
      //star registration
    } else {
      _openRegistration();
      //display donor list
    }
  }

  _onProgress(File _dataFile) {
    this._downloader.readCovidJSON(_dataFile);
  }

  _onTapDonor(final bool _isBloodDonor) {}

  _onNavigationButtonTap(int i) {
    visible = false;
    this._bottomNavigationBehavior.sink.add(i);
  }

  _onCollectTap(bool isCollection) {
    if (isCollection) {
      //register collection
    } else {
      //show previous list
    }
  }

  _onVerifiedOTP(){
    donorHandler.loginEmail = donorHandler.verificationEmail;
    donorHandler.donorBehavior.listen((value) {
      donorHandler.closeDonor();
      this._loginBehavior.sink.add(value);
      this._segmentBehavior.sink.add(1);
      donorHandler.verificationEmail = null;
    }).onError((error){
      donorHandler.closeDonor();
    });

  }

  _openRegistration() async {
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
      final _countryList = await locationProvider.getCountryList();
      Navigator.pop(context);
      Future.delayed(Duration(milliseconds: 100), () {
        Navigator.pushNamed(context, AppRoutes.pageAddressData,
            arguments: {'country_list': _countryList});
      });
    }
  }

  _resendOTP(){
    this._openLoginWidget(donorHandler.verificationEmail);
  }

  _onLogout(String _email) {}
  _onSwitched(String _email) {
    this._openLoginWidget(_email);
  }
}
