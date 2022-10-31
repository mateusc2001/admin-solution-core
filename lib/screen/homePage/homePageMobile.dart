import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_solution_core/main.dart';
import 'package:admin_solution_core/model/proposta.dart';
import 'package:admin_solution_core/screen/GradientCircle.dart';
import 'package:admin_solution_core/screen/detalheProposta/detalhePropostaMobile.dart';
import 'package:admin_solution_core/screen/login/loginMobile.dart';
import 'package:admin_solution_core/service/globals.dart';
import 'package:admin_solution_core/service/login/loginService.dart';

class HomePageMobile extends StatefulWidget {
  List propostaList;
  int views;
  Future Function() onRefresh;

  HomePageMobile({required this.propostaList, required this.views, required this.onRefresh});

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  var prod = false;
  late Globals globalsState;
  var searchController = TextEditingController();
  LoginService loginService = LoginService();
  var user;

  @override
  void initState() {
    super.initState();
  }

  _initState() async {
    var u = await globalsState.getUser();
    setState(() {
      user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    globalsState = Provider.of<Globals>(context);
    prod = globalsState.prod;
    _initState();

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        title: Text("Solution Core",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24)),
      ),
      drawer: Drawer(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xff00acc1),
              Color(0xFF543AB7),
            ],
            tileMode: TileMode.mirror,
          )),
          child: Padding(
            padding: EdgeInsets.only(top: 90, bottom: 30, left: 20, right: 20),
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
                        'Solution Core',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'RaleWay'),
                      ),
                      Text(
                        'Ambiente de ' + (prod ? 'Produção' : 'Teste'),
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'RaleWay'),
                      ),
                      const SizedBox(height: 40),
                      getRowMenu(
                          const Icon(
                            Icons.home,
                            color: Colors.white,
                            size: 30,
                          ),
                          'Home',
                          MediaQuery.of(context).size.width * .7),
                      Divider(),
                      getRowMenu(
                          const Icon(
                            Icons.settings,
                            color: Colors.white,
                            size: 30,
                          ),
                          'Setting',
                          MediaQuery.of(context).size.width * .7),
                      Divider(),
                      getRowMenu(
                          const Icon(
                            Icons.logout,
                            color: Colors.white,
                            size: 30,
                          ),
                          'Logout',
                          MediaQuery.of(context).size.width * .7, action: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: ((context) {
                          globalsState.setToken(null, null);
                          return LoginMobile();
                        })));
                      })
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(prod
                          ? Icons.production_quantity_limits
                          : Icons.local_activity),
                      Switch(
                        value: prod,
                        activeColor: Colors.purple,
                        onChanged: (bool value) {
                          setState(() {
                            prod = value;
                            globalsState.updateStatus(value);
                          });
                          Navigator.push(context,
                              MaterialPageRoute(builder: ((context) {
                                globalsState.setToken(null, null);
                                return LoginMobile();
                              })));
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 20,
                        offset: Offset(0, 0))
                  ]),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        (user != null
                            ? 'Bem vindo ${user['firstName']}'
                            : 'Bom dia'),
                        style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w300,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  RefreshIndicator(child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 20),
                          getCardMetrics(
                              'Visualizações da página',
                              widget.views.toString(),
                              Icons.remove_red_eye,
                              Icons.more_vert),
                          SizedBox(width: 15),
                          getCardMetrics('Propostas respondidas', '20',
                              Icons.playlist_add_check, Icons.filter_list_alt),
                          SizedBox(width: 15),
                          getCardMetrics('Propostas aguardando', '7',
                              Icons.pending, Icons.filter_list_alt),
                          SizedBox(width: 20)
                        ],
                      ),
                    ),
                  ), onRefresh: widget.onRefresh)
                ],
              ),
            ),
            Expanded(
                flex: 6,
                child: Container(
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            offset: Offset(0, 0))
                      ]),
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    child: Container(
                                  child: TextField(
                                    keyboardType: TextInputType.text,
                                    controller: searchController,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'OpenSans',
                                    ),
                                    decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        filled: true,
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 14.0),
                                        prefixIcon:
                                            GradientIconUtils.getGradientIcon(
                                                Icons.search, 30),
                                        suffixIcon: IconButton(
                                          onPressed: () =>
                                              searchController.clear(),
                                          icon: Icon(Icons.clear,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        ),
                                        hintText: 'Pesquisar',
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  ),
                                ))
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 8,
                          child: Container(
                            child: listBuilder(context),
                          ))
                    ],
                  ),
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onRefresh,
        child: Icon(Icons.refresh),
      ),
    );
  }

  getRowMenu(Icon icon, String title, double drawerWidth, {action}) {
    return InkWell(
      onTap: action,
      child: Container(
        width: drawerWidth,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: drawerWidth * .2,
              child: icon,
            ),
            Container(
              alignment: Alignment.centerLeft,
              width: drawerWidth * .4,
              child: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w300),
              ),
            )
          ],
        ),
      ),
    );
  }

  listBuilder(BuildContext context) {
    return ListView.separated(
        itemCount: widget.propostaList.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (context, index) {
          Proposta proposta = widget.propostaList[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          DetalheProposta(proposta: proposta))));
            },
            trailing: PopupMenuButton<MenuItem>(
                // Callback that sets the selected popup menu item.
                onSelected: (MenuItem item) {
                  setState(() {
                    // _selectedMenu = item.name;
                  });
                },
                icon: Icon(Icons.more_vert, color: (proposta.usuariosLidos?.length ?? 0) > 0 ? Colors.white : Colors.grey),
                itemBuilder: (BuildContext context) =>
                    proposta.usuariosLidos?.map((e) {
                      return PopupMenuItem<MenuItem>(
                        child: Text(
                          e.firstName ?? '-',
                          style: TextStyle(color: Colors.black),
                        ),
                      );
                    }).toList() ?? []),
            title: Text(proposta.nomeCompleto ?? '-',
                style: TextStyle(fontSize: 20)),
            subtitle: Text(proposta.email ?? '-',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            leading: GradientCircle(
                childWidget: Text(
                    (proposta.nomeCompleto?[0].toUpperCase() ?? 'A'),
                    style: TextStyle(fontSize: 26, color: Colors.white))),
          );
        });
  }

  getCardMetrics(String desc, String value, icon1, icon2) {
    return Container(
      width: 150,
      height: 150,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 0), blurRadius: 20, color: Colors.black26)
          ],
          gradient: LinearGradient(
            colors: <Color>[Color(0xff00acc1), Color(0xFF543AB7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 35, color: Colors.white),
              ),
              Icon(icon2, size: 25, color: Colors.white),
            ],
          ),
          Text(
            desc,
            style: TextStyle(fontSize: 20, color: Colors.white),
          )
        ],
      ),
    );
  }
}
