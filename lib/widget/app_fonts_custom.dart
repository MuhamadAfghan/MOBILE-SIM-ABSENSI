import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; 

class AppFonts {
  static const String poppins = 'Poppins';

  static TextStyle black({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w900,
        fontSize: fontSize.sp, 
        color: color,
      );

  static TextStyle extraBold({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w800,
        fontSize: fontSize.sp,
        color: color,
      );

  static TextStyle bold({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w700,
        fontSize: fontSize.sp,
        color: color,
      );

  static TextStyle semiBold({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w600,
        fontSize: fontSize.sp,
        color: color,
      );

  static TextStyle regular({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w400,
        fontSize: fontSize.sp,
        color: color,
      );

  static TextStyle light({double fontSize = 16, Color? color}) => TextStyle(
        fontFamily: poppins,
        fontWeight: FontWeight.w300,
        fontSize: fontSize.sp,
        color: color,
      );

  
  static TextStyle heading24 = TextStyle(
    fontFamily: poppins,
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading20 = TextStyle(
    fontFamily: poppins,
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading18 = TextStyle(
    fontFamily: poppins,
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading16 = TextStyle(
    fontFamily: poppins,
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading15 = TextStyle(
    fontFamily: poppins,
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading14 = TextStyle(
    fontFamily: poppins,
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading13 = TextStyle(
    fontFamily: poppins,
    fontSize: 13.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle heading12 = TextStyle(
    fontFamily: poppins,
    fontSize: 12.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle normal24 = TextStyle(
    fontFamily: poppins,
    fontSize: 24.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normal20 = TextStyle(
    fontFamily: poppins,
    fontSize: 20.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normal16 = TextStyle(
    fontFamily: poppins,
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normal15 = TextStyle(
    fontFamily: poppins,
    fontSize: 15.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normal14 = TextStyle(
    fontFamily: poppins,
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normal12 = TextStyle(
    fontFamily: poppins,
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normal10 = TextStyle(
    fontFamily: poppins,
    fontSize: 10.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle normal8 = TextStyle(
    fontFamily: poppins,
    fontSize: 8.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle fonterror = TextStyle(
    fontFamily: poppins,
    fontSize: 12.sp,
    color: Colors.red,
    fontWeight: FontWeight.normal,
  );

  static TextStyle fontsucces = TextStyle(
    fontFamily: poppins,
    fontSize: 12.sp,
    color: Colors.green,
    fontWeight: FontWeight.normal,
  );
}
