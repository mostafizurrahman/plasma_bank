import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plasma_bank/app_utils/image_helper.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'dart:convert';
import 'package:plasma_bank/network/imgur_handler.dart';
import 'package:intl/intl.dart';

class BloodInfo
{
  Address hospitalAddress;
  String clientPicture;
  String clientName;
  String clientMobile;
  String clientEmail;
  String bloodGroup;
  String bloodBags;
  String diseaseName;
  String injectionDate;
  BloodInfo.fromJson(final Map _inputData){
    if(_inputData != null){
      hospitalAddress = Address.fromMap(_inputData['address']);
      bloodGroup = _inputData['blood_group'];
      bloodBags = _inputData['bag_count'];
      injectionDate = _inputData['injection_date'];
      diseaseName = _inputData['disease'];
      clientEmail = _inputData['client_email'];
      clientName = _inputData['client_name'];
      clientMobile = _inputData['client_mobile'];
      clientPicture = _inputData['client_picture'];
    }
  }

  Map toJson(){
    return {
      'address' : hospitalAddress.toJson(),
      'blood_group' : bloodGroup,
      'bag_count' : bloodBags,
      'injection_date' : injectionDate,
      'disease' : diseaseName,
      'client_email' : clientEmail,
      'client_name' : clientName,
      'client_mobile' : clientMobile,
      'client_picture' : clientPicture,
    };
  }

}

class Address {
  String country;
  String code;
  String state;
  String city;
  String street;
  String house;
  String postalCode;

  Address(
      {this.country,
      this.code,
      this.state,
      this.city,
      this.street,
      this.house,
      this.postalCode});

  Address.fromMap(Map<String, dynamic> json) {
    this.country = LocationProvider.clearCasedPlace(json['country'] ?? '');
    this.street = json['street'];
    this.state = LocationProvider.clearCasedPlace(json['state'] ?? '');
    this.city = LocationProvider.clearCasedPlace(json['city'] ?? '');
    this.postalCode = json['zip'];
    this.house = json['house'];
    this.code = json['code'];
  }

  Map<String, String> toJson() {
    return {
      'country': this.country ?? "",
      'code': this.code ?? "",
      'street': this.street ?? "",
      'state': this.state ?? "",
      'zip': this.postalCode ?? "",
      'city': this.city ?? "",
      'house': this.house ?? "",
    };
  }
}

class Person {

  BloodInfo bloodInfo;
  String verificationCode;
  bool hasValidPostal;
  String age;
  String bloodGroup; //db :: blood_group
  String emailAddress; //  "mostafizur.cse@gmail.com"
  String fullName;
  ImgurResponse profilePicture;
  String mobileNumber;
  Address address;
  String birthDate;
  bool isDonor;
  DocumentReference reference;

  Person(final Map<dynamic, dynamic> _map) {
    this.fullName = _map['name'];
    this.mobileNumber = _map['mobile'];
    this.bloodGroup = _map['blood_group'];
    this.address = Address.fromMap(_map['address']);
    this.emailAddress = _map['email'];
    this.profilePicture = ImgurResponse(jsonData:  _map['profile']);
    this.age = _map['age'];
    this.birthDate = getDOB(_map['age']);
    this.hasValidPostal = _map['is_valid_postal'] ?? false;
    this.verificationCode = _map['code'];
    this.bloodInfo = BloodInfo.fromJson(_map['blood_data']);
  }

//  final String name;
//  final int votes;
//  final DocumentReference reference;

  static String getDOB(final String age){
    try{
      final String _ageString = age.replaceAll(' year', '');
      final int year = int.tryParse(_ageString);
      final _date = DateTime.now().subtract(Duration(days: year * 365));
      return DateFormat("dd MMM, yyyy").format(_date);
    } catch (ex){
      final _date = DateTime.now().subtract(Duration(days: 18 * 365));
      return DateFormat("dd MMM, yyyy").format(_date);
    }
  }

  Person.fromMap(Map<dynamic, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['mobile'] != null),
        fullName = map['name'],
        mobileNumber = map['mobile'],
        bloodGroup = map['blood_group'],
        emailAddress = map['email'],
        profilePicture = ImgurResponse(jsonData:  map['profile']),
        age = map['age'],
        birthDate = getDOB(map['age']),
        this.hasValidPostal = map['is_valid_postal'] ?? false,
        this.verificationCode = map['code'] ?? '',
        address = Address.fromMap(map['address'] ?? {});

  Person.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    return _personToJson(this);
  }

  static _personToJson(final Person _person) {
    return {
      'name': _person.fullName,
      'mobile': _person.mobileNumber,
      'blood_group': _person.bloodGroup,
      'birth_date': _person.birthDate,
      'address': _person.address.toJson(),
      'age' : _person.age,
      'email' : _person.emailAddress,
      'profile' : _person.profilePicture.toJson(),
      'code' : _person.verificationCode ?? '',
    };
  }

  @override
  String toString() => "Record<$fullName:$mobileNumber>";
}
