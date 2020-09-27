import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/models/abstract_person.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonHandler {
  static final _personHandler = PersonHandler._internal();
  PersonHandler._internal();

  factory PersonHandler() {
    _personHandler._init();
    _personHandler.readDeviceList();
    return _personHandler;
  }

  List<String> _donorList;
  List<String> get donorList{
    return _donorList;
  }
  List<String> _takerList;
  List<String> get collectorList{
    return _takerList;
  }
  final List<Person> _bloodDonorList = [];
  List<Person> get bloodDonorList{
    return _bloodDonorList;
  }
  final List<Person> _bloodTakerList = [];
  List<Person> get bloodCollectorList{
    return _bloodTakerList;
  }
  final BehaviorSubject<Person> _loginEmailBehavior = BehaviorSubject();
  BehaviorSubject<Person> get loginEmailBehavior{
    return _loginEmailBehavior;
  }
  final BehaviorSubject<String> _verifyEmailBehavior = BehaviorSubject();
  BehaviorSubject<String> get verifyEmailBehavior{
    return _verifyEmailBehavior;
  }
  //login email GET/SET
  String _loginEmail;
  String get loginEmail {
    return this._loginEmail;
  }

  //verify email GET/SET
  String _identifier;
  String get identifier {
    this._identifier = '';
    var rng = new Random();
    for (var i = 0; i < 6; i++) {
      this._identifier += (rng.nextInt(10) % 10).toString();
    }
    return this._identifier;
  }

  bool verifyIDF(final String _idf) {
    return _idf == this._identifier;
  }

  String get verificationEmail {
    return _verifyEmailBehavior.value;
  }

  //set null on verified and after login
  set verificationEmail(final String _email) {
    this._verifyEmailBehavior.sink.add(_email);
  }

  disposeStream() {
    _loginEmailBehavior.close();
    _verifyEmailBehavior.close();
  }

  _init() async {
    final _pref = await SharedPreferences.getInstance();
    final String loginEmail = _pref.getString('login_email');
    final bool isDonor = _pref.getBool('is_donor');
    this.initLoginPerson(loginEmail, isDonor: isDonor);
  }

  //error while reading login data
  _onLoginError(final _error) {
    this._loginEmail = null;
    this._loginEmailBehavior.sink.add(null);
  }

  //this will be called after verification
  initLoginPerson(final String loginEmail, {final bool isDonor = true}) {
    if (loginEmail != null && loginEmail.isNotEmpty) {
      this._loginEmail = loginEmail;
      final _repository = FirebaseRepositories();
      if (isDonor) {
        _repository
            .getDonorData(loginEmail)
            .then(_onLoginPersonLoaded)
            .catchError(_onLoginError);
      } else {
        _repository
            .getCollectorData(loginEmail)
            .then(_onLoginPersonLoaded)
            .catchError(_onLoginError);
      }
      _setSharedData(loginEmail, isDonor);
    }
  }

  _onLoginPersonLoaded(final Person _person) {
    if (_person != null) {
      this._loginEmailBehavior.sink.add(_person);
      this._verifyEmailBehavior.sink.add(null);
    }
  }

  _setSharedData(final String _email, final bool isDonor) async {
    final _pref = await SharedPreferences.getInstance();
    _pref.setBool('is_donor', isDonor);
    _pref.setString('login_email', _email);
  }

  _removeSharedData() async {
    final _pref = await SharedPreferences.getInstance();
    _pref.remove('is_donor');
    _pref.remove('login_email');
  }

  //set this email after verification, use null as email for logout
  setLoginEmail(final String _email, {final bool isDonor = true}) {
    if (_email == null) {
      this._onLoginError(null);
      this._removeSharedData();
    } else {
      initLoginPerson(_email, isDonor: isDonor);
    }
  }

  ///TODO :: LISTING OF DONORS

  StreamSubscription<DocumentSnapshot> _donorSubscriptionID;
  StreamSubscription<DocumentSnapshot> _takerSubscriptionID;

  closeListSubscriptions(final List<String> _emailList) {
    _donorSubscriptionID.cancel();
    _takerSubscriptionID.cancel();
//    donorHandler.donorEmails = _emailList;
  }

  readDeviceList() {
    final _repository = FirebaseRepositories();
    final Stream<DocumentSnapshot> _donorStream = _repository.getDonorEmails();
    final Stream<DocumentSnapshot> _collectorStream = _repository.getTakerEmails();
    _donorSubscriptionID = _donorStream.listen(_onDeviceDonorEmailRead);
    _takerSubscriptionID = _collectorStream.listen(_onDeviceTakerEmailRead);
  }

  _onDeviceDonorEmailRead(final DocumentSnapshot snapshot) {
    if (snapshot.data != null && snapshot.data.isNotEmpty) {
      _addDeviceEmail(snapshot, true);
    } else {
      _readPerson([], true);
    }
  }

  _onDeviceTakerEmailRead(final DocumentSnapshot snapshot) {
    if (snapshot.data != null && snapshot.data.isNotEmpty) {
      _addDeviceEmail(snapshot, false);
    } else {
      _readPerson([], false);
    }
  }

  _addDeviceEmail(final DocumentSnapshot snapshot, final bool isDonor) {

      snapshot.data.forEach((k, v) {
        debugPrint('key :' + k.toString() + ' value ' + v.toString());
        if (v is List<dynamic>) {
          List<String> _list = List();
          for (int i = 0; i < v.length; i++) {
            final _value = v[i];
            if (_value is String) {
              _list.add(_value);
            }
          }
          _readPerson(_list, isDonor);
        }
      });


  }

  _readPerson(final List<String> _list, final bool isDonor) async {
    final _repository = FirebaseRepositories();
    if (isDonor) {
      this._donorList = _list;
    } else {
      this._takerList = _list;
    }
    for(int i = 0; i < _list.length; i++){
      if(isDonor){
        final Person _person = await _repository.getDonorData(_list[i]);
        if(_person != null){
          this._bloodDonorList.add(_person);
        }
      } else {
        final Person _person = await _repository.getCollectorData(_list[i]);
        if(_person != null){
          this._bloodDonorList.add(_person);
        }
      }
    }
  }

  Future<bool> isEmailRegisteredAsDonor(final String _email) async {
    if (this._donorList.contains(_email)) {
      return true;
    }
    final _repository = FirebaseRepositories();
    final Person _person = await _repository.getDonorData(_email);
    if (_person != null) {
      return true;
    }
    return false;
  }

  Future<bool> isEmailRegisteredAsTaker(final String _email) async {
    if (this._takerList.contains(_email)) {
      return true;
    }
    final _repository = FirebaseRepositories();
    final Person _person = await _repository.getCollectorData(_email);
    if (_person != null) {
      return true;
    }
    return false;
  }

  updateDonorList(final Person _donor) {
    this._donorList.add(_donor.emailAddress);
    this._bloodDonorList.add(_donor);
  }
  
  updateTakerList(final Person _taker){
    this._takerList.add(_taker.emailAddress);
    this._bloodTakerList.add(_taker);
  }

  _onPersonError(final _error) {
    debugPrint(_error.toString());
  }


}

final PersonHandler donorHandler = PersonHandler();
