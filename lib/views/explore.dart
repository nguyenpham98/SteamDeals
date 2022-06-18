import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp/route/route.dart' as route;
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Deal{
  String dealID, title, image;
  double salePrice, normalPrice, score, savings;
  Deal({
    required this.dealID,
    required this.title,
    required this.image,
    required this.salePrice,
    required this.normalPrice,
    required this.score,
    required this.savings,
  });
  Map<String, dynamic> toJson() => {
    'deal_ID': dealID,
    'title': title,
    'image': image,
    'sale_price': salePrice,
    'normal_price': normalPrice,
    'metacritic_score': score,
    'savings': savings
  };
  factory Deal.fromJson(Map<String, dynamic> json) => Deal(
      dealID: json['deal_ID'],
      title: json['title'],
      image: json['image'],
      salePrice: json['sale_price'],
      normalPrice: json['normal_price'],
      score: json['metacritic_score'],
      savings: json['savings']
  );
}
class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  var user = FirebaseAuth.instance.currentUser;

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
        dealID: data["dealID"],
        title: data["title"],
        image: data["thumb"],
        salePrice: double.parse(data["salePrice"]),
        normalPrice: double.parse(data["normalPrice"]),
        score: double.parse(data["metacriticScore"]),
        savings: double.parse(data["savings"]),
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
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError){
            return const Center(child: Text("Something is wrong", style: TextStyle(color: Colors.white)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ExploreCard(deal: snapshot.data[index], userId: user?.uid);
          }
        );
        }
      ),
      bottomNavigationBar: const BottomNavBar()

    );
  }
}

class ExploreCard extends StatefulWidget {
  const ExploreCard({Key? key, required this.deal, required this.userId}) : super(key: key);
  final Deal deal;
  final String? userId;

  @override
  State<ExploreCard> createState() => _ExploreCardState();
}

class _ExploreCardState extends State<ExploreCard> {
  bool flag = false;

  Future<void> updateList(Deal deal, String? userId, bool isChecked) async {
    if (isChecked){
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'wishlist': FieldValue.arrayRemove([deal.toJson()])
      }, SetOptions(merge: true));
    }
    else {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'wishlist': FieldValue.arrayUnion([deal.toJson()])
      }, SetOptions(merge: true));
    }
  }

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
            onPressed: () => {
              updateList(widget.deal, widget.userId, flag),
              setState(() => {flag = !flag})
            },
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