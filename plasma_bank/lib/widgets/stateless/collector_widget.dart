import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/image_helper.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';

class CollectorWidget extends StatelessWidget {
  final bool visible;
  final Function(bool) _onCollectTap;
  CollectorWidget(this.visible, this._onCollectTap);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    double _top = mediaQuery.padding.top;
    double _bottom = mediaQuery.padding.bottom;
    final _width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return SafeArea(
      child: Container(
        child: AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          onEnd: () {
            debugPrint("this is the end");
          },
          duration: Duration(seconds: 1),
          child: Container(
            width: _width,
            height: MediaQuery.of(context).size.height -
                (_top > 0 ? 55 : 75) -
                _bottom -
                _top,
            //color: Color.fromARGB(255, _background, _background, _background),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ImageHelper.getImageAsset('sick_1.jpg'),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, right: 24),
                    child: Text(
                      'BLOOD IS LIFE,\nPASS IT ON',
                      style: TextStyle(
                        fontSize: 28,
                        fontFamily: AppStyle.fontBold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 16,  left: 24, right: 24),
                    child: Text(
                      'collect a beg of blood for a reason, let the reason to be life.',
                      style: TextStyle(fontSize: 16, height: 1.3, color: Colors.black.withAlpha(175)),
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: displayData.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        WidgetProvider.getBloodActionButton(
                              () => this._onCollectTap(false),
                          'BLOOD SEEKERS',
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
                              () => this._onCollectTap(true),
                          'REGISTER TO GET BLOOD',
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
                  SizedBox(height: 24,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
