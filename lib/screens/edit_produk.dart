import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:toleh/main.dart';

class EditProduk extends StatefulWidget {
  final String namaProduk;
  final String imageUrl;
  final String idProduk;
  final String idToko;
  final String idUser;

  const EditProduk(
      {Key key,
      @required this.namaProduk,
      @required this.imageUrl,
      @required this.idProduk,
      @required this.idToko,
      @required this.idUser})
      : super(key: key);
  @override
  _EditProdukState createState() => _EditProdukState();
}

class _EditProdukState extends State<EditProduk> {
  File _image;
  bool _isLoading = false;
  String _imageUrl;
  final ImagePicker picker = ImagePicker();

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
    _namaProdukController.text = widget.namaProduk;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          horizontal: BorderSide(color: Colors.black))),
                  child: Text(
                    'Edit Produk',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _namaProdukController,
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Note: biarkan gambar kosong jika anda hanya ingin mengganti nama produk!',
                          textAlign: TextAlign.center,
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
                                  await updateProduk();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Home(
                                                selectedPage: 0,
                                              )));
                                },
                                child: Text('Upload dan Simpan'))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  Future<void> updateProduk() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (_image != null) {
        http.Response imgBBResponse = await http.post(
            Uri.parse(
                'https://api.imgbb.com/1/upload?key=d361f3d20c52422be4e331693edcee97'),
            body: {'image': base64Encode(_image.readAsBytesSync())});
        var imageUrl = jsonDecode(imgBBResponse.body);
        setState(() {
          _imageUrl = imageUrl['data']['url'];
        });
      } else {
        setState(() {
          _imageUrl = widget.imageUrl;
        });
      }

      http.Response response = await http.post(
        Uri.parse('http://192.168.0.120:5000/api/produk/update'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'id_user': '${widget.idUser}',
          'id_toko': '${widget.idToko}',
          'id_produk': '${widget.idProduk}',
          'nama_produk': '${_namaProdukController.text}',
          'url_gambar': '$_imageUrl',
        }),
      );

      var decodedJson = jsonDecode(response.body);

      print(decodedJson);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
