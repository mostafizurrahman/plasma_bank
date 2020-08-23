
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:plasma_bank/network/imgur_handler.dart';

import '../models/abstract_person.dart';

class BloodDonor extends Person {

  String weight;
  String height;
  bool hasSickness;
  bool hasSmokeHabit;
  bool hasDrinkHabit;
  String diseaseName;
  String moneyAmount;
  String lastDonationDate;
<<<<<<< HEAD
  List<String> medicineList;
=======
  List<String> deviceList;
>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
  List<ImgurResponse> prescriptionList;

//  CBar(int a, int b, int cParam) :
//        c = cParam,
//        super(a, b);


<<<<<<< HEAD
  static List<ImgurResponse> getImages(final List<Map>_dataList){

    List<ImgurResponse> _images = List();
    for(final image in _dataList){
      ImgurResponse _response = ImgurResponse(jsonData:image);
      _images.add(_response);
=======
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
>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
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
<<<<<<< HEAD
        this.medicineList = map['medicines'],
=======
        this.deviceList = _getList(map['devices']),
>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
        this.prescriptionList = getImages(map['prescriptions']),
        this.lastDonationDate = map['donation_date'],
        super.fromMap(map);

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
=======
    _data['devices'] = this.deviceList;
>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
    _data['prescriptions'] = [
      this.prescriptionList.first.toJson() ?? {},
      this.prescriptionList.last.toJson() ?? {},];
    _data['donation_date'] = this.lastDonationDate;

    return _data;
  }
  BloodDonor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}