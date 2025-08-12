import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/api/app_api.dart';
import '../models/home_models.dart';

class HomeController extends GetxController {
  var settings = Rxn<HomeSettings>();
  var isLoading = false.obs;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> fetchSettings() async {
    isLoading.value = true;
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
      final data = response.data;
      if (data['success'] == true && data['data'] != null) {
        settings.value = HomeSettings.fromJson(data['data']);
      } else {
        // Tampilkan pesan error jika response tidak sesuai
        Get.snackbar('Error', 'Failed to load statistic');
      }
    } catch (e) {
      // Tampilkan pesan error jika terjadi exception
      Get.snackbar('Error', 'Failed to load statistic');
    }
    isLoading.value = false;
  }
}


