import 'package:flutter/material.dart';

import 'package:myapp/views/home.dart';
import 'package:myapp/views/explore.dart';
import 'package:myapp/views/profile.dart';


const String homePage = 'home';
const String loginPage = 'login';
const String explorePage = 'explore';
const String profilePage = 'profile';

Route<dynamic> controller(RouteSettings settings){

  switch (settings.name){
    case homePage:
      return MaterialPageRoute(builder: (context) => const HomePage());
    case explorePage:
      return MaterialPageRoute(builder: (context) => const ExplorePage());
    case profilePage:
      return MaterialPageRoute(builder: (context) => const ProfilePage());
    default:
      return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          ));
  }
}