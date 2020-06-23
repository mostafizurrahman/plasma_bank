

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/uploader.dart';

class HomePageWidget extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageWidget> {

  final _db = FirebaseRepositories();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.withAlpha(100),
          body: Center(
            child: Column(
              children: [
                StreamBuilder(
                  stream: _db.getPatientStream(),
                  builder: (_context, _snap){

                    return CircularProgressIndicator();
                  },
                ),
                RaisedButton(
                  child: Text('Go!'),
                  onPressed: () {
                    locationProvider.updateLocation();
                    _db.getPatientStream().listen((event) {

                      debugPrint("this_is _data");
                    });

//                Navigator.pushNamed(context, AppRoutes.pageRouteCamera);


//                final _channel = MethodChannel("flutter.plasma.com.imgpath");
//                _channel.invokeMethod("getImagePath").then((value) {
//
//                  final String _imagePath = value['image_path'];
//                  final String _strImage = ImageUploader.getBase64(_imagePath);
//                  ImageUploader().uploadImage(_strImage);
//                });
//                Navigator.pushNamed(context, AppRoutes.pageRouteDonor,
//                    arguments:{"name" : "mostafizur"});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

