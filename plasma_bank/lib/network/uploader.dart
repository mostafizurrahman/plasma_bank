import 'dart:convert';
import 'dart:io';

import 'package:plasma_bank/network/api_client.dart';
import 'package:plasma_bank/network/authentication.dart';

class ImageUploader {
  final _client = ApiClient();

  uploadImage(final String base64Image) async {


    // verify required params are set

    // create path and map variables
    String path = "/".replaceAll("{format}", "json");

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {
      "Authorization": Auth.ClientID
    };
    Map<String, String> formParams = {};
     Object postBody = {"image": base64Image};
     List<String> contentTypes = ["application/json"];

    String contentType =
        contentTypes.length > 0 ? contentTypes[0] : "application/json";
    List<String> authNames = [];

    var response = await _client.invokeAPI(path, 'POST', queryParams, postBody,
        headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      return _client.deserialize(response.body, 'String') as String;
    } else {
      return null;
    }
  }

  static String getBase64(String imagePath) {
    return base64Encode(File(imagePath).readAsBytesSync());
  }
}
