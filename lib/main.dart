import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:admin_solution_core/screen/gradiendIcon.dart';
import 'package:admin_solution_core/screen/login/loginMobile.dart';
import 'package:admin_solution_core/service/globals.dart';

void main() {
  runApp(const MyApp());
}

class GradientIconUtils {
  static getGradientIcon(icon, double size, {action}) {
    return InkWell(
      onTap: action,
      child: GradientIcon(
        icon,
        size,
        const LinearGradient(
          colors: <Color>[Color(0xff00acc1), Color(0xFF543AB7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const _blackPrimaryValue = 0xFF543AB7;
  static MaterialColor black = const MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFF543AB7),
      100: Color(0xFF543AB7),
      200: Color(0xFF543AB7),
      300: Color(0xFF543AB7),
      400: Color(0xFF543AB7),
      500: Color(0xFF543AB7),
      600: Color(0xFF543AB7),
      700: Color(0xFF543AB7),
      800: Color(0xFF543AB7),
      900: Color(0xFF543AB7),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Globals())],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: Color(0xff2f2f2f),
            primarySwatch: black,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            textTheme: const TextTheme(
              headline1: TextStyle(color: Colors.white),
              headline2: TextStyle(color: Colors.red),
              bodyText2: TextStyle(color: Color(0xFF543AB7)),
              subtitle1: TextStyle(color: Colors.white),
            )),
        home: LoginMobile(),
      ),
    );
  }
}