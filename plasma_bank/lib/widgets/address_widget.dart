import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/base_widget.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/stateful/data_picker_widget.dart';

class AddressWidget extends BaseWidget {
  AddressWidget(Map arguments) : super(arguments) {
    debugPrint('what happened');
  }

  @override
  State<StatefulWidget> createState() {
    final _countryList = this.getData('country_list');
    return _AddressState();
  }
}

class _AddressState extends State<AddressWidget> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(seconds: 4,), () {
      final _countryList = this.widget.getData('country_list');
      debugPrint('_done');
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
            child: DataPickerWidget(_countryList, _onLocationSelected),
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

  _onLocationSelected(final _data) {}
}
