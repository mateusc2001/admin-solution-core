import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_solution_core/model/proposta.dart';
import 'package:admin_solution_core/screen/GradientCircle.dart';
import 'package:admin_solution_core/service/globals.dart';
import 'package:admin_solution_core/service/login/loginService.dart';

class DetalheProposta extends StatefulWidget {
  Proposta proposta;

  DetalheProposta({required this.proposta});

  @override
  State<DetalheProposta> createState() => _DetalhePropostaState();
}

class _DetalhePropostaState extends State<DetalheProposta> {

  LoginService loginService = LoginService();
  late Globals globals;

  @override
  void initState() {
    super.initState();
  }

  _initState() async {
    var proposta = widget.proposta;
    var actualUser = await globals.getUser();
    if (proposta.usuariosLidos?.every((element) => element.id != actualUser?['id']) ?? false) {
      await loginService.setReadProposta(globals.getSetReadPropostaEndpoint(proposta.id, actualUser['id']));
    } else {
      log('não salvou');
    }
  }

  @override
  Widget build(BuildContext context) {
    globals = Provider.of<Globals>(context);
    _initState();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Solution Core",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 50),
            GradientCircle(childWidget: Text(widget.proposta.nomeCompleto?[0] ?? '-', style: TextStyle(fontSize: 50),), height: 100, width: 100,),
            SizedBox(height: 50),
            getRow('Nome completo', widget.proposta.nomeCompleto),
            Divider(),
            getRow('E-mail', widget.proposta.email),
            Divider(),
            getRow('Celular', widget.proposta.telefone),
            Divider(),
            getRow('Tipo de sistema', widget.proposta.tipoDeSistema),
            Divider(),
            getRow('Tipo de serviço', widget.proposta.tipoDeServico),
            Divider(),
            getRow('Descrição', widget.proposta.descricao),
          ],
        ),
      ),
    );
  }

  getRow(title, value) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 10),child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(
            fontSize: 20,
            color: Colors.grey
        )),
        SizedBox(width: 60),
        Flexible(child: Text(value, textAlign: TextAlign.right,style: TextStyle(
            fontSize: 20,
            color: Colors.white
        )))
      ],
    ),);
  }
}
