import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/models/abstract_person.dart';
import 'package:plasma_bank/network/person_handler.dart';
import 'package:plasma_bank/widgets/base/base_address_state.dart';
import 'package:plasma_bank/widgets/base/base_widget.dart';

class RequestBloodWidget extends BaseWidget {
  RequestBloodWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RequestBloodState();
  }
}

class _RequestBloodState extends BaseAddressState<RequestBloodWidget> {
  final TextConfig _diseaseConfig =
      TextConfig('disease', animateLen: 350, maxLine: 2);
  final TextConfig _countConfig =
      TextConfig('blood bags count', isDigit: true, maxLen: 1);
  final TextConfig _bloodConfig = TextConfig('blood group');
  final TextConfig _dateConfig = TextConfig('injection date');
  @override
  double getContentHeight() {
    // TODO: implement getContentHeight
    return 1300;
  }

  @override
  String getAppBarTitle() {
    // TODO: implement getAppBarTitle
    return 'REQUEST BLOOD';
  }

  @override
  String getActionTitle() {
    return "REQUEST BLOOD";
  }

  _onTap() {
    final Person _loginPerson = donorHandler.loginEmailBehavior.value;
    super.onPersonSet(_loginPerson);
  }

  @override
  Widget getBottomWidget() {
    // TODO: implement getBottomWidget
    return Column(
      children: <Widget>[
        WidgetProvider.getBloodActionButton(
          this._onTap,
          'USE YOUR ADDRESS',
          Icon(
            Icons.place,
            color: Colors.white, //Color.fromARGB(255, 240, 10, 80),
            size: 30,
          ),
        ),

//        SizedBox(height: 24,),
        WidgetTemplate.getSectionTitle('BLOOD INFO', Icons.info_outline),
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
        WidgetProvider.bloodGroupWidget(context, _bloodConfig),

      ],
    );
    ;
  }

  _onPopupClosed() {}
  _showDatePicker(TextConfig _controller) async {
    final _dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 2),
        firstDate: DateTime.now());
    if (_dateTime != null) {
      String date = DateFormat("dd MMM, yyyy").format(_dateTime);
      _controller.controller.text = date;
//      _controller.timestamped = _dateTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return super.build(context);
  }

  @override
  onAddressCompleted(Map _address) {
   debugPrint('$_address');
   final String _bags = this._countConfig.controller.text;
   final String _disease = _diseaseConfig.controller.text;
   final String _group = _bloodConfig.controller.text;
   final String _injection = _dateConfig.controller.text;
   if(_bags.isEmpty){
     super.setError(this._countConfig);
   }
   else if(_disease.isEmpty){
     super.setError(this._diseaseConfig);
   } else if (_group.isEmpty){
     super.setError(this._bloodConfig);
   } else if (_injection.isEmpty){
     super.setError(_dateConfig);
   } else {
     WidgetProvider.loading(context);
     final _data = {
       'address' : _address,
       'bag_count' : _bags,
       'disease' : _disease,
       'blood_group' : _group,
       'injection_date' : _injection,

     };

     Future.delayed(Duration(seconds: 2), () async {
       final FirebaseRepositories _repository = FirebaseRepositories();
       final bool isUpdated = await _repository.uploadBloodRequest(_data);
       Navigator.pop(context);
       if (isUpdated){
         WidgetTemplate.message(context, 'your blood request is updated successfully! anyone, who are willing to donate blood may response to your request! It is wise to made your contact info public');
       }
     });
   }
  }
}
