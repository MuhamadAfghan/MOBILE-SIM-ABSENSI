import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sim_absensi/presentation/history/history_page.dart';
import 'package:sim_absensi/presentation/profile/profile_page.dart';
import 'package:sim_absensi/presentation/roll_call/roll_call_page.dart';
import '../../../core/api/app_api.dart';
import '../models/home_models.dart';

class HomeController extends GetxController {
  var settings = Rxn<HomeSettings>();
  var isLoading = false.obs;
  var todayStatus = Rxn<TodayStatus>();
  var isTodayStatusLoading = false.obs;

  var selectedIndex = 0.obs;
  var popupMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
    fetchTodayStatus();
  }

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void navigateTo(BuildContext context, int index) {
    selectedIndex.value = index;
    if (index == 0) {
      Get.offAllNamed('/HomePage');
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

  String getCheckInTime() {
    final today = todayStatus.value;
    return (today?.statusData?.checkInTime != null && today!.statusData!.checkInTime!.length >= 5)
        ? today.statusData!.checkInTime!.substring(0, 5)
        : '--:--';
  }

  String getCheckOutTime() {
    final today = todayStatus.value;
    return (today?.statusData?.checkOutTime != null && today!.statusData!.checkOutTime!.length >= 5)
        ? today.statusData!.checkOutTime!.substring(0, 5)
        : '--:--';
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> fetchSettings() async {
    isLoading.value = true;
    print("Start fetch settings");
    try {
      final dio = Dio();
      final token = await getToken();
      final response = await dio.get(
        AppApi.settings,
        options: Options(
          headers: token.isNotEmpty
              ? {'Authorization': 'Bearer $token'}
              : null,
        ),
      );
      print("Response: ${response.data}");
      final data = response.data;
      if (data['status'] == 'success' && data['data'] != null) {
        settings.value = HomeSettings.fromJson(data['data']);
        print("settings.value updated");
      } else {
        Get.snackbar('Error', 'Failed to load statistic');
      }
    } catch (e) {
      print("fetchSettings error: $e");
      Get.snackbar('Error', 'Failed to load statistic');
    } finally {
      isLoading.value = false;
      print("isLoading set to false: ${isLoading.value}");
    }
  }

  Future<void> fetchTodayStatus() async {
    isTodayStatusLoading.value = true;
    print("Start fetch today status");
    try {
      final dio = Dio();
      final token = await getToken();
      final response = await dio.get(
        AppApi.todayStatus,
        options: Options(
          headers: token.isNotEmpty
              ? {'Authorization': 'Bearer $token'}
              : null,
        ),
      );
      print("Response: ${response.data}");
      final data = response.data;
      if (data['status'] == 'success' && data['data'] != null) {
        todayStatus.value = TodayStatus.fromJson(data['data']);
        print("todayStatus.value updated");
      } else {
        Get.snackbar('Error', 'Failed to load today status');
      }
    } catch (e) {
      print("fetchTodayStatus error: $e");
      Get.snackbar('Error', 'Failed to load today status');
    } finally {
      isTodayStatusLoading.value = false;
      print("isTodayStatusLoading set to false: ${isTodayStatusLoading.value}");
    }
  }

  /// Method untuk reload settings dari halaman
  void loadSettings() {
    fetchSettings();
  }

  /// Method untuk reload semua data home dari server
  Future<void> reloadHomeData() async {
    await fetchSettings();
    await fetchTodayStatus();
  }
}


