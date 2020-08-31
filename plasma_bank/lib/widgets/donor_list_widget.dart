import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/network/models/plasma_donor.dart';
import 'package:rxdart/rxdart.dart';

class DonorListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DonorListState();
  }
}

///You must insert a filter before donor list

class _DonorListState extends State<DonorListWidget> {
  BehaviorSubject<List<BloodDonor>> _listBehavior = BehaviorSubject();
  final _repository = FirebaseRepositories();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _listBehavior.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    Navigator.pop(context);
    return Container(
      color: Colors.red,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: WidgetProvider.getBackAppBar(context, title: 'BLOOD DONORS'),
        body: Padding(
          padding: EdgeInsets.only(
            bottom: displayData.bottom,
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: _repository.getDonorList({}),
            builder: (context, snapshot) {
              final QuerySnapshot _documentData = snapshot.data;
              if (snapshot.data == null) {
                return Center(
                  child: WidgetProvider.loadingBox(),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _documentData.documents.length + 1,
                itemBuilder: (_context, _index) {
                  if (_index == 0) {
                    return Container(height: 16,);//WidgetTemplate.getPageAppBar(context);
                  }
                  final _data = _documentData.documents[_index - 1].data;
                  final _donor = BloodDonor.fromMap(_data);
                  return _getDonorWidget(_donor);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _getDonorWidget(final BloodDonor bloodDonor) {
    bool _isPlasmaDonor = bloodDonor is PlasmaDonor;

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 28),
      child: Container(
        decoration: AppStyle.listItemDecoration,
        width: displayData.width - 48,
        height: 125,
        child: Material(
          color: Colors.transparent,
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
                  child: WidgetTemplate.getProfilePicture(bloodDonor)
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[


                  Text(bloodDonor.fullName.toUpperCase()),
                  Text(
                    bloodDonor.emailAddress,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        height: 1.5),
                  ),
                  Text(
                    bloodDonor.mobileNumber,
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey, height: 1.5),
                  ),
                  Container(
                    height: 60,
//                            color: Colors.red,
                    width: displayData.width - 160,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _getAction(Icons.phone, 0, bloodDonor),
                        SizedBox(
                          width: 24,
                        ),
                        _getAction(Icons.mail_outline, 1, bloodDonor),
                        SizedBox(
                          width: 24,
                        ),
                        _getAction(Icons.chat_bubble_outline, 2, bloodDonor)
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  _communicate(int index, BloodDonor bloodDonor){

    if(index == 2){
      Navigator.pushNamed(context, AppRoutes.pagePrivateChat, arguments: {'donor' : bloodDonor});
    }
  }

  Widget _getAction(IconData _iconData, int index, BloodDonor bloodDonor){
    return Container(
      decoration: AppStyle.circularShadow(),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        child: WidgetProvider.getInkButton(
            40, 40, ()=>_communicate(index, bloodDonor), _iconData, iconColor: AppStyle.theme(),
        ),
      ),
    );
  }

}
