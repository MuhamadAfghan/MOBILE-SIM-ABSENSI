class UserModel {
  final int id;
  final String name;
  final String nip;
  final String email;
  final String telepon;
  final String divisi;
  final String mapel;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.nip,
    required this.email,
    required this.telepon,
    required this.divisi,
    required this.mapel,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      nip: json['nip'],
      email: json['email'],
      telepon: json['telepon'],
      divisi: json['divisi'],
      mapel: json['mapel'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nip': nip,
      'email': email,
      'telepon': telepon,
      'divisi': divisi,
      'mapel': mapel,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class LoginResponse {
  final String status;
  final String message;
  final String token;
  final String serialNumber;
  final UserModel user;

  LoginResponse({
    required this.status,
    required this.message,
    required this.token,
    required this.serialNumber,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      token: data['token'],
      serialNumber: data['serial_number'],
      user: UserModel.fromJson(data['user']),
    );
  }
}
