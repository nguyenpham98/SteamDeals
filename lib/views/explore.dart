import 'package:flutter/material.dart';
import 'package:myapp/route/route.dart' as route;
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class Deal{
  String dealID = "", title = "", image = "", savings = "", score = "", salePrice = "", normalPrice = "";
  Deal(this.dealID, this.title, this.image, String salePrice, String normalPrice, this.score, String savings){
    this.savings = double.parse(savings).toStringAsFixed(2);
    this.salePrice = double.parse(salePrice).toStringAsFixed(2);
    this.normalPrice = double.parse(normalPrice).toStringAsFixed(2);
  }
}
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  Future<List<Deal>> getDeals() async {
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Explore"),
              SizedBox(width: 10)
            ]
        ),
      ),
      body: FutureBuilder(
        future: getDeals(),
        builder: (context, AsyncSnapshot snapshot){
        if (!snapshot.hasData){
        return const Text("Loading...");
        }
        List<Deal> deals = [];
        for (Deal d in snapshot.data){
        deals.add(d);
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: deals.length,
          itemBuilder: (BuildContext context, int index) {
            return ExploreCard(deal: deals[index]);
          }
        );
        }
      ),
      bottomNavigationBar: const BottomNavBar()

    );
  }
}

class ExploreCard extends StatefulWidget {
  const ExploreCard({Key? key, required this.deal}) : super(key: key);
  final Deal deal;

  @override
  State<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<ExploreCard> {
  bool flag = false;
  openBrowserTab(String url) async {
    const String redirectURL = "https://www.cheapshark.com/redirect?dealID=";
    Uri uri = Uri.parse(redirectURL + url);
    try {
      await launchUrl(uri);
    }
    catch (e) {
      throw "Cannot launch";
    }
  }
  @override
  Widget build(BuildContext context) {
    return GFCard(
      title: GFListTile(
        avatar: GFAvatar(
          backgroundImage: NetworkImage(widget.deal.image),
        ),
        titleText: widget.deal.title,
        subTitleText: "Metacritic: ${widget.deal.score}",
      ),
      content: RichText(
          text: TextSpan(
              text: "",
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                    text: "\$${widget.deal.normalPrice}",
                    style: const TextStyle(
                      color: Colors.red,
                      decoration: TextDecoration.lineThrough,
                    )
                ),
                TextSpan(
                    text: "   \$${widget.deal.salePrice}",
                    style: const TextStyle(
                        color: Colors.green
                    )
                )
              ]
          )
      ),
      buttonBar: GFButtonBar(
        children: <Widget>[
          GFIconButton(
            onPressed: () => setState(() => {flag = !flag}),
            icon: flag == true ? const Icon(Icons.bookmark_outlined)  : const Icon(Icons.bookmark_outline_sharp),
            color: GFColors.WARNING,
          ),
          GFIconButton(
              onPressed: () => openBrowserTab(widget.deal.dealID),
              icon: const Icon(Icons.open_in_new),
              color: GFColors.INFO
          )
        ],
      ),
    );
  }
}


class BottomNavBar extends StatefulWidget {

  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currIndex = 1;

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