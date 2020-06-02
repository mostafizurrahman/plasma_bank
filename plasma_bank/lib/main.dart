import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:animations/animations.dart';



void main() => runApp(PlasmaBank());

class PlasmaBank extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light(),
      ).copyWith(
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
          },
        ),
      ),
      home: Page1(),
      onGenerateRoute: getGenerateRoute,
    );
  }

  Route getGenerateRoute(RouteSettings settings) {

    return this._createRoute(settings);
  }

  Route _createRoute(final RouteSettings _settings) {
    return PageRouteBuilder(
      settings: _settings,
      pageBuilder: (context, animation, secondaryAnimation) => Page2(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

class Page1 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: RaisedButton(
          child: Text('Go!'),
          onPressed: () {
            Navigator.of(context).pushNamed("/home", arguments: {"name" : "mostafizur"} );
          },
        ),
      ),
    );
  }
}


class Page2 extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('Page 2'),
      ),
    );
  }
}