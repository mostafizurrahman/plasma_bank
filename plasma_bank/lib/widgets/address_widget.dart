import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import '../widgets/base_widget.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/base/base_state.dart';

import 'base/base_address_state.dart';

class AddressWidget extends BaseWidget {
  AddressWidget(Map arguments) : super(arguments);
  @override
  State<StatefulWidget> createState() {
    return _AddressState();
  }
}

class _AddressState extends BaseAddressState<AddressWidget> {

}
