import 'package:flutter/material.dart';

class GradientCircle extends StatelessWidget {
  Widget childWidget;
  double? width;
  double? height;

  GradientCircle({required this.childWidget, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width ?? 50,
      height: height ?? 50,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xff00acc1),
            Color(0xFF543AB7),
          ],
          tileMode: TileMode.mirror,
        )
      ),
      child: childWidget,
    );
  }
}
