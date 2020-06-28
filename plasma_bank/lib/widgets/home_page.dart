import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:plasma_bank/app_utils/image_helper.dart';
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
//  AnimationController controller;
//  Animation<double> animation;
  final _bottomNavigationBehavior = BehaviorSubject<int>();
//  final PublishSubject csvBehavior = PublishSubject<double>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    controller = AnimationController(
//        duration: const Duration(milliseconds: 1000), vsync: this);
//    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    super.dispose();
    if (_bottomNavigationBehavior != null) {
      _bottomNavigationBehavior.close();
    }
  }

  @override
  Widget build(BuildContext context) {
//    final _height = 1300.0;
//    final _width = MediaQuery.of(context).size.width;
//    final _profileWidth = _width * 0.2;
//    final _profileHeight = _profileWidth * 4 / 3.0;
    var mediaQuery = MediaQuery.of(context);
    double _top = mediaQuery.padding.top;
    double _bottom = mediaQuery.padding.bottom;
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: SingleChildScrollView(
            child: StreamBuilder(
              stream: this._bottomNavigationBehavior.stream,
              initialData: 2,
              builder: (_context, _snap) {
                if (_snap.data == 2) {
                  return _getHomeScreen(_context);
                }
                if (_snap.data == 0) {
                  return _getDonateScreen(_context);
                }
                return Container(
                  color: Colors.blue,
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: StreamBuilder(
          stream: this._bottomNavigationBehavior.stream,
          initialData: 2,
          builder: (_context, _snap) {
            return Container(
              height: (_bottom > 0 ? 55 : 65) + _bottom,

//            color: Colors.grey.withAlpha(15),
              decoration: AppStyle.bottomNavigatorBox(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _getNavigationItems(_context, _snap.data),
              ),
            );
          },
        ),
      ),
    );
  }

//theme color #FF006C
  List<Widget> _getNavigationItems(
      final BuildContext _context, final int _selectedIndex) {
    final List<String> _icons = [
      'donate_n.png',
      'collect_n.png',
      'home_n.png',
      'chat_n.png',
      'option_n.png'
    ];

    final int _buttonCount = 5;
    final _width = (MediaQuery.of(_context).size.width) / _buttonCount;
    List _widgets = List<Widget>();

    for (int i = 0; i < _buttonCount; i++) {
      final _iconName =
          _selectedIndex == i ? _icons[i].replaceAll('_n', '_h') : _icons[i];
      final _widget = Container(
        width: _width - 5,
        height: _width - 5,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(_width)),
          child: Material(
            color: Colors.white,
            child: Ink(
              child: InkWell(
                onTap: () {
                  visible = false;
                  this._bottomNavigationBehavior.sink.add(i);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2),
                      child: Container(
                        width: 24,
                        height: 24,
                        child: Image(
                          image: ImageHelper.getImageAsset(_iconName),
                        ),
                      ),
                    ),
                    Text(
                      _iconName.split('_')[0].toUpperCase(),
                      style: TextStyle(
                        fontFamily: i == _selectedIndex
                            ? AppStyle.fontBold
                            : AppStyle.fontNormal,
                        fontSize: 10,
                        color: i == _selectedIndex
                            ? Color.fromARGB(255, 255, 0, 74)
                            : Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      _widgets.add(_widget);
    }

    return _widgets;
  }

  _onTapDonor(final bool _isBloodDonor) {}

  _getHomeScreen(BuildContext _context) {
    var mediaQuery = MediaQuery.of(context);
    double _top = mediaQuery.padding.top;
    double _bottom = mediaQuery.padding.bottom;
    final _height = 1340.0;
    final _width = MediaQuery.of(_context).size.width;
    final _profileWidth = _width * 0.2;
    final _profileHeight = _profileWidth * 4 / 3.0;
    return Container(
      width: _width,
      height: _height,
      child: Padding(
        padding:  EdgeInsets.only(left: 24, right: 24, top:  (_top + 24.0), bottom: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CoronavirusWidget(this._db.getGlobalCovidData(), _width),
            HomePlasmaWidget(_profileHeight, _onTapDonor),
            HomePlasmaWidget(
              _profileHeight,
              _onTapDonor,
              isBloodDonor: true,
            ),
          ],
        ),
      ),
    );
  }

  bool visible = false;
  Widget _getDonateScreen(BuildContext _context) {
    var mediaQuery = MediaQuery.of(context);
    double _top = mediaQuery.padding.top;
    double _bottom = mediaQuery.padding.bottom;
    final _background = (0.9 * 255).toInt();
    final _width = MediaQuery.of(context).size.width;
    if (!this.visible) {
      Future.delayed(Duration(microseconds: 600), () {
        this.visible = true;
        this._bottomNavigationBehavior.sink.add(0);
      });
    }
    return Container(
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        onEnd: () {
          debugPrint("this is the end");
        },
        duration: Duration(seconds: 1),
        child: Container(
          width: _width,
          height: MediaQuery.of(_context).size.height -
              50 -
              _bottom ,
          //color: Color.fromARGB(255, _background, _background, _background),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, _background, _background, _background),
            image: DecorationImage(
              image: ImageHelper.getImageAsset('background_1.jpg'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: (24 + _top), bottom: 24, left: 24, right: 24),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BECOME A BLOOD DONOR TODAY',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: AppStyle.fontBold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32, bottom: 12),
                    child: Text(

                      'life saving heroes come in all types and sizes, a single pint can save three lives, a single gesture can create a million smiles',
                      style: TextStyle(
                        fontSize: 16,

                        height: 1.3
                      ),

                    ),
                  )
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _registerNewDonor,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.add,
                  color: Color.fromARGB(255, 240, 10, 80),
                  size: 50,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _registerNewDonor() {}

  _onProgress(File _dataFile) {
    this._downloader.readCovidJSON(_dataFile);
  }
}
