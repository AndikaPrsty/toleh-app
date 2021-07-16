class Produk {
  final String id;
  final String idToko;
  final String namaProduk;
  final String imageUrl;

  Produk(this.namaProduk, this.idToko, this.imageUrl, this.id);

  Produk.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idToko = json['id_toko'],
        namaProduk = json['nama_produk'],
        imageUrl = json['url_gambar'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_toko': idToko,
        'nama_produk': namaProduk,
        'url_gambar': imageUrl,
      };
}
