import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:admin_solution_core/main.dart';
import 'package:admin_solution_core/model/proposta.dart';
import 'package:admin_solution_core/service/globals.dart';
import 'package:admin_solution_core/service/propostaBlocV2/PropostaBloc.dart';
import 'package:admin_solution_core/service/propostaBlocV2/propostaEvents.dart';
import 'package:admin_solution_core/service/propostaBlocV2/propostaService.dart';
import 'package:admin_solution_core/service/propostaBlocV2/propostaState.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool menuOpened = true;
  late bool prod;
  late final PropostaBloc bloc;
  late Globals globalsState;
  var visualizacoes;

  @override
  void initState() {
    super.initState();
    bloc = PropostaBloc();
  }

  _updateList() async {
    setState(() {
      bloc.add(LoadPropostaEvent(endpoint: globalsState.getEndpoint()));
    });

    if (visualizacoes != null) {

    } else {
      PropostaService.findAllVisualizacoes(globalsState.getEndpoint() + "/visualizacao")
          .then((value) {
        setState(() {
          visualizacoes = value;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    globalsState = Provider.of<Globals>(context);
    prod = globalsState.prod;
    _updateList();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xff00acc1),
                    Color(0xFF543AB7),
                  ],
                  tileMode: TileMode.mirror,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 0),
                      blurRadius: 10)
                ],
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  width: getLargura(MediaQuery.of(context).size.width * (menuOpened ? .2 : 0)),
                  height: MediaQuery.of(context).size.height,
                  child: menuOpened ? Padding(
                    padding: EdgeInsets.only(top: 30, bottom: 30, left: 20, right: 20),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Image.asset('assets/solution-core-logo-new.png',
                                  width: 70),
                              const SizedBox(height: 5),
                              const Text(
                                'Bom vindo, Mateus!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w100,
                                    fontFamily: 'RaleWay'),
                              ),
                              Text(
                                'Ambiente de ' + (prod ? 'Produção' : 'Teste'),
                                style: TextStyle(
                                    color: Colors.purple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w100,
                                    fontFamily: 'RaleWay'),
                              ),
                              const SizedBox(height: 40),
                              getRowMenu(
                                  const Icon(
                                    Icons.home,
                                    color: Colors.white,
                                  ),
                                  'Home'),
                              getRowMenu(
                                  const Icon(Icons.settings, color: Colors.white),
                                  'Setting')
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(prod ? Icons.production_quantity_limits : Icons.local_activity),
                              Switch(
                                value: prod,
                                activeColor: Colors.purple,
                                onChanged: (bool value) {
                                  setState(() {
                                    prod = value;
                                    globalsState.updateStatus(value);
                                  });
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ) : SizedBox(),
                ),
                getMainContainer()
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  getLargura(a) {
    return a - 20 > 0 ? a - 20 : 0;
  }

  getRowMenu(Icon icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w100),
            ),
          )
        ],
      ),
    );
  }

  Widget getMainContainer() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      padding: EdgeInsets.all(30),
      width: MediaQuery.of(context).size.width * (menuOpened ? .80 : 1) - (menuOpened ? 20 : 40),
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white),
      child: Column(
        children: [
          Expanded(
              flex: 40,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            GradientIconUtils.getGradientIcon(
                                Icons.menu_open, 35,
                                action: () {
                                  setState(() {
                                    menuOpened = !menuOpened;
                                  });
                                }),
                            SizedBox(width: 5),
                            Text(
                              'Bem vindo, Jander!',
                              style: TextStyle(fontSize: 30),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            GradientIconUtils.getGradientIcon(
                                Icons.notifications, 35),
                            SizedBox(width: 5),
                            GradientIconUtils.getGradientIcon(Icons.logout, 35)
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      getCardMetrics('Vizualizações da página', visualizacoes.toString(),
                          Icons.remove_red_eye, Icons.more_vert),
                      SizedBox(width: 15),
                      getCardMetrics('Propostas respondidas', '20',
                          Icons.playlist_add_check, Icons.filter_list_alt),
                      SizedBox(width: 15),
                      getCardMetrics('Propostas aguardando', '7', Icons.pending,
                          Icons.filter_list_alt),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              )),
          Expanded(
              flex: 60,
              child: Container(
                clipBehavior: Clip.hardEdge,
                width: double.infinity,
                decoration: const BoxDecoration(
                    // color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          blurRadius: 20,
                          color: Colors.black12)
                    ], borderRadius: BorderRadius.all(Radius.circular(0))),
                child: getTableItemBloc(),
              ))
        ],
      ),
    );
  }

  getCardMetrics(String desc, String value, icon1, icon2) {
    return Container(
      width: 150,
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 0), blurRadius: 20, color: Colors.black26)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 25),
              ),
              GradientIconUtils.getGradientIcon(icon2, 25),
            ],
          ),
          Text(
            desc,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }

  Widget getTable(List<Proposta> propostaList) {
    return ListView.separated(
      itemCount: propostaList?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        Proposta _user = propostaList![index];
        return ListTile(
          title: Text(_user.nomeCompleto ?? ''),
          subtitle: Text(_user.email ?? ''),
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
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
            final clientsList = state.propostaList;
            return PaginatedDataTable(
              header: Text('Propostas', style: TextStyle(fontSize: 22)),
              showCheckboxColumn: false,
              rowsPerPage: 4,
              actions: [
                GradientIconUtils.getGradientIcon(Icons.refresh, 35, action: _updateList)
              ],
              columns: [
                DataColumn(
                    label: Text(
                      '#',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )),
                DataColumn(
                    label: Text(
                      'Nome',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )),
                DataColumn(
                    label: Text(
                      'Email',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )),
                DataColumn(
                    label: Text(
                      'Telefone',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )),
                DataColumn(
                    label: Text(
                      'Serviço',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )),
                DataColumn(
                    label: Text(
                      'Tipo',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    )),
              ],
              source: _DataSource(context, clientsList),
            );
          }
          return Container();
        });
  }

  getStreamBuilder() {
    // return StreamBuilder(
    //   stream: propostaBLoC.propostaList,
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.none:
    //       case ConnectionState.waiting:
    //       case ConnectionState.active:
    //         {
    //           return Container(
    //             color: Colors.white,
    //             child: Center(child: CircularProgressIndicator()),
    //           );
    //         }
    //       case ConnectionState.done:
    //         {
    //           if (snapshot.hasError) {
    //             return Text('There was an error : ${snapshot.error}');
    //           } else {
    //             return PaginatedDataTable(
    //               header: Text('Propostas', style: TextStyle(fontSize: 22)),
    //               showCheckboxColumn: false,
    //               rowsPerPage: 4,
    //               actions: [
    //                 GradientIconUtils.getGradientIcon(Icons.refresh, 35, action: _updateList)
    //               ],
    //               columns: [
    //                 DataColumn(
    //                     label: Text(
    //                   '#',
    //                   style:
    //                       TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    //                 )),
    //                 DataColumn(
    //                     label: Text(
    //                   'Nome',
    //                   style:
    //                       TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    //                 )),
    //                 DataColumn(
    //                     label: Text(
    //                   'Email',
    //                   style:
    //                       TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    //                 )),
    //                 DataColumn(
    //                     label: Text(
    //                   'Telefone',
    //                   style:
    //                       TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    //                 )),
    //                 DataColumn(
    //                     label: Text(
    //                   'Serviço',
    //                   style:
    //                       TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    //                 )),
    //                 DataColumn(
    //                     label: Text(
    //                   'Tipo',
    //                   style:
    //                       TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    //                 )),
    //               ],
    //               source: _DataSource(context, snapshot.data),
    //             );
    //           }
    //         }
    //       default:
    //         {
    //           return Center(child: CircularProgressIndicator());
    //         }
    //     }
    //   },
    // );
  }
}

class _Row {
  _Row(
    this.valueA,
    this.valueB,
    this.valueC,
    this.valueD,
  );

  final String valueA;
  final String valueB;
  final String valueC;
  final int valueD;

  bool selected = false;
}

class _DataSource extends DataTableSource {
  _DataSource(this.context, List<Proposta> propostaList) {
    _rows = propostaList;
  }

  final BuildContext context;
  List<Proposta> _rows = [];

  int _selectedCount = 0;

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= _rows.length) return null;
    final row = _rows[index];
    return DataRow.byIndex(
      index: index,
      // selected: row.selected,
      // onSelectChanged: (value) {
      //   if (row.selected != value) {
      //     _selectedCount += (value ?? false) ? 1 : -1;
      //     assert(_selectedCount >= 0);
      //     row.selected = (value ?? false);
      //     notifyListeners();
      //   }
      // },
      cells: [
        DataCell(Container(
          child: Row(
            children: [
              GradientIconUtils.getGradientIcon(Icons.copy, 15),
              SizedBox(width: 10),
              Container(
                width: 100,
                child: Text(
                  '...' +
                          row.id
                              .toString()
                              .substring(row.id.toString().length - 5) ??
                      '-',
                  style: TextStyle(overflow: TextOverflow.ellipsis),
                ),
              )
            ],
          ),
        )),
        DataCell(Text(row.nomeCompleto ?? '-')),
        DataCell(Text(row.email ?? '-')),
        DataCell(Text(row.telefone ?? '-')),
        DataCell(Text(row.tipoDeServico ?? '-')),
        DataCell(Text(row.tipoDeSistema ?? '-')),
      ],
    );
  }

  @override
  int get rowCount => _rows.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
