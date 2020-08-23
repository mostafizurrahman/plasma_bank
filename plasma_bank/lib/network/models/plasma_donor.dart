

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/blood_donor.dart';

class PlasmaDonor extends BloodDonor {

  String covidConfirmDate;
  String covidRecoveredDate;
  bool hasCovid;


  PlasmaDonor.fromMap(Map<dynamic, dynamic> map,
      {DocumentReference reference}) : super.fromMap(map){
    this.hasCovid = map['covid'];
    this.covidConfirmDate = map['covid_date'].toString();
    this.covidRecoveredDate = map['recovered_date'].toString();
  }

  @override
  Map<String, dynamic> toJson() {
    final _data = super.toJson();
    _data['covid_date'] = this.covidConfirmDate;
    _data['recovered_date'] = this.covidRecoveredDate;
    _data['has_covid'] = this.hasCovid;
    return _data;
  }

  PlasmaDonor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}