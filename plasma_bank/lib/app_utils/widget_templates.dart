import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:plasma_bank/widgets/stateless/message_widget.dart';

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

  static Widget getTextField(TextConfig _config, {
    final bool isDigit = false,
    final bool isEnabled = true,
    final bool isReadOnly = true,
    final bool showCursor = false,
    final bool isPassword = false,
    final int maxLen = 25,
    final Function onTap,
    final Function(String) onChangedValue,
    final Function onEditingDone,
    final Function onIconTap,
  }) {
    final _inputFormatter = isDigit
        ? [WhitelistingTextInputFormatter.digitsOnly]
        : [
            new WhitelistingTextInputFormatter(RegExp("[a-zA-Z. 0-9]#-_,?@:")),
            new LengthLimitingTextInputFormatter(maxLen),
          ];
    return Padding(
      padding: EdgeInsets.only(top: 8, bottom: 8),
      child: new TextField(
        controller: _config.controller,
        focusNode: _config.focusNode,
        onTap: onTap,
        onChanged: onChangedValue,
        enabled: isEnabled,
        readOnly: isReadOnly,
        showCursor: showCursor,
        maxLength: maxLen,
        style: TextStyle(height: 0.60),
        obscureText: isPassword,
        inputFormatters: _inputFormatter,
        keyboardType: isDigit ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(

          contentPadding: EdgeInsets.all(6),
//            suffix: onIconTap != null ? ClipRRect(
//              borderRadius: BorderRadius.all(Radius.circular(100)),
//              child: Container(
//                decoration: AppStyle.shadowDecoration,
//                child: Material(
//                  child: Ink(
//                    child: InkWell(
//                      onTap: onIconTap,
//                      child: WidgetProvider.circledIcon(
//                        Icon(
//                          Icons.list,
//                          color: AppStyle.theme(),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ) : null,
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
}
