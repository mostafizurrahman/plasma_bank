


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';


class KeyboardWidget extends StatefulWidget{

  final Function(String) onKeyPressed;
  KeyboardWidget(this.onKeyPressed);
  @override
  State<StatefulWidget> createState() {
    return _KeyboardState();
  }
}

class _KeyboardState extends State<KeyboardWidget>{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppStyle.KEYBOARD_HEIGHT_NUMBER,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 220, 220, 220),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.2),
            offset: Offset(0, 0),
            blurRadius: 4,
//          spreadRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: _getKeyboard(),
      ),
    );
  }



  List<Widget> _getKeyboard() {
    final _data = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['d', '0', "x"],
    ];
    final _edges = [
      EdgeInsets.fromLTRB(0, 0, 8, 0),
      EdgeInsets.fromLTRB(28, 0, 36, 0),
      EdgeInsets.fromLTRB(0, 0, 8, 0),
    ];
    List<Widget> _rows = List();
    for (int i = 0; i < 4; i++) {
      List<Widget> _widgets = List();
      for (int j = 0; j < 3; j++) {
        final _value = _data[i][j];
        final _widget = _getKeyboardWidget(_value, _edges[j]);
        _widgets.add(_widget);
      }
      _rows.add(Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _widgets,
        ),
      ));
    }
    return _rows;
  }

  Widget _getKeyboardWidget(final String _value, final EdgeInsets _padding) {
    final keyWidth = 50.0;
    return Padding(
      padding: _padding,
      child: ClipRRect(
        child: new Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.all(Radius.circular(keyWidth / 2.0)),
          ),
          width: keyWidth,
          height: keyWidth,
          child: new Material(
            child: new InkWell(
              onTap: () => this.widget.onKeyPressed(_value),
              child: new Center(
                child: Container(
                  height: keyWidth,
                  width: keyWidth,
                  child: _getContent(_value),
                ),
              ),
            ),
            color: Colors.transparent,
          ),
        ),
        borderRadius: BorderRadius.all(Radius.circular(keyWidth / 2.0)),
      ),
    );
  }

  Widget _getContent(final String _keyValue) {
    if (_keyValue == "x") {
      return Icon(Icons.backspace);
    }
    if (_keyValue == "d") {
      return Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 30,
      );
    }
    return Center(
      child: Text(
        _keyValue,
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
      ),
    );
  }

}