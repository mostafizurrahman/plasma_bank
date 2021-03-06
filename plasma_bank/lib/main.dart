import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/media/preview_widget.dart';
import 'package:plasma_bank/widgets/address_widget.dart';
import 'package:plasma_bank/widgets/blood_details.dart';
import 'package:plasma_bank/widgets/donor_list_widget.dart';
import 'package:plasma_bank/widgets/health_widget.dart';
import 'package:plasma_bank/widgets/home_page.dart';
import 'package:plasma_bank/widgets/launch_screen.dart';
import 'package:plasma_bank/widgets/location_terms.dart';
import 'package:plasma_bank/widgets/messaging/private_chat_widget.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:plasma_bank/widgets/profile_widget.dart';
import 'package:plasma_bank/widgets/request_blood.dart';
import 'package:plasma_bank/widgets/stateful/blood_collector_widget.dart';
import 'app_utils/image_helper.dart';
import 'media/camera_widget.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'widgets/messaging/filter_widget.dart';
import 'widgets/stateful/dynamic_keyboard.dart';

//https://www.fda.gov/vaccines-blood-biologics/investigational-new-drug-ind-or-device-exemption-ide-process-cber/recommendations-investigational-covid-19-convalescent-plasma#Recordkeeping
void main() {
  runApp(PlasmaBank());
}

class PlasmaBank extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PlasmaState();
  }
}

class _PlasmaState extends State<PlasmaBank> {
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Column(
      children: [
        Expanded(
          child: MaterialApp(
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''), // English, no country code
              const Locale('he', ''), // Hebrew, no country code
              const Locale('zh', ''), // Chinese, no country code
              // ... other locales the app supports
            ],
            theme: ThemeData(
              fontFamily: 'SF_UIFont',
            ),
            home: LaunchScreenWidget(),
            onGenerateRoute: getGenerateRoute,
          ),
        ),
        StreamBuilder(
          stream: this._connectivity.onConnectivityChanged,
          initialData: ConnectivityResult.wifi,
          builder: (_context, _data) {
            if (_data.hasData && _data.data != ConnectivityResult.none) {
              return SizedBox();
            }
            return Container(
              height: 20,
              decoration: BoxDecoration(
                color: AppStyle.theme(),
                image: DecorationImage(
                  image: ImageHelper.getImageAsset('no_internet.png'),
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.centerLeft,
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Route getGenerateRoute(RouteSettings settings) {
    Widget _widget;

    if(settings.name == AppRoutes.pageBloodDetails){
      _widget = BloodDetails(settings.arguments);
    }
    else if (settings.name == AppRoutes.pagePostBlood) {
      _widget = RequestBloodWidget(settings.arguments);
    } else if (settings.name == AppRoutes.pageBloodTaker) {
      _widget = BloodCollectorWidget(settings.arguments);
    } else if (settings.name == AppRoutes.pageFilterDonor) {
      _widget = FilterWidget(settings.arguments);
    } else if (settings.name == AppRoutes.pagePrivateChat) {
      _widget = PrivateChatWidget(settings.arguments);
    } else if (settings.name == AppRoutes.pageDonorList) {
      _widget = DonorListWidget(settings.arguments);
    } else if (settings.name == AppRoutes.pageHealthData) {
      _widget = HealthWidget(settings.arguments);
    }
    if (settings.name == AppRoutes.pagePersonData) {
      _widget = ProfileWidget(settings.arguments);
    } else if (settings.name == AppRoutes.pageAddressData) {
      _widget = AddressWidget(settings.arguments);
    } else if (settings.name == AppRoutes.pageLocateTerms) {
      _widget = LocationTerms();
    } else if (settings.name == AppRoutes.pageRouteCamera) {
      _widget = CameraWidget(settings.arguments);
    }
    else if (settings.name == AppRoutes.pageRouteHome) {
      _widget = HomePageWidget();
    } else if (settings.name == AppRoutes.pageRouteImage) {
      if (settings.arguments is Map<String, dynamic>) {
        final Map<String, dynamic> _args = settings.arguments;
        final imageType = _args["type"];
        final imagePath = _args["image"];
        final onUploaded = _args["on_uploaded"];
        final route = _args['route_name'];
        _widget = PreviewWidget(imageType, imagePath, onUploaded, route);
      }
    }

    if (Platform.isIOS) {
      return MaterialPageRoute(
        builder: (context) {
          return WillPopScope(
            onWillPop: () => _onPop(context),
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
    if (Navigator.of(context).userGestureInProgress) {
      return Future<bool>.value(false);
    }
    return Future<bool>.value(true);
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
