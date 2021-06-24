import 'package:flutter/material.dart';
import 'package:toleh/model/toko.dart';

import 'form_edit_toko.dart';

class MenuGambarButton extends StatefulWidget {
  const MenuGambarButton({
    Key key,
    @required this.toko,
  }) : super(key: key);

  final Toko toko;

  @override
  _MenuGambarButtonState createState() => _MenuGambarButtonState();
}

class _MenuGambarButtonState extends State<MenuGambarButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      top: 5,
      child: PopupMenuButton(
        onSelected: (value) {
          setState(() {});
        },
        icon: Icon(Icons.more_vert, color: Colors.white),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            value: 'Hapus Toko',
            child: ListTile(
              title: Text('Hapus Toko'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Hapus Toko'),
                      content:
                          Text('Apakah anda yakin ingin menghapus toko ini?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('batal')),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('hapus')),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          PopupMenuItem(
              child: ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text('Edit Gambar Toko'),
          )),
          PopupMenuItem(
              child: ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: Text('Perbarui Lokasi'),
          )),
          PopupMenuItem(
              child: ListTile(
            title: Text('Edit Deskripsi Toko'),
            onTap: () {
              Navigator.pop(context);

              return showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Edit Deskripsi Toko',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border.symmetric(
                                    horizontal:
                                        BorderSide(color: Colors.black))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormEditToko(toko: widget.toko),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}
