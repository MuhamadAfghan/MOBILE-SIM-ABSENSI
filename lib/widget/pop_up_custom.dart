import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_fonts_custom.dart';

class PopUpCustom extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  const PopUpCustom({
    Key? key,
    required this.message,
    this.backgroundColor = const Color(0xFFFF6243), 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fontSize = 16;
    try {
      fontSize = 8.sp;
    } catch (_) {
      fontSize = 8;
    }
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            message,
            style: AppFonts.regular(fontSize: 15, color: Colors.white), 
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class PopUpError extends StatelessWidget {
  final String message;
  const PopUpError({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopUpCustom(
      message: message,
      backgroundColor: const Color(0xFFFF6243), 
    );
  }
}

class PopUpSuccess extends StatelessWidget {
  final String message;
  const PopUpSuccess({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopUpCustom(
      message: message,
      backgroundColor: const Color(0xFF43FF62), 
    );
  }
}
      
