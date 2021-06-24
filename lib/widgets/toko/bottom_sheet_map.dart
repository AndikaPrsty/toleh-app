import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BottomMap extends StatefulWidget {
  const BottomMap({
    Key key,
    @required this.latitude,
    @required this.longitude,
  }) : super(key: key);

  final double latitude;
  final double longitude;

  @override
  _BottomMapState createState() => _BottomMapState();
}

class _BottomMapState extends State<BottomMap> {
  GoogleMapController _mapController;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.latitude, widget.longitude),
        zoom: 15,
      ),
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      markers: {
        Marker(
          markerId: MarkerId('${widget.latitude}'),
          position: LatLng(widget.latitude, widget.longitude),
        ),
      },
    );
  }
}
