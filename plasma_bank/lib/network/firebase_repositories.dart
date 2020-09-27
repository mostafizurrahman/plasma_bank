import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/network/models/abstract_person.dart';
import 'package:plasma_bank/network/models/blood_collector.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/network/models/plasma_donor.dart';
import 'package:plasma_bank/network/person_handler.dart';
import 'package:plasma_bank/widgets/messaging/filter_widget.dart';

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
//    if (bloodHunter is BloodCollector) {
//      final _json = bloodHunter.toJson();
//      final _data = {bloodHunter.mobileNumber: _json};
//      return await _patientCollection.add(_data);
//    } else {
//      return await _patientCollection.add(bloodHunter);
//    }
  }

  updatePatient(BloodCollector bloodHunter) async {
//    await _patientCollection
//        .document(bloodHunter.reference.documentID)
//        .updateData(bloodHunter.toJson());
  }

  Stream<DocumentSnapshot> getDonorEmails() {
    return Firestore.instance
        .collection('donor')
        .document(deviceInfo.deviceUUID)
        .snapshots();
  }

  Stream<DocumentSnapshot> getTakerEmails() {
    return Firestore.instance
        .collection('collector')
        .document(deviceInfo.deviceUUID)
        .snapshots();
  }

  Future<Person> getDonorData(final String _email) async {
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

  Future<Person> getCollectorData(final String _email) async {
    DocumentSnapshot _data = await Firestore.instance
        .collection("collector")
        .document(_email)
        .get()
        .catchError((error) {
      return null;
    });
    if (_data.exists) {
      if (_data.data.isNotEmpty) {
        return Person.fromMap(_data.data);
      }
    }
    return null;
  }



  Future<bool> updateDonationDate(String _date, String _email) async {
    bool _updated = true;
    await Firestore.instance
        .collection('donor')
        .document(_email)
        .updateData({'donation_date' : _date})
        .catchError((_error) {
      _updated = false;
      debugPrint('error+occurred  ___________ ' + _error.toString());
    });
    return _updated;
  }

  uploadBloodCollector(final BloodCollector bloodCollector) async {
    await Firestore.instance
        .collection('collector')
        .document(bloodCollector.emailAddress)
        .setData(bloodCollector.toJson())
        .catchError((_error) {
      debugPrint('error+occurred  ___________ ' + _error.toString());
    });
    List<String> _emails = donorHandler.collectorList;
    _emails.add(bloodCollector.emailAddress);
    final devices = {'acc': _emails};
    await Firestore.instance
        .collection('collector')
        .document(deviceInfo.deviceUUID)
        .setData(devices)
        .catchError((_error) {
      debugPrint('error+occurred  ___________ ' + _error.toString());
    });
    final _code = (bloodCollector?.hasValidPostal ?? false)
        ? bloodCollector.address.postalCode
        : '-1';
    await Firestore.instance
        .collection('donor')
        .document(bloodCollector.address.country)
        .collection(bloodCollector.address.state)
        .document(bloodCollector.address.city)
        .collection('data')
        .document(bloodCollector.emailAddress)
        .setData({
      'email': bloodCollector.emailAddress,
      'postal': _code,
    }).catchError((_error) {
      debugPrint('error+occurred  ___________ ' + _error.toString());
    });
  }

  uploadBloodDonor(final BloodDonor bloodDonor) async {
    await Firestore.instance
        .collection('donor')
        .document(bloodDonor.emailAddress)
        .setData(bloodDonor.toJson())
        .catchError((_error) {
      debugPrint('error+occurred  ___________ ' + _error.toString());
    });
    List<String> _emails = donorHandler.donorList;
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


  Stream<QuerySnapshot> getDonorList(final FilterData filterData) {

   final _reference = Firestore.instance.collection('donor')
        .where('disease', isNull: true ,)
       .where('address.code', isEqualTo: filterData.code)
       .where('address.state', isEqualTo: filterData.region)
       .where('address.city', isEqualTo: filterData.city);
//        .where('address.city', isEqualTo: filterData.city);
    if(filterData.bloodGroup != null && filterData.bloodGroup.isNotEmpty){
      return _reference.where('blood_group',  isEqualTo: filterData.bloodGroup).snapshots();
    }
    return _reference.snapshots();
  }

  Stream<QuerySnapshot> getCollectorList(final FilterData filterData) {

    final _reference = Firestore.instance.collection('collector')
        .where('code', isNull: true ,)
        .where('address.code', isEqualTo: filterData.code)
        .where('address.state', isEqualTo: filterData.region)
        .where('address.city', isEqualTo: filterData.city);
//        .where('address.city', isEqualTo: filterData.city);
    if(filterData.bloodGroup != null && filterData.bloodGroup.isNotEmpty){
      return _reference.where('blood_group',  isEqualTo: filterData.bloodGroup).snapshots();
    }
    return _reference.snapshots();
  }
}
