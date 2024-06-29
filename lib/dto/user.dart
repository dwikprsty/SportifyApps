class User {
  final int idPengguna;
  final String namaPengguna;
  final String email;
  final String jenisKelamin;
  final bool isAdmin;
  final String alamat;
  final String nickname;
  final String noTelp;
  final String tglLahir;
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
      namaPengguna: json['nama_pengguna'] as String? ?? '',
      email: json['email'] as String? ?? '',
      jenisKelamin: json['jenis_kelamin'] as String? ?? '',
      tglLahir: (json['tgl_lahir']) ?? DateTime.now().toIso8601String(),
      noTelp: json['no_telp'] as String? ?? '',
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
      'tgl_lahir': tglLahir,
      'no_telp': noTelp,
      'foto_profil': fotoProfil,
    };
  }
}
