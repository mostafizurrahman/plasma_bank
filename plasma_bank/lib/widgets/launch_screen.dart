import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/image_helper.dart';
import 'package:plasma_bank/app_utils/localization_helper.dart';
import 'package:plasma_bank/widgets/widget_templates.dart';

class LaunchScreenWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LaunchScreenState();
  }
}

class _LaunchScreenState extends State<LaunchScreenWidget> {
  @override
  void initState() {
    super.initState();
//    Future.delayed(const Duration(seconds: 3), () {
////      Navigator.pushNamed(context, AppRoutes.pageRouteHome);
////    });
  }

  @override
  Widget build(BuildContext context) {
    final keyWidth = 250.0;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Container(

            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
//                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localization.getText('plasma'),//'PLASMA',
                      style: TextStyle(color: Colors.redAccent, fontSize: 28),
                    ),
                    SizedBox(width: 16,),
                    Text(
                      localization.getText('bank'),//'BANK',
                      style: TextStyle(color: Colors.cyan, fontSize: 28, fontWeight: FontWeight.w100),
                    ),
                  ],
                ),
                Container(

                  width: keyWidth,
                  height: keyWidth,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        offset: Offset(0, 0),
                        blurRadius: 12,
                        spreadRadius: 8,
                      ),
                    ],
                    borderRadius: new BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: ClipRRect(
                    child: new Container(

                      child: Image(
                        fit: BoxFit.fitHeight,
                        image: ImageHelper.getImageAsset("donate.jpg"),
                      ),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WidgetTemplates.indicator(),
                    SizedBox(width: 12,),
                    Text(
                      localization.getText('moto'),
                      softWrap: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
