import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/base_widget.dart';
import 'package:plasma_bank/widgets/stateful/dynamic_keyboard.dart';
import 'package:plasma_bank/widgets/stateful/keyboard_widget.dart';
import 'package:rxdart/rxdart.dart';

abstract class BaseKeyboardState<T extends BaseWidget> extends State<T> {

  final BehaviorSubject<bool> _scrollVisibleBehavior = BehaviorSubject();
  final BehaviorSubject<TextConfig> _keyboardBehavior = BehaviorSubject();
  final BehaviorSubject<TextConfig> _errorBehavior = BehaviorSubject();
  double _heightDiscard = 0.0;
  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  ScrollController _scrollController;
  bool _keyboardState;

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    _keyboardState = _keyboardVisibility.isKeyboardVisible;
    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: onKeyboardVisibilityChanged,
    );
  }

  onKeyboardVisibilityChanged(final bool isKeyboardVisible) {
    _keyboardState = isKeyboardVisible;
    debugPrint(isKeyboardVisible.toString());
    Future.delayed(Duration(milliseconds: 100), () {
      this._heightDiscard = MediaQuery.of(context).viewInsets.bottom;
      debugPrint(this._heightDiscard.toString());
      this._scrollVisibleBehavior.sink.add(_keyboardState);
      this._animateTextField(isHide: !_keyboardState);
    });
  }

  bool get isKeyboardVisible => this._keyboardState;



  onTextFieldTapped(final TextConfig _textConfig){
    this._keyboardBehavior.sink.add(_textConfig);
  }

  _onKeyPressed(String _key) {
    if(_key.toLowerCase() == 'space'){
      _key = ' ';
    } else if(_key == 'x'){
      _key = 'del';
    }
    if (_key.toLowerCase() == 'done' || _key == 'd') {
      this._keyboardBehavior.sink.add(null);
//      if (_chatTextController.text.isEmpty) {
//        return;
//      }
//      if (!(_sendingBehavior.value ?? false)) {
//        _sendingBehavior.sink.add(true);
//        final BloodDonor _donor = super.widget.getData('donor');
//        _messageRepository.sendMessage(
//            _donor.emailAddress, this._chatTextController.text, _onDataSent);
//        this._chatTextController.text = '';
//      }
//      return;
    } else {
      final TextConfig _textConfig = this._keyboardBehavior.value;
      if(_textConfig != null) {
        if (_textConfig.controller.text.length < _textConfig.maxLen || _key == 'del') {
          WidgetProvider.addTextInController(_textConfig.controller, _key);
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    displayData.setData(context);

    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);

    final _width = MediaQuery.of(context).size.width;
    final _contentHeight = this.getContentHeight();
    return Container(
      color: AppStyle.greyBackground(),
      child: Padding(
        padding: EdgeInsets.only(bottom: displayData.bottom),
        child: Scaffold(
            appBar: WidgetProvider.appBar(
              this.getAppBarTitle(),
              actions: this.getLeftActionItems(),
            ),
            body:
            Container(

              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: this.getSingleChildContent(),
                ),
              ),
            ),


//            StreamBuilder<bool>(
//              stream: _scrollVisibleBehavior.stream,
//              initialData: false,
//              builder: (_context, _snap) {
//                return Container(
//                  width: _width,
//
//                  height: _contentHeight - (_snap.data ? _heightDiscard : 0),
//                  child: SingleChildScrollView(
//                    controller: _scrollController,
//                    child:Padding(
//                      padding: const EdgeInsets.only(left: 24, right: 24),
//                      child: this.getSingleChildContent(),
//                    ) ,
//                  ),
//                );
//              },
//            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: StreamBuilder<TextConfig>(
              stream: this._errorBehavior.stream,
              builder: (_context, _snap) {
                if (_snap.data != null) {
                  return WidgetProvider.errorButton(
                    onError,
                    'enter \'' + _snap.data.labelText + '\'',
                    context,
                  );
                }
                return WidgetProvider.button(
                  onSubmitData,
                  getActionTitle(),
                  context,
                );
              },
            ),
          bottomNavigationBar: StreamBuilder<TextConfig>(
            stream: this._keyboardBehavior.stream,
            builder: (_context, _snaps){
              if(_snaps == null || _snaps.data == null){
                return SizedBox();
              }
              if(_snaps.data.isDigit){
                return KeyboardWidget(this._onKeyPressed);
              }
              return DynamicKeyboardWidget(
                _onKeyPressed,
                doneButtonIcon: Icons.check_circle,
                onDeleteLongPressed: _onDeleteEverything,
              );
            },
          ),
        ),
      ),
    );
  }

  _onDeleteEverything(){
    final TextConfig _textConfig = this._keyboardBehavior.value;
    if(_textConfig != null){
      _textConfig.controller.text = '';
    }
  }


  onSubmitData() async {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  }

  setError(final TextConfig _errorController) {
    this._errorBehavior.sink.add(_errorController);
  }

  onError() {
    final _errorTextController = this._errorBehavior.value;
    if (_errorTextController != null ) {
      if(_errorTextController.controller.text.isEmpty){
        FocusScope.of(context).requestFocus(_errorTextController.focusNode);
      } else {
        this._errorBehavior.sink.add(null);
        this.onSubmitData();
      }
    }
  }

  double getContentHeight(){
    final _paddingBottom = MediaQuery.of(context).padding.bottom;
    final _paddingTop = MediaQuery.of(context).padding.top;
    final _appBarHeight = 54;
    final _height = MediaQuery.of(context).size.height;
    final _contentHeight =
        _height - _paddingBottom - _paddingTop - _appBarHeight;
    return _contentHeight;
  }

  Widget getSingleChildContent() {
    return Container(
      height: 1120,
      color: Colors.blueGrey,
    );
  }

  List<Widget> getLeftActionItems() {
    return [];
  }

  String getAppBarTitle() {
    return 'NO TITLE';
  }

  String getActionTitle() {
    return "NEXT";
  }

  @override
  void dispose() {
    super.dispose();
    _keyboardBehavior.close();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
    if (!this._scrollVisibleBehavior.isClosed) {
      _scrollVisibleBehavior.close();
    }
    if (!_errorBehavior.isClosed) {
      _errorBehavior.close();
    }
  }

  _animateTextField({isHide = false}) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    if (isHide) {
      FocusScope.of(context).requestFocus(FocusNode());
      Future.delayed(
        Duration(seconds: 1), () {
          if(!this._scrollVisibleBehavior.isClosed){
            this._scrollVisibleBehavior.sink.add(false);
            _scrollController.animateTo(0.0,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          }
        },
      );
    } else {
      if(!this._scrollVisibleBehavior.isClosed){
        if (this._scrollController.offset == 0.0) {
          Future.delayed(Duration(seconds: 1), () {
            _scrollController.animateTo(this._heightDiscard > 100 ? this._heightDiscard / 2 : this._heightDiscard,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          });
        }
      }
    }
  }
}
