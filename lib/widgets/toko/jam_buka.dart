import 'package:flutter/material.dart';

class JamBukaToko extends StatelessWidget {
  const JamBukaToko({
    Key key,
    @required this.jamBuka,
    @required this.jamTutup,
  }) : super(key: key);

  final String jamBuka;
  final String jamTutup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.access_time)),
          Text('$jamBuka - $jamTutup'),
        ],
      ),
    );
  }
}
