import 'package:crackstats/Constants.dart';
import 'package:flutter/material.dart';
import '../ConnectDB.dart';
import 'TeamPlayersUI.dart';

class TeamsWidget extends StatefulWidget {
  @override
  _TeamsWidgetState createState() => _TeamsWidgetState();
}

class _TeamsWidgetState extends State<TeamsWidget> {
  String leagueSelected;
  List teamsDropdownList = List();
  List<String> playerCompleteName = List();

  void getLeagueTeams() async {
    var connection = new ConnectDB();
    var retrieveteamsconnection =
        await connection.retrieveLeagueTeams(leagueSelected);
    setState(() {
      teamsDropdownList = retrieveteamsconnection;
    });
  }

  Widget setPlayerName(tempPlayerNames, teamName) {
    //List playerNameTemp = List();
    //for (int i = 0; i < temp.length; i++) {
     // String tempName = temp[i][0] + " " + temp[i][1];
     // playerNameTemp.add(tempName);
   // }
    return TeamPlayersUI(teamName, tempPlayerNames,leagueSelected);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Container(
          child: Text(
            TEAMSTITLE,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          width: MediaQuery.of(context).size.width / 1.5,
          child: DropdownButton<String>(
            isExpanded: true,
            hint: Text(LEAGUES),
            value: leagueSelected,
            icon: Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 24,
            style: TextStyle(color: PRIMARYCOLOR),
            underline: Container(
              height: 2,
              color: PRIMARYCOLOR,
            ),
            onChanged: (String newValue) {
              setState(() {
                leagueSelected = newValue;
                getLeagueTeams();
              });
            },
            items: globalLeagueList.map((list) {
              return DropdownMenuItem<String>(
                value: list,
                child: Text(list),
              );
            }).toList(),
          ),
        ),
        Column(
          children: [
            ...(teamsDropdownList).map((value) {
              return FlatButton(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: PRIMARYCOLOR)),
                minWidth: MediaQuery.of(context).size.width / 1.2,
                onPressed: () async {
                  var dbConnection = new ConnectDB();
                  var tempNameList = await dbConnection.retrieveTeamPlayers(value); 
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return setPlayerName(tempNameList, value);
                  }));
                },
                child: Text(value),
              );
            }).toList(),
          ],
        ),
      ],
    ));
  }
}
