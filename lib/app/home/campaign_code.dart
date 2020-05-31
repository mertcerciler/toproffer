import 'package:flutter/material.dart';

class CampaignCode  extends StatelessWidget {
  const CampaignCode({Key key, @required this.code}) : super(key: key);
  final String code;

  @override
  Widget build(BuildContext context) {
    String newCode = this.code;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(50, 10, 50, 20),
        child: Text('Campaign Code is $newCode',
        style: TextStyle(color: Colors.blue[900], height: 4))
    );
  }
}