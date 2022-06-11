import 'package:flutter/material.dart';
import 'package:myapp/route/route.dart' as route;


class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
        title: const Text("Explore"),
      ),
      body: ListView(

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