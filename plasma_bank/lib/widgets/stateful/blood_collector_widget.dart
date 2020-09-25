import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/api_client.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/models/blood_collector.dart';
import 'package:plasma_bank/widgets/base/base_state.dart';
import 'package:plasma_bank/widgets/base_widget.dart';

class BloodCollectorWidget extends BaseWidget {
  BloodCollectorWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CollectorState();
  }
}

class _CollectorState extends BaseKeyboardState<BloodCollectorWidget> {
  final TextConfig _nameConfig = TextConfig('name');
  final TextConfig _emailConfig = TextConfig('email');
  final TextConfig _phoneConfig = TextConfig('mobile #', isDigit: true);
  final TextConfig _addressConfig =
      TextConfig('address', maxLine: 2, animateLen: 200);
  final TextConfig _diseaseConfig = TextConfig('disease', animateLen: 350);
  final TextConfig _countConfig =
      TextConfig('blood bags count', isDigit: true, maxLen: 1);
  final TextConfig _hospitalConfig =
      TextConfig('hospital address', animateLen: 350, maxLen: 250);
  final TextConfig _bloodConfig = TextConfig('blood group');
  final TextConfig _dateConfig = TextConfig('date for blood');

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
//    Navigator.pop(context);
    return Container(
      height: 1300,
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
            'enter the hospital name or address, so that near by donner may contact you soon.',
            textAlign: TextAlign.justify,
          ),
          WidgetTemplate.getCustomTextField(
            this._hospitalConfig,
            () => super.onTextFieldTapped(this._hospitalConfig),
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'enter the number of total blood bags you need for the patient.',
            textAlign: TextAlign.justify,
          ),
          WidgetTemplate.getCustomTextField(
            this._countConfig,
            () => super.onTextFieldTapped(this._countConfig),
          ),

          SizedBox(
            height: 24,
          ),
          Text(
            'enter the approximate date when you need the blood.',
            textAlign: TextAlign.justify,
          ),
          WidgetTemplate.getTextField(
            this._dateConfig,
            isReadOnly: true,
            showCursor: false,
            onTap: () => this._showDatePicker(this._dateConfig),
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

  @override
  onSubmitData() {
    super.onSubmitData();
    final String _address = this._addressConfig.controller.text;
    final String _name = this._nameConfig.controller.text;
    final String _email = this._emailConfig.controller.text;
    final String _mobile = this._phoneConfig.controller.text;
    if (_address.isEmpty) {
      super.setError(_addressConfig);
    } else if (_name.isEmpty) {
      super.setError(_nameConfig);
    } else if (_mobile.isEmpty) {
      super.setError(_phoneConfig);
    } else if (_email.isEmpty) {
      super.setError(_emailConfig);
    } else {
      WidgetProvider.loading(context);
      final _emailClient = EmailClient(_email);
      _emailClient.validateEmail().then((value) {
        Navigator.pop(context);
        if(value){
          final String _disease = this._diseaseConfig.controller.text;
          final String _hospital = this._hospitalConfig.controller.text;
          final String _group = this._bloodConfig.controller.text;
          final String _bags = this._countConfig.controller.text;
          final String _date = this._dateConfig.controller.text;

          final BloodCollector _collector = BloodCollector(
              _email, _mobile, _name, _address,
              bloodGroup: _group,
              bloodCount: _bags,
              hospitalAddress: _hospital,
              injectionDate: _date,
              diseaseName: _disease);
          final FirebaseRepositories _repository = FirebaseRepositories();
          _repository.uploadBloodCollector(_collector).then((data) {
            Navigator.pop(context);
            WidgetTemplate.message(context,
                'your registration was successful! please! login to continue...',
                actionTitle: 'LOGIN', onActionTap: () {
                  Navigator.pop(context);
                  final Function _onTap = this.widget.getData('login_tap');
                  _onTap();
                });
          }).catchError((_error) {
            Navigator.pop(context);
          });
        } else {
          Navigator.pop(context);
          WidgetTemplate.message(context, 'this email is invalid. please! enter a valid email address and try again, later. thank you!');
        }
      }).catchError((_error){
        Navigator.pop(context);
      });


    }
  }

  _showDatePicker(TextConfig _controller) async {
    final _dateTime = await showDatePicker(
        context: context,
        initialDate:  DateTime.now(),
        lastDate: DateTime(DateTime.now().year+2),
        firstDate: DateTime.now());
    if (_dateTime != null) {
      String date = DateFormat("dd MMM, yyyy").format(_dateTime);
      _controller.controller.text = date;
//      _controller.timestamped = _dateTime;
    }
  }
}
