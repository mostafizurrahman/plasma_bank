import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/media/dash_painter.dart';

import '../../app_utils/widget_templates.dart';

class CoronavirusWidget extends StatelessWidget {
  final Stream<QuerySnapshot> _queryStream;
  final _width;
  CoronavirusWidget(this._queryStream, this._width);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyle.shadowDecoration,
      width: _width - 48,
      height: 403,
      child: StreamBuilder(
        stream: this._queryStream,
        builder: (_context, _snap) {
          if (_snap.hasData) {
            final QuerySnapshot _data = _snap.data;
            if(_data.documents.length == 0){
              return Center(
                child: Text(
                  'INTERNET ERROR',

                style: TextStyle(color: Colors.pinkAccent, fontFamily: AppStyle.fontBold),
                ),
              );
            }
            final Map<dynamic, dynamic> _mapData = _data.documents.first.data;
            if (_mapData == null) {
              return Center(
                child: Text(
                  'NO DATA FOUND\nINTERNET ERROR!',
                ),
              );
            }
            return ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(16),
              ),
              child: Material(
                child: Ink(
                  child: InkWell(
                    onTap: () {
                      debugPrint("done");
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Text(
                            'CORONAVIRUS PANDEMIC',
                            style: TextStyle(
                                fontFamily: 'SF_UIFont_Bold',
                                fontSize: 18,
                                color: Colors.black87),
                          ),
                        ),
                        CustomPaint(
                          size:
                              Size(MediaQuery.of(context).size.width - 48, 1.0),
                          painter: DashLinePainter(),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: Text(
                                'coronavirus cases',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.redAccent),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withAlpha(15),
                              ),
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.brightness_high,
                                    color: Colors.redAccent,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    AppStyle.format(_mapData['total_cases']),
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'SF_UIFont_Bold',
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: Text(
                                'recovered cases',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black87),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withAlpha(25),
                              ),
                              height: 50,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.mood,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    AppStyle.format(
                                        _mapData['total_recovered']),
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'SF_UIFont_Bold',
                                        color: Colors.green),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12, bottom: 12),
                              child: Text(
                                'total deaths',
                                style: TextStyle(
                                    fontSize: 24, color: Colors.black87),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withAlpha(15),
                              ),
                              height: 50,
                              child: Row(
                                children: [
                                  WidgetProvider.circledIcon(
                                    Icon(
                                      Icons.airline_seat_flat,
                                      color: Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    AppStyle.format(_mapData['total_death']),
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: 'SF_UIFont_Bold',
                                        color: Colors.red),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.brightness_high,
                                color: Colors.redAccent,
                              ),
                              Row(
                                children: [
                                  Text(
                                    'mild : ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    AppStyle.format(
                                        _mapData['active_cases']['mild']),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'critical : ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    AppStyle.format(
                                        _mapData['active_cases']['critical']),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return WidgetTemplate.progressIndicator();
        },
      ),
    );
  }
}
