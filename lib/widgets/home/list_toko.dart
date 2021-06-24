import 'package:flutter/material.dart';
import 'package:toleh/model/toko.dart';
import 'package:toleh/screens/toko.dart';
import 'package:toleh/widgets/home/list_tile_item.dart';

class ListToko extends StatelessWidget {
  const ListToko({
    Key key,
    @required this.tokos,
  }) : super(key: key);

  final List<Toko> tokos;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(5),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                splashColor: Colors.blue.withAlpha(30),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => TokoPage(toko: tokos[index])));
                },
                child: Container(
                  width: 300,
                  height: 100,
                  child: CustomListItem(
                    alamat: '${tokos[index].alamat}',
                    jarak: tokos[index].distance,
                    thumbnail: Image.network(
                      tokos[index].imageUrl,
                    ),
                    namaToko: '${tokos[index].namaToko}',
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: tokos.length,
      ),
    );
  }
}
