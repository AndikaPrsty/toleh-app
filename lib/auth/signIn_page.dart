import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toleh/auth/register_page.dart';
import 'package:toleh/main.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                controller: _emailController,
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
                                decoration: const InputDecoration(
                                    labelText: 'Password'),
                                controller: _passwordController,
                                obscureText: true,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Belum punya akun?'),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RegisterPage()));
                                    },
                                    child: Text('Daftar'))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                child: Text('Login'),
                                onPressed: () async {
                                  await _login();

                                  if (_errorMessage != '') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(_errorMessage)));
                                  }
                                  if (_success) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (_) => Home(
                                          selectedPage: 2,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ))
                  ],
                )),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final prefs = await SharedPreferences.getInstance();

    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });
        http.Response response = await http.post(
            Uri.parse('http://192.168.0.120:5000/api/auth/login'),
            headers: <String, String>{'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': "${_emailController.text}",
              'password': "${_passwordController.text}"
            }));
        print(response.request);
        // print('error' + response.toString());
        var currentUser = response.body;
        var decodeJson = jsonDecode(currentUser);

        print(decodeJson['error']);

        if (decodeJson['error'] != null) {
          print(true);
          setState(() {
            _success = false;
            _errorMessage = decodeJson['error'];
            _passwordController.text = '';
          });
        }

        var userObject = decodeJson['user'];

        Map<String, dynamic> map = {
          'id': userObject['id'],
          'nama': userObject['nama'],
          'email': userObject['email'],
          'role': userObject['role'],
          'telp': userObject['telp'],
          'createdAt': userObject['createdAt'],
        };

        String rawJson = jsonEncode(map);

        print(rawJson);

        prefs.setString('user_data', rawJson);
        print(jsonDecode(rawJson)['nama']);

        setState(() {
          _success = true;
          _errorMessage = '';
        });
      }
    } catch (e) {
      print('someting went wrong');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
