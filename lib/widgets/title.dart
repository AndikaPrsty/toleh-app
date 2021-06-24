import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;

  const TitleWidget({
    Key key,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.grey[400],
          border:
              Border.symmetric(horizontal: BorderSide(color: Colors.black))),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
