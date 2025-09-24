import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sim_absensi/presentation/history/history_page.dart';
import 'package:sim_absensi/presentation/home/home_page.dart';
import 'package:sim_absensi/presentation/roll_call/roll_call_page.dart';
import 'package:sim_absensi/presentation/profile/profile_page.dart';
import 'package:sim_absensi/presentation/login/login_page.dart';
import 'dart:convert';
import '../models/profile_models.dart';
import '../../../core/api/app_api.dart';
import '../../login/models/login_models.dart';

class ProfileController extends GetxController {
  var statistik = Rxn<Statistik>();
  var activity = Rxn<Activity>();
  var user = Rxn<UserModel>();
  var isLoading = false.obs;
  var error = ''.obs;
  var selectedIndex = 3.obs;
  var popupMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTokenAndFetchStatistik();
    _loadTokenAndFetchActivity();
    _loadUserFromPrefs();
  }

  void navigateTo(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      Get.offAll(() =>  HomePage());
    } else if (index == 1) {
      Get.offAll(() =>  RollCallPage());
    } else if (index == 2) {
      Get.offAll(() =>  HistoryPage());
    } else if (index == 3) {
      Get.offAll(() =>  ProfilePage());
    }
  }

  void showPopup(String message, {bool success = false}) {
    popupMessage.value = (success ? '[SUCCESS] ' : '[ERROR] ') + message;
    Future.delayed(const Duration(seconds: 2), () {
      popupMessage.value = '';
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(() => const LoginPage());
  }

  Future<void> _loadTokenAndFetchStatistik() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      await fetchStatistik(token);
    }
  }

  Future<void> fetchStatistik(String token) async {
    isLoading.value = true;
    error.value = '';
    try {
      final dio = Dio();
      final response = await dio.get(
        AppApi.statistik,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      statistik.value = Statistik.fromJson(response.data['data']);
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadTokenAndFetchActivity() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      await fetchActivity(token);
    }
  }

  Future<void> fetchActivity(String token) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        AppApi.activity,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      activity.value = Activity.fromJson(response.data['data']);
    } catch (_) {
      activity.value = null;
    }
  }

  Future<void> _loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      user.value = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    }
  }

  Future<void> reloadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      user.value = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } else {
      user.value = null;
    }
    onInit(); 
  }
}
