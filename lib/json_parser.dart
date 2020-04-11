//System Packages
import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
//Models
import 'package:compete_viewer/models/contestant_model.dart';
//Resource
import 'package:compete_viewer/resources/database_provider.dart';
import 'package:intl/intl.dart';

class JSONParser{

Future<String> _loadAsset() async {
  return await rootBundle.loadString('assets/csvjson.json');
}

Future loadContestants() async {
  String jsonContestants = await _loadAsset();
  _parseJson(jsonContestants);
}

List<Contestant> _parseJson(String jsonString) {
 List decoded = jsonDecode(jsonString);
 List<Contestant> list = List();
 DBProvider.db.deleteTables();

  decoded.forEach((contestant){
    list.add(Contestant.create(contNumber:contestant["contNumber"], contName: contestant["contName"],
     fbLikes: contestant["fbLikes"], fbComments: contestant["fbComments"], fbShares: contestant["fbShares"],
     instaLikes: contestant["instaLikes"], instaComments: contestant["instaComments"],
     lastUpdated: DateFormat("dd-MM-yyyy hh:mm a").format(DateTime.now())),);
  });

  list.forEach((contestant){
    DBProvider.db.newContestant(contestant);
  });
}
}