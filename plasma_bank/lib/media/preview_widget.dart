import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/widget_templates.dart';

class PreviewWidget extends StatefulWidget {
  final ImageType imageType;
  final String imagePath;
  PreviewWidget(this.imageType, this.imagePath);
  @override
  State<StatefulWidget> createState() {
    return _PreviewState();
  }
}

class _PreviewState extends State<PreviewWidget> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

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
                    ]),
                child: ClipRRect(
                  borderRadius: new BorderRadius.all(Radius.circular(12)),
                  child: Image.file(
                    File(this.widget.imagePath),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 90,
            child: Center(
              child: WidgetProvider.getButton(
                  "UPLOAD",
                  Icon(
                    Icons.cloud_upload,
                    color: Colors.white,
                  ),
                  _onUploadStart,
                  buttonWidth: MediaQuery.of(context).size.width - 48),
            ),
          ),
        ),
      ),
    );
  }

  _onUploadStart() {
    WidgetProvider.loading(context);
    Future.delayed(Duration(seconds: 4), () {
      Navigator.pop(context);
      WidgetTemplates.message(context,
          "Your profile picture uploaded successfully! You need to check other registration information",
          dialogTitle: "Upload Success!",
          onTapped: () {
        Navigator.pop(context);
      });
    });
  }
}
