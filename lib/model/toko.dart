class Toko {
  final String namaToko;
  final String idToko;
  final String jamBuka;
  final String jamTutup;
  final double latitude;
  final double longitude;
  final String alamat;
  final String imageUrl;
  int distance;

  Toko(this.namaToko, this.latitude, this.longitude, this.alamat, this.imageUrl,
      this.jamBuka, this.jamTutup, this.idToko);

  Toko.fromJson(Map<String, dynamic> json)
      : namaToko = json['nama_toko'],
        idToko = json['id'],
        jamBuka = json['jam_buka'],
        jamTutup = json['jam_tutup'],
        latitude = json['Lokasi']['latitude'],
        longitude = json['Lokasi']['longitude'],
        alamat = json['Lokasi']['alamat_lengkap'],
        imageUrl = json['url_gambar'];
}
