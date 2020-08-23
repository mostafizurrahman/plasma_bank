


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';

class ProfileInfoWidget extends StatefulWidget{

  final BloodDonor bloodDonor;
  ProfileInfoWidget(this.bloodDonor);
  @override
  State<StatefulWidget> createState() {
    return _ProfileInfoState();
  }
}

class _ProfileInfoState extends State<ProfileInfoWidget>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(

      ),
    );
  }
}