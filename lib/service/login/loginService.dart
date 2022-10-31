import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LoginService {

  Future<String> login(endpoint, request) async {
    String _url = endpoint;
    log(_url);
    var response = await http.post(Uri.parse(_url), body: request);
    if (response.statusCode < 300) {
      return convert.jsonDecode(response.body)['access_token'] ?? 'deu ruim';
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return '';
  }

  Future validateToken(endpoint, token) async {
    String _url = endpoint;
    var response = await http.get(Uri.parse(_url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode < 300) {
      var jsonResponse = convert.jsonDecode(response.body);
      var responses = {
        "id": jsonResponse['id'],
        "firstName": jsonResponse['firstName'],
        "lastName": jsonResponse['lastName'],
        "username": jsonResponse['username'],
        "createdAt": jsonResponse['createdAt'],
        "updatedAt": jsonResponse['updatedAt']
      };
      return responses;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }

  Future setReadProposta(endpoint) async {
    String _url = endpoint;
    log(_url);
    var response = await http.put(Uri.parse(_url));
    if (response.statusCode < 300) {
      return true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return false;
    }
  }
}