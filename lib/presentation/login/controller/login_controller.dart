import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/api/app_api.dart';
import '../models/login_models.dart';
import '../../home/home_page.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;

  String translateError(String msg) {
    if (msg.contains('Failed to login')) return 'Gagal masuk. Silakan coba lagi.';
    if (msg.contains('bad response')) return 'Terjadi kesalahan pada server. Silakan coba lagi.';
    if (msg.contains('404')) return 'Data tidak ditemukan.';
    if (msg.contains('timeout')) return 'Waktu permintaan habis. Periksa koneksi internet Anda.';
    if (msg.contains('Unknown error')) return 'Terjadi kesalahan tidak diketahui.';
    if (msg.contains('email') && msg.contains('required')) return 'Email wajib diisi.';
    if (msg.contains('password') && msg.contains('required')) return 'Password wajib diisi.';
    return msg;
  }

  Future<void> login(
    String email,
    String password, {
    Function(String message, bool isSuccess)? onMessage,
  }) async {
    isLoading.value = true;
    try {
      final response = await Dio().post(
        AppApi.login,
        data: {
          "email": email,
          "password": password,
        },
      );
      print('Login response: ${response.data}');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final loginResponse = LoginResponse.fromJson(response.data);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', loginResponse.token);
        await prefs.setString('serial_number', loginResponse.serialNumber);
        await prefs.setString('user', jsonEncode(loginResponse.user.toJson()));
        if (onMessage != null) {
          onMessage(loginResponse.message, true);
        }
        Get.offAll(() => const HomePage());
      } else {
        final msg = response.data['message'] ?? 'Unknown error';
        if (onMessage != null) {
          onMessage(translateError(msg), false);
        }
      }
    } on DioException catch (e) {
      String msg = 'Failed to login';
      if (e.response != null && e.response?.data != null) {
        msg = e.response?.data['message']?.toString() ?? msg;
      } else if (e.message != null) {
        msg = e.message!;
      }
      print('Login error: $msg');
      if (onMessage != null) {
        onMessage(translateError(msg), false);
      }
    } catch (e) {
      print('Login error: $e');
      if (onMessage != null) {
        onMessage(translateError('Failed to login: $e'), false);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    Get.offAllNamed('/login');
  }
}