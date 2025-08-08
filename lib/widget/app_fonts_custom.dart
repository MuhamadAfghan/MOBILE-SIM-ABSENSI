import 'package:flutter/material.dart';

class AppFonts {
  static const String poppins = 'Poppins';

  static TextStyle black({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w900,
        fontSize: fontSize,
        color: color,
      );

  static TextStyle extraBold({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w800,
        fontSize: fontSize,
        color: color,
      );

  static TextStyle bold({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        color: color,
      );

  static TextStyle semiBold({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
        color: color,
      );

  static TextStyle regular({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w400,
        fontSize: fontSize,
        color: color,
      );

  static TextStyle light({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w300,
        fontSize: fontSize,
        color: color,
      );

  // Preset TextStyles
  static const TextStyle heading24 = TextStyle(
    fontFamily: poppins,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading20 = TextStyle(
    fontFamily: poppins,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle heading16 = TextStyle(
    fontFamily: poppins,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body14 = TextStyle(
    fontFamily: poppins,
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: poppins,
    fontSize: 12,
    color: Colors.grey,
  );

  static const TextStyle button = TextStyle(
    fontFamily: poppins,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Untuk icon pada navbar bottom
  static const TextStyle navbarIcon = TextStyle(
    fontFamily: poppins,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
}
