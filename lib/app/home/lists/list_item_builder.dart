import 'package:flutter/material.dart';
import 'package:login/app/home/empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, List<T> item);

class ListItemBuilder<T> extends StatelessWidget {
  const ListItemBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;


  @override 
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final items = snapshot.data;
      if (items.isNotEmpty) {
       return(itemBuilder(context, items));
      } else {
        print('No posts');
        return EmptyContent(
          title: 'No posts available',
        );
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: snapshot.error.toString()
      );
    }
    return Center(child: CircularProgressIndicator());
  }
}
