class Session {
  final String idSesi;
  final String waktu;

  Session({required this.idSesi, required this.waktu});

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      idSesi: json['id_sesi'],
      waktu: json['waktu'],
    );
  }
}