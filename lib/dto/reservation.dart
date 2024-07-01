import 'package:intl/intl.dart';

class Reservation {
  final int idPengguna;
  // final String namaPengguna;
  final int idReservasi;
  final String? idLapangan;
  final String? idSesi;
  final DateTime tglSewa;
  final int harga;
  final bool pembayaran;

  Reservation({
    required this.idPengguna,
    // required this.namaPengguna,
    required this.idReservasi,
    this.idLapangan,
    this.idSesi,
    required this.tglSewa,
    required this.harga,
    required this.pembayaran,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      idPengguna: json['id_pengguna'] as int,
      // namaPengguna: json['nama_pengguna'] as String,
      idReservasi: json['id_reservasi'] as int,
      idLapangan: json['id_lapangan'] as String? ?? '',
      idSesi: json['id_sesi'] as String? ?? '',
      tglSewa: DateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'")
          .parse(json['tgl_sewa'] as String),
      harga: json['harga'] as int,
      pembayaran: json['pembayaran'] == 1 ? true : false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_pengguna': idPengguna,
      // 'nama_pengguna': namaPengguna,
      'id_reservasi': idReservasi,
      'id_lapangan': idLapangan,
      'id_sesi': idSesi,
      'tgl_sewa': tglSewa.toIso8601String(),
      'harga': harga,
      'pembayaran': pembayaran,
    };
  }
}
