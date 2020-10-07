import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/image_helper.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';

class DonorWidget extends StatelessWidget {
  final bool visible;

  final Function(bool) _onTap;
  DonorWidget(this.visible, this._onTap);

  @override
  Widget build(BuildContext context) {
//    Navigator.pop(context);
    return SafeArea(
      child: Container(
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          onEnd: () {
            debugPrint("this is the end");
          },
          duration: Duration(seconds: 1),
          child: Container(
            width: displayData.width,
            height: MediaQuery.of(context).size.height -
                (displayData.top > 0 ? 60 : 70) -
                displayData.bottom -
                displayData.top,
            //color: Color.fromARGB(255, _background, _background, _background),
            decoration: BoxDecoration(
              color: AppStyle.greyBackground(),
              image: DecorationImage(
                image: ImageHelper.getImageAsset('background_1.jpg'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  top: (24 + displayData.top), bottom: 24, left: 24, right: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BECOME A BLOOD DONOR TODAY',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: AppStyle.fontBold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 32, bottom: 12),
                    child: Text(
                      'life saving heroes come in all types and sizes, a single pint can save three lives, a single gesture can create a million smiles',
                      style: TextStyle(
                          fontSize: 16,
                          height: 1.3,
                          color: Colors.black.withAlpha(200)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: displayData.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          WidgetProvider.getBloodActionButton(
                            () => this._onTap(false),
                            'FIND A DONOR',
                            Icon(
                              Icons.group,
                              color: Colors
                                  .white, //Color.fromARGB(255, 240, 10, 80),
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          WidgetProvider.getBloodActionButton(
                            () => this._onTap(true),
                            'REGISTER AS DONOR',
                            Icon(
                              Icons.add,
                              color: Colors
                                  .white, //Color.fromARGB(255, 240, 10, 80),
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
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
