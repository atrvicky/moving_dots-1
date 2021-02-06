import 'package:flutter/material.dart';
import 'package:base_app/screens/my_screen.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String navigationId;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData.dark().copyWith(scaffoldBackgroundColor: Color(0xff424242)),
      debugShowCheckedModeBanner: false,
      initialRoute: MyScreen.id,
      routes: {
        '/': (context) => MyScreen(),
        MyScreen.id: (context) => MyScreen()
      },
    );
  }
}
