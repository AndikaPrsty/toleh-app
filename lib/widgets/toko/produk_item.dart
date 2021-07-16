import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toleh/main.dart';
import 'package:toleh/screens/edit_produk.dart';
import 'package:http/http.dart' as http;

class ProdukItem extends StatefulWidget {
  final bool showMenu;
  final String idProduk;
  final String idUser;
  final String idToko;
  final String namaProduk;
  final String imageUrl;
  const ProdukItem({
    Key key,
    @required this.showMenu,
    @required this.namaProduk,
    @required this.imageUrl,
    @required this.idProduk,
    @required this.idUser,
    @required this.idToko,
  }) : super(key: key);

  @override
  _ProdukItemState createState() => _ProdukItemState();
}

class _ProdukItemState extends State<ProdukItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(3, 3),
          )
        ]),
        child: Stack(
          children: [
            ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black54, Colors.transparent],
                ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
              },
              blendMode: BlendMode.darken,
              child: Container(
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            widget.showMenu
                ? Positioned(
                    right: -5,
                    top: 0,
                    child: PopupMenuButton(
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          child: ListTile(
                            title: Text('Hapus Produk'),
                            onTap: () {
                              Navigator.pop(context);
                              return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Hapus Produk'),
                                      content: Text(
                                          'Apakah anda yakin ingin menghapus produk ini?'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('Batal')),
                                        TextButton(
                                            onPressed: () async {
                                              await _hapusProduk();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Home(
                                                            selectedPage: 0,
                                                          )));
                                            },
                                            child: Text('Hapus')),
                                      ],
                                    );
                                  });
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            title: Text('Edit Produk'),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => EditProduk(
                                        namaProduk: widget.namaProduk,
                                        imageUrl: widget.imageUrl,
                                        idToko: widget.idToko,
                                        idProduk: widget.idProduk,
                                        idUser: widget.idUser,
                                      )));
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            Positioned(
              bottom: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  widget.namaProduk,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                            // bottomLeft
                            offset: Offset(-1.5, -1.5),
                            color: Colors.black),
                        Shadow(
                            // bottomRight
                            offset: Offset(1.5, -1.5),
                            color: Colors.black),
                        Shadow(
                            // topRight
                            offset: Offset(1.5, 1.5),
                            color: Colors.black),
                        Shadow(
                            // topLeft
                            offset: Offset(-1.5, 1.5),
                            color: Colors.black),
                      ]),
                ),
              ),
            )
          ],
        ));
  }

  Future<void> _hapusProduk() async {
    try {
      http.Response response = await http.post(
          Uri.parse('http://192.168.0.120:5000/api/produk/delete'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(<String, dynamic>{
            'id_toko': '${widget.idToko}',
            'id_user': '${widget.idUser}',
            'id_produk': '${widget.idProduk}',
          }));
      print(response.body);
    } catch (e) {
      print(e);
    }
  }
}
