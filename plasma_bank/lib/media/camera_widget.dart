import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';

import 'package:plasma_bank/app_utils/widget_templates.dart';
import 'package:plasma_bank/widgets/base/base_widget.dart';
import 'package:rxdart/rxdart.dart';

class CameraWidget extends BaseWidget {
  CameraWidget(Map arguments) : super(arguments);

  @override
  State<StatefulWidget> createState() {
    final _frontCamera = super.getData('is_front_camera');
    final _onCaptured = super.getData('on_captured_function');
    final _routeName = super.getData('route_name');
    return _CameraState(_onCaptured, _frontCamera, _routeName);
  }
}

class _CameraState extends State<CameraWidget> with WidgetsBindingObserver {
  final Function(String) _onImageCaptured;
  final bool _isFrontCamera;
  bool _isCameraDenied = false;
  final String _routeName;
  _CameraState(this._onImageCaptured, this._isFrontCamera, this._routeName);
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
      if (description.lensDirection == CameraLensDirection.front &&
          this._isFrontCamera) {
        this._onCameraSelected(description);
        break;
      } else if (description.lensDirection == CameraLensDirection.back &&
          !this._isFrontCamera) {
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
    if (this._onImageCaptured != null) {
      this._onImageCaptured(this._imagePath);
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
          body: Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
//                  decoration: new BoxDecoration(
//                    color: Colors.grey.withAlpha(170),
//                    borderRadius:
//                        new BorderRadius.all(Radius.circular(keyWidth / 2.0)),
//                    boxShadow: [
//                      BoxShadow(
//                        color: Color.fromRGBO(0, 0, 0, 0.15),
//                        offset: Offset(0, 0),
//                        blurRadius: 12,
//                        spreadRadius: 8,
//                      ),
//                    ],
//                  ),
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
                              color: AppStyle.theme(),
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
              ),
              Positioned(
                bottom: 12,
                left: (displayData.width) / 2 - 30,
                child: Center(
                  child: StreamBuilder(
                    stream: this._captureBehavior.stream,
                    initialData: false,
                    builder: (_context, _snap) {
                      return Container(
                        decoration: new BoxDecoration(
                          color: _snap.data
                              ? AppStyle.theme()
                              : Colors.white.withAlpha(200),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30)),
                        ),
                        height: 60,
                        width: 60,
                        child: ClipRRect(
                          borderRadius:
                              new BorderRadius.all(Radius.circular(30)),
                          child: new Material(
                            child: new InkWell(
                              onTapCancel: () {
                                this._captureBehavior.sink.add(false);
                              },
                              onTapDown: (_details) {
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
                                        ? Colors.white
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
            ],
          ),
        ),
      ),
    );
  }

  _onCaptured(final String imagePath) {
    this._imagePath = imagePath;
  }

  _captureImage() async {
    if (this._isCameraDenied) {
      AppSettings.openAppSettings();
    } else {
      this._captureBehavior.sink.add(true);
      final _capturedPath = await this._getCaptureImagePath();
      if (_capturedPath != null) {
        final args = {
          "type": ImageType.profile,
          "image": _capturedPath,
          'on_uploaded': _onCaptured,
          'route_name': this._routeName,
        };
        Navigator.pushNamed(context, AppRoutes.pageRouteImage, arguments: args);

        this._captureBehavior.sink.add(false);
      } else {
        WidgetTemplate.message(context,
            "Fail to capture image! Facing some technical difficulties. Please! Try again later",
            dialogTitle: "Capture Fail!");
      }
    }
  }

  Future<String> _getCaptureImagePath() async {
    if (!this._cameraController.value.isInitialized) {
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/picture/plasma';
    await Directory(dirPath).create(recursive: true);
    final String pathname =
        this.widget.getData('image_named') ?? DateTime.now().toString();
    final String filePath = '$dirPath/${pathname}.jpg';

    if (await File(filePath).exists()) {
      await File(filePath).delete(recursive: true);
      debugPrint("deleted");
    }

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
    Widget _widget;
    this._isCameraDenied = false;
    double _ratio = 1.0;
    final _width = displayData.width;
    try {
      _widget = CameraPreview(this._cameraController);
      _ratio = this._cameraController.value.aspectRatio;
    } catch (_exception) {
      this._isCameraDenied = true;
      _widget = Material(
        child: Ink(
          child: InkWell(
            onTap: () async {
              var _status = await Permission.camera.status;
              if(_status.isGranted || _status.isUndetermined){
                this._openCamera();
              } else {
                AppSettings.openAppSettings();
              }
            },
            child: Container(
              color: Colors.transparent,
              width: _width,
              height: 60,
              child: Center(
                child: Text('open app settings'),
              ),
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: _ratio,
      child: _widget,
    );
  }

  Widget _getLoader() {
    return WidgetTemplate.progressIndicator();
  }
}
