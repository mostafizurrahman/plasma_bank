import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/network/models/abstract_person.dart';
import 'package:plasma_bank/network/models/blood_collector.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/network/models/plasma_donor.dart';

class FirebaseRepositories {
  //  Future<List<Country>> getCountries() async {
//    return await this._globeAPI.getCountries();
//  }

//  Future<List<Region>> getRegion(final Country country){
//
//  }

  CollectionReference _globalCovidData;
  CollectionReference _patientCollection;
  CollectionReference _plasmaCollection;
  DocumentReference _documentCollection;
  final String country;
  final String district;
  FirebaseRepositories({this.country, this.district}) {
    this._globalCovidData = Firestore.instance.collection('coronavirus');
    this._documentCollection = Firestore.instance
        .collection('patient')
        .document('bangladesh')
        .collection('dhaka')
        .document('mohammadpur');
//    this._documentCollection.snapshots()
    this._patientCollection =
        this._documentCollection.collection('01675876752');
  }

  Stream<QuerySnapshot> getGlobalCovidData() {
    return this._globalCovidData.snapshots();
  }

  Stream<QuerySnapshot> getPatientStream() {
    return this._patientCollection.snapshots();
  }

  Future<DocumentReference> addBloodHunter(dynamic bloodHunter) async {
    if (bloodHunter is BloodCollector) {
      final _json = bloodHunter.toJson();
      final _data = {bloodHunter.mobileNumber: _json};
      return await _patientCollection.add(_data);
    } else {
      return await _patientCollection.add(bloodHunter);
    }
  }

  updatePatient(BloodCollector bloodHunter) async {
    await _patientCollection
        .document(bloodHunter.reference.documentID)
        .updateData(bloodHunter.toJson());
  }

  Stream<DocumentSnapshot> getEmails() {
    return Firestore.instance
        .collection('donor')
        .document(deviceInfo.deviceUUID)
        .snapshots();
  }

  Future<BloodDonor> getDonorData(final String _email) async {
    DocumentSnapshot _data = await Firestore.instance
        .collection('donor')
        .document(_email)
        .get()
        .catchError((error) {
      return null;
    });
    if (_data.exists) {
      if (_data.data.isNotEmpty) {
        if (_data.data.keys.contains('covid_date')) {
          return PlasmaDonor.fromMap(_data.data);
        }
        return BloodDonor.fromMap(_data.data);
      }
    }
    return null;
  }

  uploadBloodDonor(final BloodDonor bloodDonor, List<String> _emails) async {
    await Firestore.instance
        .collection('donor')
        .document(bloodDonor.emailAddress)
        .setData(bloodDonor.toJson())
        .catchError((_error) {
      debugPrint('error+occurred  ___________ ' + _error.toString());
    });
    _emails.add(bloodDonor.emailAddress);
    final devices = {'acc': _emails};
    await Firestore.instance
        .collection('donor')
        .document(deviceInfo.deviceUUID)
        .setData(devices)
        .catchError((_error) {
      debugPrint('error+occurred  ___________ ' + _error.toString());
    });
    final _code = (bloodDonor?.hasValidPostal ?? false)
        ? bloodDonor.address.postalCode
        : '-1';
    await Firestore.instance
        .collection('donor')
        .document(bloodDonor.address.country)
        .collection(bloodDonor.address.state)
        .document(bloodDonor.address.city)
        .collection('data')
        .document(bloodDonor.emailAddress)
        .setData({
      'group': bloodDonor.bloodGroup,
      'weight': bloodDonor.weight,
      'height': bloodDonor.height,
      'covid': bloodDonor is PlasmaDonor,
      'postal': _code,
    }).catchError((_error) {
      debugPrint('error+occurred  ___________ ' + _error.toString());
    });
  }
}
