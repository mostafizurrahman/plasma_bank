<<<<<<< HEAD
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
=======
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
//import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/image_helper.dart';
import 'package:plasma_bank/app_utils/localization_helper.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
<<<<<<< HEAD
=======
import 'package:plasma_bank/network/donor_handler.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35

class LaunchScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LaunchScreenState();
  }
}

class _LaunchScreenState extends State<LaunchScreenWidget> {
  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    Future.delayed(const Duration(seconds: 3), () async {

//      await FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
=======
    Future.delayed(const Duration(seconds: 2), () async {
      await this._setDeviceInfo();
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
      Navigator.popAndPushNamed(context, AppRoutes.pageRouteHome);
    });
  }

<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
=======

  _setDeviceInfo() async {

    const platform = const MethodChannel('flutter.plasma.com.device_info');
    final Map<dynamic, dynamic> _deviceIno = await platform.invokeMethod('getPackageInfo');

    deviceInfo.appPlatform = Platform.isIOS ? 'iOS' : Platform.isAndroid ? 'Android' : 'unknown';
    deviceInfo.appBundleID = _deviceIno['package_name'];
    deviceInfo.deviceUUID = _deviceIno['device_id'].toString().toUpperCase();
    deviceInfo.deviceNamed = _deviceIno['device_name'];
    final _repository = FirebaseRepositories();
    _repository.getEmails().listen((event) {
      if(event.data.isNotEmpty){
        event.data.forEach((k,v) {
          debugPrint('key :' + k.toString() + ' value ' + v.toString());
          if(v is List<dynamic>){
            List<String> _list = List();
            v.forEach((value) {
              if(value is String) {
                _list.add(value);
              }
            });
            donorHandler.donorEmails = _list;
          }
        });
      } else {
        debugPrint('empty');
      }
    });
    debugPrint('done');
  }

  @override
  Widget build(BuildContext context) {

    displayData.setData(context);
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    final keyWidth = 250.0;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Container(

<<<<<<< HEAD
            width: MediaQuery.of(context).size.width,
=======
            width: displayData.width,
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localization.getText('plasma'),//'PLASMA',
                      style: TextStyle(color: Colors.redAccent, fontSize: 28),
                    ),
                    SizedBox(width: 16,),
                    Text(
                      localization.getText('bank'),//'BANK',
                      style: TextStyle(color: Colors.cyan, fontSize: 28, fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                Container(

                  width: keyWidth,
                  height: keyWidth,
                  decoration: AppStyle.shadowDecoration,
                  child: ClipRRect(
                    child: new Container(

                      child: Image(
                        fit: BoxFit.fitHeight,
                        image: ImageHelper.getImageAsset("donate.jpg"),
                      ),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetTemplate.indicator(),
                    SizedBox(width: 12,),
                    Text(
                      localization.getText('moto'),
                      softWrap: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
