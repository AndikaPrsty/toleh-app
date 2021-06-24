import 'package:flutter/material.dart';

class AlamatToko extends StatelessWidget {
  const AlamatToko({
    Key key,
    @required this.alamat,
  }) : super(key: key);

  final String alamat;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.place_outlined)),
        Expanded(
          child: Text(
            alamat,
            maxLines: 4,
          ),
        )
      ],
    );
  }
}
