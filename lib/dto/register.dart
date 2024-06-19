class Register {
  final String username;
  final String email;
  final String password;

  Register({
    required this.username,
    required this.email,
    required this.password,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      username: json['nama_pengguna'] as String,
      email: json['email'] as String,
      password: json['kata_sandi'] as String,
    );
  }
}
