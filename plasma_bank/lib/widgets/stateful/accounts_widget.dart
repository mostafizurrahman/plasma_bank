import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/network/donor_handler.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/network/models/plasma_donor.dart';

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
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: donorHandler.donorDataList.length,
        itemExtent: 120,
        itemBuilder: (_context, _index) {
          final _data = donorHandler.donorDataList[_index];
          return _getDonorWidget(_data);

//                            this.getCountryItem(_data);
        },
      ),
    );
  }

  Widget _getDonorWidget(final BloodDonor bloodDonor) {
    bool _isPlasmaDonor = bloodDonor is PlasmaDonor;

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 10, bottom: 10),
      child: Container(
        decoration: AppStyle.listItemDecoration,
        width: MediaQuery.of(context).size.width - 48,
        height: 120,
        child: Material(
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
                      child:
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
                                Color.fromARGB(255, 220, 220, 200),
                              ),
                              value: loadingProgress.expectedTotalBytes !=
                                  null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes
                                  : null,
                            ),
                          );
                        },
                      ),

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
                          Text(bloodDonor.fullName),
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
                            width: MediaQuery.of(context).size.width - 147,
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
                          color:Colors.white,

                          child: IconButton(
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