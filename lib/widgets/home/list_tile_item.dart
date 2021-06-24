import 'package:flutter/material.dart';

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    Key key,
    @required this.thumbnail,
    @required this.namaToko,
    @required this.alamat,
    @required this.jarak,
  }) : super(key: key);

  final Widget thumbnail;
  final String namaToko;
  final String alamat;
  final int jarak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: _ShopDescription(
              namaToko: namaToko,
              alamat: alamat,
              jarak: jarak,
            ),
          ),
          SizedBox(
            width: 8,
          )
        ],
      ),
    );
  }
}

class _ShopDescription extends StatelessWidget {
  const _ShopDescription({
    Key key,
    @required this.namaToko,
    @required this.alamat,
    @required this.jarak,
  }) : super(key: key);

  final String namaToko;
  final String alamat;
  final int jarak;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            namaToko,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            'Alamat: $alamat',
            style: const TextStyle(fontSize: 10.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 3.0)),
          Text(
            'Jarak: $jarak Meter',
            style: const TextStyle(fontSize: 10.0),
          ),
        ],
      ),
    );
  }
}
