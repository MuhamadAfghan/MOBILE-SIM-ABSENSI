import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopUpCustom extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;

  const PopUpCustom({
    Key? key,
    required this.message,
    this.backgroundColor = const Color(0xFFFF6243), // warna merah seperti gambar
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = 10;
    try {
      fontSize = 10.sp;
    } catch (_) {
      fontSize = 10;
    }
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            message,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: fontSize,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
