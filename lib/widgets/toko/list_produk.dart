import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toleh/model/produk.dart';
import 'package:toleh/model/toko.dart';
import 'package:toleh/widgets/loading_indicator.dart';
import 'package:toleh/widgets/toko/produk_item.dart';
import 'package:http/http.dart' as http;

class ListProduk extends StatefulWidget {
  final Toko toko;
  final String idUser;
  final String userRole;
  const ListProduk({
    Key key,
    @required this.toko,
    @required this.idUser,
    @required this.userRole,
  }) : super(key: key);

  @override
  _ListProdukState createState() => _ListProdukState();
}

class _ListProdukState extends State<ListProduk> {
  List<Produk> produk = <Produk>[];
  bool _loading;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await _getProduk();
    });

    super.initState();
  }

  Future<void> _getProduk() async {
    setState(() {
      _loading = true;
    });
    try {
      http.Response response = await http.post(
          Uri.parse('http://192.168.0.102:5000/api/produk/'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
              <String, dynamic>{'id_toko': '${widget.toko.idToko}'}));
      List prdk = jsonDecode(response.body);
      print(prdk);
      produk = prdk.map((dynamic json) => Produk.fromJson(json)).toList();
      print(produk);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !_loading
        ? Expanded(
            child: Container(
              child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(10),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: produk
                      .map((e) => ProdukItem(
                            namaProduk: e.namaProduk,
                            imageUrl: e.imageUrl,
                            idProduk: e.id,
                            idToko: e.idToko,
                            idUser: widget.idUser,
                            toko: widget.toko,
                            userRole: widget.userRole,
                            hargaProduk: e.hargaProduk,
                            detailProduk: e.detailProduk,
                          ))
                      .toList()),
            ),
          )
        : Center(child: LoadingIndicator());
  }
}
