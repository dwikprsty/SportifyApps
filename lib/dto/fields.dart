class FieldDetail {
  final String idLapangan;
  final String idJenisLapangan;
  final String courtName;
  final String description;
  final String location;
  final int price;
  final String gambarLapangan;
  final String? jenisLapangan; // Tambahkan field jenisLapangan

  FieldDetail({
    required this.idLapangan,
    required this.idJenisLapangan,
    required this.courtName,
    required this.description,
    required this.location,
    required this.price,
    required this.gambarLapangan,
    this.jenisLapangan, // Tambahkan required untuk jenisLapangan
  });

  // Factory method for creating instance from JSON
  factory FieldDetail.fromJson(Map<String, dynamic> json) {
    return FieldDetail(
      idLapangan: json['id_lapangan'],
      idJenisLapangan: json['id_jenislap'],
      courtName: json['nama_lapangan'],
      description: json['deskripsi'],
      location: json['alamat_lapangan'],
      price: json['harga_sewa'],
      gambarLapangan: json['gambar_lapangan'],
      jenisLapangan: json['jenis_lapangan'], // Ambil nilai jenis_lapangan dari JSON
    );
  }

  // Method for converting instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id_lapangan': idLapangan,
      'id_jenislap': idJenisLapangan,
      'nama_lapangan': courtName,
      'deskripsi': description,
      'alamat_lapangan': location,
      'harga_sewa': price,
      'gambar_lapangan': gambarLapangan,
      'jenis_lapangan': jenisLapangan, // Tambahkan nilai jenis_lapangan ke JSON
    };
  }
}
