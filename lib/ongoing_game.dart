import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OngoingGame extends StatefulWidget {
  const OngoingGame({Key? key}) : super(key: key);

  @override
  _OngoingGameState createState() => _OngoingGameState();
}

class _OngoingGameState extends State<OngoingGame> {
  TextEditingController choiceOne = TextEditingController();
  TextEditingController choiceTwo = TextEditingController();
  TextEditingController choiceThree = TextEditingController();
  Map<String, dynamic> mapTemp = {};
  bool isDone = false;
  bool isCalculated = false;

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
        isDone = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mark Score"),
      ),
      body: isDone ? SingleChildScrollView(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          controller: ScrollController(),
          children: [
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: mapTemp["game_name"],
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Number Of Players - "+mapTemp["no_of_players"].toString(),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              ),
            ),
            const SizedBox(height: 20),
            const Text("Enter score below", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 5),
            const Divider(thickness: 2),
            const SizedBox(height: 5),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: mapTemp["no_of_players"],
              itemBuilder: (BuildContext context, int index) {
                int i = index+1;
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                    leading: CircleAvatar(
                      child: Text(i.toString()),
                    ),
                    trailing: mapTemp["players"][index]["total"] == 999 ? TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Enter "+mapTemp["players"][index]["name"]+"'s Score"),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: choiceOne,
                                      maxLength: 3,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          labelText: 'First Dart Points',
                                          prefixIcon: Icon(Icons.nature_people_outlined)
                                      ),
                                      autofocus: true,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    TextField(
                                      controller: choiceTwo,
                                      maxLength: 3,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          labelText: 'Second Dart Points',
                                          prefixIcon: Icon(Icons.nature_people_outlined)
                                      ),
                                      autofocus: true,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    TextField(
                                      controller: choiceThree,
                                      maxLength: 3,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          labelText: 'Third Dart Points',
                                          prefixIcon: Icon(Icons.nature_people_outlined)
                                      ),
                                      autofocus: true,
                                      textInputAction: TextInputAction.done,
                                    )
                                  ],
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('CANCEL'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('SUBMIT'),
                                    onPressed: () async {
                                      if(choiceOne.text.trim() == "" || choiceOne.text.trim().isEmpty){
                                        Navigator.pop(context);
                                        const snackBar = SnackBar(content: Text('First dart points is required'));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }else if(choiceTwo.text.trim() == "" || choiceTwo.text.trim().isEmpty){
                                        Navigator.pop(context);
                                        const snackBar = SnackBar(content: Text('Second dart points is required'));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }else if(choiceThree.text.trim() == "" || choiceThree.text.trim().isEmpty){
                                        Navigator.pop(context);
                                        const snackBar = SnackBar(content: Text('Third dart points is required'));
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }else{
                                        setState(() {
                                          mapTemp["players"][index]["a"] = int.parse(choiceOne.text.trim());
                                          mapTemp["players"][index]["b"] = int.parse(choiceTwo.text.trim());
                                          mapTemp["players"][index]["c"] = int.parse(choiceThree.text.trim());
                                          int temp = int.parse(choiceOne.text.trim()) + int.parse(choiceTwo.text.trim()) + int.parse(choiceThree.text.trim());
                                          mapTemp["players"][index]["total"] = temp;
                                          var tempVar = addGame(mapTemp);
                                          choiceOne.clear();
                                          choiceTwo.clear();
                                          choiceThree.clear();
                                          Navigator.pop(context);
                                        });
                                      }
                                    },
                                  ),

                                ],
                              );
                            }
                        );
                      },
                      child: const Text("ACTIONS"),
                    ) : TextButton(
                      onPressed: null,
                      child: Text("DONE",style: TextStyle(color: Theme.of(context).indicatorColor)),
                    ),
                    title: Text(mapTemp["players"][index]["name"]),
                    onTap: null,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            isCalculated ? const Center(
              child: CircularProgressIndicator(),
            ) : ElevatedButton(
                onPressed: (){
                  bool isInValid = false;
                  for(int i=0;i<mapTemp["no_of_players"];i++){
                    if(mapTemp["players"][i]["total"] == 999){
                      isInValid = true;
                      break;
                    }
                  }
                  if(isInValid){
                    const snackBar = SnackBar(content: Text('Mark score for all players'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }else{
                    setState(() {
                      isCalculated = true;
                    });
                    var list = [];
                    for(int i=0;i<mapTemp["no_of_players"]; i++){
                      list.add(mapTemp["players"][i]["total"]);
                    }
                    list.sort((b, a) => a.compareTo(b));
                    int first = list.first;
                    int tempCount = 0;
                    for(int j=0;j<list.length;j++){
                      if(first == list[j]){
                        tempCount = tempCount+1;
                      }else{
                        break;
                      }
                    }
                    mapTemp["winner_score"] = first;
                    if(tempCount == 1){
                      //one champion
                      for(int k=0;k<mapTemp["no_of_players"];k++){
                        if(first == mapTemp["players"][k]["total"]){
                          mapTemp["winner_name"] = mapTemp["players"][k]["name"];
                          break;
                        }
                      }
                    }else{
                      //multiple champion
                      mapTemp["is_tie"] = true;
                      String tempName = "";
                      for(int k=0;k<mapTemp["no_of_players"];k++){
                        if(first == mapTemp["players"][k]["total"]){
                          tempName = tempName+mapTemp["players"][k]["name"]+" & ";
                        }
                      }
                      tempName = tempName.substring(0, tempName.length - 2);
                      mapTemp["winner_name"] = tempName;
                    }
                    setState(() {
                      isCalculated = false;
                      addGame(mapTemp);
                    });
                    Navigator.of(context).pushNamedAndRemoveUntil('/GameList', (Route<dynamic> route) => false);
                  }
                },
                child: const Text("Find Dart Champion")
            ),
          ],
        ),
      ) : const CircularProgressIndicator(),
    );
  }

  addGame(Map<String, dynamic> mapTemp) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String rawJson = jsonEncode(mapTemp);
    prefs.setString('GAME_DETAILS', rawJson);
    return true;
  }

}