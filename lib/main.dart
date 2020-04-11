//System Packages
import 'package:flutter/material.dart';
//UI
import 'package:compete_viewer/ui/main_screen.dart';
import "package:compete_viewer/json_parser.dart";

void main() => runApp(CompeteViewer());

class CompeteViewer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // JSONParser jsonparser = JSONParser();
    // jsonparser.loadContestants().then((onValue){
    //   print("Loaded data");
    // });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.black),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Colors.black)),
      home: MainScreen(),
    );
  }
}
