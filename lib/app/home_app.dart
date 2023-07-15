import 'package:apis/view/routes/routes_manger.dart';
import 'package:flutter/material.dart';

class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      routes:RoutesManger.routes ,
      initialRoute: RoutesManger.initialRoute,
    );
  }
}
