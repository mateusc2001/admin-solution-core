import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:admin_solution_core/screen/homePage/homePage.dart';
import 'package:admin_solution_core/screen/homePage/homePageMobile.dart';
import 'package:admin_solution_core/service/globals.dart';
import 'package:admin_solution_core/service/propostaBlocV2/PropostaBloc.dart';
import 'package:admin_solution_core/service/propostaBlocV2/propostaEvents.dart';
import 'package:admin_solution_core/service/propostaBlocV2/propostaService.dart';
import 'package:admin_solution_core/service/propostaBlocV2/propostaState.dart';

class ResponsiveHomePage extends StatefulWidget {
  const ResponsiveHomePage({Key? key}) : super(key: key);

  @override
  State<ResponsiveHomePage> createState() => _ResponsiveHomePageState();
}

class _ResponsiveHomePageState extends State<ResponsiveHomePage> {
  late PropostaBloc bloc;
  late Globals globalsState;
  late int visualizacoes = -1;

  @override
  void initState() {
    super.initState();
    bloc = PropostaBloc();
  }

  _updateList({ force: false }) async {
    setState(() {
      if (force) {
        bloc = PropostaBloc();
      }
      var endpoint = globalsState.getEndpoint();
      bloc.add(LoadPropostaEvent(endpoint: endpoint));
    });

    if (force || visualizacoes == -1) {
      var url = globalsState.getEndpoint() + "/visualizacao";
      log(url);
      var views = await PropostaService.findAllVisualizacoes(url);
      setState(() {
        visualizacoes = views;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    globalsState = Provider.of<Globals>(context);
    _updateList();

    return getTableItemBloc();
  }

  Future<void> onRefresh() async {
    log('Atualizou');
    _updateList(force: true);
  }

  getTableItemBloc() {
    return BlocBuilder<PropostaBloc, PropostaState>(
        bloc: bloc,
        builder: (context, state) {
          if (state is PropostaInitialState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PropostaSuccessState) {
            var clientsList = state.propostaList;
            return LayoutBuilder(builder: (builder, constranits) {
              if (constranits.maxWidth < 600) {
                return HomePageMobile(propostaList: clientsList, views: visualizacoes, onRefresh: onRefresh);
              } else {
                return HomePage();
              }
            });
          }
          return Center(
            child: Text(state is PropostaSuccessState ? 'S' : 'N'),
          );
        });
  }
}
