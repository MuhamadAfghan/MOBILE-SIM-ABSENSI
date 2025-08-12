import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../models/roll_call_models.dart';

class RollCallController {
  final String token;
  final Dio _dio = Dio();

  RollCallController({required this.token});

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

  Future<bool> checkIn(RollCallRequest request) async {
    try {
      print('Check-in request: ${request.toJson()}');
      final response = await _dio.post(
        'http://127.0.0.1:8000/api/check-in',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print('Check-in response: ${response.statusCode} ${response.data}');
      return response.statusCode == 200;
    } catch (e) {
      print('Check-in error: $e');
      return false;
    }
  }

  Future<bool> checkOut(RollCallRequest request) async {
    try {
      print('Check-out request: ${request.toJson()}');
      final response = await _dio.post(
        'http://127.0.0.1:8000/api/check-out',
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print('Check-out response: ${response.statusCode} ${response.data}');
      return response.statusCode == 200;
    } catch (e) {
      print('Check-out error: $e');
      return false;
    }
  }
}
