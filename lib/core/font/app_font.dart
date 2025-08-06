import 'package:flutter/material.dart';

TextStyle appText({
  required double size,
  required FontWeight weight,
  Color? color,
}) => TextStyle(
  fontSize: size,
  fontWeight: weight,
  fontFamily: 'Montserrat',
  color: color,
  letterSpacing: 0.1,
);
