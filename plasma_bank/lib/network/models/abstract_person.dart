import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

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
  String bloodGroup; //db :: blood_group
  String emailAddress; //  "mostafizur.cse@gmail.com"
  String fullName;
  String profilePicture;
  String mobileNumber;
  Address address;
  DateTime birthDate;
  DocumentReference reference;

  Person(final Map<String, dynamic> _map) {
    this.fullName = _map['name'];
    this.mobileNumber = _map['mobile'];
    this.bloodGroup = _map['blood_group'];
    this.address = Address.fromMap(_map['address']);
    this.emailAddress = _map['email'];
    this.profilePicture = _map['profile'];
  }

//  final String name;
//  final int votes;
//  final DocumentReference reference;

  Person.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['mobile'] != null),
        fullName = map['name'],
        mobileNumber = map['mobile'],
        bloodGroup = map['blood_group'],
        this.birthDate = map['birth_date'] == null
            ? null
            : (map['birth_date'] as Timestamp).toDate(),
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
    };
  }

  @override
  String toString() => "Record<$fullName:$mobileNumber>";
}
