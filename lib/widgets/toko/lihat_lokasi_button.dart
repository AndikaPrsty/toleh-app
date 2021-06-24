import 'package:flutter/material.dart';

import 'bottom_sheet_map.dart';

class LihatLokasiButton extends StatelessWidget {
  const LihatLokasiButton({
    Key key,
    @required this.latitude,
    @required this.longitude,
  }) : super(key: key);

  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        onPressed: () {
          return showModalBottomSheet(
              enableDrag: false,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  child: BottomMap(latitude: latitude, longitude: longitude),
                );
              });
        },
        icon: Icon(Icons.map),
        label: Text('Lihat Lokasi'));
  }
}
