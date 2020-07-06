import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/widgets/base_widget.dart';
import 'package:plasma_bank/widgets/stateful/data_picker_widget.dart';
import 'package:rxdart/rxdart.dart';

class HealthWidget extends BaseWidget {
  HealthWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    return _HealthState();
  }
}

class _HealthState extends State<HealthWidget> {
  final String _disease = 'People who might not be able to donate blood include those who:\n\n1. have used needles to take drugs, steroids, or other substances that a doctor has not prescribed  have engaged in sex for money or drugs'+
  "\n2. test positive for certain conditions, such as HIV or Creutzfeldt-Jakob disease (CJD)\n" +
  '3. have taken certain medications\n' +
  "4. are male and have had sexual contact with other males in the past 3 months\n";
  final String _covidInfo = 'if you are infected by covid-19 then you may take plasma in critical infection status. and if you are recovered from covid-19 disease, then you may donate your plasma.';
  int languageGroupValue = 0, deviceRegGroupValue = 0;
  final BehaviorSubject<String> _errorBehavior = BehaviorSubject<String>();
  final BehaviorSubject<List<String>> _prescriptionBehavior = BehaviorSubject();
  DateTime _dateTime = new DateTime.now();
  final BehaviorSubject<int> _smokeBehavior = BehaviorSubject<int>();
  final BehaviorSubject<int> _drinkBehavior = BehaviorSubject<int>();
  final BehaviorSubject<int> _diseaseBehavior = BehaviorSubject<int>();
  final BehaviorSubject<int> _covidBehavior = BehaviorSubject<int>();

  bool skipTouch = false;
  String _imagePath;

  final TextConfig _weightConfig = TextConfig('body weight');
  final TextConfig _bloodConfig = TextConfig('blood group');
  final TextConfig _medicineConfig = TextConfig('remarks/disease');

  final TextConfig _infectionConfig = TextConfig('infection date');

  final TextConfig _recoveryConfig = TextConfig('recovery date');

  final TextConfig _ageConfig = TextConfig('age');
  final TextConfig _heightConfig = TextConfig('height');
  TextConfig _selectedConfig;

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
    if (_prescriptionBehavior != null && !_prescriptionBehavior.isClosed) {
      _prescriptionBehavior.close();
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
    final double ratio = 0.325;
//    Navigator.pop(context);
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
                height: 1310,
//                color: Colors.red,
                child: Padding(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  child: Container(
//                    color: Colors.blueAccent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        this._getTitle('PHYSICAL INFO',  Icons.person),
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 1.0),
                          painter: DashLinePainter(),
                        ),
                        Row(
                          children: [
                            Container(
                              width: (_width - 48) / 2 - 8,
                              child: this._getTextField(this._bloodConfig),
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
                        this._getTextField(this._medicineConfig,
                            isReadOnly: false, isDigit: false),
                        this._getTitle('BEHAVIOR INFO',  Icons.accessibility),
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 1.0),
                          painter: DashLinePainter(),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        WidgetTemplate.gateRadio(
                          context,
                          this._drinkBehavior,
                          'DRINKING',
                        ),
                        WidgetTemplate.gateRadio(
                          context,
                          this._smokeBehavior,
                          'SMOKING',
                        ),
                        WidgetTemplate.gateRadio(
                          context,
                          this._diseaseBehavior,
                          'DISEASE',
                          button: IconButton(
                            color: Colors.amber,
                            icon: Icon(
                              Icons.error,
                            ),
                            onPressed: () {
                              WidgetTemplate.message(context, _disease);
                            },
                          ),
                        ),
                        this._getTitle('COVID-19 INFO',  Icons.brightness_high),

                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 1.0),
                          painter: DashLinePainter(),
                        ),
                        WidgetTemplate.gateRadio(
                          context,
                          this._covidBehavior,
                          'COVID-19 :',
                          button: IconButton(
                            color: Colors.amber,
                            icon: Icon(
                              Icons.error,
                            ),
                            onPressed: () {
                              WidgetTemplate.message(context, _covidInfo);
                            },
                          ),
                        ),
                        StreamBuilder(
                          initialData: 0,
                          stream: this._covidBehavior.stream,
                          builder: (_context, _snap) {
                            if (_snap.data == 0) {
                              return SizedBox();
                            }
                            return Container(
                              width: _width - 48,
                              child: Column(
                                children: [
                                  WidgetTemplate.getTextField(
                                    this._infectionConfig,
                                    isReadOnly: true,
                                    showCursor: false,
                                    onTap: () {
                                      this._errorBehavior.sink.add('');
                                      this._showDatePicker(
                                          this._infectionConfig.controller);
                                    },
                                    onEditingDone: () {},
                                  ),
                                  WidgetTemplate.getTextField(
                                    this._recoveryConfig,
                                    isReadOnly: true,
                                    showCursor: false,
                                    onTap: () {
                                      this._showDatePicker(
                                          this._recoveryConfig.controller);
                                      this._errorBehavior.sink.add('');
                                    },
                                    onEditingDone: () {},
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        this._getTitle('PRESCRIPTION',  Icons.description),
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width, 1.0),
                          painter: DashLinePainter(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 48, bottom: 48),
                          child: StreamBuilder<List<String>>(
                            stream: _prescriptionBehavior.stream,
                            initialData: ['-', '-'],
                            builder: (context, snapshot) {
                              return _getPrescription(
                                  snapshot.data, _width, ratio);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: WidgetProvider.button(
            _createDonor,
            "CREATE DONOR",
            context,
          ),
        ),
      ),
    );
  }

  Widget _getTitle(final String _title, final IconData _icon){
    return Padding(
      padding: EdgeInsets.only(top: 48, bottom: 12),
      child: Row(
        children: [
          WidgetProvider.circledIcon(
            Icon(
              _icon,
              color: AppStyle.theme(),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            _title,
            style: TextStyle(
              fontSize: 24,
              fontFamily: AppStyle.fontBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPrescription(final List<String> data, final _width, final ratio) {
    final _widget = Container(
      decoration: AppStyle.shadowDecoration,
      width: _width * ratio,
      height: _width * ratio * 16 / 9,
      child: new Material(
        child: new InkWell(
          onTap: () => _openCamera('-'),
          child: new Center(
            child: Container(
              height: 80,
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description,
                    size: 50,
                  ),
                  Text('IMAGE')
                ],
              ),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        data[0] == '-'
            ? _widget
            : _getPrescriptionImage(data[0], _width * ratio),
        data[1] == '-'
            ? _widget
            : _getPrescriptionImage(data[1], _width * ratio),
//        data[2] == '-' ? _widget : _getPrescriptionImage(data[2], _width * ratio),
      ],
    );
  }

  Widget _getPrescriptionImage(
      final String _imagePath, final double _dimension) {
    return Container(
      decoration: AppStyle.shadowDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Container(
          width: _dimension,
          height: _dimension * 16 / 9.0,
          child: new Material(
            child: new InkWell(
              onTap: () => _openCamera(_imagePath),
              child: Image.file(
                File(_imagePath),
                fit: BoxFit.fitWidth,
              ),
            ),
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  _openCamera(String _path) {
    if (!this.skipTouch) {
      this._imagePath = _path;
      this.skipTouch = true;
      final arguments = {
        'is_front_camera': true,
        'on_captured_function': _onCaptured,
        'route_name' : AppRoutes.pageHealthData,
      };
      Navigator.pushNamed(context, AppRoutes.pageRouteCamera,
          arguments: arguments);
      Future.delayed(Duration(seconds: 1), () {
        this.skipTouch = false;
      });
    }
  }

  _onCaptured(final String _imagePath) {
    final _list = List.from(this._prescriptionBehavior.value ?? ['-', '-']) ;
    if(_list[0] == '-'){
      this._prescriptionBehavior.sink.add([_imagePath, '-']);
    } else if (_list[1] == '-' || _list[1] == this._imagePath){
      this._prescriptionBehavior.sink.add([_list[0], _imagePath]);
    }else if (_list[0] == this._imagePath){
      this._prescriptionBehavior.sink.add([_imagePath, _list[1]]);
    }
  }

  _createDonor() {}

  _getTextField(
    TextConfig _config, {
    isDigit = true,
    isReadOnly = true,
  }) {
    return WidgetTemplate.getTextField(
      _config,
      maxLen: 15,
      isReadOnly: isReadOnly,
      isDigit: isDigit,

      showCursor: true,
      onTap: () {
        this._selectedConfig = _config;
        bool isHeight = _config.labelText == 'height';
        if (_config.labelText == 'body weight' ||
            _config.labelText == 'age' ||
            isHeight) {
          List<List<int>> _data = List();
          bool _isAge = _config.labelText == 'age';
          int _count = isHeight ? 140 : _isAge ? 17 : 40;
          for (int i = 0; i < 20 + (isHeight ? 5 : 0); i++) {
            List<int> _array = List();
            for (int j = 0; j < 4; j++) {
              _array.add(_count);
              _count++;
            }
            _data.add(_array);
          }
          this._openPopUp(
              _data,
              _onSelected,
              _onClosed,
              isHeight
                  ? 'SELECT HEIGHT'
                  : _isAge ? 'SELECT AGE' : 'SELECT WEIGHT',
              unit: isHeight ? 'cm' : _isAge ? 'yr' : 'kg');
        } else if (_config.labelText == 'blood group') {
          List _data = ['A+', 'B+', 'AB+', 'O+', 'A-', 'B-', 'AB-', 'O-'];
          this._openPopUp(_data, _onSelected, _onClosed, 'SELECT BLOOD GROUP');
        }

//        this._errorBehavior.sink.add('');
      },
//      onEditingDone: () {},
    );
  }

  _onSelected(final _data) {
    if (_data == null) {
      this._selectedConfig.controller.text = '';
    } else if (this._selectedConfig.labelText == 'body weight') {
      this._selectedConfig.controller.text = _data.toString() + ' KG';
    } else if (this._selectedConfig.labelText == 'blood group') {
      this._selectedConfig.controller.text = _data.toString();
    } else if (this._selectedConfig.labelText == 'age') {
      this._selectedConfig.controller.text = _data.toString() + ' year';
    } else if (this._selectedConfig.labelText == 'height') {
      this._selectedConfig.controller.text = _data.toString() + ' cm';
    }
  }

  _onClosed() {}

  _openPopUp(final _data, final _selected, final _closed, final _title,
      {String unit = ''}) {
    Future.delayed(
      Duration(
        milliseconds: 100,
      ),
      () {
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
              child: DataPickerWidget(
                _data,
                _selected,
                _closed,
                picketTitle: _title,
                unit: unit,
              ),
            ),
          ),
        );
      },
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
