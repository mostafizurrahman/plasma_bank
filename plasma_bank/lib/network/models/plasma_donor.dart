

import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD

import '../models/blood_donor.dart';

class PlasmaDonor extends BloodDonor{

  DateTime covidConfirmDate;
  DateTime covideRecoveredDate;


  PlasmaDonor.fromMap(Map<String, dynamic> map, {DocumentReference reference}) : super.fromMap(map){
    this.covidConfirmDate = map['covid_date'];
    this.covideRecoveredDate = map['recovered_date'] == null ? null : (map['recovered_date'] as Timestamp).toDate();

  }
=======
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

>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
  @override
  Map<String, dynamic> toJson() {
    final _data = super.toJson();
    _data['covid_date'] = this.covidConfirmDate;
<<<<<<< HEAD
    _data['recovered_date'] = this.covideRecoveredDate;
    return _data;
  }
=======
    _data['recovered_date'] = this.covidRecoveredDate;
    _data['has_covid'] = this.hasCovid;
    return _data;
  }

>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
  PlasmaDonor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}