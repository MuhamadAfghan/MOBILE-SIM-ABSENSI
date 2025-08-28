class RollCallRequest {
  double latitude;
  double longitude;
  String type;
  String keterangan;

  RollCallRequest({
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.keterangan,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'type': type,
        'keterangan': keterangan,
      };
}


class RollCallResponse {
  final String status;
  final String message;
  final Map<String, dynamic> data;

  RollCallResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RollCallResponse.fromJson(Map<String, dynamic> json) {
    return RollCallResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] ?? {},
    );
  }
}

class AbsenceRequest {
  String dateStart;
  String dateEnd;
  String type; 
  String description;

  AbsenceRequest({
    required this.dateStart,
    required this.dateEnd,
    required this.type,
    required this.description,
  });
}

class AbsenceResponse {
  final String status;
  final String message;
  final Map<String, dynamic> data;

  AbsenceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AbsenceResponse.fromJson(Map<String, dynamic> json) {
    return AbsenceResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] ?? {},
    );
  }
}
