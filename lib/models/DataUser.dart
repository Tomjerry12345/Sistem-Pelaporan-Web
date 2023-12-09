class DataUser {
  final String nama, nik, jenisKelamin, email, noTelepon;

  DataUser(
      {this.nama = "",
      this.nik = "",
      this.jenisKelamin = "",
      this.email = "",
      this.noTelepon = ""});

  factory DataUser.fromJson(Map<String, dynamic> data) {
    return DataUser(
      nama: data["nama"],
      nik: data["nik"],
      jenisKelamin: data["jenis_kelamin"],
      email: data["email"],
      noTelepon: data["no_telepon"],
    );
  }
}
