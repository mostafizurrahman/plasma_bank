import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';
import 'package:plasma_bank/network/models/plasma_donor.dart';

class ProfileInfoWidget extends StatefulWidget {
  final BloodDonor bloodDonor;
  ProfileInfoWidget(this.bloodDonor);
  @override
  State<StatefulWidget> createState() {
    return _ProfileInfoState();
  }
}

class _ProfileInfoState extends State<ProfileInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    final double _contentH  = _height - MediaQuery.of(context).padding.bottom - MediaQuery.of(context).padding.top - 300;
    String __address = this.widget.bloodDonor.address.city +
        ', ' +
        this.widget.bloodDonor.address.state +
        ', ' +
        this.widget.bloodDonor.address.country;
    return
//      Container(color: Colors.red,);


      Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: _width,
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 24, top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'logged-in as...',
                  style: TextStyle(color: Colors.grey.withAlpha(150)),
                ),
              ),
              _getBasicRow(),
              Expanded(
//                color: Colors.grey,
//                height: _contentH,
                child: Column(


                  children: <Widget>[

                    SizedBox(height: 24,),
                    _getDataRow(
                        'Last Donation : ', this.widget.bloodDonor.lastDonationDate,
                        isEditable: true),
                    _getDataRow('Blood Group : ', this.widget.bloodDonor.bloodGroup),

                    _getDataRow(
                      'Plasma Donor : ', this.widget.bloodDonor is PlasmaDonor ? 'YES' : 'NO',
                    ),
                    _getDataRow(
                      'Address : ', __address.replaceAll('District', '').replaceAll('Division', ''),
                      isAddress: true,
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

  Widget _getDataRow(final String _title, final String _value,
      {bool isEditable = false, isAddress = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: MediaQuery.of(context).size.width - 48,
        height: isAddress ? 100 : 50,
        decoration: AppStyle.lightDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            SizedBox(width: 8,),
            Container(
              height: 35,
              width: isAddress ? 75 : 115,
              child: Center(
                child: Text(
                  _title,
                  style: TextStyle(color: Colors.black.withAlpha(140)),
                ),
              ),
            ),
            Expanded(
              child: Text(
                _value,
                softWrap: true,
                style: TextStyle(
                    color: Colors.black.withAlpha(180),
                    fontWeight: FontWeight.w600),
              ),
            ),
            isEditable ? ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              child: Container(
                height: 35,
                width: 35,
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    child: InkWell(
                      onTap: () {
                        debugPrint('show edit tools');
                      },
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            )
                : SizedBox(),
            SizedBox(width: 12,),
          ],
        ),
      ),
    );
  }

  Widget _getBasicRow() {
    return Row(
      children: <Widget>[
        Container(
          width: 90,
          height: 90,
          decoration: AppStyle.circularShadow(),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(110)),
            child: Image.network(
              this.widget.bloodDonor.profilePicture.thumbUrl,
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
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(
          width: 12,
        ),
        _getBasicTitleRow(),
      ],
    );
  }

  Widget _getBasicTitleRow() {
    return Expanded(
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          children: [
            TextSpan(
              text: this.widget.bloodDonor.fullName.toUpperCase() + '\n',
              style:
                  TextStyle(fontSize: 17, color: Colors.black87, height: 1.5),
            ),
            TextSpan(
              text: 'email : ',
              style: TextStyle(
                color: AppStyle.theme(),
                fontSize: 13,
                height: 1.1,
              ),
            ),
            TextSpan(
              text: this.widget.bloodDonor.emailAddress + '\n',
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                height: 1.1,
              ),
            ),
            TextSpan(
              text: 'mobile : ',
              style: TextStyle(
                color: AppStyle.theme(),
                fontSize: 13,
                height: 1.1,
              ),
            ),
            TextSpan(
              text: this.widget.bloodDonor.mobileNumber,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
