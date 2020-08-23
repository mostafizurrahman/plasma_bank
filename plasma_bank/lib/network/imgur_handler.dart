import 'dart:convert';
import 'dart:io';

<<<<<<< HEAD
import 'package:plasma_bank/network/api_client.dart';
import 'package:plasma_bank/network/auth.dart';
class ImgurResponse{
  String deleteHash;
  String imageUrl;
  ImgurResponse({this.imageUrl,
    this.deleteHash,
    Map<dynamic, dynamic> jsonData}){
    if(jsonData == null){
      assert(this.imageUrl != null , 'url is null');
    } else {
      this.imageUrl = jsonData['link'];
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
<<<<<<< HEAD
      if (this.imageUrl != null && this.imageUrl.isNotEmpty) {
        if (this.imageUrl.endsWith('.jpg')) {
          this.thumbUrl = this.imageUrl.replaceAll('.jpg', 'm.jpg');
        } else if (this.imageUrl.endsWith('.jpeg')) {
          this.thumbUrl = this.imageUrl.replaceAll('.jpg', 'm.jpeg');
        } else {
          this.thumbUrl = imageUrl;
        }
      }
>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
=======
>>>>>>> feature/Messaging
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

<<<<<<< HEAD
  Map<String, String> toJson(){
    return {
      'deletehash' : this.deleteHash ?? '',
      'link' : this.imageUrl,
    };
  }

}
=======
  Map<String, String> toJson() {
    return {
      'deletehash': this.deleteHash ?? '',
      'link': this.imageUrl,
    };
  }
}

>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
class ImgurHandler {
  final _client = ApiClient();

  Future<ImgurResponse> uploadImage(final String base64Image) async {
<<<<<<< HEAD


=======
>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
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
>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f

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
        return ImgurResponse(
            imageUrl: map['link'],
            deleteHash: map['deletehash']);
=======
      if (map is Map) {
        final _imgResp = ImgurResponse(
            imageUrl: map['link'], deleteHash: map['deletehash']);
<<<<<<< HEAD
>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
=======
        _imgResp.setThumb();
        return _imgResp;
>>>>>>> feature/Messaging
      }
    }
    return null;
  }

<<<<<<< HEAD
  deleteImage(final String deleteHash) async{

=======
  deleteImage(final String deleteHash) async {
>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
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

>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
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

>>>>>>> 07ec83756422bca318c6c5d11e312426e7d1dc3f
  static String getBase64(String imagePath) {
    return base64Encode(File(imagePath).readAsBytesSync());
  }
}
