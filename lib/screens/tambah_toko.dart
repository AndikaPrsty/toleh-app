import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toleh/model/user.dart';
import 'package:toleh/widgets/title.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';

class TambahTokoPage extends StatefulWidget {
  @override
  _TambahTokoPageState createState() => _TambahTokoPageState();
}

class _TambahTokoPageState extends State<TambahTokoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  ImagePicker picker = ImagePicker();
  Position _position;
  LocationPermission _permission;
  bool _isLoading = false;
  bool _isSuccess;

  User user;

  TextEditingController _namaTokoController = TextEditingController();
  TextEditingController _jamBukaController = TextEditingController();
  TextEditingController _jamTutupController = TextEditingController();
  TextEditingController _latitudeController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  TextEditingController _namaJalanController = TextEditingController();
  TextEditingController _provinsiController = TextEditingController();
  TextEditingController _kabupatenController = TextEditingController();
  TextEditingController _kecamatanController = TextEditingController();
  TextEditingController _kelurahanController = TextEditingController();
  TextEditingController _kodePosController = TextEditingController();

  Future<void> getImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: [CropAspectRatioPreset.ratio3x2],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      setState(() {
        _image = croppedImage;
      });
    }
  }

  Future<void> getLocationPermission() async {
    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied ||
        _permission == LocationPermission.deniedForever) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Akses GPS dibutuhkan!'),
              content: Text('Mohon nyalakan akses layanan lokasi'),
              actions: [
                TextButton(
                    onPressed: () async {
                      await Geolocator.openAppSettings();
                    },
                    child: Text('buka pengaturan aplikasi'))
              ],
            );
          });
    }
  }

  Future<void> getCurrentLocation() async {
    _position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('user_data') != null) {
        final userData = jsonDecode(prefs.getString('user_data'));
        user = User.fromJson(userData);

        print(user.id);
      }

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _namaTokoController.dispose();
    _jamBukaController.dispose();
    _jamTutupController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _namaJalanController.dispose();
    _provinsiController.dispose();
    _kabupatenController.dispose();
    _kecamatanController.dispose();
    _kelurahanController.dispose();
    _kodePosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: LoadingOverlay(
        isLoading: _isLoading,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              width: width,
              height: height,
              padding: EdgeInsets.only(bottom: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TitleWidget(
                      title: 'Tambah Toko',
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      child: _image != null
                          ? Image.file(
                              _image,
                              fit: BoxFit.cover,
                            )
                          : IconButton(
                              icon: Icon(Icons.add_a_photo),
                              onPressed: () {
                                getImage();
                              },
                            ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama Toko tidak boleh kosong';
                                }
                                return null;
                              },
                              controller: _namaTokoController,
                              decoration: InputDecoration(
                                  labelText: 'Nama Toko',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    keyboardType: TextInputType.datetime,
                                    controller: _jamBukaController,
                                    validator: (String value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Jam Buka tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Jam Buka',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: _jamTutupController,
                                    keyboardType: TextInputType.datetime,
                                    validator: (String value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Jam Tutup tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Jam Tutup',
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _latitudeController,
                                        validator: (String value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Latitude tidak boleh kosong';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Latitude',
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        controller: _longitudeController,
                                        validator: (String value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Longitude tidak boleh kosong';
                                          }
                                          return null;
                                        },
                                        enabled: false,
                                        decoration: InputDecoration(
                                            labelText: 'Longitude',
                                            border: OutlineInputBorder()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await getLocationPermission();
                                    await getCurrentLocation();
                                    setState(() {
                                      _latitudeController.text =
                                          _position.latitude.toString();
                                      _longitudeController.text =
                                          _position.longitude.toString();
                                      _isLoading = false;
                                    });
                                  },
                                  child: Text('lokasi terkini'))
                            ],
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _namaJalanController,
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama Jalan tidak boleh kosong';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Nama Jalan',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _provinsiController,
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'Provinsi tidak boleh kosong';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Provinsi',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _kabupatenController,
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kabupaten tidak boleh kosong';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Kabupaten',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _kecamatanController,
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kecamatan tidak boleh kosong';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Kecamatan',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _kelurahanController,
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kelurahan tidak boleh kosong';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Kelurahan',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: _kodePosController,
                              validator: (String value) {
                                if (value == null || value.isEmpty) {
                                  return 'Kode Pos tidak boleh kosong';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Kode Pos',
                                  border: OutlineInputBorder()),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.red),
                                  child: Text('Batal'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _tambahToko();

                                    if (_isSuccess == true) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('Tambah'),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _tambahToko() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });

        http.Response imgBBResponse = await http.post(
            Uri.parse(
                'https://api.imgbb.com/1/upload?key=d361f3d20c52422be4e331693edcee97'),
            body: {'image': base64Encode(_image.readAsBytesSync())});

        var imageUrl = jsonDecode(imgBBResponse.body);
        imageUrl = imageUrl['data']['url'];

        http.Response response = await http.post(
          Uri.parse('http://192.168.0.102:5000/api/toko/'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, dynamic>{
            'id_user': '${user.id}',
            'nama_toko': '${_namaTokoController.text}',
            'url_gambar': '$imageUrl',
            'jalan': '${_namaJalanController.text}',
            'jam_buka': '${_jamBukaController.text}',
            'jam_tutup': '${_jamTutupController.text}',
            'latitude': '${_latitudeController.text}',
            'longitude': '${_longitudeController.text}',
            'kode_pos': '${_kodePosController.text}',
            'kabupaten': '${_kabupatenController.text}',
            'provinsi': '${_provinsiController.text}',
            'kecamatan': '${_kecamatanController.text}',
            'kelurahan': '${_kelurahanController.text}',
          }),
        );

        var decodeJson = jsonDecode(response.body);

        print(decodeJson);

        setState(() {
          _isSuccess = true;
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
