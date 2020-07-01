import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/stateful/data_picker_widget.dart';

class AddressWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddressState();
  }
}

class _AddressState extends State<AddressWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(
          milliseconds: 1100,
        ), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Material(
          color: Colors.transparent,
          type: MaterialType.card,
          child: WillPopScope(
            onWillPop: () async {
              return Future<bool>.value(false);
            },
            child: DataPickerWidget(List(), _onLocationSelected),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final _city = locationProvider.gpsCity;

    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: WidgetProvider.appBar('Address'),
        body: Container(),
      ),
    );
  }

  _onLocationSelected(final _data){

  }


}
