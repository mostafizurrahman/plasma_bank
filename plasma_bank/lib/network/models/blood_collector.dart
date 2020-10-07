import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../imgur_handler.dart';
import '../models/abstract_person.dart';

class BloodCollector extends Person {


  String bloodCount;
  String injectionDate;
  String hospitalAddress;
  String diseaseName;

  BloodCollector( Map _inputData) : super(_inputData) {

    this.hospitalAddress = _inputData['hospital_address'];
    this.injectionDate = _inputData['injection_date'];
    this.bloodCount = _inputData['bag_count'];
    this.diseaseName = _inputData['disease_name'];


  }


  Map<String, dynamic> toJson(){
    Map _data = super.toJson();
    _data['hospital_address'] = this.hospitalAddress;
    _data['injection_date'] = this.injectionDate;
    _data['blood_count'] = this.bloodCount;
    _data['disease_name'] = this.diseaseName;
    return _data;
  }
//  Person.fromMap(Map<String, dynamic> map, {this.reference})
//      : assert(map['name'] != null),
//        assert(map['mobile'] != null),
//        fullName = map['name'],
//        mobileNumber = map['mobile'],
//        bloodGroup = map['blood_group'],
//        this.birthDate = map['birth_date'] == null ? null : (map['birth_date'] as Timestamp).toDate(),
//        address = Address.fromMap(map['address'] ?? {});
//  BloodCollector(final Map<dynamic, dynamic> _map, {DocumentReference reference}) : super(_map){
//    this.reference = reference;
//    this.hospitalAddress = Address.fromMap(_map['hospital_address']);
//    this.injectionDate = _map['injection_date'] == null ? null : (_map['injection_date'] as Timestamp).toDate();
//    this.diseaseName = _map['disease'];
//    this.hospitalName = _map['hospital_name'];
//    this.bloodCount = _map['blood_count'];
//  }
//
//
//  BloodCollector.fromMap(Map<String, dynamic> map, {DocumentReference reference}) : super.fromMap(map){
//
//    this.reference = reference;
//    debugPrint("Dont know");
//    this.diseaseName = map['disease'];
//    this.bloodCount = map['blood_count'];
//    this.injectionDate = map['injection_date'] == null ? null : (map['injection_date'] as Timestamp).toDate();
//    this.hospitalAddress = Address.fromMap(map['hospital_address']);
//    this.hospitalName = map['hospital_name'];
//  }
//  @override
//  Map<String, dynamic> toJson(){
//    final _data = super.toJson();
//    _data['disease'] = this.diseaseName;
//    _data['blood_count'] = this.bloodCount;
//    _data['injection_date'] = this.injectionDate;
//    _data['hospital_name'] = this.hospitalName;
//    _data['hospital_address'] = this.hospitalAddress.toJson();
//    return _data;
//  }
//  BloodCollector.fromSnapshot(DocumentSnapshot snapshot)
//      : this.fromMap(snapshot.data, reference: snapshot.reference);

}
