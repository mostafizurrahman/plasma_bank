import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';

class IntegerItem extends StatelessWidget {
  final List<int> _data;
  final int _selectedItem;
  final String unitName;
  final bool isCircle;
  final double dimension;
  final Function(int) _onSelectedItem;

  IntegerItem(this._data, this._selectedItem, this._onSelectedItem,
      {this.unitName = '', this.isCircle = true, this.dimension = 50});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
//        color: Colors.yellow,
        height: dimension,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: this._getItemList(),
        ),
      ),
    );
  }

  List<Widget> _getItemList() {
    List<Widget> _widgets = List();
    for (final _item in this._data) {
      final _isSelected = _selectedItem == _item;

      Widget _itemWidget = Container(
        decoration: AppStyle.circularShadow(),
        child: Container(
//          color: Colors.blueAccent,
          height: dimension,
          width: dimension,
          decoration: _isSelected
              ? AppStyle.highlightShadow()
              : AppStyle.lightShadow(),
          child: ClipRRect(
            child: Container(
              child: new Material(
                child: new InkWell(
                  onTap: () => this._onSelectedItem(_item),
                  child: new Center(
                    child: Container(
                      child:
                      Stack(
                        children: [
                          Center(
                            child: Text(
                              _item.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppStyle.fontBold,
                                color: _isSelected
                                    ? AppStyle.theme()
                                    : Colors.black54,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 3,
                            left: 0,
                            right: 0,
                            child: Text(

                              this.unitName,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          )

                        ],
                      )
//                      Column(
//                        mainAxisAlignment: MainAxisAlignment.center,
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: [

//                          unitName == '' ? SizedBox() : Text(this.unitName),
//                        ],
//                      )
                      ,
                    ),
                  ),
                ),
                color: Colors.transparent,
              ),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(this.isCircle ? 200 : 100),
            ),
          ),
        ),
      );
      _widgets.add(_itemWidget);
    }
    return _widgets;
  }
}
