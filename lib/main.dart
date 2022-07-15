import 'package:apps_ad/HomePage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ad-for-apps',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(builder: (context) {
          String? routeName = settings.name;
          print("onGenerateRoute:$routeName");
          return HomePage(pkgName: routeName,);
        });
      },
    );
  }
}
