

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/network/covid_data_helper.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/models/blood_hunter.dart';
import 'package:plasma_bank/network/uploader.dart';
import 'package:plasma_bank/widgets/widget_templates.dart';
import 'package:rxdart/rxdart.dart';

class HomePageWidget extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageWidget> {

  final _db = FirebaseRepositories();
  final _downloader = CovidDataHelper();
//  final PublishSubject csvBehavior = PublishSubject<double>();

  final PublishSubject dataBehavior = PublishSubject<double>();
  @override
  void dispose() {
    super.dispose();
    this.dataBehavior.close();
//    if (this.csvBehavior != null){
//      this.csvBehavior.close();
//    }
  }

  @override
  Widget build(BuildContext context) {

    final _chunk = MediaQuery.of(context).size.width / 100.0;
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.withAlpha(100),
          body: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: this.dataBehavior,
                  initialData: 0,
                  builder: (_context, _snap){

                    return Container(
                      color: Colors.redAccent,
                      height: 10,
                      width: _chunk  * _snap.data ,
                    );
                  },
                ),
                RaisedButton(
                  child: Text('Go!'),
                  onPressed: () {

                    String now = DateTime.now().toLocal().toString();
                    debugPrint(now);
//                    this.dataBehavior.sink.add(0.0);

                    _downloader.downloadRemoteFile(
                        'https://covid.ourworldindata.org/data/owid-covid-data.json',
                        'total_deaths.json',
                        _onProgress);
//                    locationProvider.updateLocation();
//                    _db.getPatientStream().listen((event) async {
//
//                      final _map = event.documents.first.data;
//
//                      final _data = BloodHunter(_map, reference: event.documents.first.reference);
//                      _data.mobileNumber = '01682836170';
//                      _data.emailAddress = 'kanchan@gmail.com';
//                      _data.fullName = 'Afrin Sultana';


//                      final _response = await get('https://www.worldometers.info/coronavirus');
//                      final String _data = _response.body;
//                      debugPrint("this_is _data");

//                      final _newData = Map.from(_data.toJson());
//                      debugPrint("done");
//                      _newData['name'] = 'Tasmia Rahman';
//                      _newData['mobile'] = "01940444550";
//                      final _newHuter = BloodHunter(_newData);
//                      final DocumentReference _reference = await _db.addBloodHunter(_data);
//                      debugPrint(_reference.documentID);
//                    });

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

  _onProgress(File _dataFile){

    this._downloader.readCovidJSON(_dataFile);
  }

}

