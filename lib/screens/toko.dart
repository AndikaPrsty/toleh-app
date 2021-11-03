import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toleh/model/toko.dart';
import 'package:toleh/model/user.dart';
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
  final Toko toko;
  User user;

  _TokoPageState({
    @required this.toko,
  });

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var prefs = await SharedPreferences.getInstance();
      user = prefs.getString('user_data') != null
          ? User.fromJson(jsonDecode(prefs.getString('user_data')))
          : null;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: user != null
          ? (user.id == toko.idUser || user.role == 'ADMIN'
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => TambahProduk(
                              toko: toko,
                              user: user,
                            )));
                  },
                  child: Icon(Icons.add),
                )
              : SizedBox())
          : SizedBox(),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Container(
                child: Stack(
                  children: [
                    GambarToko(imageUrl: toko.imageUrl),
                    NamaToko(namaToko: toko.namaToko),
                    user != null
                        ? (user.id == toko.idUser || user.role == 'ADMIN'
                            ? MenuGambarButton(
                                toko: toko,
                                user: user,
                              )
                            : SizedBox())
                        : SizedBox()
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
              ListProduk(
                toko: toko,
                idUser: user != null ? user.id : '',
                userRole: user != null ? user.role : '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
