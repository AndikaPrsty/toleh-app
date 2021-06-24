import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toleh/widgets/title.dart';

class TambahProduk extends StatefulWidget {
  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  File _image;

  final ImagePicker picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            TitleWidget(title: 'Tambah Produk'),
            Form(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Nama Produk', border: OutlineInputBorder()),
                  ),
                ),
                Container(
                  width: 300,
                  height: 300,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(
                          _image,
                          fit: BoxFit.cover,
                        )
                      : IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: getImage,
                        ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Batal')),
                      ),
                      ElevatedButton(
                          onPressed: () {}, child: Text('Upload dan Simpan'))
                    ],
                  ),
                )
              ],
            ))
          ],
        ),
      )),
    );
  }
}
