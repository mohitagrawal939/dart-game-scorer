import 'dart:convert';
import 'package:dart_game/create_game.dart';
import 'package:dart_game/ongoing_game.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameList extends StatefulWidget {
  const GameList({Key? key}) : super(key: key);

  @override
  _GameListState createState() => _GameListState();
}

class _GameListState extends State<GameList> {

  Map<String, dynamic> mapTemp = {};

  @override
  void initState() {
    super.initState();
    getGameDetails();
  }

  getGameDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('GAME_DETAILS');
    if(stringValue != null){
      Map<String, dynamic> map = jsonDecode(stringValue);
      setState(() {
        mapTemp = map;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dev Dart Scorer"),
      ),
      body: mapTemp.isNotEmpty ? ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        controller: ScrollController(),
        children: [
          Card(
            margin: const EdgeInsets.all(20.0),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text(mapTemp["game_name"].toUpperCase()),
              trailing: const Icon(Icons.arrow_drop_down),
              children: <Widget>[
                ListTile(
                  title: const Text("No. Of Players"),
                  subtitle: Text(mapTemp["no_of_players"].toString()),
                  onTap:null,
                ),
                ListTile(
                  title: Text(mapTemp["is_tie"] ? "Winners Name" : "Winner Name"),
                  subtitle: Text(mapTemp["winner_name"] == "LoveYourself" ? "NA" : mapTemp["winner_name"]),
                  onTap:null,
                ),
                ListTile(
                  title: Text(mapTemp["is_tie"] ? "Winners Points" : "Winner Points"),
                  subtitle: Text(mapTemp["winner_name"] == "LoveYourself" ? "NA" : mapTemp["winner_score"].toString()),
                  onTap:null,
                ),
                mapTemp["winner_name"] == "LoveYourself" ? const SizedBox() : const Text("Players & Scores"),
                mapTemp["winner_name"] == "LoveYourself" ? const SizedBox() : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: mapTemp["no_of_players"],
                  itemBuilder: (BuildContext context, int index) {
                    int tot = mapTemp["players"][index]["a"]+mapTemp["players"][index]["b"]+mapTemp["players"][index]["c"];
                    return Card(
                      margin: const EdgeInsets.only(top: 15,left: 15,right: 15),
                      color: Theme.of(context).splashColor,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(tot.toString()),
                        ),
                        title: Text(mapTemp["players"][index]["name"]),
                        subtitle: Text(mapTemp["players"][index]["a"].toString()+" --- "+mapTemp["players"][index]["b"].toString()+" --- "+mapTemp["players"][index]["c"].toString()),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                mapTemp["winner_name"] == "LoveYourself" ? ButtonBar(
                  children: <Widget>[
                    TextButton(
                      onPressed: (){
                        setState(() {
                          mapTemp["is_started_playing"] = true;
                          addGame(mapTemp);
                        });
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const OngoingGame()));
                      },
                      child: Text(mapTemp["is_started_playing"] ? "CONTINUE PLAYING" : "START GAME")
                    )
                  ],
                ) : const SizedBox(),
              ],
            ),
          )
        ],
      ) : const Center(
          child: Text("There is no game available..."),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateGame()));
        },
        tooltip: 'New Game',
        child: const Icon(Icons.add),
      ),
    );
  }

  addGame(Map<String, dynamic> mapTemp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rawJson = jsonEncode(mapTemp);
    prefs.setString('GAME_DETAILS', rawJson);
  }
}
