import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:toleh/model/toko.dart';
import 'package:http/http.dart' as http;

import 'package:toleh/widgets/home/list_toko.dart';
import 'package:toleh/widgets/loading_indicator.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  Position _position;
  FloatingSearchBarController _searchController;
  GlobalKey _searchBarKey = GlobalKey<FloatingSearchBarState>();
  List<Toko> tokos = <Toko>[];
  bool loading = false;

  @override
  void initState() {
    _searchController = FloatingSearchBarController();
    _getTokos();
    print('tokos: $tokos');
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getTokos() async {
    setState(() {
      loading = true;
    });

    try {
      http.Response response =
          await http.get(Uri.parse('http://192.168.0.120:5000/api/toko/'));
      List toko = jsonDecode(response.body);
      print(toko);
      tokos = toko.map((dynamic json) => Toko.fromJson(json)).toList();
      await _getCurrentLocation();
      _calculateDistance();
      setState(() {
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getCurrentLocation() async {
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  void _calculateDistance() {
    for (final toko in tokos) {
      setState(() {
        toko.distance = Geolocator.distanceBetween(_position.latitude,
                _position.longitude, toko.latitude, toko.longitude)
            .toInt();
      });
    }
    tokos.sort((a, b) => a.distance.compareTo(b.distance));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 70),
            child: Text(
              'Menampilkan toko oleh-oleh terdekat :',
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
        loading ? LoadingIndicator() : ListToko(tokos: tokos),
        Container(
          child: FloatingSearchBar(
            onSubmitted: (String value) {
              print('searching $value');
              _searchController.close();
            },
            clearQueryOnClose: false,
            hint: 'Bakpia',
            key: _searchBarKey,
            controller: _searchController,
            builder: (context, _) => buildBody(),
          ),
        ),
      ],
    );
  }

  Widget buildBody() {
    return ClipRRect(borderRadius: BorderRadius.circular(8));
  }
}
