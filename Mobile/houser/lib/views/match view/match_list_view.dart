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

  List<Match> matches = [];

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
    return FutureBuilder(
      future: loadMatches().timeout(const Duration(seconds: 5)),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)
      {
        if(snapshot.hasData)
        {
          return matchList();
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
          if(matches.isNotEmpty) {
            return matchList();
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
    matches = await widget._apiService.GetMatchesByUser(widget._currentLogin.user!.id);
    return true;
  }

  Widget matchList()
  {
    return RefreshIndicator(
      onRefresh: () async {
        await loadMatches();
        setState(() {

        });
      },
      child: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index)
          {
            return WGMatchCard(matches[index]);
          }
      ),
    );
  }
}
