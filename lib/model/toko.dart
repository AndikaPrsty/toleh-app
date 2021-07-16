class Toko {
  final String namaToko;
  final String idToko;
  final String idUser;
  final String jamBuka;
  final String jamTutup;
  final double latitude;
  final double longitude;
  final String alamat;
  final String imageUrl;
  final String provinsi;
  final String kabupaten;
  final String kecamatan;
  final String kelurahan;
  final int kodePos;
  final String jalan;
  int distance;

  Toko(
      this.namaToko,
      this.latitude,
      this.longitude,
      this.alamat,
      this.imageUrl,
      this.jamBuka,
      this.jamTutup,
      this.idToko,
      this.provinsi,
      this.kabupaten,
      this.kecamatan,
      this.kelurahan,
      this.kodePos,
      this.jalan,
      this.idUser);

  Toko.fromJson(Map<String, dynamic> json)
      : namaToko = json['nama_toko'],
        idToko = json['id'],
        idUser = json['id_user'],
        jamBuka = json['jam_buka'],
        jamTutup = json['jam_tutup'],
        latitude = json['Lokasi']['latitude'],
        longitude = json['Lokasi']['longitude'],
        alamat = json['Lokasi']['alamat_lengkap'],
        provinsi = json['Lokasi']['provinsi'],
        kabupaten = json['Lokasi']['kabupaten'],
        kecamatan = json['Lokasi']['kecamatan'],
        kelurahan = json['Lokasi']['kelurahan'],
        kodePos = json['Lokasi']['kode_pos'],
        jalan = json['Lokasi']['jalan'],
        imageUrl = json['url_gambar'];
}
