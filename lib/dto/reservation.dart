class Reservation {
  final String idReservasi;
  final String idPengguna;
  final String namaPengguna;
  final String idLapangan;
  final String idSesi;
  final String tglSewa;

  Reservation({
    required this.idReservasi,
    required this.idPengguna,
    required this.namaPengguna,
    required this.idLapangan,
    required this.idSesi,
    required this.tglSewa,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      idReservasi: json['id_reservasi'] as String,
      idPengguna: json['id_pengguna'] as String,
      namaPengguna: json['nama_pengguna'] as String,
      idLapangan: json['id_lapangan'] as String,
      idSesi: json['id_sesi'] as String,
      tglSewa: json['tgl_sewa'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_reservasi': idReservasi,
      'id_pengguna': idPengguna,
      'nama_pengguna': namaPengguna,
      'id_lapangan': idLapangan,
      'id_sesi': idSesi,
      'tgl_sewa': tglSewa,
    };
  }
}
