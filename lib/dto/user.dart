class User {
  final int idPengguna;
  final String namaPengguna;
  final String email;
  final String jenisKelamin;
  final bool isAdmin;
  final String alamat;
  final String nickname;
  final String noTelp;
  final DateTime tglLahir;
  String fotoProfil;

  User({
    required this.idPengguna,
    required this.namaPengguna,
    required this.email,
    required this.jenisKelamin,
    required this.isAdmin,
    required this.alamat,
    required this.nickname,
    required this.noTelp,
    required this.tglLahir,
    required this.fotoProfil,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idPengguna: json['id_pengguna'] as int,
      isAdmin: json['jenis_pengguna'] as String == 'admin' ? true : false,
      alamat: json['alamat'] as String? ?? '',
      fotoProfil: json['foto_profil'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      namaPengguna: json['username'] as String? ?? '',
      email: json['email'] as String? ?? '',
      jenisKelamin: json['gender'] as String? ?? '',
      tglLahir: json['birthday'] != null
          ? DateTime.parse(json['birthday'])
          : DateTime.now(),
      noTelp: json['phone_number'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pengguna': idPengguna,
      'jenis_pengguna': isAdmin ? 'admin' : 'customer',
      'nama_pengguna': namaPengguna,
      'email': email,
      'nickname': nickname,
      'alamat': alamat,
      'jenis_kelamin': jenisKelamin,
      'tgl_lahir': tglLahir.toIso8601String(),
      'no_telp': noTelp,
      'foto_profil': fotoProfil,
    };
  }
}
