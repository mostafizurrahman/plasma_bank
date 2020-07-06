import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/widgets/base_widget.dart';
import 'package:rxdart/rxdart.dart';

class HealthWidget extends BaseWidget {
  HealthWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    return _HealthState();
  }
}

class _HealthState extends State<HealthWidget> {
  int languageGroupValue = 0, deviceRegGroupValue = 0;
  final BehaviorSubject<String> _errorBehavior = BehaviorSubject<String>();
  DateTime _dateTime = new DateTime.now();
  final BehaviorSubject<int> _smokeBehavior = BehaviorSubject<int>();
  final BehaviorSubject<int> _drinkBehavior = BehaviorSubject<int>();
  final BehaviorSubject<int> _diseaseBehavior = BehaviorSubject<int>();
  final BehaviorSubject<int> _covidBehavior = BehaviorSubject<int>();

//  this.weight = map['weight'];
//  this.hasSickness = map['sick'];
//  this.diseaseName = map['disease'];
//  this.hasSmokeHabit = map['smoke'];
//  this.hasDrinkHabit = map['drink'];
//  this.medicineList = map['medicines'];
//  this.prescriptionList = map['prescriptions'];

  final TextConfig _weightConfig = TextConfig('body weight');
  final TextConfig _bloodConfig = TextConfig('blood group');
  final TextConfig _medicineConfig = TextConfig('remarks/disease');

  final TextConfig _infectionConfig = TextConfig('infection date');

  final TextConfig _recoveryConfig = TextConfig('recovery date');

  final TextConfig _ageConfig = TextConfig('age');
  final TextConfig _heightConfig = TextConfig('height');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_errorBehavior != null && !_errorBehavior.isClosed) {
      _errorBehavior.close();
    }
    if (_smokeBehavior != null && !_smokeBehavior.isClosed) {
      _smokeBehavior.close();
    }
    if (_drinkBehavior != null && !_drinkBehavior.isClosed) {
      _drinkBehavior.close();
    }
    if (_diseaseBehavior != null && !_diseaseBehavior.isClosed) {
      _diseaseBehavior.close();
    }
    if (_covidBehavior != null && !_covidBehavior.isClosed) {
      _covidBehavior.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _paddingBottom = MediaQuery.of(context).padding.bottom;
    final _paddingTop = MediaQuery.of(context).padding.top;
    final _appBarHeight = 54;
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final _contentHeight =
        _height - _paddingBottom - _paddingTop - _appBarHeight;
    return Container(
      color: AppStyle.greyBackground(),
      child: Padding(
        padding: EdgeInsets.only(bottom: _paddingBottom),
        child: Scaffold(
          appBar: WidgetProvider.appBar('Health'),
          body: Container(
            height: _contentHeight,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Container(
                width: _width,
                height: 1500,
//                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  child: Container(
//                    color: Colors.blueAccent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 32, bottom: 12),
                          child: Text(
                            'PHYSICAL INFO',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 1.0),
                          painter: DashLinePainter(),
                        ),
                        Row(
                          children: [
                            Container(
                              width: (_width - 48) / 2 - 8,
                              child: WidgetTemplate.getTextField(
                                this._bloodConfig,
                                isReadOnly: true,
                                showCursor: false,
                                onTap: () {
                                  this._errorBehavior.sink.add('');
                                },
                                onEditingDone: () {},
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              width: (_width - 48) / 2 - 8,
                              child: this._getTextField(this._ageConfig),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: (_width - 48) / 2 - 8,
                              child: this._getTextField(this._weightConfig),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              width: (_width - 48) / 2 - 8,
                              child: this._getTextField(this._heightConfig),
                            ),
                          ],
                        ),
                        this._getTextField(this._medicineConfig),
                        Padding(
                          padding: EdgeInsets.only(top: 36, bottom: 12),
                          child: Text(
                            'BEHAVIOR INFO',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 1.0),
                          painter: DashLinePainter(),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        WidgetTemplate.gateRadio(context,
                          this._drinkBehavior, 'DRINKING', ),
                        WidgetTemplate.gateRadio(context,
                          this._smokeBehavior, 'SMOKING',
                        ),
                        WidgetTemplate.gateRadio(context,
                          this._diseaseBehavior,
                          'DISEASE',
                          button: IconButton(
                            color: Colors.amber,
                            icon: Icon(
                              Icons.error,
                            ),
                            onPressed: () {
                              debugPrint('show popup');
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 36, bottom: 12),
                          child: Text(
                            'COVID-19 INFO',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 1.0),
                          painter: DashLinePainter(),
                        ),
                        WidgetTemplate.gateRadio(context,
                          this._covidBehavior,
                          'COVID-19 :',
                          button: IconButton(
                            color: Colors.amber,
                            icon: Icon(
                              Icons.error,
                            ),
                            onPressed: () {
                              debugPrint('show popup');
                            },
                          ),
                        ),
                        
                        StreamBuilder(
                          initialData: 0,
                          stream: this._covidBehavior.stream,
                          builder: (_context, _snap){

                            if(_snap.data == 0){
                              return SizedBox();
                            }
                            return Container(
                              width:  _width - 48,
                              height: 200,
//                              color: Colors.red,
                              child: Column(
                                children: [
                                  WidgetTemplate.getTextField(
                                    this._infectionConfig,
                                    isReadOnly: true,
                                    showCursor: false,
                                    onTap: () {
                                      this._errorBehavior.sink.add('');
                                      this._showDatePicker(this._infectionConfig.controller);
                                    },
                                    onEditingDone: () {},
                                  ),
                                  WidgetTemplate.getTextField(
                                    this._recoveryConfig,
                                    isReadOnly: true,
                                    showCursor: false,
                                    onTap: () {
                                      this._showDatePicker(this._recoveryConfig.controller);
                                      this._errorBehavior.sink.add('');
                                    },
                                    onEditingDone: () {},
                                  )
                                ],
                              ),
                            );

                          },
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getTextField(TextConfig _config) {
    return WidgetTemplate.getTextField(
      _config,
      maxLen: 15,
      isReadOnly: false,
      isDigit: true,
      showCursor: true,
      onTap: () {
        this._errorBehavior.sink.add('');
      },
      onEditingDone: () {},
    );
  }

  _showDatePicker(TextEditingController _controller) async {

    _dateTime = await showDatePicker(
        context: context,
        initialDate: _dateTime ?? DateTime.now(),
        lastDate: DateTime.now(),
        firstDate: DateTime(1920));
    if (_dateTime != null) {
      String date = DateFormat("dd-MM-yyyy").format(_dateTime);
      _controller.text = date;
    }
  }
}
