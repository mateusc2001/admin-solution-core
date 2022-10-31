import 'dart:developer';

import 'package:admin_solution_core/model/proposta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class PropostaService {

  delete(id) {}
  create(id) {}

  Future<List<Proposta>> findAll(endpoint) async {
    String _url = endpoint;
    List collection;
    List<Proposta> _contacts;
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      collection = convert.jsonDecode(response.body);
      _contacts = collection.map((json) => Proposta.fromJson(json)).toList();
      return _contacts;
    } else {

      print('Request failed with status: ${response.statusCode}.');
    }
    return [];
  }

  static Future<int> findAllVisualizacoes(endpoint) async {
    String _url = endpoint;
    var response = await http.get(Uri.parse(_url));
    if (response.statusCode == 200) {
      return convert.jsonDecode(response.body).length;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return -1;
  }
}
