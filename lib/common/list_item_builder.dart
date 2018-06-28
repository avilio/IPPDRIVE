import 'package:flutter/material.dart';

typedef Widget ItemWidgetBuilder<T>(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  final List<T> items;
  final ItemWidgetBuilder<T> itemBuilder;

  const ListItemsBuilder({Key key, this.items, this.itemBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items != null) {
      if (items.isNotEmpty)
        return _buildList();
      else
        return _placeHolder();
    } else
      return Center(child: CircularProgressIndicator());
  }

  Widget _buildList() {

    print(items);
    return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => itemBuilder(context, items[index]));
  }

  Widget _placeHolder() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Nada Para Mostrar',
              style: TextStyle(fontSize: 16.0),
              textAlign: TextAlign.center
            )
          ],
        ),
      );
}
