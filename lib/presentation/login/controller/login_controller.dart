import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/api/app_api.dart';
import '../models/login_models.dart';
import '../../home/home_page.dart'; // tambahkan ini jika ingin langsung push ke widget

class LoginController extends GetxController {
  var isLoading = false.obs;

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final response = await Dio().post(
        AppApi.login,
        data: {
          "email": email,
          "password": password,
        },
      );
      print('Login response: ${response.data}'); // log response di sini
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final loginResponse = LoginResponse.fromJson(response.data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', loginResponse.token);
        await prefs.setString('serial_number', loginResponse.serialNumber);
        await prefs.setString('user', jsonEncode(loginResponse.user.toJson())); // fix: use toJson()
        // Navigasi ke HomePage setelah login sukses
        Get.offAll(() => const HomePage());
      } else {
        Get.snackbar('Login Failed', response.data['message'] ?? 'Unknown error');
      }
    } catch (e) {
      print('Login error: $e'); // log error juga
      Get.snackbar('Error', 'Failed to login: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('serial_number');
    await prefs.remove('user');
    Get.offAllNamed('/login'); // pastikan route '/login' sudah ada di AppRoutes
  }
}