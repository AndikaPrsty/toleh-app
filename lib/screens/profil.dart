import 'package:toleh/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toleh/screens/tambah_toko.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key key,
    @required this.width,
    @required this.user,
  }) : super(key: key);

  final User user;

  final double width;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.center,
                width: widget.width,
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.black))),
                child: Text(
                  'Profil Saya',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Positioned(
                right: 0,
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert),
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                        child: ListTile(
                      title: Text('Logout'),
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove('user_data');
                        Phoenix.rebirth(context);
                      },
                    ))
                  ],
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.black))),
            width: widget.width,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'),
                        fit: BoxFit.fill),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          widget.user.nama,
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            width: widget.width,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black),
              ),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.date_range)),
                      Expanded(
                        child: Text(
                          'bergabung pada ' +
                              DateFormat.yMMMMEEEEd('id').format(
                                  DateTime.parse(widget.user.createdAt)),
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.account_box)),
                      Expanded(
                        child: Text(
                          widget.user.role,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.phone)),
                      Expanded(
                        child: Text(
                          widget.user.nomorTelepon,
                          maxLines: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            width: widget.width,
            child: Column(
              children: [
                Text('Tambahkan Toko Oleh-Oleh Anda Sekarang Juga!!'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => TambahTokoPage(),
                        ),
                      );
                    },
                    child: Text('Disini')),
              ],
            ),
          )
        ],
      ),
    );
  }
}
