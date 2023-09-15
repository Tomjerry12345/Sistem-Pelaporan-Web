class Data {
  final String file, nama, jenisLaporan, deskripsi, type, typeFile, tanggal;
  final Map? lokasi;

  Data(
      {this.file = "",
      this.nama = "",
      this.jenisLaporan = "",
      this.deskripsi = "",
      this.type = "",
      this.typeFile = "",
      this.tanggal = "",
      this.lokasi});

  factory Data.fromJson(Map<String, dynamic> data) {
    return Data(
      nama: data["nama"],
      jenisLaporan: data["jenis_laporan"],
      deskripsi: data["deskripsi"],
      type: data["type"],
      typeFile: data["type_file"],
      lokasi: data["lokasi"],
    );
  }
}

List<Data> demoData = [
  Data(
    file: "assets/icons/xd_file.svg",
    nama: "Test Nama",
    jenisLaporan: "Test Jenis Laporan",
    deskripsi: "Test Deskripsi",
    type: "masuk",
    typeFile: "image",
    tanggal: "August, 5 2023",
    lokasi: {
      "latitude": -5.1586824153460675,
      "longitude": 119.43967957753794,
    },
  ),
];
