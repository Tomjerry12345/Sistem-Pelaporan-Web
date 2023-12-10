class Data {
  final String file, nama, jenisLaporan, deskripsi, type, typeFile, tanggal;
  final bool konfirmasi;
  final Map? lokasi;

  Data(
      {this.file = "",
      this.nama = "",
      this.jenisLaporan = "",
      this.deskripsi = "",
      this.type = "",
      this.typeFile = "",
      this.tanggal = "",
      this.lokasi,
      this.konfirmasi = true});

  factory Data.fromJson(Map<String, dynamic> data) {
    return Data(
      nama: data["nama"],
      jenisLaporan: data["jenis_laporan"],
      deskripsi: data["deskripsi"],
      type: data["type"],
      typeFile: data["type_file"],
      file: data["file"],
      lokasi: data["lokasi"],
      konfirmasi: data["konfirmasi"],
    );
  }
}
