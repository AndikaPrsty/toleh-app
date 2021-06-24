import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toleh/auth/signIn_page.dart';
import 'package:toleh/model/user.dart';
import 'package:toleh/screens/profil.dart';

class Akun extends StatefulWidget {
  @override
  _AkunState createState() => _AkunState();
}

class _AkunState extends State<Akun> {
  User user;
  bool _isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('user_data') != null) {
        final userData = jsonDecode(prefs.getString('user_data'));
        user = User.fromJson(userData);

        print(user.nama);
      }

      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : (user != null
            ? ProfilePage(
                width: width,
                user: user,
              )
            : SignInPage());
  }
}
