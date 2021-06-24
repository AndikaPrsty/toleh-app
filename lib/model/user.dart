class User {
  final String id;
  final String nama;
  final String createdAt;
  final String role;
  final String nomorTelepon;

  User(this.nama, this.createdAt, this.role, this.nomorTelepon, this.id);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
      nama = json['nama'],
        createdAt = json['createdAt'],
        role = json['role'],
        nomorTelepon = json['telp'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'createdAt': createdAt,
        'role': role,
        'telp': nomorTelepon
      };
}
