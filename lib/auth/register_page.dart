import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _namaController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  bool _success;
  String _errorMessage = '';

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
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Daftar',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          return null;
                        },
                        controller: _emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong';
                          }
                          return null;
                        },
                        controller: _namaController,
                        decoration: InputDecoration(labelText: 'Nama'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Nomor Telepon tidak boleh kosong';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.phone,
                        controller: _phoneNumberController,
                        decoration: InputDecoration(labelText: 'Nomor Telepon'),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Sudah punya akun?'),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Login'))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () async {
                            await _register();
                            if (_errorMessage != '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(_errorMessage)));
                            }
                            if (_success) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Register')),
                    ),
                  ],
                )),
          )),
        ),
      ),
    );
  }

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _register() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });
        print('send to api');
        http.Response response = await http.post(
            Uri.parse('http://192.168.0.120:5000/api/auth/register'),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: jsonEncode({
              'nama': _namaController.text,
              'email': '${_emailController.text}',
              'password': '${_passwordController.text}',
              'telp': _phoneNumberController.text,
              'role': 'ADMIN'
            }));

        var decodeJson = jsonDecode(response.body);

        if (decodeJson['error'] != null) {
          setState(() {
            _success = false;
            _errorMessage = decodeJson['error'];
          });
        } else {
          setState(() {
            _success = true;
            _errorMessage = '';
          });
        }
      } else {
        _success = false;
      }
    } catch (e) {
      print('something went wrong');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
