import 'package:flutter/material.dart';

class NamaToko extends StatelessWidget {
  const NamaToko({
    Key key,
    @required this.namaToko,
  }) : super(key: key);

  final String namaToko;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 10,
      left: 10,
      child: Text(
        namaToko,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                  // bottomLeft
                  offset: Offset(-1.5, -1.5),
                  color: Colors.black),
              Shadow(
                  // bottomRight
                  offset: Offset(1.5, -1.5),
                  color: Colors.black),
              Shadow(
                  // topRight
                  offset: Offset(1.5, 1.5),
                  color: Colors.black),
              Shadow(
                  // topLeft
                  offset: Offset(-1.5, 1.5),
                  color: Colors.black),
            ]),
      ),
    );
  }
}
