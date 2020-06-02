

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';

class HomePageWidget extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageWidget> {


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.withAlpha(100),
          body: Center(
            child: RaisedButton(
              child: Text('Go!'),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.pageRouteDonor,
                    arguments:{"name" : "mostafizur"});
              },
            ),
          ),
        ),
      ),
    );
  }

}

