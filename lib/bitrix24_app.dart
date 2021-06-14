import 'package:bitrix24/screens/home_screen.dart';
import 'package:flutter/material.dart';

class Bitrix24App extends StatelessWidget {
  const Bitrix24App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color mainColor = Color(0xFFB1F2B36);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(mainColor: mainColor),
    );
  }
}
