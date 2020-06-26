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
//  final PublishSubject csvBehavior = PublishSubject<double>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height * 1.5;
    final _width = MediaQuery.of(context).size.width;
    final _profileWidth = _width * 0.2;
    final _profileHeight = _profileWidth * 4 / 3.0;
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            child: SingleChildScrollView(
              child: Container(
                width: _width,
                height: _height,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CoronavirusWidget(this._db.getGlobalCovidData(), _width),
                      Padding(
                        padding: const EdgeInsets.only(top: 48, bottom: 24),
                        child: Container(
                          decoration: AppStyle.shadowDecoration,
                          height: 350,
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 12),
                                child: Text(
                                  'DONATE  PLASMA',
                                  style: TextStyle(
                                      fontFamily: 'SF_UIFont_Bold',
                                      fontSize: 20,
                                      color: Colors.green),
                                ),
                              ),
                              CustomPaint(
                                size: Size(
                                    MediaQuery.of(context).size.width - 48,
                                    1.0),
                                painter: DashLinePainter(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 16, left: 16, right: 16),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: _profileHeight,
                                        width: _profileWidth,
                                        decoration: AppStyle.getLightBox(),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          child: Image.network(
                                            'https://i.imgur.com/csdE6UE.jpg',
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 1.75,
                                                  backgroundColor: Colors.red,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    Color.fromARGB(
                                                        255, 220, 220, 200),
                                                  ),
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: _profileHeight * 0.75,
                                              child: Center(
                                                child: Text(
                                                  'Mostafizru Rahman Mony',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: _profileHeight * 0.25,
                                              alignment: Alignment.bottomCenter,
                                              child: Row(
                                                children: [
                                                  WidgetProvider.circledIcon(
                                                    Icon(
                                                      Icons.add,
                                                      color: Colors.green,
                                                      size:
                                                          _profileHeight * 0.15,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Text('new plasma donor'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: Text(
                                              'AB+',
                                              style: TextStyle(
                                                fontSize: 54,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: AppStyle.fontBold,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16, right: 5),
                                                child:
                                                    WidgetProvider.circledIcon(
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Icon(
                                                      Icons.colorize,
                                                      color: Colors.red,
                                                      size: 17,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text('BLOOD GROUP'),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 24),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16),
                                                  child: Text(
                                                    'DHAKA,',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          AppStyle.fontBold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16),
                                                  child: Text(
                                                    'BANGLADESH',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily:
                                                          AppStyle.fontBold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16, right: 5),
                                                child:
                                                    WidgetProvider.circledIcon(
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: Icon(
                                                      Icons.location_on,
                                                      color: Colors.red,
                                                      size: 17,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text('BLOOD  REGION'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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

  _onProgress(File _dataFile) {
    this._downloader.readCovidJSON(_dataFile);
  }
}
