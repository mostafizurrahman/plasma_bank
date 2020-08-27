import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/network/donor_handler.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/imgur_handler.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'dart:ui' as ui;

import 'package:rxdart/rxdart.dart';

class UploaderWidget extends StatefulWidget {
  final BloodDonor bloodDonor;
  final List<String> emails;
  final Function(bool) onCompleted;
  UploaderWidget(this.bloodDonor, this.emails, this.onCompleted);

  @override
  State<StatefulWidget> createState() {
    return _UploaderState(this.bloodDonor.profilePicture);
  }
}

class _UploaderState extends State<UploaderWidget> {
  BehaviorSubject<ImgurResponse> _subject = BehaviorSubject<ImgurResponse>();
  BehaviorSubject<String> _status =  BehaviorSubject<String>();
  ImgurResponse _imgurResponse;
  _UploaderState(this._imgurResponse);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), _startUploading);
  }

  @override
  void dispose() {
    super.dispose();
    _status.close();
    _subject.close();
  }

  @override
  Widget build(BuildContext context) {
//    Navigator.pop(context);
    return WillPopScope(
      onWillPop: () async {
        return Future<bool>.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: displayData.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(child: this._getLoader()),
                SizedBox(
                  height: displayData.height * 0.225,
                ),
                _getDataRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getLoader() {
    return Padding(
      padding: EdgeInsets.only(top: 48),
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
          borderRadius: new BorderRadius.all(
            const Radius.circular(12.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WidgetTemplate.indicator(),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'UPLOADING...',
                style: TextStyle(fontSize: 13, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getDataRow() {
    return Padding(
      padding: EdgeInsets.only(top: 48),
      child: Container(
        width: displayData.width - 64,
        height: 120,
        decoration: new BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 6.0,
            ),
          ],
          color: Colors.black54.withOpacity(0.5),
          borderRadius: new BorderRadius.all(
            const Radius.circular(12.0),
          ),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
            ),
            Container(
              decoration: AppStyle.highlightShadow(color: Colors.white),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(1000),
                ),
                child: Container(
                  width: 90,
                  height: 90,
                  child: StreamBuilder<ImgurResponse>(
                    stream: _subject.stream,
                    initialData: this._imgurResponse,
                    builder: (_context, _snap) {
                      if (_snap.data == null ||
                          _snap.data.imageUrl == null ||
                          _snap.data.imageUrl.isEmpty ||
                          _snap.data.imageUrl == 'p1' ||
                          _snap.data.imageUrl == 'p2') {
                        return Center(child: Text('NO IMAGE...'));
                      }
                      debugPrint(_snap.data?.imageUrl ?? 'NIL IMAGE PATH');
                      final _imageWidget = Image.file(
                        File(_snap.data.imageUrl),
                        fit: BoxFit.fitWidth,
                      );
                      _imageWidget.image.evict();
                      return _imageWidget;
                    },
                  ),
                ),
              ),
            ),
            SizedBox(width: 16,),
            Expanded(
              child: Center(
                child: StreamBuilder<String>(
                  stream: _status.stream,
                  initialData: null,
                  builder: (context, snapshot) {
                    if(snapshot.data == null){
                      return Text(
                        'please wait, processing information...',
                        style: TextStyle(color: Colors.white, fontSize: 11),
                      );
                    }
                    return Text(
                      'please wait, uploading ${snapshot.data} image...',
                      style: TextStyle(color: Colors.white, fontSize: 11),
                    );
                  }
                ),
              ),
            ),
            SizedBox(width: 8,),
          ],
        ),
      ),
    );
  }

  _onUploadError(final _error) {
    debugPrint('error_occured');
    Navigator.pop(context);
    this.widget.onCompleted(false);
  }

  _startUploading() async {

    final _uploader = ImgurHandler();
    if (this.widget.bloodDonor.profilePicture != null) {
      if (this.widget.bloodDonor.profilePicture.imageUrl != null &&
          this.widget.bloodDonor.profilePicture.imageUrl.isNotEmpty) {
        final _profileImageStr = ImgurHandler.getBase64(
            this.widget.bloodDonor.profilePicture.imageUrl);
        _status.sink.add('profile');
        final _imgResponse = await _uploader
            .uploadImage(_profileImageStr)
            .catchError(_onUploadError);
        if (_imgResponse != null) {
          this.widget.bloodDonor.profilePicture = _imgResponse;
        }
      }
    }


    if (this.widget.bloodDonor.prescriptionList != null &&
        this.widget.bloodDonor.prescriptionList.first != null) {
      if (this.widget.bloodDonor.prescriptionList.first.imageUrl != null) {
        if (this.widget.bloodDonor.prescriptionList.first.imageUrl != 'p1') {
          this._subject.sink.add(this.widget.bloodDonor.prescriptionList.first);
          _status.sink.add('first prescription');

          final _prescription = ImgurHandler.getBase64(
              this.widget.bloodDonor.prescriptionList.first.imageUrl);
          final _imgResponse = await _uploader
              .uploadImage(_prescription)
              .catchError(_onUploadError);
          if (_imgResponse != null) {
            this.widget.bloodDonor.prescriptionList.first.imageUrl =
                _imgResponse.imageUrl;
            this.widget.bloodDonor.prescriptionList.first.deleteHash =
                _imgResponse.deleteHash;
          }
        }
      }
    }
    if (this.widget.bloodDonor.prescriptionList != null &&
        this.widget.bloodDonor.prescriptionList.last != null) {
      if (this.widget.bloodDonor.prescriptionList.last.imageUrl != null) {
        if (this.widget.bloodDonor.prescriptionList.last.imageUrl != 'p2') {
          this._subject.sink.add(this.widget.bloodDonor.prescriptionList.last);
          final _prescription = ImgurHandler.getBase64(
              this.widget.bloodDonor.prescriptionList.last.imageUrl);
          _status.sink.add('next prescription');
          final _imgResponse = await _uploader
              .uploadImage(_prescription)
              .catchError(_onUploadError);
          if (_imgResponse != null) {
            this.widget.bloodDonor.prescriptionList.last.imageUrl =
                _imgResponse.imageUrl;
            this.widget.bloodDonor.prescriptionList.last.deleteHash =
                _imgResponse.deleteHash;
          }
        }
      }
    }

      _status.sink.add(null);
      final _fireRepository = FirebaseRepositories();
      final BloodDonor _donor = this.widget.bloodDonor;
      await _fireRepository
          .uploadBloodDonor(_donor, this.widget.emails)
          .catchError(_onUploadError);

        donorHandler.donorDataList.add(this.widget.bloodDonor);
        Navigator.pop(context);
        WidgetTemplate.message(context, 'your account associated with email ${this.widget.bloodDonor.emailAddress} is created successfully, you can login to your account by email code verification, in OPTION menu!\nThank You!',
        onActionTap: ()=>this.widget.onCompleted(true), onTapped:()=>this.widget.onCompleted(true), headerColor: Colors.green, titleIcon: Icon(Icons.done, color: Colors.green,) );

  }
}
