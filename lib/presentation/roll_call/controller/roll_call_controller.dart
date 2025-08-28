import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sim_absensi/widget/pop_up_custom.dart';
import '../models/roll_call_models.dart';
import '../../../core/api/app_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';


class RollCallController {
  String token;
  final Dio _dio = Dio();

  RollCallController({required this.token});

  Future<void> ensureToken() async {
    if (token.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('token') ?? '';
      print('Loaded token: $token');
    } else {
      print('Using existing token: $token');
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception('GPS tidak aktif');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Izin lokasi ditolak permanen. Ubah di Settings.');
    }

    
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      timeLimit: const Duration(seconds: 10),
    );
  }

  Future<RollCallResponse?> checkIn(RollCallRequest request) async {
    await ensureToken();
    try {
      request.type = "mobile";
      final position = await getCurrentLocation();
      
      request.latitude = position.latitude;
      request.longitude = position.longitude;
      print('Lokasi dikirim: Lat=${position.latitude}, Lng=${position.longitude}');
      print('Check-in request: ${request.toJson()}');
      final response = await _dio.post(
        AppApi.checkIn,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      print('Check-in response: ${response.statusCode} ${response.data}');
      print('Check-in message: ${response.data['message']}');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return RollCallResponse.fromJson(response.data);
      } else {
        final msg = response.data['message'] ?? 'Gagal mengirim absensi!';
        print('Check-in error message: $msg');
        return RollCallResponse(
          status: 'error',
          message: msg,
          data: {},
        );
      }
    } catch (e) {
      print('Check-in error: $e');
      print('Check-in error message: Gagal mengirim absensi!');
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
      final position = await getCurrentLocation();
      
      request.latitude = position.latitude;
      request.longitude = position.longitude;
      print('Lokasi dikirim: Lat=${position.latitude}, Lng=${position.longitude}');
      print('Check-out request: ${request.toJson()}');
      final response = await _dio.post(
        AppApi.checkOut,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      print('Check-out response: ${response.statusCode} ${response.data}');
      print('Check-out message: ${response.data['message']}');
      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return RollCallResponse.fromJson(response.data);
      } else {
        final msg = response.data['message'] ?? 'Gagal mengirim absensi!';
        print('Check-out error message: $msg');
        return RollCallResponse(
          status: 'error',
          message: msg,
          data: {},
        );
      }
    } catch (e) {
      print('Check-out error: $e');
      print('Check-out error message: Gagal mengirim absensi!');
      return RollCallResponse(
        status: 'error',
        message: 'Gagal mengirim absensi!',
        data: {},
      );
    }
  }

  
  String parseErrorMessage(dynamic message) {
    if (message is String) return message;
    if (message is Map) {
      
      if (message.containsKey('upload_attachment')) {
        final val = message['upload_attachment'];
        if (val is List && val.isNotEmpty) return val[0];
      }
      
      final firstKey = message.keys.isNotEmpty ? message.keys.first : null;
      final firstVal = firstKey != null ? message[firstKey] : null;
      if (firstVal is List && firstVal.isNotEmpty) return firstVal[0];
      if (firstVal is String) return firstVal;
      return 'Terjadi kesalahan';
    }
    return 'Terjadi kesalahan';
  }

  Future<AbsenceResponse?> submitAbsence(AbsenceRequest request, {File? attachment}) async {
    await ensureToken();
    try {
      if (attachment != null) {
        final sizeInKB = attachment.lengthSync() / 1024;
        if (sizeInKB > 2048) {
          return AbsenceResponse(
            status: 'error',
            message: 'File terlalu besar. Maks 2MB.',
            data: {},
          );
        }
      }

      FormData formData = FormData.fromMap({
        'date-start': request.dateStart,
        'date-end': request.dateEnd,
        'type': request.type,
        'description': request.description,
        if (attachment != null)
          'upload_attachment': await MultipartFile.fromFile(attachment.path, filename: attachment.path.split('/').last),
      });

      final response = await _dio.post(
        AppApi.absence,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      print('Absence response: ${response.statusCode} ${response.data}');
      print('Absence message: ${response.data['message']}');
      if ((response.statusCode == 200 || response.statusCode == 201) && response.data['status'] == 'success') {
        return AbsenceResponse.fromJson(response.data);
      } else {
        final msg = parseErrorMessage(response.data['message']);
        print('Absence error message: $msg');
        return AbsenceResponse(
          status: 'error',
          message: msg,
          data: {},
        );
      }
    } catch (e) {
      print('Absence error: $e');
      print('Absence error message: Gagal mengirim izin!');
      return AbsenceResponse(
        status: 'error',
        message: 'Gagal mengirim izin!',
        data: {},
      );
    }
  }

  
  void showPopup(BuildContext context, String message, {Color? backgroundColor}) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 40, 
        left: 20,
        right: 20,
        child: PopUpCustom(
          message: message,
          backgroundColor: backgroundColor ?? const Color(0xFF2196F3),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
  }

  
  double calculateDistanceInMeters(double startLat, double startLng, double endLat, double endLng) {
    return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
  }
}
