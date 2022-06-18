import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/provider/google_sign_in.dart';
import 'package:myapp/route/route.dart' as route;
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

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

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        actions: [
          user == null ? const Text("") :
          TextButton(
            child: const Text(
                "Logout",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                )),
            onPressed: (){
              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
            },
          )
        ]
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          else if (snapshot.hasData){
            return const Wishlist();
          }
          else if (snapshot.hasError){
            return const Center(child: Text("Something is wrong"));
          }
          return const LoginForm();
        }
      ),
      bottomNavigationBar: const BottomNavBar(),

    );
  }
}

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  final user = FirebaseAuth.instance.currentUser!;

  Future<List<Deal>> getSavedDeals() async {
    List<Deal> deals = [];
    await FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((snapshot) {
      if (snapshot.data()!.containsKey('wishlist')){
        for (var data in snapshot.data()!["wishlist"]){
          Deal deal = Deal.fromJson(data);
          deals.add(deal);
        }
      }
    });
    return deals;
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            GFAvatar(
              backgroundImage: NetworkImage(user.photoURL!),
            ),
            const SizedBox(height: 20),
            Text(
              '${user.displayName!}\'s Wishlist',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16
              )
            ),
            const SizedBox(height: 15),
            FutureBuilder(
              future: getSavedDeals(),
              builder: (context, AsyncSnapshot snapshot){
                if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                }
                else if (snapshot.hasError){
                  return const Center(child: Text("Something is wrong", style: TextStyle(color: Colors.white)));
                }
                return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return SavedDealTile(deal: snapshot.data[index], userId: user.uid);
                    }
                );
              }
            )


          ],
        ),
      )
    );
  }
}

class SavedDealTile extends StatefulWidget {
  const SavedDealTile({Key? key, required this.deal, required this.userId}) : super(key: key);
  final Deal deal;
  final String? userId;
  @override
  State<SavedDealTile> createState() => _SavedDealTileState();
}

class _SavedDealTileState extends State<SavedDealTile> {
  bool flag = true;

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

  @override
  Widget build(BuildContext context) {
    return GFListTile(
      color: Colors.white,
      avatar: GFAvatar(
        backgroundImage: NetworkImage(widget.deal.image),
        shape: GFAvatarShape.standard
      ),
      titleText: widget.deal.title,
      subTitleText: "\$${widget.deal.salePrice}",
      icon: flag ? const Icon(Icons.favorite, color: Colors.red) : const Icon(Icons.favorite_border, color: Colors.black),
      onTap: (){
        updateList(widget.deal, widget.userId, flag);
        setState(() {flag = !flag;});
      },
    );
  }
}



class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "You are not logged in yet. Please log in using your Google account.",
          style: TextStyle(
            color: Colors.white60
          ),
          textAlign: TextAlign.center,
        ),
        GFButton(
          onPressed: (){
            final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
            provider.googleLogin();
          },
          text: "Sign In With Google",
          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.cyanAccent),
        ),
      ]
    );
  }
}


class BottomNavBar extends StatefulWidget {

  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currIndex = 2;

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