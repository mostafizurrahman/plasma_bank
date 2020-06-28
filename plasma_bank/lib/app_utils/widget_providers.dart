

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:plasma_bank/widgets/widget_templates.dart';

import 'app_constants.dart';
import 'image_helper.dart';

class WidgetProvider{

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
            icon: new Icon(Icons.arrow_back, ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      title: Text(title ?? "", style: TextStyle(
        color: Colors.pink
      ),),
      centerTitle: true,
    );
  }

  static Widget getButton(final String _title, final Icon suffixIcon, final Function _onTap, {final buttonWidth = 250.0}){
    return Padding(
      padding: const EdgeInsets.only(left: 24, right:  24, top: 16, bottom:  24),
      child: Container(
        width: buttonWidth,
        height: 48,
        child: RaisedButton(
          onPressed: _onTap,
          elevation: 0.5,
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40),
            side: BorderSide(color: Colors.cyan, width: 1.75),
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
                    color: Colors.white
                ),
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
                child: Center(
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static circledIcon(final Widget _icon){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(1000),
          ),
          border: Border.all(
              width: 0.85,
              color: Colors.red,
              style: BorderStyle.solid)),
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
    final _width = (MediaQuery.of(_context).size.width) / _buttonCount;
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
                onTap: ()=>_onTap(i),
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

}