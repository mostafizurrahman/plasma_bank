import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/media/preview_widget.dart';
import 'package:plasma_bank/widgets/home_page.dart';
import 'package:plasma_bank/widgets/launch_screen.dart';
import 'package:plasma_bank/widgets/patient_info.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'media/camera_widget.dart';

//https://www.fda.gov/vaccines-blood-biologics/investigational-new-drug-ind-or-device-exemption-ide-process-cber/recommendations-investigational-covid-19-convalescent-plasma#Recordkeeping
void main() => runApp(PlasmaBank());

class PlasmaBank extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    return MaterialApp(
//      theme: ThemeData.from(
//        colorScheme: const ColorScheme.light(),
//      ).copyWith(
//        pageTransitionsTheme: const PageTransitionsTheme(
//          builders: <TargetPlatform, PageTransitionsBuilder>{
//            TargetPlatform.android: ZoomPageTransitionsBuilder(),
//          },
//        ),
//      ),
      home: LaunchScreenWidget(),
      onGenerateRoute: getGenerateRoute,
    );
  }

  Route getGenerateRoute(RouteSettings settings) {
    Widget _widget;

    if (settings.name == AppRoutes.pageRouteCamera) {
      _widget = CameraWidget();
    }
    if (settings.name == AppRoutes.pageRouteDonor) {
      _widget = PatientInfoWidget();
    } else if (settings.name == AppRoutes.pageRouteHome) {
      _widget = HomePageWidget();
    } else if (settings.name == AppRoutes.pageRouteImage){

      if (settings.arguments is Map<String, dynamic>){

        final  Map<String, dynamic> _args = settings.arguments;
        final imageType = _args["type"];
        final imagePath = _args["image"];
        _widget = PreviewWidget(imageType, imagePath);
      }
    }

    if (Platform.isIOS) {
      return MaterialPageRoute(
        builder: (context) {
          return WillPopScope(
            onWillPop: ()=>_onPop(context),
            child: _widget,
          );
        },
        settings:
            RouteSettings(name: settings.name, arguments: settings.arguments),
      );
    }
    return this._createRoute(settings, _widget);
  }

  Future<bool> _onPop(BuildContext context) async {
    if (Navigator.of(context).userGestureInProgress){
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);;
  }


  Route _createRoute(final RouteSettings _settings, final _widget) {
    return PageRouteBuilder(
      settings: _settings,
      pageBuilder: (context, animation, secondaryAnimation) => _widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _State();
  }
}

class _State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: RaisedButton(
          child: Text('Go!'),
          onPressed: () {
            Navigator.pushNamed(context, "/root",
                arguments: {"name": "mostafizur"});
          },
        ),
      ),
    );
  }
}
