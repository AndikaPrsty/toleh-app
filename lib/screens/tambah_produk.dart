import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:toleh/main.dart';
import 'package:toleh/model/toko.dart';
import 'package:toleh/model/user.dart';
import 'package:toleh/widgets/title.dart';
import 'package:http/http.dart' as http;

class TambahProduk extends StatefulWidget {
  final User user;
  final Toko toko;

  const TambahProduk({Key key, @required this.user, @required this.toko})
      : super(key: key);

  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  File _image;
  bool _isLoading = false;
  bool _isSuccess;
  final ImagePicker picker = ImagePicker();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _namaProdukController = TextEditingController();

  Future<void> getImage() async {
    final pickedImage = await picker.getImage(source: ImageSource.camera);
    if (pickedImage != null) {
      File croppedImage = await ImageCropper.cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: [CropAspectRatioPreset.square],
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

  @override
  void initState() {
    print(widget.user.id);
    print(widget.toko.idToko);
    super.initState();
  }

  @override
  void dispose() {
    _namaProdukController.dispose();
    super.dispose();
  }

  Future<void> _tambahProduk() async {
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

        print(imageUrl);

        imageUrl = imageUrl['data']['url'];

        http.Response response = await http.post(
          Uri.parse('http://192.168.0.120:5000/api/produk/add'),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, dynamic>{
            'id_user': '${widget.user.id}',
            'id_toko': '${widget.toko.idToko}',
            'url_gambar': '$imageUrl',
            'nama_produk': '${_namaProdukController.text}',
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

  @override
  Widget build(BuildContext context) {
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
          body: SafeArea(
              child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                TitleWidget(title: 'Tambah Produk'),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _namaProdukController,
                            validator: (String value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama Produk tidak boleh kosong';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText: 'Nama Produk',
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Container(
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
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Batal')),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await _tambahProduk();
                                    print('hello?');
                                    if (_isSuccess == true) {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  Home(
                                                    selectedPage: 0,
                                                  )));
                                    }
                                  },
                                  child: Text('Upload dan Simpan'))
                            ],
                          ),
                        )
                      ],
                    ))
              ],
            ),
          )),
        ),
      ),
    );
  }
}
