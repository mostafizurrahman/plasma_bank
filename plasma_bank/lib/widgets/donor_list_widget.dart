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
import 'package:plasma_bank/network/person_handler.dart';
import 'package:plasma_bank/widgets/base/base_widget.dart';
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

  FilterPageType _pageType;

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
    this._pageType = widget.getData('page_type');
  }

  String _getAppBarTitle() {
    return this._pageType == FilterPageType.FILTER_REQUEST
        ? 'BLOOD REQUESTS'
        : this._pageType == FilterPageType.FILTER_DONOR
            ? 'BLOOD DONORS'
            : 'BLOOD SEEKERS';
  }

  Stream<QuerySnapshot> _getStream() {
    return this._pageType == FilterPageType.FILTER_REQUEST
        ? _repository.getBloodRequestList(this.widget.getData('filter_data'))
        : this._pageType == FilterPageType.FILTER_DONOR
            ? _repository.getDonorList(this.widget.getData('filter_data'))
            : _repository.getCollectorList(this.widget.getData('filter_data'));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
//    Navigator.pop(context);
    final _isDonor = this._pageType == FilterPageType.FILTER_DONOR;
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
              WidgetProvider.getCustomAppBar(context, '', _getAppBarTitle()),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: displayData.bottom,
                  ),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _getStream(),
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
                          final _data =
                              _documentData.documents[_index - 1].data;
                          if (this._pageType == FilterPageType.FILTER_REQUEST) {
                            final _donor = BloodInfo.fromJson(_data);
                            return _getBloodInfo(_donor);
                          } else {
                            final _donor = Person(_data);
                            _donor.isDonor = _isDonor;
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
                              response: ImgurResponse.fromThumb(
                                  bloodInfo.clientPicture))
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
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 0, bottom: 24),
      child: Container(
        decoration: AppStyle.listItemDecoration,
        width: displayData.width - 48,
        height: 90,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            child: InkWell(
              onTap: () {
                final bloodInfo = BloodInfo();
                bloodInfo.hospitalAddress = bloodDonor.address;
                bloodInfo.clientName = bloodDonor.fullName;
                bloodInfo.clientEmail = bloodDonor.emailAddress;
                bloodInfo.clientMobile = bloodDonor.mobileNumber;
                bloodInfo.isDonor = bloodDonor.isDonor;
                bloodInfo.bloodGroup = bloodDonor.bloodGroup;
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
                    child: WidgetTemplate.getProfilePicture(bloodDonor,
                        proHeight: 65),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _getPersonDescription(bloodDonor),
                        ),
                        this._pageType == FilterPageType.FILTER_COLLECTOR
                            ? SizedBox()
                            : Container(
                                width: 50,
                                height: 90,
                                child: Center(
                                  child: Text(
                                    bloodDonor.bloodGroup ?? "",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                              ),
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

  Widget _getPersonDescription(final Person _person) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: _person.fullName.toUpperCase(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppStyle.theme(),
            ),
          ),
          TextSpan(
            text: _person.isDonor
                ? '\n is a donor, willing to donate a bag of '
                : '\nis looking for blood near by his address : ',
            style: TextStyle(
              fontSize: 13,
//                                      fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: _person.isDonor
                ? _person.bloodGroup
                : _person.address.toString(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppStyle.theme(),
            ),
          ),
//          TextSpan(
//            text: _person.isDonor
//                ? ' if you are searching for blood then you can contact him and convince hit to donate. '
//                : ' if you are willing to donate blood, please contact him for further details about the blood he/she needs.',
//            style: TextStyle(
//              fontSize: 13,
////                                      fontWeight: FontWeight.w600,
//              color: Colors.black,
//            ),
//          ),
        ],
      ),
    );
  }

  _communicate(int index, Person bloodDonor) {
    if (index == 2) {
      Navigator.pushNamed(context, AppRoutes.pagePrivateChat,
          arguments: {'donor': bloodDonor});
    } else if (index == 0) {
    } else if (index == 1) {}
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
