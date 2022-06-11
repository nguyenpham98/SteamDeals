import 'package:flutter/material.dart';
import 'package:myapp/route/route.dart' as route;


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("My wishlist"),
      ),
      body: const Center(
          child: Text("profile page")
      ),
      bottomNavigationBar: const BottomNavBar(),

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