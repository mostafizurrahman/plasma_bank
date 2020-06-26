import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class AppConstants {}

class AppRoutes {
  static const String pageRouteHome = "/home";
  static const String pageRouteDonor = "/home/donor";
  static const String pageRouteEntry = "/home/entry";
  static const String pageRouteImage = "/home/camera/image";
  static const String pageRouteCamera = "/home/camera";
}

class AppConfig {
  static const double PADDING_ALL = 24;
  static const double FONT_SIZE_DEF = 13;
  static const double FONT_SIZE_SML = 10;
  static const double FONT_SIZE_XL = 15;
  static const double FONT_SIZE_XXL = 18;
}

class AppStyle {
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

  static String format(final int number){
    final _formatter = new NumberFormat("###,###,###", "en_US");
    return _formatter.format(number).toString();
  }
}

enum ImageType { profile, prescription, document }
