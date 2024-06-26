class User {
  final int id;
  final String namaPengguna;
  final String email;
  final String jenisKelamin;
  final bool isAdmin;
  final String alamat;
  final String nickname;
  final String noTelp;
  final DateTime tglLahir;
  final String password; // Tambahkan field password

  User({
    required this.id,
    required this.namaPengguna,
    required this.email,
    required this.jenisKelamin,
    required this.isAdmin,
    required this.alamat,
    required this.nickname,
    required this.noTelp,
    required this.tglLahir,
    required this.password, 
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_pengguna'],
      namaPengguna: json['nama_pengguna'],
      email: json['email'],
      jenisKelamin: json['jenis_kelamin'],
      isAdmin: json['jenis_pengguna'] == 'admin',
      alamat: json['alamat'],
      nickname: json['nickname'],
      noTelp: json['no_telp'],
      tglLahir: DateTime.parse(json['tgl_lahir']),
      password: json['kata_sandi'], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_pengguna': id,
      'nama_pengguna': namaPengguna,
      'email': email,
      'jenis_kelamin': jenisKelamin,
      'jenis_pengguna': isAdmin ? 'admin' : 'user',
      'alamat': alamat,
      'nickname': nickname,
      'no_telp': noTelp,
      'tgl_lahir': tglLahir.toIso8601String(),
      'kata_sandi': password, 
    };
  }
}
