import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:plasma_bank/network/api_client.dart';
import 'package:plasma_bank/network/auth.dart';
import 'package:http/http.dart' as http;

class ImgurResponse {
  String deleteHash;
  String imageUrl;
  String thumbUrl;
  ImgurResponse(
      {this.imageUrl, this.deleteHash, Map<dynamic, dynamic> jsonData}) {
    if (jsonData != null) {
      this.imageUrl = jsonData['link'];
      this.deleteHash = jsonData['deletehash'];
      setThumb();
    }
  }

  ImgurResponse.fromThumb(final String _thumb){
    this.thumbUrl = _thumb;
  }


  setThumb(){
    if (this.imageUrl != null && this.imageUrl.isNotEmpty) {
      if (this.imageUrl.endsWith('.jpg')) {
        this.thumbUrl = this.imageUrl.replaceAll('.jpg', 'm.jpg');
      } else if (this.imageUrl.endsWith('.jpeg')) {
        this.thumbUrl = this.imageUrl.replaceAll('.jpg', 'm.jpeg');
      } else {
        this.thumbUrl = imageUrl;
      }
    }
  }

  Map<String, String> toJson() {
    return {
      'deletehash': this.deleteHash ?? '',
      'link': this.imageUrl,
    };
  }
}

class ImgurHandler {
  final _client = ApiClient();

  Future<ImgurResponse> uploadImage(final String base64Image) async {
    // verify required params are set

    // create path and map variables
    String path = "/";

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {"Authorization": Auth.ClientID};
    Map<String, String> formParams = {};
    Object postBody = {"image": base64Image};

    String contentType = "application/json";
    List<String> authNames = [];

    var response = await _client.invokeAPI(path, 'POST', queryParams, postBody,
        headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      final map = json.decode(response.body)['data'];
      if (map is Map) {
        final _imgResp = ImgurResponse(
            imageUrl: map['link'], deleteHash: map['deletehash']);
        _imgResp.setThumb();
        return _imgResp;
      }
    }
    return null;
  }

  deleteImage(final String deleteHash) async {
    String path = "/$deleteHash";

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {"Authorization": Auth.ClientID};
    Map<String, String> formParams = {};
    Object postBody = {};

    String contentType = "application/json";
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

  Future<dynamic> sendCode(final Object postBody) async {
    String url = 'http://image-app.com/code.php';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = postBody.toString();
    Response response =
        await post(url, headers: headers, body: json).catchError((_error) {
      debugPrint("DERRO");
    });
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

  static Future<Map> fetchGallery() async {
    final response = await http.get('https://pastebin.com/raw/Q5pE9dK4');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return json.decode(response.body);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load gallery data!');
    }
  }
}
