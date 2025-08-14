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

// Response model for check-in/check-out
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
