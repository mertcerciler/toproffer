import 'dart:async';

import 'package:flutter/material.dart';
import 'package:login/app/home/restaurant_active_campaigns.dart';
import 'package:login/app/home/restaurant_settings.dart';
import 'package:login/app/home/user_interests.dart';
import 'package:login/app/sign_in/sign_up_restaurant_page.dart';
import 'package:provider/provider.dart';
import 'home/campaign_list_page_2.dart';
import 'services/database.dart';

class UserTypePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<String>(
      stream: database.getUserTypeStream(),
      builder: (context, snapshot)  {
        if(snapshot.hasData) {
          final userType = snapshot.data;
          if (userType == '(customers)') {
            return StreamBuilder(
              stream: database.getUserInsterestsStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return UserInterestsPage();
                }
                return CampaignListPage(database: database);
              } );
          }
          else if (userType == '(restaurants)') {
            return RestaurantsActiveCampaigns(database: database);
          }
          else {
            return SignUpRestaurantPage.create(context);
          }
        }
        else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}