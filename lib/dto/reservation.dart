class Reservation {
  final String idPengguna;
  final String namaPengguna;
  final String idLapangan;
  final String idSesi;
  final String tglSewa;
  final String harga;
  final String pembayaran;

  Reservation({
    required this.idPengguna,
    required this.namaPengguna,
    required this.idLapangan,
    required this.idSesi,
    required this.tglSewa,
    required this.harga,
    required this.pembayaran,
  });

  Map<String, String> toMap() {
    return {
      'id_pengguna': idPengguna,
      'nama_pengguna': namaPengguna,
      'id_lapangan': idLapangan,
      'id_sesi': idSesi,
      'tgl_sewa': tglSewa,
      'harga': harga,
      'pembayaran': pembayaran,
    };
  }
}
