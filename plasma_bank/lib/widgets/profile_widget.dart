


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/base_widget.dart';

class ProfileWidget extends BaseWidget{
  ProfileWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }

}


class _ProfileState extends State<ProfileWidget> {

  @override
  Widget build(BuildContext context) {

    final _padding = MediaQuery.of(context).padding.bottom;
    final _width = MediaQuery.of(context).size.width;
    return Container(
      color: AppStyle.greyBackground(),
      child:  Padding(
        padding: EdgeInsets.only(bottom: _padding),
        child: Scaffold(
          appBar: WidgetProvider.appBar('Profile'),

        ),
      ),
    );
  }


}