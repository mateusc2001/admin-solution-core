import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_solution_core/main.dart';
import 'package:admin_solution_core/screen/homePage/responsive.dart';
import 'package:admin_solution_core/service/globals.dart';
import 'package:admin_solution_core/service/login/loginService.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({Key? key}) : super(key: key);

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  LoginService loginService = LoginService();
  var big = true;
  var loading = true;
  var usernameController = TextEditingController();
  var passwordController = TextEditingController();
  late Globals globals;
  var obscurePassword = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(new Duration(milliseconds: 500), (timer) {
      if (loading) {
        setState(() {
          big = !big;
        });
      }
    });
  }

  _initState() async {
    var token = await globals.storage.read(key: 'token');
    if (token != null && loading) {
      setState(() {
        loading = false;
      });
      loginService
          .validateToken(globals.getValidateToken(), token)
          .then((value) {
        if (value != false) {
          globals.setToken(token, value);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResponsiveHomePage()),
          );
        }
      });
    } else {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    globals = Provider.of<Globals>(context);
    _initState();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getColumn(),
          ),
        ),
      ),
    );
  }

  getColumn() {
    if (loading) {
      return [
        AnimatedContainer(
          width: big ? 250 : 200,
          height: big ? 250 : 200,
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 1000),
          child: Image.asset('assets/solution-core-logo-new.png', width: 150),
        )
      ];
    } else {
      return [
        AnimatedContainer(
          width: big ? 250 : 200,
          height: big ? 250 : 200,
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 1000),
          child: Image.asset('assets/solution-core-logo-new.png', width: 150),
        ),
        // Text('Solution Core', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w300, letterSpacing: 2, color: Colors.white),),
        SizedBox(height: 100),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
              hintText: 'Usuáro',
              hintStyle: TextStyle(color: Colors.grey),
              prefixIcon:
                  GradientIconUtils.getGradientIcon(Icons.account_circle, 30)),
        ),
        SizedBox(height: 40),
        TextField(
          controller: passwordController,
          obscureText: obscurePassword,
          decoration: InputDecoration(
              hintText: 'Senha',
              hintStyle: TextStyle(color: Colors.grey),
              suffixIcon: IconButton(
                onPressed: () =>
                    setState(() => obscurePassword = !obscurePassword),
                icon: Icon(
                    obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).primaryColor),
              ),
              prefixIcon: GradientIconUtils.getGradientIcon(Icons.lock, 30)),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            'Esqueceu sua senha?',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          width: double.infinity,
          child: MaterialButton(
              onPressed: () async {
                var request = {
                  "username": usernameController.value.text,
                  "password": passwordController.value.text,
                };
                var token = await loginService.login(
                    globals.getLoginEndpoint(), request);
                var user = await loginService.validateToken(
                    globals.getValidateToken(), token);

                if (user != false) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    globals.setToken(token, user);
                    return ResponsiveHomePage();
                  })));
                }
              },
              color: Theme.of(context).primaryColor,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              )),
        )
      ];
    }
  }
}
