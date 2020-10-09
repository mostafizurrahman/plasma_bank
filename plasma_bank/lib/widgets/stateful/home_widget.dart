import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../app_utils/app_constants.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/app_constants.dart';
import '../../app_utils/widget_providers.dart';
import '../../app_utils/widget_providers.dart';
import '../../app_utils/widget_templates.dart';
import '../../app_utils/widget_templates.dart';
import '../../network/imgur_handler.dart';

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<HomeWidget> {
  final BehaviorSubject<List> _galleryBehavior = BehaviorSubject();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_galleryBehavior != null && !_galleryBehavior.isClosed) {
      _galleryBehavior.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _fetchGallery();
    return Container(
      width: displayData.width,
      height: displayData.height - displayData.navHeight,
      color: Colors.grey.withAlpha(25),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'YOUR INSPIRING STORIES',
                          style: TextStyle(
                            fontSize: 18,
//                            fontFamily: AppStyle.fontBold,
                            color: AppStyle.theme(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: WidgetProvider.getMaterialButton(
                        _onDonorAdd,
                        Icons.add_circle,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List>(
                  stream: _galleryBehavior,
                  builder: (_context, _snapshot) {
                    if (_snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          width: 200,
                          height: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              WidgetTemplate.indicator(),
                              SizedBox(
                                height: 12,
                              ),
                              Text('FETCHING STORIES...'),
                            ],
                          ),
                        ),
                      );
                    }
                    if (_snapshot.hasData && _snapshot.data.isNotEmpty) {
                      final dataList = _snapshot.data;
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: dataList.length + 1,
                        itemBuilder: (_context, _index) {
                          if (_index == dataList.length) {
                            return Container(
                              color: Colors.red,
                              height: 90,
                            );
                          }
                          final _data = dataList[_index];
                          return _getStoryWidget(_data);

//                            this.getCountryItem(_data);
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          "NO STORIES\nINTERNET ERROR! :)",
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getStoryWidget(final Map _inputData) {
    final imagePaths = _inputData['url'].toString().split("_._");
    final String _descriptions = _inputData['desc'].toString();
    final String _title = _inputData['title'].toString();
    return Container(
      width: displayData.width - 48,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          imagePaths.length == 1
              ? WidgetTemplate.getImageWidget(imagePath: imagePaths.first)
              : Row(
                  children: <Widget>[
                    Container(
                      child: WidgetTemplate.getImageWidget(
                          imagePath: imagePaths.first),
                      width: displayData.width / 2 - 4,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      child: WidgetTemplate.getImageWidget(
                          imagePath: imagePaths.last),
                      width: displayData.width / 2 - 4,
                    ),
                  ],
                ),
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 16, ),
            child: Text(
                _title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: Text(
                _descriptions,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,

              ),
            ),
          ),
        ],
      ),
    );
  }

  _onDonorAdd() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2), _fetchGallery);
  }

  _fetchGallery() async {
    final _galleryMap =
    await ImgurHandler.fetchGallery().catchError(_onGalleryError);
    if(this._galleryBehavior != null && mounted
        && !this._galleryBehavior.isClosed) {
      if (_galleryMap != null) {
        final List _listData = _galleryMap['list'];
        this._galleryBehavior.sink.add(_listData);
      } else {
        this._galleryBehavior.sink.add([]);
      }
    }
  }

  _onGalleryError(final _error) {
    this._galleryBehavior.sink.add([]);
  }
}
