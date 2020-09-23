import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/abstract_person.dart';

class BloodCollector {
  String email;
  String mobile;
  String bloodCount;
  String bloodGroup;
  String collectorName;
  String injectionDate;
  String hospitalAddress;
  String collectorAddress;
  String diseaseName;

  BloodCollector(
      this.email, this.mobile, this.collectorName, this.collectorAddress,
      {this.bloodGroup,
      this.bloodCount,
      this.hospitalAddress,
      this.injectionDate,
        this.diseaseName,
      });

  BloodCollector.fromJson(final Map _data){
    this.email = _data['email'];
    this.mobile = _data['mobile'];
    this.bloodCount = _data['bag_count'];
    this.bloodGroup = _data['blood_group'];
    this.diseaseName = _data['disease_name'];
    this.collectorName = _data['collector_name'];
    this.injectionDate = _data['injection_date'];
    this.hospitalAddress = _data['hospital_address'];
    this.collectorAddress = _data['collector_address'];
  }

  Map<String, dynamic> toJson(){
    return {
    'email' :  this.email,
    'mobile' : this.mobile,
    'bag_count' : this.bloodCount,
    'blood_group' : this.bloodGroup,
    'disease_name' : this.diseaseName,
    'collector_name' : this.collectorName,
    'injection_date' : this.injectionDate,
    'hospital_address' : this.hospitalAddress,
    'collector_address' : this.collectorAddress,
    };
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
