

class ZipData {

  String code;
  String place;
  String region;
  String country;
  String postalCode;

  ZipData.fromJson(Map<dynamic, dynamic> _jsonData){
    code = _jsonData['country abbreviation'].toString();
    final _place = _jsonData['places'];
    if(_place != null && _place is List){
      this.place = _place.first['place name'];
    }
  }
}