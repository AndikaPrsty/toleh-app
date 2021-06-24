import 'package:flutter/material.dart';
import 'package:toleh/screens/edit_produk.dart';

class ProdukItem extends StatelessWidget {
  const ProdukItem({
    Key key,
  }) : super(key: key);

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
                  'https://id-test-11.slatic.net/p/1b81775398a3cbc68cd0845ba97f936f.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
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
                                      onPressed: () {}, child: Text('Hapus')),
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
                            builder: (BuildContext context) => EditProduk()));
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Bakpia sadas sadasd',
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
}
