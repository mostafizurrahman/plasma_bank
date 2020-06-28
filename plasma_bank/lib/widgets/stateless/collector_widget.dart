

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/image_helper.dart';

class CollectorWidget extends StatelessWidget {

  final bool visible;
  final Function(bool ) _onCollectTap;
  CollectorWidget(this.visible, this._onCollectTap);


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double _top = mediaQuery.padding.top;
    double _bottom = mediaQuery.padding.bottom;
    final _width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Container(
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        onEnd: () {
          debugPrint("this is the end");
        },
        duration: Duration(seconds: 1),
        child: Container(
          width: _width,
          height: MediaQuery.of(context).size.height - 60 - _bottom,
          //color: Color.fromARGB(255, _background, _background, _background),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageHelper.getImageAsset('sick_1.jpg'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Padding(
            padding:  EdgeInsets.only(top: (24 + _top), bottom:  24, left: 24, right:  24),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Blood is a life\npass it on!'.toUpperCase(),
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: AppStyle.fontBold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32, bottom: 200),
                    child: Text(
                      'collect a beg of blood for a reason, let the reason to be life. there is no great joy than saving a life.',
                      style: TextStyle(fontSize: 16, height: 1.3, color: Colors.black.withAlpha(200)),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    onPressed: (){
                      this._onCollectTap(false);
                    },
                    backgroundColor: AppStyle.theme(),
                    child: Icon(
                      Icons.group,
                      color: Colors.white, //Color.fromARGB(255, 240, 10, 80),
                      size: 35,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  FloatingActionButton(
                    onPressed: (){
                      this._onCollectTap(false);
                    },
                    backgroundColor: AppStyle.theme(),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}