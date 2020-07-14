import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plasma_bank/network/models/blood_collector.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';


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


  Stream<QuerySnapshot> getGlobalCovidData(){
    return this._globalCovidData.snapshots();
  }

  Stream<QuerySnapshot> getPatientStream() {
    return this._patientCollection.snapshots();
  }

  Future<DocumentReference> addBloodHunter(dynamic bloodHunter) async {
    if(bloodHunter is BloodCollector){
      final _json = bloodHunter.toJson();
      final _data = {bloodHunter.mobileNumber: _json};
      return await _patientCollection.add(_data);
    } else {
//      final _data = {bloodHunter['mobile']: bloodHunter};
      return await _patientCollection.add(bloodHunter);
    }
  }

  updatePatient(BloodCollector bloodHunter) async {
    await _patientCollection
        .document(bloodHunter.reference.documentID)
        .updateData(bloodHunter.toJson());
  }


  Future<DocumentReference> uploadBloodDonor(final BloodDonor bloodDonor){
    assert(bloodDonor.address != null, 'ADDRESS MUST NOT BE NULL');
    final _code = bloodDonor.hasValidPostal ? bloodDonor.address.postalCode : 'invalid_postal';
    return Firestore.instance.collection('donor')
        .document(bloodDonor.address.country)
        .collection(bloodDonor.address.state)
        .document(bloodDonor.address.city)
        .collection(_code)
        .add(bloodDonor.toJson());
  }
}
