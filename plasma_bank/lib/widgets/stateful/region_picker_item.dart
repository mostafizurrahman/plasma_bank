import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plasma_bank/app_utils/app_constants.dart';
import 'package:plasma_bank/app_utils/location_provider.dart';
import 'package:plasma_bank/app_utils/widget_providers.dart';
import 'package:rxdart/rxdart.dart';



class RegionWidget extends StatelessWidget {
  final double _height = 75;
  final Region regionData;
  final bool isSelected;
  final Function(dynamic) onSelected;
  RegionWidget(this.regionData, this.onSelected, this.isSelected);



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
      child: Container(
        height: _height,
        decoration: AppStyle.getLightBox(),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: Material(
            child: Ink(
              child: InkWell(
                onTap: (){
                  if(this.onSelected != null){
                    this.onSelected(this.regionData);
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 8,),
                    Container(
                      child: Center(
                        child: WidgetProvider.circledIcon(
                          Icon(
                            Icons.place,
                            color: Colors.black54,
                            size: 25,
                          ),
                        ),
                      ),
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        border: Border.all(
                          width: 0.85,
                          color: Colors.grey,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Text(this.regionData.regionName),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          this.isSelected ? Icon(Icons.check_circle, color: AppStyle.theme(),)
                              : SizedBox(),
                          SizedBox(width: 8,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
