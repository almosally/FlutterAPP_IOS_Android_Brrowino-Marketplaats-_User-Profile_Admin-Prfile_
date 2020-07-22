import 'dart:convert';

import 'package:borrowinomobileapp/models/OfferDetails.dart';
import 'package:borrowinomobileapp/models/PlaceOffer.dart';
import 'package:borrowinomobileapp/models/SearchOffer.dart';
import 'package:borrowinomobileapp/models/SearchUser.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:github_search/repo.dart';
//import 'package:date_format/date_format.dart';

import 'dart:convert' show json, utf8;
import 'dart:io';
import 'dart:async';
class CallApi {

  static final HttpClient _httpClient = HttpClient();
  //static final String _url = "api.github.com";
  static final String _url = 'http://api.borrowino.ga/';
 // final String _url = 'http://10.0.2.2:8000/';


  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    ;
    return await http.post(
        fullUrl, body: jsonEncode(data), headers: _setHeaders()
    );
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await http.get(fullUrl, headers: _setHeaders()
    );
  }

  editData(data, apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await http.post(
        fullUrl,
        body: jsonEncode(data),
        headers: _setTokenHeaders())
        .then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
    });
  }


  _setHeaders() =>
      {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }


  _getTokenPost() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return token;
  }

  _setTokenHeaders() =>
      <String, String> {
        'Content-Type': 'application/json',

        'Authorization': 'Bearer ' + _getTokenPost().toString(),
        // Authorization: Bearer
      };

  postOfferData(data,apiUrl) async {
    var fullUrl =_url + apiUrl +await _getTokenPost().toString();
    return await http.post(
        fullUrl, headers: _setTokenHeaders(), body: jsonEncode(data)
    );
  }


  static Future<List<SearchOffer>> getOffersWithSearchQuery(String query) async {
    final uri = Uri.https(_url, 'search?q=$query', {
      'q': query,
      'page': '0',
      'per_page': '25'
    });

    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null) {
      return null;
    }
    if (jsonResponse['errors'] != null) {
      return null;
    }
    if (jsonResponse['data'] == null) {
      return List();
    }

    return SearchOffer.mapJSONStringToList(jsonResponse['data']);
  }

  static Future<List<SearchUser>> getUsersWithSearchQuery(String query) async {
    final uri = Uri.https(_url, 'search?q=$query&type=users', {
      'q': query,
      'page': '0',
      'per_page': '25'
    });

    final jsonResponse = await _getJson(uri);
    if (jsonResponse == null) {
      return null;
    }
    if (jsonResponse['errors'] != null) {
      return null;
    }
    if (jsonResponse['data'] == null) {
      return List();
    }

    return SearchUser.mapJSONStringToList(jsonResponse['data']);
  }


  static Future<Map<String, dynamic>> _getJson(Uri uri) async {
    try {
      final httpRequest = await _httpClient.getUrl(uri);
      final httpResponse = await httpRequest.close();
      if (httpResponse.statusCode != HttpStatus.OK) {
        return null;
      }

      final responseBody = await httpResponse.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } on Exception catch (e) {
      print('$e');
      return null;
    }
  }
}