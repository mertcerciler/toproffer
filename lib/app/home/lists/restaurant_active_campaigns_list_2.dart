import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login/app/home/campaign_details.dart';
import 'package:login/app/home/models/campaign_model.dart';
import 'package:login/app/services/database.dart';

class RestaurantCampaignList extends StatefulWidget {
  RestaurantCampaignList(
      {@required this.campaign,
      @required this.database}); //, @required this.onTap);
  final List<CampaignModel> campaign;
  final Database database;
  // final VoidCallback onTap;

  @override
  _RestaurantCampaignList createState() => _RestaurantCampaignList();
}

class _RestaurantCampaignList extends State<RestaurantCampaignList> {
  Duration duration;
  bool checkDuration = false;

  _showDuration(int index) {
    Timer _timerCampaign;
    DateTime now = DateTime.now().toLocal();
    duration = widget.campaign[index].campaignFinished.difference(now);
    const oneSec = const Duration(seconds: 1);
    _timerCampaign = new Timer.periodic(oneSec, (Timer timer) {
      if (!mounted) return;
      setState(() {
        if ((duration - oneSec).inSeconds < 1) {
          checkDuration = true;
         /* removeCampaign(index);
          removeAllCampaign(index);*/
          _timerCampaign.cancel();
        } else {
          duration = duration - oneSec;
        }
      });
    });
  }

  /*removeCampaign(int index) async {
    if (checkDuration == true) {
      await widget.database.deleteCampaign(widget.campaign[index]);
    }
  }

  removeAllCampaign(int index) async {
    if (checkDuration == true) {
      await widget.database.deleteAllCampaign(widget.campaign[index]);
    }
  }*/

  void _navigateCampaignDetails(BuildContext context, CampaignModel campaign) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return CampaignDetailsPage(
              campaign: campaign, database: widget.database);
        },
      ),
    );
  }

  List<Widget> _campaignDays(List<dynamic> campaignDays) {
    List<Widget> list = new List<Widget>();
    for (var days in campaignDays) {
      list.add(new Text(
        ' $days ',
        style: TextStyle(fontSize: 15, color: Colors.blueGrey),
      ));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.83,
      width: MediaQuery.of(context).size.width * 0.99,
      child: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Container(
                    child: widget.campaign[index].campaignType == "Momentarily"
                        ? Card(
                            elevation: 5,
                            child: InkWell(
                              onTap: () => _navigateCampaignDetails(
                                  context, widget.campaign[index]),
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage:  NetworkImage('${widget.campaign[index].imageUrl}'),
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
                                                child: _showDuration(index)),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: new Text(
                                                        '${widget.campaign[index].title}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.red[300],
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: new Text(
                                                        '${widget.campaign[index].content}',
                                                        textAlign:
                                                            TextAlign.center,
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
                                                "${widget.campaign[index].campaignCategory1}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                             widget.campaign[index]
                                                    .campaignCategory2
                                                    .contains("Optional")
                                                ? Container()
                                                : Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "${widget.campaign[index].campaignCategory2}",
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
                                                  '₺ ${widget.campaign[index].oldPrice.toStringAsFixed(2)}',
                                                  style: new TextStyle(
                                                      color: Colors.black,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  ' --> ₺ ${widget.campaign[index].newPrice.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                //sized box ekledik width 45 olan ve altına da duration için text box açtık
                                                SizedBox(
                                                  width: 45,
                                                ),
                                                //Buraya duration gelecek
                                                Text(
                                                  '${duration.inHours}:${duration.inMinutes % 60}:${duration.inSeconds % 60}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
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
                            ))
                        : Card(
                            elevation: 5,
                            child: InkWell(
                              onTap: () => _navigateCampaignDetails(
                                  context, widget.campaign[index]),
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage: 
                                          NetworkImage("${widget.campaign[index].imageUrl}"),
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: new Text(
                                                        '${widget.campaign[index].title}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 21,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.red[300],
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
                                                      alignment:
                                                          Alignment.center,
                                                      child: new Text(
                                                        '${widget.campaign[index].content}',
                                                        textAlign:
                                                            TextAlign.center,
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
                                                "${widget.campaign[index].campaignCategory1}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                            widget.campaign[index]
                                                    .campaignCategory2
                                                    .contains("Optional")
                                                ? Container()
                                                : Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "${widget.campaign[index].campaignCategory2}",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),

                                            SizedBox(
                                              height: 8,
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: _campaignDays(widget
                                                    .campaign[index].campaignDays),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 12,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Text(
                                                  '₺ ${widget.campaign[index].oldPrice.toStringAsFixed(2)}',
                                                  style: new TextStyle(
                                                      color: Colors.black,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      fontSize: 15),
                                                ),
                                                Text(
                                                  ' --> ₺ ${widget.campaign[index].newPrice.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                //sized box ekledik width 45 olan ve altına da duration için text box açtık
                                                SizedBox(
                                                  width: 45,
                                                ),

                                                Text(
                                                  '${widget.campaign[index].startingHour.substring(10, 12)}:${widget.campaign[index].startingHour.substring(13, 15)} - ${widget.campaign[index].endingHour.substring(10, 12)}:${widget.campaign[index].endingHour.substring(13, 15)}',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
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
                            )));
              },
              itemCount: widget.campaign.length,
            ),
          ),
        ],
      ),
    );
  }
}
