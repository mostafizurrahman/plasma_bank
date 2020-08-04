import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:rxdart/rxdart.dart';

class DonorHandler {
  static final _donorHandler = DonorHandler._internal();
  DonorHandler._internal();
  factory DonorHandler() {
    return _donorHandler;
  }

  PublishSubject<String> donorLoginBehavior = PublishSubject();

  dispose(){
    _donorHandler.donorLoginBehavior.close();
    if(!donorLoginBehavior.isClosed){
      donorLoginBehavior.close();
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
          _repository.getDonorData(_email).then( (value) {
                  if(value != null){
                    donorDataList.add(value);
                  }
                },
              );
        }
      },
    );
  }

  bool hasExistingAccount(final String _email){
    return this._donorEmails.contains(_email);
  }

}

final DonorHandler donorHandler = DonorHandler();
