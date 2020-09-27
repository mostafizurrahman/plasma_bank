import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/network/person_handler.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/network/models/plasma_donor.dart';
import 'package:rxdart/rxdart.dart';

class AccountsWidget extends StatefulWidget {

  final Function(String) onAccountSelected;
  AccountsWidget(this.onAccountSelected);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AccountState();
  }
}

class _AccountState extends State<AccountsWidget> {

  BehaviorSubject<bool> _cautionBehavior = BehaviorSubject();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(!_cautionBehavior.isClosed){
      _cautionBehavior.close();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), _onLoaded);
  }


  _onLoaded(){
    if(this._cautionBehavior != null && !this._cautionBehavior.isClosed){
      this._cautionBehavior.sink.add(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:


        StreamBuilder<bool>(
          stream: _cautionBehavior.stream,
          initialData: false,
          builder: (context, snapshot) {
            if(!snapshot.data){
              return Center(
                child: Container(
                  width: displayData.width - 48,
                  height: 140,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(strokeWidth: 1.75,),
                      ),
                      Text(
                        'Loading all accounts, created by this device. Tap an item to login.',
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),

                ),
              );
            }
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: donorHandler.bloodDonorList.length,
//            itemExtent: 120,
              itemBuilder: (_context, _index) {
                final _data = donorHandler.bloodDonorList[_index];
                return _getDonorWidget(_data);

//                            this.getCountryItem(_data);
              },
            );
          }
        ),
      ),
    );
  }

  Widget _getDonorWidget(final BloodDonor bloodDonor) {
    bool _isPlasmaDonor = bloodDonor is PlasmaDonor;

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 24),
      child: Container(
        decoration: AppStyle.listItemDecoration,
        width: displayData.width - 48,
        height: 95,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            child: InkWell(
              onTap: (){
                this.widget.onAccountSelected(bloodDonor.emailAddress);
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 12,
                  ),
                  Container(
                    width: 75,
                    height: 75,

                    decoration: AppStyle.circularShadow(),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(110)),
                      child: bloodDonor.profilePicture?.thumbUrl != null ?
                      Image.network(
                        bloodDonor.profilePicture.thumbUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.75,
                              backgroundColor: Colors.red,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.cyan,
                              ),
                              value: loadingProgress.expectedTotalBytes !=
                                  null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                      ) : Center(child: CircularProgressIndicator(strokeWidth: 1.75,),),

//                Image(
//                  image: NetworkImage('https://i.imgur.com/oCb2p45.jpeg'),
//                  fit: BoxFit.fitWidth,
//                ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Stack(
                    children:<Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(bloodDonor.fullName.toUpperCase()),
                          Text(
                            bloodDonor.emailAddress,
                            style: TextStyle(
                                fontSize: 12, color: Colors.black54, height: 1.5),
                          ),
                          Text(
                            bloodDonor.mobileNumber,
                            style:
                            TextStyle(fontSize: 12, color: Colors.grey, height: 1.5),
                          ),
                          Container(
                            width: displayData.width - 147,
                            height: 25,
                          ),
                        ],
                      ),
                      Positioned(

                        top: 30,
                        right: 4,
                        bottom: 30,
                        child: Container(
                          width: 35,
                          height: 35,


                          child: IconButton(
                            color: Colors.transparent,
                            icon: Icon(Icons.chevron_right, color: AppStyle.theme(),),
                          ),
                        ),
                      ),
                    ],
                  ),

//            Expanded(
//              child: Row(
//                crossAxisAlignment: CrossAxisAlignment.center,
//                mainAxisAlignment: MainAxisAlignment.end,
//                children: <Widget>[
//
//                ],
//              ),
//            )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
