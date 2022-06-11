import 'package:flutter/material.dart';
import 'package:myapp/route/route.dart' as route;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SteamDeals",
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      onGenerateRoute: route.controller,
      initialRoute: route.homePage,
    );
  }
}
