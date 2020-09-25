import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

class LocalizationHelper {
  String _languageCode;
  LocalizationHelper() {
    this._languageCode = ui.window?.locale?.languageCode ?? 'en';
    debugPrint(this._languageCode);
    //english, bangla, hindi, chinese, japanese, french, spanish, german, latin arabic
//    List< String> _supported = ['en', 'bn', 'fr', 'hi', 'de', 'es', 'la', 'ja', 'ar'];
//    if (!_supported.contains(this._languageCode)){
//      this._languageCode = 'en';
//    }
  }

  String getText(final String _lanKey) {
    switch (this._languageCode) {
      case 'bn':
        return this._getBN(_lanKey);
      case 'fr':
        return this._getFR(_lanKey);
      case 'hi':
        return this._getHI(_lanKey);
      case 'de':
        return this._getDE(_lanKey);
      case 'es':
        return this._getES(_lanKey);
      case 'la':
        return this._getLA(_lanKey);
      case 'ja':
        return this._getJA(_lanKey);
      case 'ar':
        return this._getAR(_lanKey);
      case 'zh':
        return this._getZH(_lanKey);
      case 'en':
      default:
        return this._getEN(_lanKey);
    }
  }

  String _getEN(final String _lanKey) {
    return {
      'plasma': 'PLASMA',
      'bank': 'BANK',
      'moto': 'DONATE PLASMA, SAVE LIFE...'
    }[_lanKey];
  }

//  banco de plasma
  String _getBN(final String _lanKey) {
    return {
      'plasma': 'প্লাজমা',
      'bank': 'ব্যাংক',
      'moto': 'প্লাজমা ডোনেট করুন, জীবন বাঁচান ...'
    }[_lanKey];
  }

  String _getFR(final String _lanKey) {
    return {
      'plasma': 'PLASMA',
      'bank': 'BANQUE',
      'moto': 'DONNEZ DU PLASMA, SAUVEZ LA VIE...'
    }[_lanKey];
  }

  String _getHI(final String _lanKey) {
    return {
      'plasma': 'प्लाज्मा',
      'bank': 'बैंक',
      'moto': 'डोनेट प्लास्मो, बचाओ जीवन ...'
    }[_lanKey];
  }

  String _getDE(final String _lanKey) {
    return {
      'plasma': 'PLASMA',
      'bank': 'BANK',
      'moto': 'PLASMA SPENDEN, LEBEN RETTEN ...'
    }[_lanKey];
  }

  String _getES(final String _lanKey) {
    return {
      'plasma': 'PLASMA',
      'bank': 'BANCO',
      'moto': 'DONAR PLASMA, SALVAR VIDA ...',
    }[_lanKey];
  }

  String _getLA(final String _lanKey) {
    return {
      'plasma': 'PLASMA',
      'bank': 'RIPAE',
      'moto': 'Char PLASMA: animam salvam facere ...'.toUpperCase()
    }[_lanKey];
  }

  String _getZH(final String _lanKey) {
    return {'plasma': '等离子体', 'bank': '银行', 'moto': '捐赠血浆，拯救生命...'}[_lanKey];
  }

  String _getJA(final String _lanKey) {
    return {
      'plasma': 'プラズマ',
      'bank': 'バンク',
      'moto': 'プラズマを寄付し、命を救う...'
    }[_lanKey];
  }

  String _getAR(final String _lanKey) {
    return {
      'plasma': 'بنك',
      'bank': 'البلازما',
      'moto': 'تبرع بلازما ، وفر الحياة '
    }[_lanKey];
  }
}

final localization = LocalizationHelper();
