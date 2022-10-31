import 'package:flutter/material.dart';

class Utils {
  static Text nulableText(String? text) {
    return Text(text ?? 'Não informado');
  }
}