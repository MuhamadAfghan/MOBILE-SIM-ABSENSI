import 'package:flutter/material.dart';
import 'package:sim_absensi/presentation/home/home_page.dart';
import 'package:sim_absensi/widget/app_color_custom.dart';
import 'package:get/get.dart';
import 'controller/login_controller.dart';
import 'package:sim_absensi/widget/pop_up_custom.dart';
import 'package:sim_absensi/widget/app_input_custom.dart';
import 'package:sim_absensi/widget/app_button_custome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _loginController = Get.put(LoginController());
  final RxString _errorMessage = ''.obs;

  @override
  void initState() {
    super.initState();
    _clearToken();
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('serial_number');
    await prefs.remove('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Stack(
          children: [
            Container(
              color: const Color(0xFFF2F8FF),
              width: double.infinity,
              height: double.infinity,
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Logo & Ilustrasi
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 48, bottom: 24),
                        child: Column(
                          children: [
                            // Ilustrasi (gunakan icon dan lingkaran)
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Background lingkaran jam
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE3F0FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.access_time,
                                    size: 70,
                                    color: AppColor.primaryBlue.withOpacity(0.18),
                                  ),
                                ),
                                // Icon orang
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: AppColor.primaryBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: AppColor.onPrimary,
                                  ),
                                ),
                                // Ornamen jaringan (kanan atas)
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Icon(
                                    Icons.hub,
                                    size: 32,
                                    color: AppColor.primaryBlue.withOpacity(0.18),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Teks hadir.in
                            Text(
                              'hadir.in',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColor.primaryBlue,
                                fontFamily: 'Comic Sans MS', // opsional, agar mirip gambar
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Form Login
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Welcome
                            const Text(
                              'Welcome!',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Please enter login details below',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Username
                            AppInputCustom(
                              controller: _emailController,
                              hintText: 'Username',
                              keyboardType: TextInputType.text,
                            ),
                            // Password
                            AppInputCustom(
                              controller: _passwordController,
                              hintText: 'Password',
                              obscureText: true,
                              keyboardType: TextInputType.text,
                              margin: const EdgeInsets.only(bottom: 28),
                            ),
                            // Tombol Login
                            AppButtonCustom(
                              label: 'Login',
                              loading: _loginController.isLoading.value,
                              color: AppColor.primaryBlue,
                              onPressed: () async {
                                await _loginController.login(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                                // Handle error or navigation inside the login method or use a callback/observable for error handling.
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_loginController.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            // Tampilkan popup jika ada error/message
            Obx(() => _errorMessage.value.isNotEmpty
                ? Positioned(
                    top: 40,
                    left: 0,
                    right: 0,
                    child: PopUpCustom(message: _errorMessage.value),
                  )
                : const SizedBox.shrink(),
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showError(String message) {
    _errorMessage.value = message;
    Future.delayed(const Duration(seconds: 2), () {
      _errorMessage.value = '';
    });
  }
}
