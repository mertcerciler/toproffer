import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login/app/home/campaign_details.dart';
import 'package:login/app/home/models/campaign_model.dart';
import 'package:login/app/services/database.dart';


class RestaurantHistoryCampaignList extends StatefulWidget {
  RestaurantHistoryCampaignList({@required this.campaign, @required this.database});//, @required this.onTap);
  final List<CampaignModel> campaign;
  final Database database;
 // final VoidCallback onTap;
  
   @override
  _RestaurantHistoryCampaignList createState() => _RestaurantHistoryCampaignList();
}
class _RestaurantHistoryCampaignList  extends State<RestaurantHistoryCampaignList > {
  Duration duration;
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.9,
      child: 
        Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                itemBuilder: (ctx, index) {
                  return Container(
                    child: widget.campaign[index].campaignType == "Momentarily"
                      ? Card(
                        
                          elevation: 5,
                          child: InkWell(
                           child: Container(
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: NetworkImage("${widget.campaign[index].imageUrl}"),
                                  //minRadius: 30,
                                  //maxRadius: 70,
                                  backgroundColor: Colors.blue[300],
                                  radius: 50,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.all(10),
                                          //height: 150,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                //content kısmı için refactor with container yapıp alignment: Alignment.center ekledik
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: new Text(
                                                    '${widget.campaign[index].title}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 21,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red[300],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Sized box eklendi altına da icon eklendi
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Icon(
                                                Icons.access_alarms,
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.all(10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                //content kısmı için refactor with container yapıp alignment: Alignment.center ekledik
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: new Text(
                                                    '${widget.campaign[index].content}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        //Category için fast food ekledik manuel altına da sized box ekledik
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Fast Food",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '\$${widget.campaign[index].oldPrice.toStringAsFixed(2)}',
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              ' --> \$${widget.campaign[index].newPrice.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            //sized box ekledik width 45 olan ve altına da duration için text box açtık
                                            SizedBox(
                                              width: 45,
                                            ),
                                            //Buraya duration gelecek
                                            
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          )
                          
                        )
                    : Card(
                      elevation: 5,
                      child: InkWell(
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: NetworkImage("${widget.campaign[index].imageUrl}"),
                                  //minRadius: 30,
                                  //maxRadius: 70,
                                  backgroundColor: Colors.blue[300],
                                  radius: 50,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.all(10),
                                          //height: 150,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                //content kısmı için refactor with container yapıp alignment: Alignment.center ekledik
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: new Text(
                                                    '${widget.campaign[index].title}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 21,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.red[300],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              //Sized box eklendi altına da icon eklendi
                                              SizedBox(
                                                width: 6,
                                              ),
                                              Icon(
                                                Icons.alarm_off,
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.all(10),
                                          //height: 150,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                //content kısmı için refactor with container yapıp alignment: Alignment.center ekledik
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  child: new Text(
                                                    '${widget.campaign[index].content}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        //Category için fast food ekledik manuel altına da sized box ekledik
                                        Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Fast Food",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              '\$${widget.campaign[index].oldPrice.toStringAsFixed(2)}',
                                              style: new TextStyle(
                                                  color: Colors.black,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              ' --> \$${widget.campaign[index].newPrice.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            //sized box ekledik width 45 olan ve altına da duration için text box açtık
                                            SizedBox(
                                              width: 45,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    )
                  );
                },
                itemCount: widget.campaign.length,
              ),
            ),
          ],
        ),
    );
  }
}
