import 'dart:convert';
import 'dart:io';

import 'package:plasma_bank/network/api_client.dart';
import 'package:plasma_bank/network/auth.dart';
class ImgurResponse{
  String deleteHash;
  String imageUrl;
  String thumbUrl;
  ImgurResponse({this.imageUrl,
    this.deleteHash,
    Map<dynamic, dynamic> jsonData}){
    if(jsonData == null){
      assert(this.imageUrl != null , 'url is null');
    } else {
      this.imageUrl = jsonData['link'];
      if(this.imageUrl != null && this.imageUrl.isNotEmpty){
        if(this.imageUrl.endsWith('.jpg')){
          this.thumbUrl = this.imageUrl.replaceAll('.jpg', 'm.jpg');
        } else if (this.imageUrl.endsWith('.jpeg')){
          this.thumbUrl = this.imageUrl.replaceAll('.jpg', 'm.jpeg');
        } else {
          this.thumbUrl = imageUrl;
        }

      }
      this.deleteHash = jsonData['deletehash'];
    }
  }

  Map<String, String> toJson(){
    return {
      'deletehash' : this.deleteHash ?? '',
      'link' : this.imageUrl,
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
    Map<String, String> headerParams = {
      "Authorization": Auth.ClientID
    };
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
      if(map is Map) {
        return ImgurResponse(
            imageUrl: map['link'],
            deleteHash: map['deletehash']);
      }
    }
    return null;
  }

  deleteImage(final String deleteHash) async{

    String path = "/$deleteHash";

    // query params
    List<QueryParam> queryParams = [];
    Map<String, String> headerParams = {
      "Authorization": Auth.ClientID
    };
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

  static String getBase64(String imagePath) {
    return base64Encode(File(imagePath).readAsBytesSync());
  }
}
