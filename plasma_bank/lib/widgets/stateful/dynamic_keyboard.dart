import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:rxdart/rxdart.dart';

class DynamicKeyboardWidget extends StatefulWidget {
  final IconData doneButtonIcon;
  final Function(String) onKeyPressed;
  final Function(String) onKeyDownStart;
  final Function onDeleteLongPressed;
  DynamicKeyboardWidget(this.onKeyPressed,
      {this.onKeyDownStart, this.onDeleteLongPressed, this.doneButtonIcon = Icons.check_circle});

  @override
  State<StatefulWidget> createState() {
    return _DynamicKeyboardState();
  }
}

class _DynamicKeyboardState extends State<DynamicKeyboardWidget> {
  final int _keyboardNumber = 1;
  final int _keyboardString = 0;
  final int _keyboardSpecial = 2;
  BehaviorSubject<bool> _upperCasedBehavior = BehaviorSubject();
  BehaviorSubject<int> _numberBehavior = BehaviorSubject();

  double _keyboardHeight = AppStyle.KEYBOARD_HEIGHT_TEXT;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _upperCasedBehavior.close();
    _numberBehavior.close();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _keyboardHeight = 210;
//    displayData.setData(context);
    return Container(
//            decoration: AppStyle.lightDecoration,
      color: Color.fromARGB(200, 230, 230, 230),
      width: MediaQuery.of(context).size.width,
      height: _keyboardHeight,
      child: StreamBuilder<int>(
          initialData: _keyboardString,
          stream: _numberBehavior.stream,
          builder: (context, snapshot) {
            return _getKeyboard(snapshot.data);
          }),
    );
  }

  Widget _getKeyboard(final int _index) {
    List<List<String>> _keyDataTxt = [
      ['Q', 'W', 'E', 'R', 'T', "Y", 'U', 'I', "O", "P"],
      ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
      ["TOG", 'Z', "X", "C", "V", "B", "N", "M", "DEL"], //'⬇'
      ["123", "space", "DONE"]
    ];

    List<List<String>> _keyDataNum = [
      ['0', '1', '2', '3', '4', "5", '6', '7', "8", "9"],
      ["-", "/", ":", ";", "(", ")", "~", "&", "@", "\""],
      ["#+=", '.', ",", "?", "!", "\'", "DEL"],
      ["ABC", "space", "DONE"]
    ];

    List<List<String>> _keyDataChar = [
      ['[', ']', '{', '}', '#', "%", '^', '*', "+", "="],
      ["_", "\\", "|", "~", "<", ">", "€", "\$", "￥", "•"],
      ["123", '.', ",", "?", "!", "\'", "DEL"],
      ["ABC", "space", "DONE"]
    ];

    List<Widget> _columnWidgets = _index == _keyboardString
        ? [
            _get10CharactersRow(_keyDataTxt[0], isFirstRow: true),
            _get9CharactersRow(_keyDataTxt[1]),
            _get9TCharactersRow(_keyDataTxt[2]),
            _get3CharactersRow(_keyDataTxt[3]),
          ]
        : _index == _keyboardNumber
            ? [
                _get10CharactersRow(_keyDataNum[0], isFirstRow: true),
                _get10CharactersRow(_keyDataNum[1]),
                _get7CharactersRow(_keyDataNum[2]),
                _get3CharactersRow(_keyDataNum[3]),
              ]
            : [
                _get10CharactersRow(_keyDataChar[0], isFirstRow: true),
                _get10CharactersRow(_keyDataChar[1]),
                _get7CharactersRow(_keyDataChar[2]),
                _get3CharactersRow(_keyDataChar[3]),
              ];

    return StreamBuilder<bool>(
        stream: _upperCasedBehavior.stream,
        builder: (context, snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _columnWidgets,
          );
        });
  }

  Widget _get10CharactersRow(final List<String> _dataList,
      {bool isFirstRow = false}) {
    final double _keyHeight = (_keyboardHeight - 52) / 4;
    final double _paddingTop = isFirstRow ? 0 : 6;
    final double _paddingLR = 2.5;
    double _keyWidth = (displayData.width - (_paddingLR * (10 * 2 + 1))) / 10.0;

    List<Widget> _widgets = List();
    for (int i = 0; i < _dataList.length; i++) {
      final Widget _widget = _getKeyWidget(
          _paddingLR, _paddingTop, _keyWidth, _keyHeight, _dataList[i]);
      _widgets.add(_widget);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _widgets,
    );
  }

  Widget _get9CharactersRow(final List<String> _dataList) {
    final double _keyHeight = (_keyboardHeight - 52) / 4;
    final double _paddingTop = 6;
    final double _paddingLR = 2.5;
    double _keyWidth =
        (displayData.width - (_paddingLR * (10 * 2 + 1)) - 28) / 9.0;

    List<Widget> _widgets = List();
    _widgets.add(SizedBox(
      width: 14,
    ));
    for (int i = 0; i < _dataList.length; i++) {
      final Widget _widget = _getKeyWidget(
          _paddingLR, _paddingTop, _keyWidth, _keyHeight, _dataList[i]);
      _widgets.add(_widget);
    }
    _widgets.add(SizedBox(
      width: 14,
    ));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _widgets,
    );
  }

  Widget _get9TCharactersRow(final List<String> _dataList) {
    final double _keyHeight = (_keyboardHeight - 52) / 4;
    final double _paddingTop = 6;
    final double _paddingLR = 2.5;
    double discarding = 2.5 * 8 + 12 * 2 + 2 * _keyHeight + 12;
    double _keyWidth = (displayData.width - discarding) / 7.0;

    List<Widget> _widgets = List();
    Widget _widget = Padding(
      padding: EdgeInsets.only(left: _paddingLR, top: _paddingTop, right: 8),
      child: _getKeyWidget(0, 0, _keyHeight, _keyHeight, _dataList[0],
          isSpecial: true),
    );
    _widgets.add(_widget);
    for (int i = 1; i < _dataList.length - 1; i++) {
      final Widget _widget = _getKeyWidget(
          _paddingLR, _paddingTop, _keyWidth, _keyHeight, _dataList[i]);
      _widgets.add(_widget);
    }
    _widget = Padding(
      padding: EdgeInsets.only(left: 8, top: _paddingTop, right: _paddingLR),
      child: _getKeyWidget(
          0, 0, _keyHeight, _keyHeight, _dataList[_dataList.length - 1],
          isSpecial: true),
    );
    _widgets.add(_widget);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _widgets,
    );
  }

  Widget _get7CharactersRow(final List<String> _dataList) {
    final double _keyDimension = (_keyboardHeight - 47) / 4;
    final double _paddingTop = 6;
    final double _paddingLR = 2.5;
    List<Widget> _widgets = List();
    Widget _widget = Padding(
      padding: EdgeInsets.only(left: _paddingLR, top: _paddingTop, right: 12),
      child: _getKeyWidget(0, 0, _keyDimension, _keyDimension, _dataList[0],
          isSpecial: true),
    );
    _widgets.add(_widget);
    for (int i = 1; i < _dataList.length - 1; i++) {
      final Widget _widget = _getKeyWidget(
          _paddingLR, _paddingTop, _keyDimension, _keyDimension, _dataList[i]);
      _widgets.add(_widget);
    }
    _widget = Padding(
      padding: EdgeInsets.only(left: 12, top: _paddingTop, right: _paddingLR),
      child: _getKeyWidget(
          0, 0, _keyDimension, _keyDimension, _dataList[_dataList.length - 1],
          isSpecial: true),
    );
    _widgets.add(_widget);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _widgets,
    );
  }

  Widget _get3CharactersRow(final List<String> _dataList) {
    final double _contentWidth = displayData.width - 70;
    final double _keyHeight = (_keyboardHeight - 52) / 4;
    final double _paddingTop = 4;
    final double _paddingLR = 2.5;
    List<Widget> _widgets = List();
    Widget _widget = _getKeyWidget(
        _paddingLR, _paddingTop, _contentWidth * 0.2, _keyHeight, _dataList[0],
        isSpecial: true);
    _widgets.add(_widget);

    _widget = _getKeyWidget(
        16, _paddingTop, _contentWidth * 0.6 + 27.5, _keyHeight, _dataList[1],
        isSpecial: false);
    _widgets.add(_widget);
    _widget = _getKeyWidget(
        _paddingLR, _paddingTop, _contentWidth * 0.2, _keyHeight, _dataList[2],
        isSpecial: true);
    _widgets.add(_widget);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: _widgets,
    );
  }

  Widget _getKeyWidget(final double _paddingLR, final double _paddingTop,
      final double _keyWidth, final double _keyHeight, final String _key,
      {bool isSpecial = false}) {
    return Padding(
      padding: EdgeInsets.only(
        left: _paddingLR,
        right: _paddingLR,
        top: _paddingTop,
      ),
      child: Container(
        width: _keyWidth,
        height: _keyHeight,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              offset: Offset(0, 0),
              blurRadius: 1,
              spreadRadius: 0.5,
            ),
          ],
          borderRadius: const BorderRadius.all(
            const Radius.circular(5),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
            const Radius.circular(5),
          ),
          child: Material(
            color: isSpecial ? Colors.grey : Colors.white,
            child: Ink(
              child: InkWell(
                onTapDown: (value) => _onKeyStarted(_key),
                onTapCancel: () {
                  if (this.widget.onKeyDownStart != null) {
                    this.widget.onKeyDownStart(null);
                  }
                },
                onTap: () => _onKeyPressed(_key),
                child: Center(
                  child: _key == 'TOG'
                      ? _getToggleIcon()
                      : _key == 'DEL'
                          ? _getDeleteIcon()
                          : _key == 'DONE'
                              ? _getDoneIcon()
                              : StreamBuilder<bool>(
                                  initialData: false,
                                  stream: _upperCasedBehavior.stream,
                                  builder: (context, snapshot) {
                                    return Text(
                                      snapshot.data
                                          ? _key.toUpperCase()
                                          : _key.toLowerCase(),
                                      style: TextStyle(
                                        fontSize: isSpecial || _key == 'space'
                                            ? 16
                                            : 20,
                                        fontFamily: isSpecial || _key == 'space'
                                            ? AppStyle.fontNormal
                                            : AppStyle.fontBold,
                                      ),
                                    );
                                  },
                                ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getDeleteIcon() {
    return GestureDetector(
      onLongPress: (){
        if(this.widget.onDeleteLongPressed != null) {
          this.widget.onDeleteLongPressed();
        }
      },

      child: Icon(
        Icons.backspace,
        color: Colors.black,
      ),
    );
  }

  Widget _getDoneIcon() {
    return Icon(
      this.widget.doneButtonIcon,
      color: Colors.black,
    );
  }

  Widget _getToggleIcon() {
    return StreamBuilder<bool>(
      stream: _upperCasedBehavior.stream,
      initialData: false,
      builder: (context, snapshot) {
        return Icon(
          snapshot.data ? Icons.file_download : Icons.file_upload, //
          color: Colors.black,
        );
      },
    );
  }

  _onKeyPressed(final String _key) {
    final bool _isUpperCased = _upperCasedBehavior.value ?? false;
    if (_key == 'TOG') {
      this._upperCasedBehavior.sink.add(!_isUpperCased);
    } else if (_key == '123') {
      this._numberBehavior.sink.add(_keyboardNumber);
    } else if (_key == 'ABC') {
      this._numberBehavior.sink.add(_keyboardString);
    } else if (_key == '#+=') {
      this._numberBehavior.sink.add(_keyboardSpecial);
    } else {
      this.widget.onKeyPressed(
          _isUpperCased ? _key.toUpperCase() : _key.toLowerCase());
    }
  }

  _onKeyStarted(final String _key) {
    if (this.widget.onKeyDownStart != null) {
      final bool _isUpperCased = _upperCasedBehavior.value ?? false;
      if (_key == 'TOG' ||
          _key == '123' ||
          _key == 'ABC' ||
          _key == '#+=' ||
          _key == 'DONE') {
      } else {
        if (_key == 'DEL') {
          this.widget.onKeyDownStart('del');
        } else if (_key == 'space') {
          this.widget.onKeyDownStart('spc');
        } else {
          this.widget.onKeyDownStart(
              _isUpperCased ? _key.toUpperCase() : _key.toLowerCase());
        }
      }
    }
  }
}
