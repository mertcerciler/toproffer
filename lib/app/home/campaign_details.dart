import 'package:flutter/material.dart';
import 'package:login/app/home/campaign_details_customer.dart';
import 'package:login/app/home/campaign_details_restaurant.dart';
import 'package:login/app/home/models/campaign_model.dart';
import 'package:login/app/services/database.dart';
import 'package:provider/provider.dart';




class CampaignDetailsPage extends StatefulWidget {
  CampaignDetailsPage({Key key, this.title, @required this.campaign, @required this.database}) : super(key: key);
  final String title;
  final CampaignModel campaign;
  final Database database;

  static Future<void> show(BuildContext context, CampaignModel campaign) async {
      final database = Provider.of<Database>(context, listen: false);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CampaignDetailsPage(campaign: campaign, database: database),
          fullscreenDialog: true,
        )
      );
  }
  @override
  _CampaignDetailsPage createState() => _CampaignDetailsPage();
}

class _CampaignDetailsPage extends State<CampaignDetailsPage> {
  @override

  Widget build(BuildContext context) {
    return StreamBuilder(stream: widget.database.getUserTypeStream(),
    builder: (context, snapshot) {
      final userType = snapshot.data;
      if (userType == '(customers)') {
        return CampaignDetailsCustomerPage(campaign: widget.campaign, database: widget.database);
      }
      return CampaignDetailsRestaurantPage(campaign: widget.campaign, database: widget.database);
    });
    
  }
}
