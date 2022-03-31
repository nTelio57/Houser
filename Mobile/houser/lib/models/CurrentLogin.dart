import 'package:flutter/foundation.dart';
import 'package:houser/models/User.dart';
import 'package:houser/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrentLogin{

  SharedPreferences? prefs;
  final ApiService _apiService = ApiService();

  String userId = '';
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
      var id = prefs!.getString("id")!;
      userId = id;

      var userResponse = await _apiService.GetUserById(id);
      user = userResponse;

      saveUserDataToSharedPreferences();
    }catch(e){
      if (kDebugMode) {
        print('Failed to load user data from shared preferences for user $userId. $e');
      }
      return false;
    }
    return true;
  }

  void clearSharedPreferences()
  {
    prefs!.clear();
  }

  void clear()
  {
    clearSharedPreferences();
    _singleton = CurrentLogin._internal();
  }

}