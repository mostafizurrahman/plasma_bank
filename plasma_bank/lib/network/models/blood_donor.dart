
import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
=======
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:plasma_bank/network/imgur_handler.dart';
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35

import '../models/abstract_person.dart';

class BloodDonor extends Person {

<<<<<<< HEAD
  double weight;
=======
  String weight;
  String height;
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
  bool hasSickness;
  bool hasSmokeHabit;
  bool hasDrinkHabit;
  String diseaseName;
  String moneyAmount;
<<<<<<< HEAD
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

=======
  String lastDonationDate;
  List<String> deviceList;
  List<ImgurResponse> prescriptionList;

//  CBar(int a, int b, int cParam) :
//        c = cParam,
//        super(a, b);


  static List<String> _getList(List<dynamic> _data){
    List<String> _list = List();
    _data.forEach((element) {
      if(element is String ){
        if(element.isNotEmpty) {
          _list.add(element);
        }
      }
    });
    return _list;
  }


  static List<ImgurResponse> getImages(final List<dynamic>_dataList){

    List<ImgurResponse> _images = List();
    for(final image in _dataList){
      if(image is Map){
        ImgurResponse _response = ImgurResponse(jsonData:image);
        _images.add(_response);
      }
    }
    return _images;
  }

  BloodDonor.fromMap(Map<dynamic, dynamic> map, {DocumentReference reference}) :
        this.weight = map['weight'],
        this.height = map['height'],
        this.hasSickness = map['sick'],
        this.diseaseName = map['disease'],
        this.hasSmokeHabit = map['smoke'],
        this.hasDrinkHabit = map['drink'],
        this.deviceList = _getList(map['devices']),
        this.prescriptionList = getImages(map['prescriptions']),
        this.lastDonationDate = map['donation_date'],
        super.fromMap(map);

>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
  @override
  Map<String, dynamic> toJson(){
    final _data = super.toJson();
    _data['wight'] = this.weight;
    _data['sick'] = this.hasSickness;
    _data['disease'] = this.diseaseName;
    _data['smoke'] = this.hasSmokeHabit;
    _data['drink'] = this.hasDrinkHabit;
<<<<<<< HEAD
    _data['medicines'] = this.medicineList;
    _data['prescriptions'] = this.prescriptionList;
=======
    _data['devices'] = this.deviceList;
    _data['prescriptions'] = [
      this.prescriptionList.first.toJson() ?? {},
      this.prescriptionList.last.toJson() ?? {},];
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    _data['donation_date'] = this.lastDonationDate;

    return _data;
  }
  BloodDonor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}