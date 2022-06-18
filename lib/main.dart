import 'package:flutter/material.dart';
import 'package:myapp/provider/google_sign_in.dart';
import 'package:myapp/route/route.dart' as route;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "SteamDeals",
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        onGenerateRoute: route.controller,
        initialRoute: route.homePage,
      ),
    );
  }
}
