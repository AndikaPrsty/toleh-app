import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toleh/model/toko.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';

class FormEditToko extends StatefulWidget {
  const FormEditToko({
    Key key,
    @required this.toko,
  }) : super(key: key);

  final Toko toko;

  @override
  _FormEditTokoState createState() => _FormEditTokoState();
}

class _FormEditTokoState extends State<FormEditToko> {
  TextEditingController _namaTokoController = TextEditingController();
  TextEditingController _jamBukaController = TextEditingController();
  TextEditingController _jamTutupController = TextEditingController();
  TextEditingController _namaJalanController = TextEditingController();
  TextEditingController _provinsiController = TextEditingController();
  TextEditingController _kabupatenController = TextEditingController();
  TextEditingController _kecamatanController = TextEditingController();
  TextEditingController _kelurahanController = TextEditingController();
  TextEditingController _kodePosController = TextEditingController();

  @override
  void initState() {
    _namaTokoController.text = widget.toko.namaToko;
    _jamBukaController.text = widget.toko.jamBuka;
    _jamTutupController.text = widget.toko.jamTutup;
    _namaJalanController.text = widget.toko.jalan;
    _provinsiController.text = widget.toko.provinsi;
    _kabupatenController.text = widget.toko.kabupaten;
    _kecamatanController.text = widget.toko.kecamatan;
    _kelurahanController.text = widget.toko.kelurahan;
    _kodePosController.text = widget.toko.kodePos.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                controller: _namaTokoController,
                decoration: InputDecoration(
                    labelText: 'Nama Toko', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                controller: _namaJalanController,
                decoration: InputDecoration(
                    labelText: 'Nama Jalan', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                controller: _jamBukaController,
                decoration: InputDecoration(
                    labelText: 'Jam Buka', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextFormField(
                controller: _jamTutupController,
                decoration: InputDecoration(
                    labelText: 'Jam Tutup', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _provinsiController,
                decoration: InputDecoration(
                    labelText: 'Provinsi', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _kabupatenController,
                decoration: InputDecoration(
                    labelText: 'Kabupaten', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _kecamatanController,
                decoration: InputDecoration(
                    labelText: 'Kecamatan', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _kelurahanController,
                decoration: InputDecoration(
                    labelText: 'Kelurahan', border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _kodePosController,
                decoration: InputDecoration(
                    labelText: 'Kode Pos', border: OutlineInputBorder()),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      await _updateToko();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home(
                                    selectedPage: 0,
                                  )));
                    },
                    child: Text('Simpan'))),
          ],
        ),
      ),
    );
  }

  Future<void> _updateToko() async {
    final prefs = await SharedPreferences.getInstance();

    var user = jsonDecode(prefs.getString('user_data'));

    if (user != null) {
      try {
        var idUser = user['id'];
        print(idUser);
        http.Response response = await http.post(
            Uri.parse('http://192.168.0.102:5000/api/toko/update'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(<String, dynamic>{
              'id_toko': '${widget.toko.idToko}',
              'id_user': '$idUser',
              'jam_buka': '${_jamBukaController.text}',
              'jam_tutup': '${_jamTutupController.text}',
              'jalan': '${_namaJalanController.text}',
              'provinsi': '${_provinsiController.text}',
              'nama_toko': '${_namaTokoController.text}',
              'kabupaten': '${_kabupatenController.text}',
              'kecamatan': '${_kecamatanController.text}',
              'kelurahan': '${_kelurahanController.text}',
              'kode_pos': '${_kodePosController.text}'
            }));

        print(response.body);
      } catch (e) {
        print(e);
      }
    } else {
      return;
    }
  }

  @override
  void dispose() {
    _namaTokoController.dispose();
    _jamBukaController.dispose();
    _jamTutupController.dispose();
    _namaJalanController.dispose();
    _provinsiController.dispose();
    _kabupatenController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _kodePosController.dispose();
    super.dispose();
  }
}
