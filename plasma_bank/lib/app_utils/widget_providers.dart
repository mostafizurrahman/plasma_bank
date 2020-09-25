import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/widgets/stateful/data_picker_widget.dart';

import 'app_constants.dart';
import 'image_helper.dart';

class WidgetProvider {
  static Widget getAppBar(BuildContext context, {title}) {
    return AppBar(
      elevation: 1.25,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
      leading: Container(
        height: 70,
        child: Center(
          child: new IconButton(
            icon: new Icon(
              Icons.arrow_back,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      title: Text(
        title ?? "",
        style: TextStyle(color: Colors.pink),
      ),
      centerTitle: true,
    );
  }

  static Widget getButton(
      final String _title, final Icon suffixIcon, final Function _onTap,
      {final buttonWidth = 250.0}) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 24),
      child: Container(
        width: buttonWidth,
        height: 48,
        child: RaisedButton(
          onPressed: _onTap,
          elevation: 0.5,
          color: AppStyle.theme(),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40),
            side: BorderSide(color: Colors.white, width: 1.75),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: suffixIcon,
              )
            ],
          ),
        ),
      ),
    );
  }

  static loading(BuildContext context) {
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
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: new BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 6.0,
                    ),
                  ],
                  color: Colors.black54.withOpacity(0.5),
                  borderRadius:
                      new BorderRadius.all(const Radius.circular(12.0)),
                ),
                child: WidgetProvider.loadingBox(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget loadingBox() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: WidgetTemplate.indicator(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              "LOADING...",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  static circledIcon(final Widget _icon) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
          border: Border.all(
              width: 0.85, color: Colors.red, style: BorderStyle.solid)),
      child: _icon,
    );
  }

  //theme color #FF006C
  static List<Widget> navigators(
      final BuildContext _context, final int _selectedIndex, _onTap) {
    final List<String> _icons = [
      'donate_n.png',
      'collect_n.png',
      'home_n.png',
      'chat_n.png',
      'option_n.png'
    ];

    final int _buttonCount = 5;
    final _width = displayData.width / _buttonCount;
    List _widgets = List<Widget>();

    for (int i = 0; i < _buttonCount; i++) {
      final _iconName =
          _selectedIndex == i ? _icons[i].replaceAll('_n', '_h') : _icons[i];
      final _widget = Container(
        color: Colors.transparent,
        width: _width - 5,
        height: _width - 5,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(_width)),
          child: Material(
            color: Colors.white,
            child: Ink(
              child: InkWell(
                onTap: () => _onTap(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(2),
                      child: Container(
                        width: 24,
                        height: 24,
                        child: Image(
                          image: ImageHelper.getImageAsset(_iconName),
                        ),
                      ),
                    ),
                    Text(
                      _iconName.split('_')[0].toUpperCase(),
                      style: TextStyle(
                        fontFamily: i == _selectedIndex
                            ? AppStyle.fontBold
                            : AppStyle.fontNormal,
                        fontSize: 10,
                        color: i == _selectedIndex
                            ? Color.fromARGB(255, 255, 0, 74)
                            : Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      _widgets.add(_widget);
    }
    return _widgets;
  }

  static button(Function _onTap, final String txt, BuildContext context,
      {padding = 50.0}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        height: 50,
        width: displayData.width - padding,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: AppStyle.theme(),
          onPressed: () {
            debugPrint('this is done');
            if (_onTap != null) {
              _onTap();
            }
          },
          child: Text(
            txt,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  static errorButton(Function _onTap, final String txt, BuildContext context,
      {padding = 50.0}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        height: 50,
        width: displayData.width-padding,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: AppStyle.theme(), width: 1.5),
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.white,
          onPressed: () {
            debugPrint('this is done');
            if (_onTap != null) {
              _onTap();
            }
          },
          child: Text(
            txt,
            style: TextStyle(fontSize: 13, color: AppStyle.theme()),
          ),
        ),
      ),
    );
  }

  static PreferredSize appBar(String _title, {List<Widget> actions}) {
    assert(_title != null, 'TITLE IS NULL');
    return PreferredSize(
      preferredSize: Size.fromHeight(54.0),
      child: AppBar(
        automaticallyImplyLeading: false, // hides leading widget
        flexibleSpace: AppBar(
          actions: actions != null ? actions : [],
          centerTitle: false,
          backgroundColor: AppStyle.greyBackground(),
          title: Text(
            _title,
            style: TextStyle(color: AppStyle.titleTxtColor()),
          ),
          iconTheme: IconThemeData(color: AppStyle.theme()),
          titleSpacing: 0,
        ),
      ),
    );
  }

  static Widget getInkButton(
    final double _width,
    final double _height,
    final Function _onTap,
    final IconData _iconName, {
    final String title,
    final double iconSize = 25,
    final Color iconColor = Colors.black,
  }) {
    return Container(
      width: _width,
      height: _width,
      child: new Material(
        child: new InkWell(
          onTap: _onTap,
          child: new Center(
            child: Container(
              height: 80,
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _iconName,
                    size: iconSize,
                    color: iconColor,
                  ),
                  title != null ? Text(title ?? '') : SizedBox(),
                ],
              ),
            ),
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }

  static addTextInController(
      final TextEditingController _selectedController, String _key) {
    var cursorPos = _selectedController.selection;
    final String _text = _selectedController.text;
    int _start = cursorPos.start;
    int _end = cursorPos.end;
    String _firstString = _start >= 0 ? _text.substring(0, _start) : _text;
    String _endString =
        _end >= 0 && _end >= _start ? _text.substring(_end, _text.length) : '';
    int _offset =
        (_start == -1 && _end == -1 ? 0 : _start >= 0 ? _start : _end) + 1;
    String _output;
    if (_key.toLowerCase() != 'del') {
      _firstString += _key;
      _output = _firstString + _endString;
    } else {
      if (_start == _end && _start > 0) {
        _output =
            _firstString.substring(0, _firstString.length - 1) + _endString;
        _offset = _start - 1;
      } else if (_start == 0 && _end == 0) {
        _offset = 0;
        _output = _firstString + _endString;
      } else if (_end > _start) {
        _output = _firstString + _endString;
        _offset = _start;
      } else {
        _output = _firstString + _endString;
        _offset = _output.length;
      }
    }
    _selectedController.text = _output;
    cursorPos = TextSelection.fromPosition(TextPosition(offset: _offset));
    _selectedController.selection = cursorPos;
  }

  static Widget getBackAppBar(BuildContext _context, {final title}) {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
      leading: Row(
        children: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              color: AppStyle.theme(),
            ),
            onPressed: () => Navigator.of(_context).pop(),
          ),

//
//          _getProfilePicture(donorHandler.loginDonor),
//          SizedBox(width: 12,),
        ],
      ),
      title: title == null
          ? SizedBox()
          : title is String
              ? Text(
                  title,
                  style: TextStyle(fontSize: 22, fontFamily: AppStyle.fontBold, color: Colors.black),
                )
              : title,
      centerTitle: true,
    );
  }

  static  openLocationPopUp(BuildContext context, final _data, final _selected, final _closed, final _title) {
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
              ),
            ),
          ),
        );
      },
    );
  }

  static Widget bloodGroupWidget(final BuildContext context, final TextConfig _textConfig, {final Function onPopupClosed}){
    return WidgetTemplate.getTextField(
      _textConfig,
      isReadOnly: true,
      onTap: () {
        List _data = [
          'A+',
          'B+',
          'AB+',
          'O+',
          'A-',
          'B-',
          'AB-',
          'O-'
        ];
        WidgetProvider.openLocationPopUp(
            context,
            _data,
                (_data) => _textConfig.controller.text =
                _data.toString(),
            onPopupClosed,
            'SELECT BLOOD GROUP');
      },
    );
  }
}
