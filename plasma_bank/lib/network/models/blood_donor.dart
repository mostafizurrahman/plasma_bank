
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/abstract_person.dart';

class BloodDonor extends Person {

  double weight;
  bool hasSickness;
  bool hasSmokeHabit;
  bool hasDrinkHabit;
  String diseaseName;
  String moneyAmount;
  DateTime lastDonationDate;
  List<String> medicineList;
  List<String> prescriptionList;


  BloodDonor.fromMap(Map<String, dynamic> map, {DocumentReference reference}) : super.fromMap(map){
    this.weight = map['weight'];
    this.hasSickness = map['sick'];
    this.diseaseName = map['disease'];
    this.hasSmokeHabit = map['smoke'];
    this.hasDrinkHabit = map['drink'];
    this.medicineList = map['medicines'];
    this.prescriptionList = map['prescriptions'];
    this.lastDonationDate = map['donation_date'] == null ? null : (map['donation_date'] as Timestamp).toDate();
  }

  @override
  Map<String, dynamic> toJson(){
    final _data = super.toJson();
    _data['wight'] = this.weight;
    _data['sick'] = this.hasSickness;
    _data['disease'] = this.diseaseName;
    _data['smoke'] = this.hasSmokeHabit;
    _data['drink'] = this.hasDrinkHabit;
    _data['medicines'] = this.medicineList;
    _data['prescriptions'] = this.prescriptionList;
    _data['donation_date'] = this.lastDonationDate;

    return _data;
  }
  BloodDonor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}