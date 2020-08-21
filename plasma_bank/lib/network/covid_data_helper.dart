import 'dart:convert';
import 'package:http/http.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CovidData {
  final String date;
  final double totalCases;
  final double newCases;
  final double totalDeaths;
  final double newDeaths;
  CovidData(
      {this.date,
      this.totalCases,
      this.newCases,
      this.totalDeaths,
      this.newDeaths});
}

class CovidCountry {
  String continent;
  double deathRate;
  double population;
  String countryCode;
  String countryName;
  double aged65older;
  double aged70older;
  double gdpPerCapita;
  double lifeExpectancy;
  double bedsPerThousand;
  double handWashFacility;
  double populationDensity;
  double totalCasesPerMillion;
  double totalDeathsPerMillion;

  List<CovidData> _dateList = List();
  CovidCountry(this.countryCode);

  setMap(final Map<String, dynamic> _data){


//    "location": "Afghanistan",
//    "date": "2019-12-31",
//    "total_cases": 0.0,
//    "new_cases": 0.0,
//    "total_deaths": 0.0,
//    "new_deaths": 0.0,
//    "total_cases_per_million": 0.0,
//    "new_cases_per_million": 0.0,
//    "total_deaths_per_million": 0.0,
//    "new_deaths_per_million": 0.0,
//    "population": 38928341.0,
//    "population_density": 54.422,
//    "median_age": 18.6,
//    "aged_65_older": 2.581,
//    "aged_70_older": 1.337,
//    "gdp_per_capita": 1803.987,
//    "cvd_death_rate": 597.029,
//    "diabetes_prevalence": 9.59,
//    "handwashing_facilities": 37.746,
//    "hospital_beds_per_thousand": 0.5,
//    "life_expectancy": 64.83
    this.continent = _data["continent"];
    this.countryName =  _data["location"];
    this.population = _data["population"];
    this.aged65older = _data["aged_65_older"];
    this.aged70older = _data["aged_70_older"];
    this.deathRate = _data["cvd_death_rate"];
    this.gdpPerCapita = _data["gdp_per_capita"];
    this.lifeExpectancy = _data["life_expectancy"];
    this.populationDensity = _data["population_density"];
    this.handWashFacility = _data['handwashing_facilities'];
    this.bedsPerThousand = _data["hospital_beds_per_thousand"];
    this.totalCasesPerMillion =  _data["total_cases_per_million"];
    this.totalDeathsPerMillion = _data["total_deaths_per_million"];

  }
}

class CovidDataHelper {
  List<CovidCountry> _globalList = List();

//  bool _initDownload = false;
  bool _isDownloading = false;
  bool _skipMonkey = false;
  Future<StreamedResponse> _streamedResponse;

  Function(File) _didDownloadEnd;

  CovidDataHelper();

  Future<bool> downloadRemoteFile(
      String sourceUrl, String fileName, Function(File) didCompleted) async {
    if (this._isDownloading || this._skipMonkey) {
      return false;
    }
    String _currentDate =
        DateTime.now().toString().split(" ").first ?? DateTime.now().toString();
    final _covidFileName = _currentDate + '_' + fileName;
    final _preference = await SharedPreferences.getInstance();
    final _savedFileName = _preference.getString('json_file_date') ?? 'NONE';
    final _lastFileDate = _savedFileName.split("_").first ?? "";
    final _documentDir = await getApplicationDocumentsDirectory();
    final _savedFile = File(_documentDir.path + '/$_savedFileName');
    if (_lastFileDate == _currentDate) {
      didCompleted(_savedFile);
      return true;
    }
    this._skipMonkey = true;
    this._didDownloadEnd = didCompleted;
    final http.Client httpClient = http.Client();
    final httpRequest = new http.Request('GET', Uri.parse(sourceUrl));
    _streamedResponse = httpClient.send(httpRequest);
    String filePath = _documentDir.path + '/$_covidFileName';
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete(recursive: true);
    }
    if (await _savedFile.exists()) {
      await _savedFile.delete(recursive: true);
    }
    Future.delayed(Duration(seconds: 25), () {
      this._skipMonkey = false;
    });
    RandomAccessFile nativeFile = await file.open(mode: FileMode.write);
    _streamedResponse.asStream().listen(
        (http.StreamedResponse _streamResponse) async {
      debugPrint("starting.......");
      this._isDownloading = true;
      _streamResponse.stream.listen(
        (List<int> chunk) async {
          nativeFile.writeFromSync(chunk);
          debugPrint(chunk.length.toString());
        },
        onDone: () async {
          nativeFile.closeSync();
          _preference.setString('json_file_date', _covidFileName);
          this._isDownloading = false;
          this._didDownloadEnd(file);
          _streamedResponse = null;
        },
        onError: (_error) {
          _streamedResponse = null;
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

  readCovidJSON(final File file) async {
    if (file != null) {
      try {
        this._globalList.clear();

        final Map<String, dynamic> jsonMap =
            await json.decode(file.readAsStringSync());
        final _keyArray = List.castFrom(jsonMap.keys.toList());
        for (String _key in _keyArray) {
          final List<dynamic> _dataArray = jsonMap.remove(_key);
          final _covidCountry = CovidCountry(_key);
          final Map<String, dynamic> _dataMap = _dataArray.last;
          if (_dataMap != null){
            _covidCountry.setMap(_dataMap);
          }
          for (final Map<String, dynamic> _covid in _dataArray) {
            final CovidData _covidData = CovidData(
              date: _covid['date'],
              newCases: _covid['new_cases'],
              totalCases: _covid['total_cases'],
              newDeaths: _covid['new_deaths'],
              totalDeaths: _covid['total_deaths'],
            );
            _covidCountry._dateList.add(_covidData);
          }
          this._globalList.add(_covidCountry);
        }
        debugPrint('total_countries : ' + this._globalList.length.toString());
      } catch (e) {
        print(e);
      }
    }
  }
}
