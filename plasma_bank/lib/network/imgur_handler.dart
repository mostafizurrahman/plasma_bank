import 'dart:convert';
import 'dart:io';

<<<<<<< HEAD
import 'package:plasma_bank/network/api_client.dart';
import 'package:plasma_bank/network/auth.dart';
class ImgurResponse{
  final String deleteHash;
  final String imageUrl;
  ImgurResponse(this.imageUrl, this.deleteHash);
  Map<String, String> toJson(){
    return {
      'deletehash' : this.deleteHash ?? '',
      'link' : this.imageUrl,
    };
  }

}
=======
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

>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
class ImgurHandler {
  final _client = ApiClient();

  Future<ImgurResponse> uploadImage(final String base64Image) async {
<<<<<<< HEAD


=======
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    // verify required params are set

    // create path and map variables
    String path = "/";

    // query params
    List<QueryParam> queryParams = [];
<<<<<<< HEAD
    Map<String, String> headerParams = {
      "Authorization": Auth.ClientID
    };
    Map<String, String> formParams = {};
     Object postBody = {"image": base64Image};

=======
    Map<String, String> headerParams = {"Authorization": Auth.ClientID};
    Map<String, String> formParams = {};
    Object postBody = {"image": base64Image};
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35

    String contentType = "application/json";
    List<String> authNames = [];

    var response = await _client.invokeAPI(path, 'POST', queryParams, postBody,
        headerParams, formParams, contentType, authNames);

    if (response.statusCode >= 400) {
      throw new ApiException(response.statusCode, response.body);
    } else if (response.body != null) {
      final map = json.decode(response.body)['data'];
<<<<<<< HEAD
      if(map is Map) {
        return ImgurResponse(map['link'], map['deletehash']);
=======
      if (map is Map) {
        final _imgResp = ImgurResponse(
            imageUrl: map['link'], deleteHash: map['deletehash']);
        _imgResp.setThumb();
        return _imgResp;
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
      }
    }
    return null;
  }

<<<<<<< HEAD
  deleteImage(final String deleteHash) async{

=======
  deleteImage(final String deleteHash) async {
>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
    String path = "/$deleteHash";

    // query params
    List<QueryParam> queryParams = [];
<<<<<<< HEAD
    Map<String, String> headerParams = {
      "Authorization": Auth.ClientID
    };
    Map<String, String> formParams = {};
    Object postBody = {};


=======
    Map<String, String> headerParams = {"Authorization": Auth.ClientID};
    Map<String, String> formParams = {};
    Object postBody = {};

>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
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

<<<<<<< HEAD
=======
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

>>>>>>> 91d5bde7e182f349837b51c29c061962546dca35
  static String getBase64(String imagePath) {
    return base64Encode(File(imagePath).readAsBytesSync());
  }
}
