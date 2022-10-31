import 'package:admin_solution_core/model/user.dart';

class Proposta {
  String? id;
  String? nomeCompleto;
  String? email;
  String? telefone;
  String? tipoDeServico;
  String? tipoDeSistema;
  String? descricao;
  List<User>? usuariosLidos;

  Proposta(
      {this.id,
      this.nomeCompleto,
      this.email,
      this.telefone,
      this.tipoDeServico,
      this.tipoDeSistema,
      this.descricao,
      this.usuariosLidos});

  Proposta.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomeCompleto = json['nomeCompleto'];
    email = json['email'];
    telefone = json['telefone'];
    tipoDeServico = json['tipoDeServico'];
    tipoDeSistema = json['tipoDeSistema'];
    descricao = json['descricao'];
    if (json['usuariosLidos'] != null) {
      usuariosLidos = <User>[];
      json['usuariosLidos'].forEach((v) {
        usuariosLidos?.add(new User.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['nomeCompleto'] = this.nomeCompleto;
    data['email'] = this.email;
    data['telefone'] = this.telefone;
    data['tipoDeServico'] = this.tipoDeServico;
    data['tipoDeSistema'] = this.tipoDeSistema;
    data['descricao'] = this.descricao;
    return data;
  }
}
