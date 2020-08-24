



import 'package:flutter/cupertino.dart';

class BaseChatWidget extends StatefulWidget{
  final Map arguments;

  const BaseChatWidget(this.arguments, {Key key }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  BaseChatState();
  }

  getData(String _key) {
    return arguments[_key.toString()];
  }
}


class BaseChatState<T extends BaseChatWidget> extends State<T> {
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}