import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/widgets/base/base_state.dart';
import 'package:plasma_bank/widgets/base_widget.dart';

class CollectorWidget extends BaseWidget {
  CollectorWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CollectorState();
  }
}

class _CollectorState extends BaseKeyboardState<CollectorWidget> {
  final TextConfig _nameConfig = TextConfig('name');
  final TextConfig _emailConfig = TextConfig('email');
  final TextConfig _phoneConfig = TextConfig('mobile #', isDigit: true);
  final TextConfig _addressConfig = TextConfig('address', maxLine: 2);
  final TextConfig _diseaseConfig = TextConfig('disease');
  final TextConfig _bloodConfig = TextConfig('blood group');

  @override
  String getActionTitle() {
    // TODO: implement getActionTitle
    return 'REGISTER';
  }

  @override
  String getAppBarTitle() {
    // TODO: implement getAppBarTitle
    return 'BLOOD COLLECTION';
  }

  @override
  Widget getSingleChildContent() {
    return Container(
      height: 1000,
      child: Column(
        children: <Widget>[
          WidgetTemplate.getSectionTitle('PERSONAL INFO', Icons.info_outline),
          WidgetTemplate.getCustomTextField(
            this._nameConfig,
            () => super.onTextFieldTapped(this._nameConfig),
          ),
          WidgetTemplate.getCustomTextField(
            this._phoneConfig,
                () => super.onTextFieldTapped(this._phoneConfig),
          ),

          WidgetTemplate.getCustomTextField(
            this._emailConfig,
                () => super.onTextFieldTapped(this._emailConfig),
          ),
          WidgetTemplate.getCustomTextField(
            this._addressConfig,
                () => super.onTextFieldTapped(this._addressConfig),
          ),

          WidgetTemplate.getSectionTitle('REASONS', Icons.info_outline),
          SizedBox(
            height: 24,
          ),
          Text(
            'enter brief details about the disease for whom you are collecting the blood, so that donner may realise the relevancy of blood donation. ignore, if you are unwilling to disclose.',
            textAlign: TextAlign.justify,
          ),
          WidgetTemplate.getCustomTextField(
            this._diseaseConfig,
                () => super.onTextFieldTapped(this._diseaseConfig),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'you may specify the blood group, which you are looking for. it will help you find the blood more easily.',
            textAlign: TextAlign.justify,
          ),
          WidgetTemplate.getTextField(
            _bloodConfig,
            maxLen: 15,
            isReadOnly: true,
            onTap: () {
              List _data = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];
              WidgetProvider.openLocationPopUp(
                  context,
                  _data,
                  (_data) => _bloodConfig.controller.text = _data.toString(),
                  _onPopupClosed,
                  'SELECT BLOOD GROUP');
            },
          ),
        ],
      ),
    );
  }

  _onPopupClosed() {}
}
