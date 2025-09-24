class Statistik {
  final int persentaseKehadiran;
  final int jumlahTidakMasuk;
  final int jumlahMasuk;
  final int jumlahTelat;
  final int jumlahIzin;
  final int jumlahSakit;

  Statistik({
    required this.persentaseKehadiran,
    required this.jumlahTidakMasuk,
    required this.jumlahMasuk,
    required this.jumlahTelat,
    required this.jumlahIzin,
    required this.jumlahSakit,
  });

  factory Statistik.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Statistik(
      persentaseKehadiran: parseInt(json['persentase_kehadiran']),
      jumlahTidakMasuk: parseInt(json['jumlah_tidak_masuk']),
      jumlahMasuk: parseInt(json['jumlah_masuk']),
      jumlahTelat: parseInt(json['jumlah_telat']),
      jumlahIzin: parseInt(json['jumlah_izin']),
      jumlahSakit: parseInt(json['jumlah_sakit']),
    );
  }
}

class Activity {
  final String? checkInTime;
  final String? checkOutTime;
  final bool isLate;
  final int lateDurationMinutes;
  final String expectedCheckInTime;

  Activity({
    required this.checkInTime,
    required this.checkOutTime,
    required this.isLate,
    required this.lateDurationMinutes,
    required this.expectedCheckInTime,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Activity(
      checkInTime: json['check_in_time']?.toString(), 
      checkOutTime: json['check_out_time']?.toString(), 
      isLate: json['is_late'] ?? false,
      lateDurationMinutes: parseInt(json['late_duration_minutes']),
      expectedCheckInTime: json['expected_check_in_time']?.toString() ?? '',
    );
  }

  String get formattedCheckIn =>
      (checkInTime != null && checkInTime!.isNotEmpty) ? checkInTime!.substring(0, 5) : '--:--';

  String get formattedCheckOut =>
      (checkOutTime != null && checkOutTime!.isNotEmpty) ? checkOutTime!.substring(0, 5) : '--:--';

  String get formattedTerlambat => (isLate)
      ? 'Hari ini, ${expectedCheckInTime.isNotEmpty ? expectedCheckInTime.substring(0, 5) : "--:--"} (+${lateDurationMinutes}m)'
      : 'Hari ini, -';
}
