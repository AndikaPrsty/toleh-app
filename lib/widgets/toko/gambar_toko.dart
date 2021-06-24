import 'package:flutter/material.dart';

class GambarToko extends StatelessWidget {
  const GambarToko({
    Key key,
    @required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black54, Colors.transparent],
          ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
        },
        blendMode: BlendMode.darken,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
      ),
      height: 200,
      width: MediaQuery.of(context).size.width,
    );
  }
}
