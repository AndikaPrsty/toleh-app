import 'package:flutter/material.dart';
import 'package:toleh/model/toko.dart';
import 'package:toleh/widgets/title.dart';
import 'package:toleh/widgets/toko/alamat_toko.dart';
import 'package:toleh/widgets/toko/gambar_toko.dart';
import 'package:toleh/widgets/toko/jam_buka.dart';
import 'package:toleh/widgets/toko/lihat_lokasi_button.dart';
import 'package:toleh/widgets/toko/list_produk.dart';
import 'package:toleh/widgets/toko/menu_gambar_button.dart';
import 'package:toleh/widgets/toko/nama_toko.dart';
import 'package:toleh/screens/tambah_produk.dart';

class TokoPage extends StatefulWidget {
  final Toko toko;

  const TokoPage({Key key, this.toko}) : super(key: key);

  @override
  _TokoPageState createState() => _TokoPageState(toko: this.toko);
}

class _TokoPageState extends State<TokoPage> {
  final toko;

  _TokoPageState({
    @required this.toko,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => TambahProduk()));
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    GambarToko(imageUrl: toko.imageUrl),
                    NamaToko(namaToko: toko.namaToko),
                    MenuGambarButton(toko: toko)
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                // height: 170,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      AlamatToko(alamat: toko.alamat),
                      JamBukaToko(
                        jamBuka: toko.jamBuka,
                        jamTutup: toko.jamTutup,
                      ),
                      Row(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // EditDeskripsiTokoButton(toko: toko),
                          LihatLokasiButton(
                              latitude: toko.latitude,
                              longitude: toko.longitude),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              TitleWidget(title: 'Daftar Produk'),
              ListProduk(),
            ],
          ),
        ),
      ),
    );
  }
}
