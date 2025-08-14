import 'package:get/get.dart';
import '../controller/roll_call_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RollCallBinding extends Bindings {
  @override
  void dependencies() async {
    // Ambil token dari SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    Get.lazyPut<RollCallController>(() => RollCallController(token: token));
  }
}
