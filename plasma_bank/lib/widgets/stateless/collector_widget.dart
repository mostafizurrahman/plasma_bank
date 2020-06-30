import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/image_helper.dart';

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
    return Container(
      child: AnimatedOpacity(
        opacity: visible ? 1.0 : 0.0,
        onEnd: () {
          debugPrint("this is the end");
        },
        duration: Duration(seconds: 1),
        child: Container(
          width: _width,
          height: MediaQuery.of(context).size.height -
              (_top > 0 ? 43 : 60) -
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
                    'BECOME A BLOOD DONOR TODAY',
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: AppStyle.fontBold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 32, bottom: 115, left: 24, right: 24),
                  child: Text(
                    'life saving heroes come in all types and sizes, a single pint can save three lives, a single gesture can create a million smiles',
                    style: TextStyle(
                        fontSize: 16,
                        height: 1.3,
                        color: Colors.black.withAlpha(200)),
                  ),
                ),
              ],
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.only(right: 12, bottom: 8),
              child: Container(
                width: 135,
                height: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: _width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                heroTag: '__hero',
                                onPressed: () {
                                  this._onCollectTap(true);
                                },
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.group,
                                  color: AppStyle
                                      .theme(), //Color.fromARGB(255, 240, 10, 80),
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton(
                                onPressed: () {
                                  this._onCollectTap(false);
                                },
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.add,
                                  color: AppStyle.theme(),
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
