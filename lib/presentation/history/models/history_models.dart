class HistoryRecord {
  final int id;
  final String date;
  final String dayName;
  final String? checkInTime;
  final String? checkOutTime;
  final String? status;
  final String? statusText;
  final String? location;
  final String? keterangan;
  final String? workingHoursFormatted;
  final bool isComplete;

  HistoryRecord({
    required this.id,
    required this.date,
    required this.dayName,
    this.checkInTime,
    this.checkOutTime,
    this.status,
    this.statusText,
    this.location,
    this.keterangan,
    this.workingHoursFormatted,
    required this.isComplete,
  });

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      id: json['id'],
      date: json['date'] ?? '',
      dayName: json['day_name'] ?? '',
      checkInTime: json['check_in_time']?.toString(),
      checkOutTime: json['check_out_time']?.toString(),
      status: json['status']?.toString(),
      statusText: json['status_text']?.toString(),
      location: json['location']?.toString(),
      keterangan: json['keterangan']?.toString(),
      workingHoursFormatted: json['working_hours']?['formatted']?.toString(),
      isComplete: json['is_complete'] ?? false,
    );
  }
}
