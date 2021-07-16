import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toleh/main.dart';
import 'package:toleh/model/toko.dart';
import 'package:toleh/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:toleh/screens/edit_gambar_toko.dart';
import 'form_edit_toko.dart';

class MenuGambarButton extends StatefulWidget {
  const MenuGambarButton({
    Key key,
    @required this.toko,
    @required this.user,
  }) : super(key: key);

  final Toko toko;
  final User user;

  @override
  _MenuGambarButtonState createState() => _MenuGambarButtonState();
}

class _MenuGambarButtonState extends State<MenuGambarButton> {
  User user;
  Position _position;
  @override
  void initState() {
    super.initState();
  }

  Future<void> getCurrentLocation() async {
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

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
                            onPressed: () async {
                              await _hapusToko();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(
                                            selectedPage: 0,
                                          )));
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => EditGambarToko(
                          toko: widget.toko, user: widget.user)));
            },
            title: Text('Edit Gambar Toko'),
          )),
          PopupMenuItem(
              child: ListTile(
            onTap: () {
              Navigator.pop(context);

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Perbarui Lokasi Toko'),
                    content: Text(
                        'Perbarui lokasi akan otomatis sesuai dengan lokasi anda saat ini!'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('batal')),
                      TextButton(
                          onPressed: () async {
                            await getCurrentLocation();
                            await _updateLokasiToko();
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Home(
                                          selectedPage: 0,
                                        )));
                          },
                          child: Text('perbarui')),
                    ],
                  );
                },
              );
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

  Future<void> _hapusToko() async {
    try {
      if (widget.user != null) {
        http.Response response = await http.post(
            Uri.parse('http://192.168.0.120:5000/api/toko/delete'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(<String, dynamic>{
              'id_toko': '${widget.toko.idToko}',
              'id_user': '${widget.user.id}'
            }));
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateLokasiToko() async {
    try {
      http.Response response = await http.post(
          Uri.parse('http://192.168.0.120:5000/api/toko/update_koordinat'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(<String, dynamic>{
            'latitude': '${_position.latitude}',
            'longitude': '${_position.longitude}',
            'id_toko': '${widget.toko.idToko}',
            'id_user': '${widget.user.id}'
          }));

      var decodedJson = jsonDecode(response.body);
      print(decodedJson);
    } catch (e) {
      print(e);
    }
  }
}
