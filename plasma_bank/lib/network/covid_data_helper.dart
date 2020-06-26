import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
//{
//"continent": "Asia",
//"location": "Afghanistan",
//"date": "2020-06-25",
//"total_cases": 29715.0,
//"new_cases": 234.0,
//"total_deaths": 639.0,
//"new_deaths": 21.0,
//"total_cases_per_million": 763.326,
//"new_cases_per_million": 6.011,
//"total_deaths_per_million": 16.415,
//"new_deaths_per_million": 0.539,
//
//
//"population": 38928341.0,
//"population_density": 54.422,
//"median_age": 18.6,
//"aged_65_older": 2.581,
//"aged_70_older": 1.337,
//"gdp_per_capita": 1803.987,
//"cvd_death_rate": 597.029,
//"diabetes_prevalence": 9.59,
//"handwashing_facilities": 37.746,
//"hospital_beds_per_thousand": 0.5,
//"life_expectancy": 64.83
//}

class CovidData {
  final String date;
  final double totalCases;
  final double newCases;
  final double totalDeaths;
  final double newDeaths;
  CovidData({this.date, this.totalCases, this.newCases, this.totalDeaths,
      this.newDeaths});


}

class CovidCountry {
  final String continent;
  final String countryCode;
  final String countryName;
  final double population;
  final double aged65older;
  final double aged70older;
  final double gdpPerCapita;
  final double bedsPerThousand;
  final double handWashFacility;
  final double lifeExpectancy;
  final double totalDeathsPerMillion;
  final double totalCasesPerMillion;

  List<CovidData> _dateList;
  CovidCountry(
  this.countryCode,
      {this.continent,
      this.countryName,
      this.population,
      this.aged65older,
      this.aged70older,
      this.gdpPerCapita,
      this.lifeExpectancy,
      this.bedsPerThousand,
      this.handWashFacility,
      this.totalCasesPerMillion,
      this.totalDeathsPerMillion,});
}

class CovidDataHelper {
//  bool _initDownload = false;
  bool _isDownloading = false;
  bool _skipMonkey = false;
  Future<StreamedResponse> _streamedResponse;
//  double _contentLength;
  String _sourceUrl;
  String _fileName;
  Function(File) _didDownloadEnd;

//  final _sourceURL =
//      'https://covid.ourworldindata.org/data/owid-covid-data.json';

  //https://covid.ourworldindata.org/data/ecdc/total_deaths.csv
  //https://covid.ourworldindata.org/data/ecdc/new_deaths.csv
  //https://covid.ourworldindata.org/data/ecdc/total_cases.csv
  //https://covid.ourworldindata.org/data/ecdc/new_cases.csv
  CovidDataHelper();

  Future<bool> downloadRemoteFile(


      String sourceUrl, String fileName, Function(File) didCompleted) async {


    if (this._isDownloading || this._skipMonkey){
      return false;
    }
    this._skipMonkey = true;
    this._didDownloadEnd = didCompleted;
    final http.Client httpClient = http.Client();
    final httpRequest = new http.Request('GET', Uri.parse(sourceUrl));
    _streamedResponse = httpClient.send(httpRequest);
    String filePath =
        (await getApplicationDocumentsDirectory()).path + '/$fileName';
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete(recursive: true);
    }
    Future.delayed(Duration(seconds: 25), (){
      this._skipMonkey = false;
    });
    RandomAccessFile nativeFile = await file.open(mode: FileMode.write);
    _streamedResponse.asStream().listen(
        (http.StreamedResponse _streamResponse) async {

          this._isDownloading = true;
      _streamResponse.stream.listen(
        (List<int> chunk) async {
          nativeFile.writeFromSync(chunk);
        },
        onDone: () async {
          nativeFile.closeSync();
          this._isDownloading = false;
          this._didDownloadEnd(file);
        },
        onError: (_error) {
          debugPrint(_error);
          this._isDownloading = false;
          this._didDownloadEnd(null);
        },
      );
    }, onError: (_error) {
      this._isDownloading = false;
      debugPrint(_error);
      this._didDownloadEnd(null);
    });
    return true;
  }

  readCovidJSON(final File file){
    if (file != null){
      final Map<String, dynamic> jsonMap = json.decode(file.readAsStringSync());
      jsonMap.forEach((key, value) {
        debugPrint(key);
        if (value is List<Map<String, dynamic>>){
          debugPrint(value[0]['location']);
        }
      });
    }
  }
}
