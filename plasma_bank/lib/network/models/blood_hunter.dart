
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/abstract_person.dart';
class BloodHunter extends Person{

  String diseaseName;
  int bloodCount;
  DateTime injectionDate;
  String hospitalName;
  Address hospitalAddress;
  List<String> prescriptionList;


  BloodHunter.fromMap(Map<String, dynamic> map, {DocumentReference reference}) : super.fromMap(map){
    this.diseaseName = map['disease'];
    this.bloodCount = map['blood_count'];
    this.injectionDate = map['injection_date'] == null ? null : (map['injection_date'] as Timestamp).toDate();
    this.hospitalAddress = Address.fromMap(map['hospital_address']);
    this.prescriptionList = map['prescriptions'];
    this.hospitalName = map['hospital_name'];
  }
  @override
  Map<String, dynamic> toJson(){
    final _data = super.toJson();
    _data['disease'] = this.diseaseName;
    _data['blood_count'] = this.bloodCount;
    _data['injection_date'] = this.injectionDate;
    _data['hospital_name'] = this.hospitalName;
    _data['prescriptions'] = this.prescriptionList;
    _data['hospital_address'] = this.hospitalAddress.toJson();
    return _data;
  }
  BloodHunter.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}