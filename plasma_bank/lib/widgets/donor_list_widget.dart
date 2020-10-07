import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/media/dash_painter.dart';
import 'package:plasma_bank/network/firebase_repositories.dart';
import 'package:plasma_bank/network/imgur_handler.dart';
import 'package:plasma_bank/network/models/abstract_person.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/network/models/plasma_donor.dart';
import 'package:plasma_bank/widgets/base_widget.dart';
import 'package:rxdart/rxdart.dart';

import 'messaging/filter_widget.dart';

class DonorListWidget extends BaseWidget {
  DonorListWidget(Map arguments) : super(arguments);

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

  bool isDonorList;

  bool isBloodInfo;
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
    this.isDonorList = widget.getData('is_donor') ?? false;
    this.isBloodInfo = widget.getData('is_blood') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    Navigator.pop(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
//        backgroundColor: Colors.white,
//        extendBodyBehindAppBar: true,
//        extendBody: true,
//        appBar: AppBar(
//          elevation: 0,
//          backgroundColor: Colors.white,
//          leading: WidgetProvider.getCustomAppBar(
//              context, this.isBloodInfo ? 'BLOOD SEEKERS' : 'BLOOD DONORS', ''),
//          titleSpacing: 0,
//          centerTitle: false,
//        ),
//        WidgetProvider.appBar(
//          'BLOOD DONORS',
//        ),

//            WidgetProvider.getBackAppBar(
//          context,
//          title: Text(
//            this.isBloodInfo ? 'BLOOD SEEKERS' : 'BLOOD DONORS',
//            style: TextStyle(color: Colors.black),
//          ),
//        ),

          body: Column(
            children: <Widget>[
              WidgetProvider.getCustomAppBar(
                  context, this.isBloodInfo ? 'BLOOD SEEKERS' : 'BLOOD DONORS', ''),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: displayData.bottom,
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: this.isDonorList
                        ? _repository.getDonorList(this.widget.getData('filter_data'))
                        : this.isBloodInfo
                            ? _repository
                                .getBloodRequestList(this.widget.getData('filter_data'))
                            : _repository
                                .getCollectorList(this.widget.getData('filter_data')),
                    builder: (context, snapshot) {
                      final QuerySnapshot _documentData = snapshot.data;
                      if (snapshot.data == null) {
                        return Center(
                          child: WidgetProvider.loadingBox(),
                        );
                      }
                      debugPrint(_documentData.documents.toString());
                      return ListView.builder(

                        scrollDirection: Axis.vertical,
                        itemCount: _documentData.documents.length + 1,
                        itemBuilder: (_context, _index) {
                          if (_index == 0) {
                            return Container(
                              height: 24,
                            ); //WidgetTemplate.getPageAppBar(context);
                          }
                          final _data = _documentData.documents[_index - 1].data;
                          if (this.isBloodInfo) {
                            final _donor = BloodInfo.fromJson(_data);
                            return _getBloodInfo(_donor);
                          } else {
                            final _donor = Person(_data);
                            return _getDonorWidget(_donor);
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBloodInfo(BloodInfo bloodInfo) {
    debugPrint(bloodInfo.clientName);
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Container(
        height: 85,
        decoration: AppStyle.listItemDecoration,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            child: InkWell(
              onTap: () {
                debugPrint('done');
                Navigator.pushNamed(context, AppRoutes.pageBloodDetails,
                    arguments: bloodInfo);
              },
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 12,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(110)),
                    child: Container(
                      width: 65,
                      height: 65,
                      child: bloodInfo.clientPicture != null
                          ? WidgetTemplate.getImageWidget(
                              ImgurResponse.fromThumb(bloodInfo.clientPicture))
                          : Center(
                              child: Text(
                                bloodInfo.clientName
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                    color: AppStyle.theme()),
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  bloodInfo.clientName.toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.indigo),
                                ),
                              ),
                              Text(
                                  'is searching for ${bloodInfo.bloodBags} bags blood near by',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                  )),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        bloodInfo.hospitalAddress.state +
                                            ', ' +
                                            bloodInfo.hospitalAddress.city +
                                            '  ' +
                                            bloodInfo.hospitalAddress.street,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 50,
                          height: 90,
                          child: Center(
                            child: Text(
                              bloodInfo.bloodGroup ?? "",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getDonorWidget(final Person bloodDonor) {
    bool _isPlasmaDonor = bloodDonor is PlasmaDonor;

    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 0, bottom: 24),
      child: Container(
        decoration: AppStyle.listItemDecoration,
        width: displayData.width - 48,
        height: 90,
        child: Material(
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(110)),
                child:
                    WidgetTemplate.getProfilePicture(bloodDonor, proHeight: 65),
              ),
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            bloodDonor.fullName.toUpperCase(),
                            style: TextStyle(fontSize: 13),
                          ),
                          Container(
                            height: 60,
                            width: displayData.width - 160,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                _getAction(Icons.phone, 0, bloodDonor),
                                SizedBox(
                                  width: 16,
                                ),
                                _getAction(Icons.mail_outline, 1, bloodDonor),
                                SizedBox(
                                  width: 16,
                                ),
                                _getAction(
                                    Icons.chat_bubble_outline, 2, bloodDonor)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 50,
                      height: 90,
                      child: Center(
                        child: Text(
                          bloodDonor.bloodGroup ?? "",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _communicate(int index, Person bloodDonor) {
    if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.pagePrivateChat,
          arguments: {'donor': bloodDonor});
    }
  }

  Widget _getAction(IconData _iconData, int index, Person bloodDonor) {
    return Container(
      decoration: AppStyle.circularShadow(),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        child: WidgetProvider.getInkButton(
          40,
          40,
          () => _communicate(index, bloodDonor),
          _iconData,
          iconColor: AppStyle.theme(),
        ),
      ),
    );
  }

  _onFilterApplied(final FilterData _data) {
    debugPrint('selected');
  }
}
