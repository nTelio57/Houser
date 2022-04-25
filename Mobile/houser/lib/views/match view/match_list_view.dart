import 'package:flutter/material.dart';
import 'package:houser/models/Match.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/widgets/WG_MatchCard.dart';

class MatchListView extends StatefulWidget {

  final CurrentLogin _currentLogin = CurrentLogin();
  final ApiService _apiService = ApiService();

  MatchListView({Key? key}) : super(key: key);

  @override
  _MatchListViewState createState() => _MatchListViewState();
}

class _MatchListViewState extends State<MatchListView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      appBar: AppBar(),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }

  Widget body()
  {
    return Container(
      margin: const EdgeInsets.all(10),
      child: matchLoader(),
    );
  }

  Widget matchLoader()
  {
    var matchList = widget._currentLogin.matchList;
    return FutureBuilder(
      future: loadMatches().timeout(const Duration(seconds: 5)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
      {
        if(snapshot.hasData)
        {
          return matchListView();
        }
        else if(snapshot.hasError)
        {
          return SizedBox(
            width: double.infinity,
            child: Text(
              'Įvyko klaida bandant gauti suderinimų sąrašą.'.toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.red
              ),
            ),
          );
        }
        else
        {
          if(matchList.isNotEmpty) {
            return matchListView();
          }
          else
          {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      },
    );
  }

  Future loadMatches() async
  {
    await widget._currentLogin.loadMessages();
    return true;
  }

  Widget matchListView()
  {
    var matchList = widget._currentLogin.matchList;
    return RefreshIndicator(
      onRefresh: () async {
        await loadMatches();
        setState(() {

        });
      },
      child: ListView.builder(
          itemCount: matchList.length,
          itemBuilder: (context, index)
          {
            return WGMatchCard(matchList[index]);
          }
      ),
    );
  }
}
