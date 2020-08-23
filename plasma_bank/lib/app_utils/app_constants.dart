import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
<<<<<<< HEAD
=======
import 'package:rxdart/rxdart.dart';
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35

class AppConstants {}

class AppRoutes {
  static const String pageRouteHome = "/home";
  static const String pageRouteDonor = "/home/donor";
  static const String pageRouteEntry = "/home/entry";
  static const String pageRouteImage = "/home/camera/image";
  static const String pageRouteCamera = "/home/camera";

  static const String pageLocateTerms = '/home/locationTerms';
  static const String pageAddressData = '/home/address';
  static const String pagePersonData = '/home/personal';
  static const String pageHealthData = '/home/personal/health';

<<<<<<< HEAD
=======
  static const String pageDonorList = '/home/donor/list';
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
}

class AppConfig {
  static const double PADDING_ALL = 24;
  static const double FONT_SIZE_DEF = 13;
  static const double FONT_SIZE_SML = 10;
  static const double FONT_SIZE_XL = 15;
  static const double FONT_SIZE_XXL = 18;
  AppConfig();
  bool hasInternet = true;
}

class AppStyle {
<<<<<<< HEAD

=======
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
  static const double PADDING = 24;
  static const double PADDING_M = 12;
  static const double PADDING_S = 8;

  static const double ICON_SIZE_S = 26;

<<<<<<< HEAD
  static Color greyBackground({ alpha = 255}){

=======
  static Color greyBackground({alpha = 255}) {
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    final _background = (0.9 * 255).toInt();
    return Color.fromARGB(alpha, _background, _background, _background);
  }

<<<<<<< HEAD

  static Color txtLine(){
    return Color.fromARGB(255, 150, 150, 150);
  }

  static BoxDecoration circularShadow(){
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0, 0),
          blurRadius: 12,
          spreadRadius: 8,
        ),
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
    );
  }


  static BoxDecoration lightShadow(){
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          offset: Offset(0, 0),
          blurRadius: 8,
          spreadRadius: 4,
        ),
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
    );
  }

  static BoxDecoration highlightShadow(){
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 255, 20, 80),
          offset: Offset(0, 0),
          blurRadius: 8,
          spreadRadius: 4,
        ),
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
    );
  }

  static const fontBold = 'SF_UIFont_Bold';
  static const fontNormal = 'SF_UIFont';
  static const Color colorHighlight = Color.fromARGB(255, 255, 20, 80);
  static const BoxDecoration shadowDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.15),
        offset: Offset(0, 0),
        blurRadius: 12,
        spreadRadius: 8,
      ),
    ],
    borderRadius: const BorderRadius.all(
      const Radius.circular(16),
    ),
  );

  static const BoxDecoration selectedDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(255, 255, 20, 80),
        offset: Offset(0, 0),
        blurRadius: 12,
        spreadRadius: 8,
      ),
    ],
    borderRadius: const BorderRadius.all(
      const Radius.circular(16),
    ),
  );

  static String format(final int number) {
    final _formatter = new NumberFormat("###,###,###", "en_US");
    return _formatter.format(number).toString();
  }

  static Color theme(){
    return Color.fromARGB(255, 240, 10, 80);
  }

  static Color titleTxtColor(){
    return Color.fromARGB(255, 60, 50, 70);
  }

  static BoxDecoration getLightBox() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0, 0),
          blurRadius: 6,
          spreadRadius: 3,
        ),
      ],
      borderRadius: const BorderRadius.all(
        const Radius.circular(5),
      ),
    );
  }

  static BoxDecoration bottomNavigatorBox() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0, 0),
          blurRadius: 12,
          spreadRadius: 8,
        ),
      ],
      borderRadius: const BorderRadius.only(
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
      ),
    );
//    BoxDecoration(
//      color: Colors.white,
//      boxShadow: [
//        BoxShadow(
//          color: Colors.black.withAlpha(20),
//          offset: Offset(0, 0),
//          blurRadius: 4,
//          spreadRadius: 2,
//        ),
//      ],
//      borderRadius: const BorderRadius.only( topLeft: const Radius.circular(12), topRight: const Radius.circular(12),),
//
//    );
  }
}

class TextConfig{

  final int maxLen;
  final bool isDigit;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final String labelText;
  TextConfig(this.labelText, {this.isDigit = false, this.maxLen = 25});
}
=======
  static Color txtLine() {
    return Color.fromARGB(255, 150, 150, 150);
  }

  static BoxDecoration circularShadow() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0, 0),
          blurRadius: 12,
          spreadRadius: 8,
        ),
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
    );
  }

  static BoxDecoration lightShadow() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.1),
          offset: Offset(0, 0),
          blurRadius: 8,
          spreadRadius: 4,
        ),
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
    );
  }

  static BoxDecoration highlightShadow({Color color}) {
    if (color == null) {
      color = Color.fromARGB(255, 255, 20, 80);
    }
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: color,
          offset: Offset(0, 0),
          blurRadius: 8,
          spreadRadius: 4,
        ),
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(1000),
      ),
    );
  }

  static const fontBold = 'SF_UIFont_Bold';
  static const fontNormal = 'SF_UIFont';
  static const Color colorHighlight = Color.fromARGB(255, 255, 20, 80);

  static const BoxDecoration lightDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(200, 200, 200, 200),
        offset: Offset(0, 0),
        blurRadius: 4,
        spreadRadius: 2.25,
      ),
    ],
    borderRadius: const BorderRadius.all(
      const Radius.circular(6),
    ),
  );

  static const BoxDecoration shadowDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.15),
        offset: Offset(0, 0),
        blurRadius: 12,
        spreadRadius: 8,
      ),
    ],
    borderRadius: const BorderRadius.all(
      const Radius.circular(16),
    ),
  );

  static const BoxDecoration listItemDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.15),
        offset: Offset(0, 0),
        blurRadius: 12,
        spreadRadius: 8,
      ),
    ],
    borderRadius: const BorderRadius.all(
      const Radius.circular(8),
    ),
  );

  static const BoxDecoration selectedDecoration = BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(255, 255, 20, 80),
        offset: Offset(0, 0),
        blurRadius: 12,
        spreadRadius: 8,
      ),
    ],
    borderRadius: const BorderRadius.all(
      const Radius.circular(16),
    ),
  );

  static String format(final int number) {
    final _formatter = new NumberFormat("###,###,###", "en_US");
    return _formatter.format(number).toString();
  }

  static Color theme() {
    return Color.fromARGB(255, 240, 10, 80);
  }

  static Color titleTxtColor() {
    return Color.fromARGB(255, 60, 50, 70);
  }

  static BoxDecoration getLightBox() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0, 0),
          blurRadius: 6,
          spreadRadius: 3,
        ),
      ],
      borderRadius: const BorderRadius.all(
        const Radius.circular(5),
      ),
    );
  }

  static BoxDecoration bottomNavigatorBox() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0, 0),
          blurRadius: 12,
          spreadRadius: 8,
        ),
      ],
      borderRadius: const BorderRadius.only(
        topLeft: const Radius.circular(12),
        topRight: const Radius.circular(12),
      ),
    );
//    BoxDecoration(
//      color: Colors.white,
//      boxShadow: [
//        BoxShadow(
//          color: Colors.black.withAlpha(20),
//          offset: Offset(0, 0),
//          blurRadius: 4,
//          spreadRadius: 2,
//        ),
//      ],
//      borderRadius: const BorderRadius.only( topLeft: const Radius.circular(12), topRight: const Radius.circular(12),),
//
//    );
  }
}

class DeviceInfo {
  String appPlatform;
  String appBundleID;
  String deviceNamed;
  String deviceUUID;

  static final _device = DeviceInfo._internal();
  DeviceInfo._internal();
  factory DeviceInfo() {
    return _device;
  }
}

final DeviceInfo deviceInfo = DeviceInfo();

class TextConfig {
  final int maxLen;
  Timestamped timestamped;
  final bool isDigit;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final String labelText;
  TextConfig(this.labelText, {this.isDigit = false, this.maxLen = 25});
}

class DisplayData {
  
  
  double _height = 0;
  double _width = 0;
  double _navHeight = 0;
  double _padBottom = 0;
  double _padTop = 0;
  static final _device = DisplayData._internal();
  DisplayData._internal();
  factory DisplayData() {
    return _device;
  }
  
  
  setData(final BuildContext _context){
    _padTop = MediaQuery.of(_context).padding.top;
    _height = MediaQuery.of(_context).size.height;
    _width = MediaQuery.of(_context).size.width;
    _padBottom = MediaQuery.of(_context).padding.bottom;
    _navHeight = (_padBottom > 0 ? 55 : 65) + _padBottom;

//    double _height = MediaQuery.of(_context).size.height;
//    double _width = MediaQuery.of(_context).size.width;
  }


  double get height  {
    return _height;
  }

  double get top {
    return _padTop;
  }

  double get bottom {
    return _padBottom;
  }

  double get width {
    return _width;
  }

  double get navHeight{
    return _navHeight;
  }

}

final DisplayData displayData = DisplayData();
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35

enum ImageType { profile, prescription, document }
