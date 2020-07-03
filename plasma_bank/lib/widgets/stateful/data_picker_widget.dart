import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/widgets/stateful/region_picker_item.dart';
import 'package:rxdart/rxdart.dart';

import 'country_picker_item.dart';

class DataPickerWidget extends StatefulWidget {
  final bool hasDoneButton;
  final String picketTitle;
  final List dataList;
  final Function(dynamic) onSelectedData;
  final Function onClosed;

  DataPickerWidget(this.dataList, this.onSelectedData, this.onClosed,
      {this.picketTitle = 'PICK A DATA', this.hasDoneButton = true});
  @override
  State<StatefulWidget> createState() {
    return _DataPickerState();
  }
}

class _DataPickerState extends State<DataPickerWidget> {
  @override
  Widget build(BuildContext context) {
    final double _titleHeight = 55;
    return BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 48, bottom: 48),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: Container(
            decoration: AppStyle.shadowDecoration,
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    height: _titleHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 24, right: 8),
                            child: Text(
                              this.widget.picketTitle,
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: _titleHeight,
                          height: _titleHeight,
                          child: ClipRRect(
                            child: Ink(
                              child: InkWell(
                                onTap: () {
                                  debugPrint('this is the end');
                                  if (this.widget.onClosed != null)
                                    this.widget.onClosed();
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.cancel,
                                  color: AppStyle.theme(),
                                  size: 32,
                                ),
                              ),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(26)),
                          ),
                        )
                      ],
                    ),
                  ),
                  CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 1.0),
                    painter: DashLinePainter(),
                  ),
                  Expanded(
                    child: StreamBuilder<Object>(
                      stream: _tempSubject.stream,
                      builder: (context, snapshot) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: this.widget.dataList.length + 1,
                          itemExtent: 75,
                          itemBuilder: (_context, _index) {
                            if (_index == this.widget.dataList.length) {
                              return Container(
                                height: 90,
                              );
                            }
                            final _data = this.widget.dataList[_index];
                            bool isSelected = _data == this._tempSubject.value;
                            return _getItemWidget(_data, isSelected);

//                            this.getCountryItem(_data);
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: this.widget.hasDoneButton
                  ? WidgetProvider.button(
                      _onDataPicked,
                      "SELECT",
                      context,
                      padding: 96,
                    )
                  : SizedBox(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getItemWidget(final _data, final bool _isSelected) {
    if (_data is Region || _data is City) {
      return RegionWidget(_data, this._onSubjectSelected, _isSelected);
    }

    return CountryWidget(_data, this._onSubjectSelected, _isSelected);
  }

  final BehaviorSubject _tempSubject = BehaviorSubject();
  _onDataPicked() {
    if (this.widget.onSelectedData != null) {
      this.widget.onSelectedData(this._tempSubject.value);
      Navigator.pop(context);
    }
  }

  _onSubjectSelected(final _data) {
    this._tempSubject.sink.add(_data);
  }

  Widget getCountryItem(final Country _country) {
    return Card(
      elevation: 0.1,
      child: Container(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Text(
                _country.flag,
                style: TextStyle(fontSize: 35),
              ),
            ),
            Center(
              child: Text(
                _country.countryName,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_tempSubject != null) {
      _tempSubject.close();
    }
  }
}