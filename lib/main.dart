import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  runApp(
    ScreenUtilInit(
      designSize: Size(375, 812), // ganti sesuai desain Anda
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        title: 'Hadir.in - Attendance App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF42A5F5)),
          useMaterial3: true,
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
