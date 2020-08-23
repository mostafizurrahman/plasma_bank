import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
import 'dart:convert';
=======
import 'package:plasma_bank/app_utils/image_helper.dart';
import 'dart:convert';
import 'package:plasma_bank/network/imgur_handler.dart';
import 'package:intl/intl.dart';
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35

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
    this.country = json['country'];
    this.street = json['street'];
    this.state = json['state'];
    this.city = json['city'];
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

abstract class Person {
<<<<<<< HEAD
  String bloodGroup; //db :: blood_group
  String emailAddress; //  "mostafizur.cse@gmail.com"
  String fullName;
  String profilePicture;
  String mobileNumber;
  Address address;
  DateTime birthDate;
  DocumentReference reference;

  Person(final Map<String, dynamic> _map) {
=======

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
  DocumentReference reference;

  Person(final Map<dynamic, dynamic> _map) {
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    this.fullName = _map['name'];
    this.mobileNumber = _map['mobile'];
    this.bloodGroup = _map['blood_group'];
    this.address = Address.fromMap(_map['address']);
    this.emailAddress = _map['email'];
<<<<<<< HEAD
    this.profilePicture = _map['profile'];
=======
    this.profilePicture = ImgurResponse(jsonData:  _map['profile']);
    this.age = _map['age'];
    this.birthDate = getDOB(_map['age']);
    this.hasValidPostal = _map['is_valid_postal'] ?? false;
    this.verificationCode = _map['code'];
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
  }

//  final String name;
//  final int votes;
//  final DocumentReference reference;

<<<<<<< HEAD
  Person.fromMap(Map<String, dynamic> map, {this.reference})
=======
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
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
      : assert(map['name'] != null),
        assert(map['mobile'] != null),
        fullName = map['name'],
        mobileNumber = map['mobile'],
        bloodGroup = map['blood_group'],
<<<<<<< HEAD
        this.birthDate = map['birth_date'] == null
            ? null
            : (map['birth_date'] as Timestamp).toDate(),
=======
        emailAddress = map['email'],
        profilePicture = ImgurResponse(jsonData:  map['profile']),
        age = map['age'],
        birthDate = getDOB(map['age']),
        this.hasValidPostal = map['is_valid_postal'] ?? false,
        this.verificationCode = map['code'] ?? '',
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
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
<<<<<<< HEAD
=======
      'age' : _person.age,
      'email' : _person.emailAddress,
      'profile' : _person.profilePicture.toJson(),
      'code' : _person.verificationCode ?? '',
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    };
  }

  @override
  String toString() => "Record<$fullName:$mobileNumber>";
}
