import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';


class PreviewWidget extends StatefulWidget {
  final ImageType imageType;
  final String imagePath;
  final Function onUploaded;
  final String routeName;
  PreviewWidget(this.imageType, this.imagePath, this.onUploaded, this.routeName);
  @override
  State<StatefulWidget> createState() {
    return _PreviewState();
  }
}

class _PreviewState extends State<PreviewWidget> {

  Image _imageWidget;
  @override
  void initState() {

    super.initState();
    _imageWidget = Image.file(
      File(this.widget.imagePath),
      fit: BoxFit.fitHeight,
    );
    _imageWidget.image.evict();
  }

  @override
  void dispose() {

    super.dispose();
    _imageWidget.image.evict();
  }
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final _height = MediaQuery.of(context).size.height;
=======

>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: WidgetProvider.getAppBar(context, title: "PROFILE"),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Container(
                decoration: new BoxDecoration(
                  color: Colors.grey.withAlpha(170),
                  borderRadius: new BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      offset: Offset(0, 0),
                      blurRadius: 12,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: new BorderRadius.all(Radius.circular(12)),
                  child: _imageWidget,
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 90,
            child: Center(
              child: WidgetProvider.getButton(
                  "USE PICTURE",
                  Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  _onUploadStart,
<<<<<<< HEAD
                  buttonWidth: MediaQuery.of(context).size.width - 48),
=======
                  buttonWidth:
                  displayData.width - 48),
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
            ),
          ),
        ),
      ),
    );
  }

  _onUploadStart() {
    WidgetProvider.loading(context);
    Future.delayed(Duration(seconds: 1), () {
//      final _uploader = ImageUploader();
//      final _base64 = ImageUploader.getBase64(this.widget.imagePath);
//      _uploader.uploadImage(_base64);
      this.widget.onUploaded(this.widget.imagePath);
      Navigator.pop(context);
      Navigator.popUntil(context, ModalRoute.withName(this.widget.routeName));
//      WidgetTemplate.message(context,
//          "Your profile picture uploaded successfully! You need to check other registration information",
//          dialogTitle: "Upload Success!", onTapped: () {
//        Navigator.pop(context);
//      });
    });
  }


}
