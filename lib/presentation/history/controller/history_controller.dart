import 'package:get/get.dart';
import 'package:sim_absensi/presentation/home/home_page.dart';
import 'package:sim_absensi/presentation/profile/profile_page.dart';
import 'package:sim_absensi/presentation/roll_call/roll_call_page.dart';
import '../../../core/api/app_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/history_models.dart';

class HistoryDisplayRecord {
  final String date;
  final String day;
  final String checkIn;
  final String checkOut;

  HistoryDisplayRecord({
    required this.date,
    required this.day,
    required this.checkIn,
    required this.checkOut,
  });
}

class HistoryController extends GetxController {
  var records = <HistoryRecord>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;

  var selectedIndex = 2.obs;
  var popupMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory(limit: 10);
  }

  void changePage(int index) {
    selectedIndex.value = index;
  }

  void navigateTo(int index) {
    selectedIndex.value = index;
    if (index == 0) {
      Get.offAll(() =>  HomePage());
    } else if (index == 1) {
      Get.offAll(() =>  RollCallPage());
    } else if (index == 2) {
      // Tetap di halaman ini
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

  /// Method untuk reload data history dari server
  Future<void> reloadHistory() async {
    await fetchHistory(limit: 10);
  }

  /// Mengubah records menjadi data siap tampil
  List<HistoryDisplayRecord> getDisplayRecords() {
    return records.map((absen) {
      final tgl = absen.date.split('-').length > 2 ? absen.date.split('-')[2] : '-';
      final hari = absen.dayName.length >= 3 ? absen.dayName.substring(0, 3) : absen.dayName;
      final masuk = (absen.checkInTime != null && absen.checkInTime!.length >= 5)
          ? absen.checkInTime!.substring(0, 5)
          : '--:--';
      final keluar = (absen.checkOutTime != null && absen.checkOutTime!.length >= 5)
          ? absen.checkOutTime!.substring(0, 5)
          : '--:--';
      return HistoryDisplayRecord(
        date: tgl,
        day: hari,
        checkIn: masuk,
        checkOut: keluar,
      );
    }).toList();
  }
}
   