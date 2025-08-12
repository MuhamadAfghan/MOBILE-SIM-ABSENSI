class RollCallRequest {
  final double latitude;
  final double longitude;
  final String keterangan;

  RollCallRequest({
    required this.latitude,
    required this.longitude,
    required this.keterangan,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'keterangan': keterangan,
      };
}
