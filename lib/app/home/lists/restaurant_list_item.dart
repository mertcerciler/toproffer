import 'package:flutter/material.dart';
import 'package:login/app/home/models/restaurant_model.dart';
import 'package:login/app/services/database.dart';

import '../restaurant_details.dart';


class RestaurantListItem extends StatefulWidget {
  RestaurantListItem({@required this.restaurant, @required this.database});//, @required this.onTap);
  final List<RestaurantModel> restaurant;
  final Database database;
 // final VoidCallback onTap;
  
   @override
  _RestaurantListItem createState() => _RestaurantListItem();
}
class _RestaurantListItem  extends State<RestaurantListItem > {

  void _navigateRestaurantDetails(BuildContext context, RestaurantModel restaurant) {
     Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return RestaurantDetailsPage(restaurant: restaurant, database: widget.database);
        },
      ),
    );
  }
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
                    child: Card(
                      elevation: 5,
                      child: InkWell(
                            onTap: () => _navigateRestaurantDetails(context, widget.restaurant[index]),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: NetworkImage('${widget.restaurant[index].imageUrl}'),
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
                                                    '${widget.restaurant[index].restaurantName}',
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
                                                    '${widget.restaurant[index].restaurantAddress}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 2,
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
                itemCount: widget.restaurant.length,
              ),
            ),
          ],
        ),
    );
  }
}
