import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateGame extends StatefulWidget {
  const CreateGame({Key? key}) : super(key: key);

  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {

  TextEditingController gameNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController noOfPlayerController = TextEditingController();
  bool isMain = false;
  Map<String, dynamic> gameDetailsMap = {
    'game_name': "Dart Game Default",
    'no_of_players': 25,
    'winner_name': "LoveYourself",
    'winner_score': 999,
    'is_tie': false,
    'is_started_playing': false,
    'players': [
      {
        "name": "Player 1", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 2", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 3", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 4", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 5", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 6", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 7", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 8", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 9", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 10", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 11", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 12", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 13", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 14", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
      {
        "name": "Player 15", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
	  {
        "name": "Player 16", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
	  {
        "name": "Player 17", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
	  {
        "name": "Player 18", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
	  {
        "name": "Player 19", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
	  {
        "name": "Player 20", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
	  {
        "name": "Player 21", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
	  {
        "name": "Player 22", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
	  {
        "name": "Player 23", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
	  {
        "name": "Player 24", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
	  {
        "name": "Player 25", 'a': 999, 'b': 999, 'c': 999, 'total':999
      },
    ]
  };

  addGame(Map<String, dynamic> mapTemp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rawJson = jsonEncode(mapTemp);
    prefs.setString('GAME_DETAILS', rawJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Game"),
        actions: [
          TextButton(
            onPressed: (){
              addGame(gameDetailsMap);
              //Navigator.push(context, MaterialPageRoute(builder: (context) => const GameList()));
              Navigator.of(context).pushNamedAndRemoveUntil('/GameList', (Route<dynamic> route) => false);
            },
            child: const Text("SAVE")
          )
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        controller: ScrollController(),
        padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0,bottom: 5.0),
        children: [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor)
              ),
              hintText: 'Enter game name',
              labelText: 'Game Name',
              prefixIcon: const Icon(Icons.nature_people_outlined)
            ),
            controller: gameNameController,
            keyboardType: TextInputType.text,
            readOnly: isMain,
            autofocus: true,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Theme.of(context).primaryColor)
                ),
                hintText: 'Enter no. of players',
                labelText: 'Number Of Player',
                prefixIcon: const Icon(Icons.emoji_people_outlined)
            ),
            controller: noOfPlayerController,
            keyboardType: TextInputType.number,
            readOnly: isMain,
            autofocus: true,
          ),
          const SizedBox(height: 20),
          !isMain ? ElevatedButton(
            onPressed: (){
              FocusScope.of(context).unfocus();
              if(gameNameController.text.trim() == "" || gameNameController.text.trim().isEmpty){
                const snackBar = SnackBar(content: Text('Game name is required'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }else if(noOfPlayerController.text.trim() == "" || noOfPlayerController.text.trim().isEmpty){
                const snackBar = SnackBar(content: Text('Number of players in game is required'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }else if(int.parse(noOfPlayerController.text.trim()) <= 0){
                const snackBar = SnackBar(content: Text('Atleast one player is required'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }else if(int.parse(noOfPlayerController.text.trim()) > 25){
                const snackBar = SnackBar(content: Text('Maximum 25 players is allowed'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }else{
                setState(() {
                  isMain = true;
                  gameDetailsMap["game_name"] = gameNameController.text.trim();
                  gameDetailsMap["no_of_players"] = int.parse(noOfPlayerController.text.trim());
                });
              }
            },
            child: const Text("Next")
          ) : const SizedBox(),
          isMain ? const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text("Add players name here :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
          ) : const SizedBox(),
          isMain ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: gameDetailsMap["no_of_players"],
            itemBuilder: (context, index) {
              int i = index+1;
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  title: Text(gameDetailsMap["players"][index]["name"]),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                  onTap: () async {
                    nameController.clear();
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Enter Player ("+i.toString()+") Name"),
                            content: TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                  labelText: 'Player Name',
                                  prefixIcon: Icon(Icons.person_pin_outlined)
                              ),
                              autofocus: true,
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('CANCEL'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  if(nameController.text.trim() == "" || nameController.text.trim().isEmpty){
                                    Navigator.pop(context);
                                    const snackBar = SnackBar(content: Text('Name of player is required'));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  }else{
                                    setState(() {
                                      Navigator.pop(context);
                                      gameDetailsMap["players"][index] = {
                                        "name": nameController.text.trim(), 'a': 999, 'b': 999, 'c': 999, 'total':999
                                      };
                                    });
                                  }
                                },
                              ),

                            ],
                          );
                        }
                    );
                  },
                )
              );
            },
          ): const SizedBox(),
        ],
      ),
    );
  }
}
