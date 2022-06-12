import 'package:flutter/material.dart';
import 'package:myapp/route/route.dart' as route;
import 'package:http/http.dart' as http;
import 'package:getwidget/getwidget.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isAuth = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("My profile"),
              SizedBox(width: 10)
            ]
        ),
      ),
      body: Container(
        child: isAuth ? const Wishlist() : const LoginForm()
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
  @override
  Widget build(BuildContext context) {
    return const Text("wishlist", style: TextStyle(color: Colors.white));
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
          onPressed: (){},
          text: "Sign In With Google",
          icon: const Icon(Icons.login_rounded),
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