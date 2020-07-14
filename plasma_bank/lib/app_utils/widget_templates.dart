import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:plasma_bank/widgets/stateless/message_widget.dart';
import 'package:rxdart/rxdart.dart';

import 'app_constants.dart';

class WidgetTemplate {
  static Widget progressIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetTemplate.indicator(),
          Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              "LOADING...",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget indicator() {
    return CircularProgressIndicator(
      strokeWidth: 1.75,
      backgroundColor: Colors.red,
      valueColor: AlwaysStoppedAnimation<Color>(
        Color.fromARGB(255, 220, 220, 200),
      ),
      semanticsLabel: "LOADING...",
    );
  }

  static message(BuildContext context, String message,
      {String dialogTitle,
      Function onTapped,
        Function onActionTap,
      String actionTitle,
      Icon titleIcon = const Icon(
        Icons.info,
        color: Colors.blueAccent,
        size: 30,
      ),
      Icon actionIcon = const Icon(
        Icons.check_circle,
        size: 25,
        color: Colors.white,
      ),
      Color headerColor = Colors.green,
      Color messageColor = Colors.black}) {
    MessageWidget _overlayWidget = MessageWidget(
      message,
      onTapped: onTapped,
      onActionTap: onActionTap,
      actionIcon: actionIcon,
      actionTitle: actionTitle,
      headerColor: headerColor,
      messageColor: messageColor,
      dialogTitle: dialogTitle,
    );
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => _overlayWidget));
  }

  static Widget getTextField(
    TextConfig _config, {
    final bool isDigit = false,
    final bool isEnabled = true,
    final bool isReadOnly = true,
    final bool showCursor = false,
    final bool isPassword = false,
    final int maxLen = 25,
    final Function onTap,
    String Function(String) validator,
    final Function(String) onChangedValue,
    final Function onEditingDone,
    final Function onIconTap,
  }) {
    if (validator == null) {
      validator = (String value) {
        return null;
      };
    }
    final _inputFormatter = isDigit || _config.isDigit
        ? [
            new LengthLimitingTextInputFormatter(maxLen),
            WhitelistingTextInputFormatter.digitsOnly
          ]
        : [
            WhitelistingTextInputFormatter(RegExp("[a-zA-Z0-9,.:@ /]")),
            new LengthLimitingTextInputFormatter(maxLen),
          ];
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: new TextField(
        autofillHints: null,
        enableSuggestions: false,

        controller: _config.controller,
        focusNode: _config.focusNode,
        expands: false,
        onTap: onTap,
        onChanged: onChangedValue,
        enabled: isEnabled,
        readOnly: isReadOnly,
        showCursor: showCursor,
        maxLength: maxLen,
        obscureText: isPassword,
        inputFormatters: _inputFormatter,
        keyboardType: isDigit ? TextInputType.number : TextInputType.text,
        autocorrect: false,
        keyboardAppearance: Brightness.light,
        decoration: InputDecoration(
            errorText: validator(_config.controller.text),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppStyle.theme(), width: 0.75),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppStyle.txtLine(), width: 0.75),
            ),
            labelText: _config.labelText.toLowerCase(),
            counterText: ""),
        textInputAction: TextInputAction.done,
        onEditingComplete: onEditingDone,
      ),
    );
  }

  static Widget gateRadio(final BehaviorSubject<int> _radioStream, final String _title,

      {IconButton button}) {
    return Row(
      children: [
        Expanded(
          child: button == null
              ? Text(
                  _title,
                  style: TextStyle(fontFamily: AppStyle.fontBold, color: Colors.grey),
                )
              : Row(
                  children: [
                    Text(
                      _title,
                      style: TextStyle(fontFamily: AppStyle.fontBold, color: Colors.grey),
                    ),
                    button,
                  ],
                ),
        ),
        Container(
//        color: Colors.yellow,
//          width: 50,
          child: StreamBuilder(
            initialData: 0,
            stream: _radioStream.stream,
            builder: (_context, _snap) {
              return Row(
                children: <Widget>[
                  SizedBox(
                    width: 30,
                    child: Text(
                      'YES',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  new Radio(
                    value: 1,
                    groupValue: _snap.data,
                    onChanged: (value) {

                      FocusScope.of(_context).requestFocus(FocusNode());
                      _radioStream.sink.add(value);
                    },
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Container(
//          color: Colors.red,
//          width: 50,
          child: StreamBuilder(
            initialData: 0,
            stream: _radioStream.stream,
            builder: (_context, _snap) {
              return Row(
                children: <Widget>[
                  SizedBox(
                    width: 25,
                    child: Text(
                      'NO',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  new Radio(
                    value: 0,
                    groupValue: _snap.data,
                    onChanged: (value) {
                      FocusScope.of(_context).requestFocus(FocusNode());
                      _radioStream.sink.add(value);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
