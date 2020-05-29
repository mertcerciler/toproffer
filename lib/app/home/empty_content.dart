import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  EmptyContent({@required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          this.title,
          style: Theme.of(context).textTheme.title,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            height: 200,
            child: Image.asset(
              'assets/waiting.png',
              fit: BoxFit.cover,
            )),
      ],
    );
  }
}