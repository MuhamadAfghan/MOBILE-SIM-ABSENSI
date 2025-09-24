import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

// Tambahkan import Firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:sim_absensi/presentation/history/history_page.dart';
import 'package:sim_absensi/presentation/home/home_page.dart';
import 'package:sim_absensi/presentation/profile/profile_page.dart';
import 'package:sim_absensi/presentation/roll_call/roll_call_page.dart';

import 'routes/app_routes.dart';

Future<void> main() async {
  // Pastikan binding dan format tanggal
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) => GetMaterialApp(
        title: 'Hadir.in - Attendance App',
        theme: ThemeData(
          fontFamily: 'Poppins',
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF42A5F5)),
          useMaterial3: true,
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id', ''), 
        ],
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
