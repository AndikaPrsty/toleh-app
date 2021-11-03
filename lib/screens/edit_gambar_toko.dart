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

class EditGambarToko extends StatefulWidget {
  final Toko toko;
  final User user;

  const EditGambarToko({Key key, @required this.toko, @required this.user})
      : super(key: key);

  @override
  _EditGambarTokoState createState() => _EditGambarTokoState();
}

class _EditGambarTokoState extends State<EditGambarToko> {
  File _image;

  final ImagePicker picker = ImagePicker();
  bool _isLoading = false;

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

  @override
  void initState() {
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
          child: Column(
            children: [
              TitleWidget(title: 'Ubah Gambar Toko'),
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
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Batal')),
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          await updateImage();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => Home(
                                selectedPage: 0,
                              ),
                            ),
                          );
                        },
                        child: Text('Upload dan Simpan'))
                  ],
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  Future<void> updateImage() async {
    try {
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
        Uri.parse('http://192.168.0.102:5000/api/toko/update_gambar'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, dynamic>{
          'id_user': '${widget.user.id}',
          'id_toko': '${widget.toko.idToko}',
          'url_gambar': '$imageUrl',
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
