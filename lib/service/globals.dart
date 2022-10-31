import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' as convert;

class Globals with ChangeNotifier {

  final String tstEndpoint = 'http://tst.api.solutioncore.com.br';
  final String prodEndpoint = 'https://api.solutioncore.com.br';

  final String prodAuthService = 'http://auth.service.solutioncore.com.br';
  final String tstAuthService = 'http://tst.auth.service.solutioncore.com.br';

  bool prod = false;
  final storage = new FlutterSecureStorage();

  updateStatus(bool status) {
    prod = status;
    notifyListeners();
  }

  alterarEstado() {
    prod = !prod;
    notifyListeners();
  }

  getEndpoint() {
    return prod ? prodEndpoint : tstEndpoint;
  }

  getLoginEndpoint() {
    return prod ? '$prodAuthService/auth/login' : '$tstAuthService/auth/login';
  }

  getValidateToken() {
    return prod ? '$prodAuthService/auth/profile' : '$tstAuthService/auth/profile';
  }

  getSetReadPropostaEndpoint(propostaId, userId) {
    var  finalPath = '/proposta-id/$propostaId/user-id/$userId';
    return prod ? '$prodEndpoint$finalPath' : '$tstEndpoint$finalPath';
  }

  setToken(String? value, user) {
    storage.write(key: 'token', value: value);
    storage.write(key: 'user', value: convert.jsonEncode(user));
  }

  Future<String?> getToken() {
    return storage.read(key: 'token');
  }

  Future getUser() async {
    var user = await storage.read(key: 'user');
    return user != null ? convert.jsonDecode(user) : null;
  }
}