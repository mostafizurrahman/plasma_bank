import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/network/covid_data_helper.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/models/blood_hunter.dart';
import 'package:plasma_bank/network/uploader.dart';
import 'package:plasma_bank/widgets/stateless/coronavirus_widget.dart';
import 'package:plasma_bank/widgets/stateless/home_plasma_widget.dart';
import 'package:plasma_bank/widgets/widget_templates.dart';
import 'package:rxdart/rxdart.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageWidget> {
  final _db = FirebaseRepositories();
  final _downloader = CovidDataHelper();
  final _bottomNavigationBehavior = BehaviorSubject<int>();
//  final PublishSubject csvBehavior = PublishSubject<double>();

  @override
  void dispose() {
    super.dispose();
    if(_bottomNavigationBehavior != null) {
      _bottomNavigationBehavior.close();
    }
  }

  @override
  Widget build(BuildContext context) {
//    final _height = 1300.0;
//    final _width = MediaQuery.of(context).size.width;
//    final _profileWidth = _width * 0.2;
//    final _profileHeight = _profileWidth * 4 / 3.0;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: this._bottomNavigationBehavior.stream,
                initialData: 2,
                builder: (_context, _snap){
                  if(_snap.data == 2){
                    return _getHomeScreen(_context);
                  }
                  return Container(color: Colors.blue,);
                },
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 60,

//            color: Colors.grey.withAlpha(15),
            decoration: AppStyle.bottomNavigatorBox(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getNavigationItems(final BuildContext _context){

    final int _buttonCount = 5;
    final _width = (MediaQuery.of(_context).size.width - 48) / _buttonCount;
    List _widgets = List<Widget>();

    for( int i = 0; i < _buttonCount; i++){

      final _widget = Container(
        width: _width,
        height: 52,
        child: RaisedButton(
          elevation: 0.4,
          child: Row(children: [

          ],),
        ),
      );
    }


  }

  _onTapDonor(final bool _isBloodDonor){

  }

  _getHomeScreen(BuildContext _context){
    final _height = 1300.0;
    final _width = MediaQuery.of(_context).size.width;
    final _profileWidth = _width * 0.2;
    final _profileHeight = _profileWidth * 4 / 3.0;
    return Container(
      width: _width,
      height: _height,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CoronavirusWidget(this._db.getGlobalCovidData(), _width),
            HomePlasmaWidget(_profileHeight, _onTapDonor),
            HomePlasmaWidget(_profileHeight, _onTapDonor, isBloodDonor: true,),
          ],
        ),
      ),
    );
  }

  _onProgress(File _dataFile) {
    this._downloader.readCovidJSON(_dataFile);
  }
}
