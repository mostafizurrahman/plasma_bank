import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/widgets/stateful/integer_item.dart';
import 'package:plasma_bank/widgets/stateful/region_picker_item.dart';
import 'package:rxdart/rxdart.dart';

import 'country_picker_item.dart';

class DataPickerWidget extends StatefulWidget {
  final bool hasDoneButton;
  final isGridView;
  final String picketTitle;
  final List dataList;
  final Function(dynamic) onSelectedData;
  final Function onClosed;
  final String unit;

  DataPickerWidget(this.dataList, this.onSelectedData, this.onClosed,
      {this.picketTitle = 'PICK A DATA',
        this.unit = '',
      this.hasDoneButton = true,
      this.isGridView = false});
  @override
  State<StatefulWidget> createState() {
    return _DataPickerState();
  }
}

class _DataPickerState extends State<DataPickerWidget> {
  final itemExtent = 80.0;
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
                    decoration: AppStyle.getLightBox(),
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
                    size: Size(displayData.width, 1.0),
                    painter: DashLinePainter(),
                  ),
                  Expanded(
                    child: StreamBuilder<Object>(
                      stream: _tempSubject.stream,
                      builder: (context, snapshot) {
                        return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: this.widget.dataList.length + 1,
                          itemExtent: itemExtent,
                          itemBuilder: (_context, _index) {
                            if (_index == this.widget.dataList.length) {
                              return Container(
                                height: 90,
                              );
                            }
                            final _data = this.widget.dataList[_index];
                            return _getItemWidget(_data);

//                            this.getCountryItem(_data);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: this.widget.hasDoneButton
                  ?
              Container(color: AppStyle.theme(), height: 60,
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    child: InkWell(
                      onTap: _onDataPicked,
                      child: SizedBox(width: displayData.width - 48, height: 60,
                      child: Center(
                        child: Text('SELECT' , style: TextStyle(fontSize: 20, color: Colors.white),),
                      ),

                      ),
                    ),
                  ),
                ),
              )

//              WidgetProvider.button(
//                      _onDataPicked,
//                      "SELECT",
//                      context,
//                      padding: 96,
//                    )
                  : SizedBox(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getItemWidget(final _data) {

    if(_data is String){

      bool _isSelected = _data == this._tempSubject.value;
      return Padding(
        padding: EdgeInsets.only(left: 16, right:  16, top: 12, bottom: 12),
        child: Container(

          decoration: AppStyle.lightShadow(),
          child: ClipRRect(
            child: Material(
              color: Colors.transparent,
              child: Ink(
                child: InkWell(
                  onTap: (){
                    this._tempSubject.sink.add(_data);
                  },
                  child: Row(
                    children: [
                      SizedBox(width: 12,),
                      WidgetProvider.circledIcon(Icon(Icons.radio_button_checked ,color: _isSelected ? AppStyle.theme() :  Colors.cyan,),),
                      SizedBox(width: 12,),
                      Text(
                        _data,
                        style: TextStyle(
                          color: _isSelected ?  AppStyle.theme() : Colors.black54 ,
                          fontSize: 16,
                          fontFamily: AppStyle.fontBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
        ),
      );
    }

    if (_data is List<int>) {

      return IntegerItem(
        _data,
        this._tempSubject.value,
        this._onSubjectSelected,
        dimension: itemExtent - 32,
        unitName: this.widget.unit,
      );
    }

    bool _isSelected = _data == this._tempSubject.value;
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
