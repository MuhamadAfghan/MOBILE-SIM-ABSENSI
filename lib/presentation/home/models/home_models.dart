class HomeSettings {
  final int id;
  final String mondayStartTime;
  final String mondayEndTime;
  final bool mondayIsActive;
  final String tuesdayStartTime;
  final String tuesdayEndTime;
  final bool tuesdayIsActive;
  final String wednesdayStartTime;
  final String wednesdayEndTime;
  final bool wednesdayIsActive;
  final String thursdayStartTime;
  final String thursdayEndTime;
  final bool thursdayIsActive;
  final String fridayStartTime;
  final String fridayEndTime;
  final bool fridayIsActive;
  final String saturdayStartTime;
  final String saturdayEndTime;
  final bool saturdayIsActive;
  final String locationName;
  final double latitude;
  final double longitude;
  final int radius;
  final String createdAt;
  final String updatedAt;

  HomeSettings({
    required this.id,
    required this.mondayStartTime,
    required this.mondayEndTime,
    required this.mondayIsActive,
    required this.tuesdayStartTime,
    required this.tuesdayEndTime,
    required this.tuesdayIsActive,
    required this.wednesdayStartTime,
    required this.wednesdayEndTime,
    required this.wednesdayIsActive,
    required this.thursdayStartTime,
    required this.thursdayEndTime,
    required this.thursdayIsActive,
    required this.fridayStartTime,
    required this.fridayEndTime,
    required this.fridayIsActive,
    required this.saturdayStartTime,
    required this.saturdayEndTime,
    required this.saturdayIsActive,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.radius,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HomeSettings.fromJson(Map<String, dynamic> json) {
    return HomeSettings(
      id: json['id'],
      mondayStartTime: json['monday_start_time'] ?? '',
      mondayEndTime: json['monday_end_time'] ?? '',
      mondayIsActive: json['monday_is_active'] ?? false,
      tuesdayStartTime: json['tuesday_start_time'] ?? '',
      tuesdayEndTime: json['tuesday_end_time'] ?? '',
      tuesdayIsActive: json['tuesday_is_active'] ?? false,
      wednesdayStartTime: json['wednesday_start_time'] ?? '',
      wednesdayEndTime: json['wednesday_end_time'] ?? '',
      wednesdayIsActive: json['wednesday_is_active'] ?? false,
      thursdayStartTime: json['thursday_start_time'] ?? '',
      thursdayEndTime: json['thursday_end_time'] ?? '',
      thursdayIsActive: json['thursday_is_active'] ?? false,
      fridayStartTime: json['friday_start_time'] ?? '',
      fridayEndTime: json['friday_end_time'] ?? '',
      fridayIsActive: json['friday_is_active'] ?? false,
      saturdayStartTime: json['saturday_start_time'] ?? '',
      saturdayEndTime: json['saturday_end_time'] ?? '',
      saturdayIsActive: json['saturday_is_active'] ?? false,
      locationName: json['location_name'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      radius: json['radius'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class TodayStatus {
  final String date;
  final bool isWorkingDay;
  final String? statusType;
  final StatusData? statusData;
  final WorkSchedule? workSchedule;

  TodayStatus({
    required this.date,
    required this.isWorkingDay,
    this.statusType,
    this.statusData,
    this.workSchedule,
  });

  factory TodayStatus.fromJson(Map<String, dynamic> json) {
    return TodayStatus(
      date: json['date'] ?? '',
      isWorkingDay: json['is_working_day'] ?? false,
      statusType: json['status_type'],
      statusData: json['status_data'] != null
          ? StatusData.fromJson(json['status_data'])
          : null,
      workSchedule: json['work_schedule'] != null
          ? WorkSchedule.fromJson(json['work_schedule'])
          : null,
    );
  }
}

class StatusData {
  final String? source;
  final bool? hasCheckedIn;
  final bool? hasCheckedOut;
  final String? checkInTime;
  final String? checkOutTime;
  final String? type;
  final String? keterangan;
  final bool? isLate;

  StatusData({
    this.source,
    this.hasCheckedIn,
    this.hasCheckedOut,
    this.checkInTime,
    this.checkOutTime,
    this.type,
    this.keterangan,
    this.isLate,
  });

  factory StatusData.fromJson(Map<String, dynamic> json) {
    return StatusData(
      source: json['source'],
      hasCheckedIn: json['has_checked_in'],
      hasCheckedOut: json['has_checked_out'],
      checkInTime: json['check_in_time'],
      checkOutTime: json['check_out_time'],
      type: json['type'],
      keterangan: json['keterangan'],
      isLate: json['is_late'],
    );
  }
}

class WorkSchedule {
  final String? startTime;
  final String? endTime;
  final String? locationName;

  WorkSchedule({
    this.startTime,
    this.endTime,
    this.locationName,
  });

  factory WorkSchedule.fromJson(Map<String, dynamic> json) {
    return WorkSchedule(
      startTime: json['start_time'],
      endTime: json['end_time'],
      locationName: json['location_name'],
    );
  }
}
