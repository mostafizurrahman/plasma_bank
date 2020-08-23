import 'dart:math';

import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DonorHandler {
  static final _donorHandler = DonorHandler._internal();
  DonorHandler._internal();
  factory DonorHandler() {
    return _donorHandler;
  }

  readLoginData(final BehaviorSubject _subject) async {
    final _pref = await SharedPreferences.getInstance();
    this._loginEmail = _pref.getString('login_email');
    final _repository = FirebaseRepositories();
    if (_loginEmail != null && _loginEmail.isNotEmpty) {
      _repository.getDonorData(_loginEmail).then(
        (value) {
          if (value != null) {
            this.loginDonor = value;
            _subject.sink.add(value);
          }
        },
      );
    } else {
      _subject.sink.add(null);
    }
  }

  String _loginEmail;
  BloodDonor loginDonor;
  String _verificationEmail;
  String _identifier;

  PublishSubject<String> donorLoginBehavior = PublishSubject();
  PublishSubject<BloodDonor> donorBehavior = PublishSubject();

  dispose() {
    _donorHandler.donorLoginBehavior.close();
    if (!donorLoginBehavior.isClosed) {
      donorLoginBehavior.close();
    }
    closeDonor();
  }

  closeDonor() {
    _donorHandler.donorBehavior.close();
    if (!donorBehavior.isClosed) {
      donorBehavior.close();
    }
  }

  List<String> _donorEmails = List();
  List<BloodDonor> donorDataList = [];

  List<String> get donorEmails {
    return _donorEmails;
  }

  set donorEmails(List<String> _emails) {
    _emails.forEach(
      (_email) {
        if (!_donorEmails.contains(_email)) {
          _donorEmails.add(_email);
          final _repository = FirebaseRepositories();
          _repository.getDonorData(_email).then(
            (value) {
              if (value != null) {
                donorDataList.add(value);
              }
            },
          );
        }
      },
    );
  }

  bool hasExistingAccount(final String _email) {
    return this._donorEmails.contains(_email);
  }

  set loginEmail(String _email) {

    donorBehavior = PublishSubject();
    this._loginEmail = _email;
    if (_email == null) {
      this.loginDonor = null;
      donorBehavior.sink.add(null);
    } else {
      SharedPreferences.getInstance().then((value) async {
        value.setString('login_email', _email);
      });
      final _repository = FirebaseRepositories();
      _repository.getDonorData(_email).then(
        (value) {
          if (value != null) {
            this.loginDonor = value;
            donorBehavior.sink.add(value);
          }
        },
      ).catchError((_error) {
        donorBehavior.sink.add(null);
      });
    }
  }

  logoutEmail(final String _email) async {
    if(_email == this.loginEmail){
      this.loginEmail = null;
      final _pref = await SharedPreferences.getInstance();
      _pref.remove('login_email');
      loginDonor = null;
    }
  }



  String get loginEmail {
    return this._loginEmail;
  }

  set verificationEmail(final String _email) {
    this._verificationEmail = _email;
  }

  String get verificationEmail {
    return _verificationEmail;
  }

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
}

final DonorHandler donorHandler = DonorHandler();
