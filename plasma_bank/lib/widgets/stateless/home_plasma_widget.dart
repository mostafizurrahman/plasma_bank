import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/media/dash_painter.dart';

class HomePlasmaWidget extends StatelessWidget {
  final double _profileHeight;
  final bool isBloodDonor;
  final Function(bool) _onTapDonor;
  HomePlasmaWidget(this._profileHeight, this._onTapDonor, {this.isBloodDonor = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48, ),
      child: Container(
        decoration: AppStyle.shadowDecoration,
        height: 365,
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
          child: Material(

            child: Ink(
              child: InkWell(
                onTap: (){
                  debugPrint("DONE");
                  this._onTapDonor(this.isBloodDonor);
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        'DONATE  ${this.isBloodDonor ? 'BLOOD' : 'PLASMA'} ',
                        style: TextStyle(
                            fontFamily: 'SF_UIFont_Bold',
                            fontSize: 20,
                            color: Colors.green),
                      ),
                    ),
                    CustomPaint(
                      size: Size(displayData.width - 48, 1.0),
                      painter: DashLinePainter(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: _profileHeight,
                              width: _profileHeight / 4.0 * 3.0,
                              decoration: AppStyle.getLightBox(),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                child: Image.network(
                                  'https://i.imgur.com/csdE6UE.jpg',
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.75,
                                        backgroundColor: Colors.red,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color.fromARGB(255, 220, 220, 200),
                                        ),
                                        value: loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: _profileHeight * 0.75,
                                    child: Center(
                                      child: Text(
                                        'Mostafizru Rahman Mony',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: _profileHeight * 0.25,
                                    alignment: Alignment.bottomCenter,
                                    child: Row(
                                      children: [
                                        WidgetProvider.circledIcon(
                                          Icon(
                                            Icons.add,
                                            color: Colors.green,
                                            size: _profileHeight * 0.15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text('new ${this.isBloodDonor ? 'blood' : 'plasma'} donor'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16,),
                    CustomPaint(
                      size: Size(displayData.width - 48, 1.0),
                      painter: DashLinePainter(),
                    ),
                    Expanded(
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              SizedBox(height: 8,),
                              Text('+8801675876752',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppStyle.fontBold), ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8,bottom: 12, top: 5, right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    WidgetProvider.circledIcon(
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Icon(
                                          Icons.perm_contact_calendar,
                                          color: Colors.red,
                                          size: 17,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Text('CONTACT NUMBER'),
                                  ],
                                ),
                              ),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(

                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(

                                    'AB+',
                                    style: TextStyle(
                                      fontSize: 48,
                                      fontFamily: AppStyle.fontBold,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 8,bottom: 16, top: 5, right: 8),
                                    child: Row(
                                      children: [
                                        WidgetProvider.circledIcon(
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.colorize,
                                              color: Colors.red,
                                              size: 17,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Text('BLOOD GROUP'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16),
                                        child: Text(
                                          'DHAKA,',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: AppStyle.fontBold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      //FIXED LENGTH
                                      Text(
                                        'BANGLADESH',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: AppStyle.fontBold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8,bottom: 11, top: 8, right: 8),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        WidgetProvider.circledIcon(
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Icon(
                                              Icons.location_on,
                                              color: Colors.red,
                                              size: 17,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Text('BLOOD  REGION'),
                                      ],
                                    ),
                                  ),
                                ],
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
