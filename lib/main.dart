import 'dart:async';
import 'game_list.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dev Dart',
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
      routes: {
        '/GameList': (BuildContext context) => const GameList(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState(){
    super.initState();
    login();
  }

  login(){
    return Timer(
        const Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const GameList()))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/background.gif"), fit: BoxFit.cover,),
            ),
          ),
        ],
      ),
    );
  }
}