import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../models/roll_call_models.dart';
import '../../../core/api/app_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RollCallController {
  String token;
  final Dio _dio = Dio();

  RollCallController({required this.token});

  Future<void> ensureToken() async {
    if (token.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token') ?? '';
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<RollCallResponse?> checkIn(RollCallRequest request) async {
    await ensureToken();
    try {
      request.type = "mobile";
      print('Check-in request: ${request.toJson()}');
      final response = await _dio.post(
        AppApi.checkIn,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500, // accept 400 for error handling
        ),
      );
      print('Check-in response: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200) {
        return RollCallResponse.fromJson(response.data);
      } else {
        // Ambil pesan error dari backend jika ada
        final msg = response.data is Map && response.data['message'] != null
            ? response.data['message']
            : 'Gagal mengirim absensi!';
        print('Check-in failed: ${response.statusCode} $msg');
        return RollCallResponse(
          status: 'error',
          message: msg,
          data: {},
        );
      }
    } catch (e) {
      print('Check-in error: $e');
      return RollCallResponse(
        status: 'error',
        message: 'Gagal mengirim absensi!',
        data: {},
      );
    }
  }

  Future<RollCallResponse?> checkOut(RollCallRequest request) async {
    await ensureToken();
    try {
      request.type = "mobile";
      print('Check-out request: ${request.toJson()}');
      final response = await _dio.post(
        AppApi.checkOut,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500, // accept 400 for error handling
        ),
      );
      print('Check-out response: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200) {
        return RollCallResponse.fromJson(response.data);
      } else {
        final msg = response.data is Map && response.data['message'] != null
            ? response.data['message']
            : 'Gagal mengirim absensi!';
        print('Check-out failed: ${response.statusCode} $msg');
        return RollCallResponse(
          status: 'error',
          message: msg,
          data: {},
        );
      }
    } catch (e) {
      print('Check-out error: $e');
      return RollCallResponse(
        status: 'error',
        message: 'Gagal mengirim absensi!',
        data: {},
      );
    }
  }
}
