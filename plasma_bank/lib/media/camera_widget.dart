import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/widgets/widget_templates.dart';
import 'package:rxdart/rxdart.dart';

class CameraWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CameraState();
  }
}

class _CameraState extends State<CameraWidget> with WidgetsBindingObserver {
  String _imagePath;
  CameraController _cameraController;

  BehaviorSubject<bool> _cameraBehavior = BehaviorSubject<bool>();
  BehaviorSubject<bool> _captureBehavior = BehaviorSubject<bool>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _openCamera();
  }

  _openCamera() async {
    Future.delayed(Duration(microseconds: 1000), _selectCamera);
  }

  _selectCamera() async {
    final cameras = await availableCameras();
    for (CameraDescription description in cameras) {
      if (description.lensDirection == CameraLensDirection.back) {
        this._onCameraSelected(description);
        break;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    if (_cameraBehavior != null) {
      _cameraBehavior.close();
    }

    if (_captureBehavior != null) {
      this._captureBehavior.close();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState _state) {
    if (this._cameraController == null ||
        !this._cameraController.value.isInitialized) return;
    if (_state == AppLifecycleState.inactive) {
      this._cameraController.dispose();
    } else if (_state == AppLifecycleState.resumed &&
        this._cameraController != null) {
      _onCameraSelected(this._cameraController.description);
    }
    super.didChangeAppLifecycleState(_state);
  }

  @override
  Widget build(BuildContext context) {
    final keyWidth = 40.0;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  decoration: new BoxDecoration(
                      color: Colors.grey.withAlpha(170),
                      borderRadius:
                          new BorderRadius.all(Radius.circular(keyWidth / 2.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          offset: Offset(0, 0),
                          blurRadius: 12,
                          spreadRadius: 8,
                        ),
                      ]),
                  child: StreamBuilder(
                    stream: this._cameraBehavior.stream,
                    initialData: false,
                    builder: (_buildContext, _snapData) {
                      return Container(
                        child: _snapData.data
                            ? this._getCameraPreviewWidget()
                            : this._getLoader(),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: ClipRRect(
                    child: new Container(
                      decoration: new BoxDecoration(
                        color: Colors.white.withAlpha(150),
                        borderRadius: new BorderRadius.all(
                            Radius.circular(keyWidth / 2.0)),
                      ),
                      width: keyWidth,
                      height: keyWidth,
                      child: new Material(
                        child: new InkWell(
                          onTap: _onCameraExit,
                          child: new Center(
                            child: Container(
                              height: keyWidth,
                              width: keyWidth,
                              child: Icon(
                                Icons.cancel,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                    borderRadius:
                        BorderRadius.all(Radius.circular(keyWidth / 2.0)),
                  ),
                )
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(24),
            child: Container(
              decoration: new BoxDecoration(
                color: Colors.grey,
                borderRadius: new BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(40, 100, 20, 80),
                    offset: Offset(0, 0),
                    blurRadius: 8,
                    spreadRadius: 4,
                  ),
                ],
              ),
              height: 100,
              child: Center(
                child: StreamBuilder(
                  stream: this._captureBehavior.stream,
                  initialData: false,
                  builder: (_context, _snap) {
                    return Container(
                      decoration: new BoxDecoration(
                        color: _snap.data
                            ? Colors.cyan.withAlpha(150)
                            : Colors.white.withAlpha(200),
                        borderRadius: new BorderRadius.all(Radius.circular(30)),
                      ),
                      height: 60,
                      width: 60,
                      child: ClipRRect(
                        borderRadius: new BorderRadius.all(Radius.circular(30)),
                        child: new Material(
                          child: new InkWell(
                            onTapCancel: (){
                              this._captureBehavior.sink.add(false);
                            },
                            onTapDown: (_details){
                              this._captureBehavior.sink.add(true);
                            },
                            onTap: _captureImage,
                            child: new Center(
                              child: Container(
                                height: keyWidth,
                                width: keyWidth,
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: _snap.data
                                      ? AppStyle.colorHighlight
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          color: Colors.transparent,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _captureImage() async {
    this._captureBehavior.sink.add(true);
    final _capturedPath = await this._getCaptureImagePath();
    if (_capturedPath != null) {
      Navigator.pushNamed(context, AppRoutes.pageRouteImage,
          arguments: _capturedPath);
    } else {}
  }

  Future<String> _getCaptureImagePath() async {
    if (!this._cameraController.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/picture/plasma';
    await Directory(dirPath).create(recursive: true);
    final String filePath =
        '$dirPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (this._cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await this._cameraController.takePicture(filePath);
    } on CameraException catch (e) {
      return null;
    }
    return filePath;
  }

  _onCameraExit() {
    Navigator.pop(context);
  }

  _onCameraSelected(final CameraDescription _cameraDescription) async {
    if (this._cameraController != null) {
      await this._cameraController.dispose();
    }
    this._cameraController = CameraController(
      _cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    // If the controller is updated then update the UI.
    this._cameraController.addListener(() {
      if (mounted) {
        this._cameraBehavior.sink.add(true);
      }
      if (this._cameraController.value.hasError) {
        debugPrint(
            'Camera error ${this._cameraController.value.errorDescription}');
      }
    });

    try {
      await this._cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint("Camera Error ${e.description}");
    }

    if (mounted) {
      this._cameraBehavior.sink.add(true);
    }
  }

  Widget _getCameraPreviewWidget() {
//    if (this._cameraController == null || !this._cameraController.value.isInitialized){
//      this._cameraBehavior.sink.add(false);
//    }
    final _ratio = this._cameraController.value.aspectRatio;
    final _width = MediaQuery.of(context).size.width - 48;
    return ClipRRect(
      borderRadius: new BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: _width,
        height: ((_width / _ratio) - 48.0 / _ratio),
        child: CameraPreview(this._cameraController),
      ),
    );
  }

  Widget _getLoader() {
    return WidgetTemplates.progressIndicator();
  }
}
