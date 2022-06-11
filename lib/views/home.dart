import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/route/route.dart' as route;
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';

class Deal{
  String dealID = "", title = "", image = "", savings = "", score = "", salePrice = "", normalPrice = "";
  Deal(this.dealID, this.title, this.image, String salePrice, String normalPrice, String score, String savings){
    this.savings = double.parse(savings).toStringAsFixed(2);
    this.salePrice = double.parse(salePrice).toStringAsFixed(2);
    this.normalPrice = double.parse(normalPrice).toStringAsFixed(2);
  }

}
class Customer {
  String name = "";
  int age = 1;
  String location = "";
  // constructor
  Customer(this.name, this.age, this.location);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Deal>> getFeaturedDeals() async {
    const String baseUrl = 'www.cheapshark.com';
    const String charactersPath = 'api/1.0/deals';
    final Map<String, String> queryParameters = <String, String>{
      "storeID": "1",
      "onSale": "1",
      "pageSize": "10"
    };
    var response = await http.get(Uri.https(baseUrl, charactersPath, queryParameters));
    var jsonData = jsonDecode(response.body);
    List<Deal> deals = [];
    for (var data in jsonData){
      Deal deal = Deal(
          data["dealID"],
          data["title"],
          data["thumb"],
          data["salePrice"],
          data["normalPrice"],
          data["metacriticScore"],
          data["savings"],
      );
      deals.add(deal);
    }
    return deals;
  }

  Future<List<Deal>> getBestScoreDeals() async {
    const String baseUrl = 'www.cheapshark.com';
    const String charactersPath = 'api/1.0/deals';
    final Map<String, String> queryParameters = <String, String>{
      "storeID": "1",
      "onSale": "1",
      "pageSize": "10",
      "sortBy": "Metacritic"
    };
    var response = await http.get(Uri.https(baseUrl, charactersPath, queryParameters));
    var jsonData = jsonDecode(response.body);
    List<Deal> deals = [];
    for (var data in jsonData){
      Deal deal = Deal(
        data["dealID"],
        data["title"],
        data["thumb"],
        data["salePrice"],
        data["normalPrice"],
        data["metacriticScore"],
        data["savings"],
      );
      deals.add(deal);
    }
    return deals;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text("SteamDeals"),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 15, bottom: 10),
        child: Column(
          children: [
            GFAlert(
              alignment: Alignment.center,
              backgroundColor: Colors.white,
              content: 'SteamDeals is a bookmarking tool for game deals',
              type: GFAlertType.rounded,
              bottombar: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GFButton(
                    onPressed: (){Navigator.pushNamed(context, route.explorePage);},
                    icon: const Icon(Icons.double_arrow, color: Colors.white),
                    position: GFPosition.end,
                    child: const Text("Explore"),
                  )
                ]
              ),
            ),
            const Text(
              "Featured",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white60) ,
            ),
            FutureBuilder(
              future: getFeaturedDeals(),
              builder: (context, AsyncSnapshot snapshot){
                if (!snapshot.hasData){
                  return const Text("Loading...");
                }
                List<Deal> deals = [];
                for (Deal d in snapshot.data){
                  deals.add(d);
                }
                return GFCarousel(
                          items: deals.map(
                            (deal) {
                          return Container(
                            margin: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                              child: GFCard(
                                boxFit: BoxFit.cover,
                                image: Image.network(
                                  deal.image,
                                  height: 25
                                ),
                                showImage: true,
                                title: GFListTile(
                                  title: Text(deal.title),
                                ),
                                content: GFButtonBar(
                                  children: [
                                    GFButton(
                                      onPressed: (){},
                                      shape: GFButtonShape.pills,
                                      child: Text("-${deal.savings}%"),
                                    ),
                                    GFButton(
                                      onPressed: (){},
                                      shape: GFButtonShape.pills,
                                      type: GFButtonType.transparent,
                                      child: RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: DefaultTextStyle.of(context).style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "\$${deal.normalPrice} ",
                                              style: const TextStyle(
                                                color: Colors.red,
                                                decoration: TextDecoration.lineThrough),
                                            ),
                                            TextSpan(
                                                text: "\$${deal.salePrice}",
                                                style: const TextStyle(
                                                  color: Colors.green
                                                )
                                            )
                                          ],
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                      onPageChanged: (index) {
                        setState(() {
                          index;
                        });
                      },
                );
              }
          ),
          const Text(
              "Best score",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white60) ,
          ),
            FutureBuilder(
                future: getBestScoreDeals(),
                builder: (context, AsyncSnapshot snapshot){
                  if (!snapshot.hasData){
                    return const Text("Loading...");
                  }
                  List<Deal> deals = [];
                  for (Deal d in snapshot.data){
                    deals.add(d);
                  }
                  return GFCarousel(
                    items: deals.map(
                          (deal) {
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            child: GFCard(
                              boxFit: BoxFit.cover,
                              image: Image.network(
                                  deal.image,
                                  height: 25
                              ),
                              showImage: true,
                              title: GFListTile(
                                title: Text(deal.title),
                              ),
                              content: GFButtonBar(
                                children: [
                                  GFButton(
                                    onPressed: (){},
                                    shape: GFButtonShape.pills,
                                    child: Text("-${deal.savings}%"),
                                  ),
                                  GFButton(
                                      onPressed: (){},
                                      shape: GFButtonShape.pills,
                                      type: GFButtonType.transparent,
                                      child: RichText(
                                        text: TextSpan(
                                          text: '',
                                          style: DefaultTextStyle.of(context).style,
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: "\$${deal.normalPrice} ",
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  decoration: TextDecoration.lineThrough),
                                            ),
                                            TextSpan(
                                                text: "\$${deal.salePrice}",
                                                style: const TextStyle(
                                                    color: Colors.green
                                                )
                                            )
                                          ],
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ).toList(),
                    onPageChanged: (index) {
                      setState(() {
                        index;
                      });
                    },
                  );
                }
            ),

    ]
        ),
      ),
      bottomNavigationBar: const BottomNavBar()

    );
  }
}
class BottomNavBar extends StatefulWidget {

  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currIndex = 0;

  List<String> routes = [route.homePage, route.explorePage, route.profilePage];

  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: "Home"
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.videogame_asset),
        label: "Explore"
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: "Profile"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      currentIndex: currIndex,
      onTap: (index) => Navigator.pushNamed(context, routes[index]),
    );
  }
}

