

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/blood_donor.dart';

class PlasmaDonor extends BloodDonor{

  DateTime covidConfirmDate;
  DateTime covideRecoveredDate;


  PlasmaDonor.fromMap(Map<String, dynamic> map, {DocumentReference reference}) : super.fromMap(map){
    this.covidConfirmDate = map['covid_date'];
    this.covideRecoveredDate = map['recovered_date'] == null ? null : (map['recovered_date'] as Timestamp).toDate();

  }
  @override
  Map<String, dynamic> toJson() {
    final _data = super.toJson();
    _data['covid_date'] = this.covidConfirmDate;
    _data['recovered_date'] = this.covideRecoveredDate;
    return _data;
  }
  PlasmaDonor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}