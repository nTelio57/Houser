import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houser/models/User.dart';
import 'package:houser/services/api_service.dart';
import 'package:houser/services/messenger_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CurrentLogin{

  SharedPreferences? prefs;
  final ApiService _apiService = ApiService();

  String jwtToken = '';
  User? user;

  static CurrentLogin _singleton = CurrentLogin._internal();
  CurrentLogin._internal();
  factory CurrentLogin()
  {
    return _singleton;
  }

  Future loadSharedPreferences() async{
    prefs = await SharedPreferences.getInstance();
  }

  void saveUserDataToSharedPreferences()
  {
    prefs!.setString("token", jwtToken);
    prefs!.setString("id", user!.id);
    prefs!.setString("email", user!.email);
  }

  Future<bool> loadUserDataFromSharedPreferences() async
  {
    var token = prefs!.getString("token");
    if (token == null || token.isEmpty) return false;

    try{
      jwtToken = token;
      var id = prefs!.getString("id")!;

      var userResponse = await _apiService.GetUserById(id);
      user = userResponse;

      var filter = await _apiService.GetUsersFilter(user!.id);
      if(filter == null) {
        return false;
      }
      user!.filter = filter;

      saveUserDataToSharedPreferences();
    }catch(e){
      if (kDebugMode) {
        print('Failed to load user data from shared preferences. $e');
      }
      return false;
    }
    return true;
  }

  Future loadMessages(BuildContext context) async{
    var provider = Provider.of<MessengerService>(context, listen: false);
    var list = await _apiService.GetMatchesByUser(user!.id);
    provider.matchList = list;

    for(var match in provider.matchList)
      {
        var messageList = await _apiService.GetMessagesByMatch(match.id);
        match.messages = messageList;
      }
  }

  void clearSharedPreferences()
  {
    prefs!.clear();
  }

  Future clear() async
  {
    clearSharedPreferences();
    _singleton = CurrentLogin._internal();
    await _singleton.loadSharedPreferences();
    await MessengerService().closeConnection();
  }

}