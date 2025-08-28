import 'package:get/get.dart';
import '../../../core/api/app_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_models.dart';

class HistoryController extends GetxController {
  var records = <HistoryRecord>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  Future<void> fetchHistory({int limit = 10, int? month, int? year}) async {
    isLoading.value = true;
    error.value = '';
    print("Start fetch history");
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final url = Uri.parse(
        '${AppApi.history}?limit=$limit'
        '${month != null ? '&month=$month' : ''}'
        '${year != null ? '&year=$year' : ''}',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Fetch history response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResp = json.decode(response.body);

        if (jsonResp['data'] != null && jsonResp['data']['records'] != null) {
          final List data = jsonResp['data']['records'];
          records.value = data.map((e) => HistoryRecord.fromJson(e)).toList();
          print('History loaded: ${records.length} records');
        } else {
          error.value = 'Data tidak ditemukan';
          print('History error: Data tidak ditemukan');
        }
      } else {
        error.value = 'Failed to load history (Code: ${response.statusCode})';
        print('History error: Failed to load history (Code: ${response.statusCode})');
      }
    } catch (e) {
      error.value = e.toString();
      print('History error: $e');
    } finally {
      isLoading.value = false;
      print("History isLoading set to false: ${isLoading.value}");
    }
  }
}
