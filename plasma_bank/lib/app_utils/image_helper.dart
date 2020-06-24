import 'package:flutter/material.dart';

class ImageHelper {
  static AssetImage getImageAsset(String name) {
    return AssetImage('lib/assets/$name');
  }

  static Widget getImageWidget(String fileName){
    return Image(
      image: ImageHelper.getImageAsset(fileName),
    );

  }
}
