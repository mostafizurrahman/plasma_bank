import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:ui' as ui;

import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/media/dash_painter.dart';

class DataPickerWidget extends StatefulWidget {
  final bool hasDoneButton;
  final String picketTitle;
  final List dataList;
  final Function(dynamic) onSelectedData;

  DataPickerWidget(this.dataList, this.onSelectedData,
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
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: this.widget.hasDoneButton ? WidgetProvider.button(
                _onDataPicked,
                "DONE",
                context,
              ) : SizedBox(),
            ),
          ),
        ),
      ),
    );
  }

  _onDataPicked() {}
}
