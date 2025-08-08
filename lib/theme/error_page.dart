import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final int errorCode;

  const ErrorPage({Key? key, required this.errorCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String message;
    String imagePath;
    switch (errorCode) {
      case 400:
        message = 'Request tidak valid, misal format JSON salah atau field kurang';
        imagePath = 'assets/images/error_400.png';
        break;
      case 401:
        message = 'Belum login atau token salah/kadaluarsa';
        imagePath = 'assets/images/error_401.png';
        break;
      case 403:
        message = 'Tidak memiliki akses walau sudah login';
        imagePath = 'assets/images/error_403.png';
        break;
      case 404:
        message = 'URL tidak ditemukan di server';
        imagePath = 'assets/images/error_404.png';
        break;
      case 405:
        message = 'Method tidak diizinkan (misalnya POST ke endpoint GET)';
        imagePath = 'assets/images/error_405.png';
        break;
      case 408:
        message = 'Request terlalu lama, client timeout';
        imagePath = 'assets/images/error_408.png';
        break;
      case 409:
        message = 'Konflik data, seperti mendaftar email yang sudah ada';
        imagePath = 'assets/images/error_409.png';
        break;
      case 422:
        message = 'Data valid tapi gagal diproses (biasanya validasi)';
        imagePath = 'assets/images/error_422.png';
        break;
      case 429:
        message = 'Terlalu sering request dalam waktu pendek';
        imagePath = 'assets/images/error_429.png';
        break;
      case 500:
        message = 'Kesalahan di server, biasanya bug pada backend';
        imagePath = 'assets/images/error_500.png';
        break;
      case 502:
        message = 'Server proxy menerima respon error dari backend';
        imagePath = 'assets/images/error_502.png';
        break;
      case 503:
        message = 'Server sedang tidak bisa digunakan';
        imagePath = 'assets/images/error_503.png';
        break;
      case 504:
        message = 'Server tidak membalas tepat waktu';
        imagePath = 'assets/images/error_504.png';
        break;
      default:
        message = 'Terjadi kesalahan';
        imagePath = 'assets/images/error_default.png';
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Error $errorCode',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
