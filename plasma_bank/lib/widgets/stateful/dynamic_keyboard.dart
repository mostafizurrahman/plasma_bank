


import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';

class DynamicKeyboardWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DynamicKeyboardState();
  }

}


class _DynamicKeyboardState extends State<DynamicKeyboardWidget> {


  double _keyboardHeight = 200;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _keyboardHeight = 215;
    displayData.setData(context);
    return Container(
      child: Scaffold(


//        body: Container(height: 100, color: Colors.green,),
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: displayData.bottom),
          child: Container(
//            decoration: AppStyle.lightDecoration,
          color: Color.fromARGB(200, 230, 230, 230),
            width: MediaQuery.of(context).size.width,
            height: _keyboardHeight,
            child: _getKeyboard(),
          ),
        ),
      ),
    );
  }


  Widget _getKeyboard(){

    List<List<String>> _keyDataTxt = [
      ['Q', 'W', 'E', 'R', 'T', "Y", 'U', 'I', "O", "P"],
      ["A", "S", "D", "F", "G", "H", "J", "K", "L"],
      ["⬆", 'Z', "X", "C", "V", "B", "N", "M", "⌫"],//'⬇'
      ["123",  "space", "✅"]];


    List<List<String>> _keyDataNum = [
      ['0', '1', '2', '3', '4', "5", '6', '7', "8", "9"],
      ["-", "/", ":", ";", "(", ")", "~", "&", "@", "\""],
      ["#+=", '.', ",", "?", "!", "\'", "DEL"],
      ["ABC", "SMILE", "SPACE", "DONE"]];

    List<List<String>> _keyDataChar = [
      ['[', ']', '{', '}', '#', "%", '^', '*', "+", "="],
      ["_", "\\", "|", "~", "<", ">", "€", "\$", "￥", "•"],
      ["#+=", '.', ",", "?", "!", "\'", "DEL"],
      ["ABC",  "SPACE", "DONE"]];

    final double _keyHeight = (_keyboardHeight - 52) / 4;
    List<Widget> _columnWidgets = [];

    double charWidth = 0;
    for(int i = 0; i < 4; i++){
      List<String> _dataArray = _keyDataTxt[i];
      final int len = _dataArray.length;
      final double _space = (len+1).toDouble() * 5;
      final double _paddingTop = i == 0 ? 6 : 10;
      final double _paddingBottom = i == 3 ? 8 : 0;
      List<Widget> _rowData = [];

      double _keyWidth =  (displayData.width - _space) / len;
      if(charWidth == 0){
        charWidth = _keyWidth;
      }

      if(i == 1){
        _rowData.add(SizedBox(width: 12,));
      }
      for(int j = 0; j < len; j++){
        final String _key = _dataArray[j];
        final _spacial = "⬆" == _key || "⌫" == _key;
        final double _paddingLeft = 2.5 + ( _key == "⌫" ? 6 : 0);
        final double _paddingRight = _paddingLeft + ("⬆" == _key ? 6 : 0);//j == len - 1 ? 2.5 : 5;


        if(i == 3){
          if(j == 0 || j == 2){
            _keyWidth = (displayData.width - _space) * 0.2;
          } else {
            _keyWidth = (displayData.width - _space) * 0.6;
          }
        }
        final Widget _keyWidget =  Padding(
          padding: EdgeInsets.only(left: _paddingLeft,
              right: _paddingRight, bottom: _paddingBottom, top: _paddingTop),
          child: Container(
            width: _spacial ? _keyHeight : _isText(_key)? charWidth  : _keyWidth , height: _keyHeight,

            decoration: BoxDecoration(
              color: Colors.white,
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
                child: Ink(
                  child: InkWell(
                    onTap: (){
                      debugPrint("I AM DONE");
                    },
                    child:
                    Center(
                      child: Text(
                        _key,
                        style: TextStyle(fontSize: 20, fontFamily: AppStyle.fontBold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        _rowData.add(_keyWidget);
      }

      if(i == 1){
        _rowData.add(SizedBox(width: 12,));
      }
      final Row _row = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _rowData,
      );
      _columnWidgets.add(_row);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:_columnWidgets,
    );
  }


  bool _isText(String key){

    if(key.length > 1){
      return false;
    }
    int _i = key.codeUnitAt(0);
    return _i >= 65 && _i <= 90 || _i >= 97 && _i <= 122;

  }

//  Widget _getKeyWidget(final String key,
//      final double _width, final dou)



}