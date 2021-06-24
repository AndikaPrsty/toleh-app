import 'package:flutter/material.dart';
import 'package:toleh/widgets/toko/produk_item.dart';

class ListProduk extends StatelessWidget {
  const ListProduk({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: List.generate(
            50,
            (index) => ProdukItem(),
          )),
    ));
  }
}
