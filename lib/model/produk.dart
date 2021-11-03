class Produk {
  final String id;
  final String idToko;
  final String namaProduk;
  final String detailProduk;
  final int hargaProduk;
  final String imageUrl;

  Produk(this.namaProduk, this.idToko, this.imageUrl, this.id,
      this.detailProduk, this.hargaProduk);

  Produk.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        idToko = json['id_toko'],
        namaProduk = json['nama_produk'],
        detailProduk = json['detail_produk'],
        hargaProduk = json['harga_produk'],
        imageUrl = json['url_gambar'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'id_toko': idToko,
        'nama_produk': namaProduk,
        'detail_produk': detailProduk,
        'harga_produk': hargaProduk,
        'url_gambar': imageUrl,
      };
}
