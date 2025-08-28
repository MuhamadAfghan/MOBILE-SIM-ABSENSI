import 'package:flutter/material.dart';
import 'package:sim_absensi/presentation/home/home_page.dart';
import 'package:sim_absensi/widget/app_color_custom.dart';
import 'package:get/get.dart';
import 'package:sim_absensi/widget/app_fonts_custom.dart';
import 'controller/login_controller.dart';
import 'package:sim_absensi/widget/pop_up_custom.dart';
import 'package:sim_absensi/widget/app_input_custom.dart';
import 'package:sim_absensi/widget/app_button_custome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 24.h,
                              left: 24.w,
                              right: 24.w,
                              bottom: 8.h,
                            ),
                            child: SizedBox(
                              width: 60.w,
                              height: 60.w,
                              child: Image.asset(
                                'assets/images/logo_wikrama.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: 120.w,
                              height: 120.w,
                              child: Image.asset(
                                'assets/images/login.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Text(
                                  'Welcome!',
                                  style: AppFonts.bold(fontSize: 28.sp, color: Colors.black),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'Please enter login details below',
                                  style: AppFonts.regular(fontSize: 15.sp, color: Colors.black54),
                                ),
                                SizedBox(height: 32.h),

                                
                                AppInputCustom(
                                  controller: _emailController,
                                  hintText: 'Username',
                                  keyboardType: TextInputType.text,
                                ),

                                
                                AppInputCustom(
                                  controller: _passwordController,
                                  hintText: 'Password',
                                  obscureText: true,
                                  keyboardType: TextInputType.text,
                                  margin: EdgeInsets.only(bottom: 28.h),
                                ),

                                
                                AppButtonCustom(
                                  label: 'Login',
                                  loading: _loginController.isLoading.value,
                                  color: AppColor.primaryBlue,
                                  onPressed: () async {
                                    await _loginController.login(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                      onMessage: (msg, isSuccess) {
                                        _showError(
                                          (isSuccess ? '[SUCCESS]' : '[ERROR]') + ' ' + msg,
                                        );
                                      },
                                    );
                                  },
                                ),

                                
                                Obx(() => _errorMessage.value.isNotEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(top: 16.h),
                                        child: _errorMessage.value.startsWith('[SUCCESS]')
                                            ? PopUpSuccess(message: _errorMessage.value.replaceFirst('[SUCCESS]', '').trim())
                                            : PopUpError(message: _errorMessage.value.replaceFirst('[ERROR]', '').trim()),
                                      )
                                    : const SizedBox.shrink(),
                                ),
                                SizedBox(height: 12.h),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
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
