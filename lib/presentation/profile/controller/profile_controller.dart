import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void onInit() {
    super.onInit();
    _loadTokenAndFetchStatistik();
    _loadTokenAndFetchActivity();
    _loadUserFromPrefs();
  }

  Future<void> _loadTokenAndFetchStatistik() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null && token.isNotEmpty) {
      await fetchStatistik(token);
    } else {
      
      
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
      print('Status code: ${response.statusCode}');
      print('Response data: ${response.data}');
      statistik.value = Statistik.fromJson(response.data['data']);
    } catch (e) {
      print('Error fetching statistik: $e');
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
      print('Activity status code: ${response.statusCode}');
      print('Activity response data: ${response.data}');
      activity.value = Activity.fromJson(response.data['data']);
    } catch (e) {
      print('Error fetching activity: $e');
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
  }
}
