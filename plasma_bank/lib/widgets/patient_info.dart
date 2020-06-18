

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';

class PatientInfoWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _PatientInfoState();
  }
}

class _PatientInfoState extends State<PatientInfoWidget> {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.red,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.withAlpha(100),
          appBar: WidgetProvider.getAppBar(context),
        ),
      ),
    );
  }

}