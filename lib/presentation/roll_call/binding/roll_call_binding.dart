import 'package:get/get.dart';
import '../controller/roll_call_controller.dart';

class RollCallBinding extends Bindings {
  @override
  void dependencies() {
    // Token bisa diambil dari storage jika perlu, di sini contoh sederhana
    Get.lazyPut<RollCallController>(() => RollCallController(token: ''));
  }
}
