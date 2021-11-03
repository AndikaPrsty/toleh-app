import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:toleh/model/toko.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<MapPage> {
  GoogleMapController _mapController;
  LocationPermission _permission;
  Position _position;

  static final CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(-7.8875851, 110.3273665), zoom: 13);

  List<Toko> tokos = <Toko>[];

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<MarkerId, Marker> sortedMarkers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getTokos() async {
    try {
      http.Response response =
          await http.get(Uri.parse('http://192.168.0.102:5000/api/toko/'));

      List toko = jsonDecode(response.body);

      tokos = toko.map((json) => Toko.fromJson(json)).toList();

      print('tokos here ==========================');
      // print(tokos.toList());
      for (final toko in tokos) {
        print(toko.alamat);
      }
    } catch (e) {
      print(e);
    }
  }

  void _setMarkers() {
    for (final toko in tokos) {
      print(toko.alamat);
      final MarkerId markerId = MarkerId(toko.latitude.toString());
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(toko.latitude, toko.longitude),
        infoWindow: InfoWindow(title: toko.namaToko),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            markerId.value.toString() == tokos[0].latitude.toString()
                ? BitmapDescriptor.hueGreen
                : BitmapDescriptor.hueRed),
      );

      setState(() {
        markers[markerId] = marker;
      });
    }
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
    // print('pembuktian2 $locations');
  }

  Future<void> _openAppSetting() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Akses GPS dibutuhkan!'),
            content: Text('Anda harus mengizinkan layanan lokasi'),
            actions: [
              TextButton(
                  onPressed: () async {
                    await Geolocator.openAppSettings();
                  },
                  child: Text('Buka Pengaturan')),
            ],
          );
        });
  }

  Future<void> _getLocationPermission() async {
    _permission = await Geolocator.requestPermission();
    if (_permission == LocationPermission.deniedForever ||
        _permission == LocationPermission.denied) {
      await _openAppSetting();
    }
  }

  Future<void> _moveToCurrentLocation() async {
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(_position.latitude, _position.longitude), zoom: 14.5)));
    await _getTokos();
    _calculateDistance();
    _setMarkers();
    for (final toko in tokos) {
      print('tokos ${toko.latitude}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _kGooglePlex,
      buildingsEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      compassEnabled: true,
      rotateGesturesEnabled: true,
      trafficEnabled: true,
      markers: Set<Marker>.of(markers.values),
      onMapCreated: (GoogleMapController controller) async {
        _mapController = controller;
        await _getLocationPermission();
        _moveToCurrentLocation();
      },
      onTap: (LatLng latlang) {
        print('koordinat: ' + latlang.toString());
      },
    );
  }
}
