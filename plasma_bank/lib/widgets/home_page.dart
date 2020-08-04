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
import 'package:plasma_bank/widgets/stateless/collector_widget.dart';
import 'package:plasma_bank/widgets/stateless/coronavirus_widget.dart';
import 'package:plasma_bank/widgets/stateless/donor_widget.dart';
import 'package:plasma_bank/widgets/stateless/home_plasma_widget.dart';
import 'package:rxdart/rxdart.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageWidget> {

  BehaviorSubject<int> _segmentBehavior = BehaviorSubject();
  final _bottomNavigationBehavior = BehaviorSubject<int>();
  final Connectivity _connectivity = Connectivity();
  final _downloader = CovidDataHelper();
  final _db = FirebaseRepositories();
  bool visible = false;

  @override
  void initState() {

    super.initState();
    donorHandler.donorLoginBehavior.listen(_openLoginWidget);
  }


  _openLoginWidget(final String value){


  }

  @override
  void dispose() {
    super.dispose();
    if (_bottomNavigationBehavior != null) {
      _bottomNavigationBehavior.close();
    }
    if(!_segmentBehavior.isClosed){
      _segmentBehavior.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double _top = mediaQuery.padding.top;
    double _bottom = mediaQuery.padding.bottom;
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
        } else if (_snap.data == 3){
        } else if (_snap.data == 4){
          _widget = _getSettingsWidget(_context);
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
                  height: (_bottom > 0 ? 55 : 65) + _bottom,
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






  Widget _getSettingsWidget(BuildContext _context){
    final _width =  MediaQuery.of(context).size.width;
    return Container(
      width:_width,
      color: Colors.red,
      child: StreamBuilder<int>(
        initialData: 0,
        stream: this._segmentBehavior.stream,
        builder: (context, snapshot) {
          return Column(
            children: <Widget>[
              CupertinoSegmentedControl(
                onValueChanged: (value){

                },
                groupValue: snapshot.data,
                children: loadTabs(),
              )
            ],
          );
        }
      ),
    );

  }
   loadTabs() {
    final map = new Map();
    for (int i = 0; i < 4; i++) {
//putIfAbsent takes a key and a function callback that has return a value to that key.
// In our example, since the Map is of type <int,Widget> we have to return widget.
      map.putIfAbsent(
          i,
              () => Text(
            "Tab $i",
            style: TextStyle(color: Colors.white),
          ));
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

  Widget _getMessageWidget(){
    if (!this.visible) {
      Future.delayed(Duration(microseconds: 600), () {
        this.visible = true;
        this._bottomNavigationBehavior.sink.add(0);
      });
    }


  }

  _registerDonorTap(final bool isRegistration) async{
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
  _onCollectTap(bool isCollection){
    if(isCollection){
      //register collection
    } else {
      //show previous list
    }
  }

  _openRegistration() async {
    WidgetProvider.loading(context);
    final _status = await locationProvider.updateLocation();
    if (_status == GeolocationStatus.denied) {
      Navigator.pop(context);

      WidgetTemplate.message(context, 'location permission is denied! please, go to app settings and provide location permission to create your account.',
          actionTitle: 'open app settings',
          actionIcon: Icon(Icons.settings, color: Colors.white,),
          onActionTap: (){
            Navigator.pop(context);
            AppSettings.openAppSettings();
          }
      );
    } else {
      final _countryList = await locationProvider.getCountryList();
      Navigator.pop(context);
      Future.delayed(Duration(milliseconds: 100), () {
        Navigator.pushNamed(context, AppRoutes.pageAddressData,
            arguments: {'country_list': _countryList});
      });
    }
  }
}
