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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_pengguna'] as int,
      namaPengguna: json['nama_pengguna'] as String,
      email: json['email'] as String,
      jenisKelamin: json['jenis_kelamin'] as String,
      isAdmin: json['jenis_pengguna'] as String == 'admin' ? true : false,
      alamat: json['alamat'] as String,
      nickname: json['nickname'] as String,
      noTelp: json['no_telp'] as String,
      tglLahir: json['tgl_lahir'] != null ? DateTime.parse(json['tgl_lahir'] as String) : DateTime.now(),
    );
  }
}
