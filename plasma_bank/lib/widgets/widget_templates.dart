import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/widgets/stateless/message_widget.dart';

class WidgetTemplates {
  static Widget progressIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WidgetTemplates.indicator(),
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
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      semanticsLabel: "LOADING...",
    );
  }

  static message(BuildContext context, String message,

      {String dialogTitle,
      Function onTapped,
      String actionTitle,
      Icon titleIcon = const Icon(Icons.info, color: Colors.blueAccent, size: 30,),
      Icon actionIcon = const Icon(Icons.check_circle, size: 25, color: Colors.white,),
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
}
