import 'package:flutter/material.dart';
import 'package:toleh/model/toko.dart';

class FormEditToko extends StatelessWidget {
  const FormEditToko({
    Key key,
    @required this.toko,
  }) : super(key: key);

  final Toko toko;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                initialValue: toko.alamat,
                decoration: InputDecoration(
                    labelText: 'Alamat', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Jam Buka', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Provinsi', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Kabupaten', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Kecamatan', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Kelurahan', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: 'Kode Pos', border: OutlineInputBorder()),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Simpan'))),
          ],
        ),
      ),
    );
  }
}
