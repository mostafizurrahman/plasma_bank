import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/network/models/blood_hunter.dart';

class FirebaseRepositories {

  //  Future<List<Country>> getCountries() async {
//    return await this._globeAPI.getCountries();
//  }

//  Future<List<Region>> getRegion(final Country country){
//
//  }

  CollectionReference _patientCollection;
  CollectionReference _plasmaCollection;
  DocumentReference _documentCollection;
  final String country;
  final String district;
  FirebaseRepositories({this.country, this.district}) {
    this._documentCollection = Firestore.instance
        .collection('patient')
        .document('bangladesh')
        .collection('dhaka')
        .document('mohammadpur');
//    this._documentCollection.snapshots()
    this._patientCollection =
        this._documentCollection.collection('01675876752');
  }

  Stream<QuerySnapshot> getPatientStream() {
    return this._patientCollection.snapshots();
  }

  Future<DocumentReference> addBloodHunter(dynamic bloodHunter) async {
    if(bloodHunter is BloodHunter){
      final _json = bloodHunter.toJson();
      final _data = {bloodHunter.mobileNumber: _json};
      return await _patientCollection.add(_data);
    } else {
//      final _data = {bloodHunter['mobile']: bloodHunter};
      return await _patientCollection.add(bloodHunter);
    }
  }

  updatePatient(BloodHunter bloodHunter) async {
    await _patientCollection
        .document(bloodHunter.reference.documentID)
        .updateData(bloodHunter.toJson());
  }
}
