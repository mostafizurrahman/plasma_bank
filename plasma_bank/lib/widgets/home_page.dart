

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/models/blood_hunter.dart';
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
//                    locationProvider.updateLocation();
                    _db.getPatientStream().listen((event) async {
                      debugPrint("this_is _data");
                      final _map = event.documents.first.data;

                      final _data = BloodHunter(_map, reference: event.documents.first.reference);
                      _data.mobileNumber = '01682836170';
                      _data.emailAddress = 'kanchan@gmail.com';
                      _data.fullName = 'Afrin Sultana';

//                      final _newData = Map.from(_data.toJson());
//                      debugPrint("done");
//                      _newData['name'] = 'Tasmia Rahman';
//                      _newData['mobile'] = "01940444550";
//                      final _newHuter = BloodHunter(_newData);
                      final DocumentReference _reference = await _db.addBloodHunter(_data);
                      debugPrint(_reference.documentID);
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

