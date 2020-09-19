import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:plasma_bank/network/imgur_handler.dart';
import 'package:plasma_bank/network/message_repository.dart';
import 'package:plasma_bank/network/models/blood_donor.dart';

import 'package:plasma_bank/widgets/stateless/message_widget.dart';
import 'package:rxdart/rxdart.dart';

import 'app_constants.dart';
import 'widget_providers.dart';

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
      backgroundColor: AppStyle.theme(),
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.cyan,
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

  static Widget getMessageWidget(final MessageData _data) {
    final _date =
    DateFormat.yMMMEd().add_jms().format(DateTime.parse(_data.dateTime));
    double left = 0;
    double right = 0;
    String _title = _date.toString();
    var _alignment = CrossAxisAlignment.start;
    Color _color = Colors.black;
    if (_data.isOutGoing) {
      right = 32;
    } else {
      _color = Colors.blueGrey;
      left = 32;
      _alignment = CrossAxisAlignment.end;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 20, left: 12, right: 12),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: left,
          ),
          Expanded(
            child: Container(
              child: Column(
                crossAxisAlignment: _alignment,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                    child: Text(
                      _title,
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(_data.message,
                        style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: _color,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              ),
              decoration: AppStyle.lightDecoration,
            ),
          ),
          SizedBox(
            width: right,
          ),
        ],
      ),
    );
  }

  static Widget getProfilePicture(final BloodDonor _donor, {double proHeight =  50}){
//    return WidgetTemplate.getImageWidget(_donor.profilePicture);
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(100)),
      child: _donor.profilePicture != null
          ? Container(
        color: Colors.grey,
        height: proHeight,
        width: proHeight,
        child: WidgetTemplate.getImageWidget(_donor.profilePicture),
      )
          : Center(
        child: Text(
          _donor.fullName.substring(0, 1).toUpperCase(),
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppStyle.theme()),
        ),
      ),
    );
  }


  static Widget getImageWidget(final ImgurResponse _response){
    return Image.network(
      _response.thumbUrl,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context,
          Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 1.75,
            backgroundColor: Colors.red,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.cyan,
            ),
            value: loadingProgress.expectedTotalBytes !=
                null
                ? loadingProgress
                .cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }

  static Widget getSectionTitle(final String _title, final IconData _icon) {
    return Padding(
      padding: EdgeInsets.only(top: 48, bottom: 12),
      child: Row(
        children: [
          WidgetProvider.circledIcon(
            Icon(
              _icon,
              color: AppStyle.theme(),
            ),
          ),
          SizedBox(
            width: 12,
          ),
          Text(
            _title,
            style: TextStyle(
              fontSize: 24,
              fontFamily: AppStyle.fontBold,
            ),
          ),
        ],
      ),
    );
  }
}



