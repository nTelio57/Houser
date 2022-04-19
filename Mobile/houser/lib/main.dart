import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:houser/utils/current_login.dart';
import 'package:houser/resources/app_colors.dart';
import 'package:houser/views/offer%20view/offer_view.dart';
import 'package:houser/views/welcome_view.dart';
import 'package:houser/utils/offer_card_manager.dart';
import 'package:provider/provider.dart';

Widget _defaultHome = const WelcomeView();

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();

  await ensureLoggedIn();

  runApp(const MyApp());
}

Future ensureLoggedIn() async
{
  bool _isLoggedInResult = false;
  try{
    _isLoggedInResult = await isLoggedIn().timeout(const Duration(seconds: 5));
  }on TimeoutException {
    _isLoggedInResult = false;
  }
  if (kDebugMode) {
    print('Is logged in result: $_isLoggedInResult');
  }


  if(_isLoggedInResult) {
    if(CurrentLogin().user!.name == null) {
      CurrentLogin().clear();
      return;
    }
    _defaultHome = OfferView();
  }
}

Future initialize() async
{
  await CurrentLogin().loadSharedPreferences();
}

Future<bool> isLoggedIn() async{
  var prefs = CurrentLogin().prefs!;
  var token = prefs.getString("token");

  if(token == null || token.isEmpty) return false;

  return await CurrentLogin().loadUserDataFromSharedPreferences();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OfferCardManager(),
      child: MaterialApp(
        title: 'Houser',
        theme: ThemeData(
          primarySwatch: AppColors.primaryPalette,
          primaryColor: AppColors.primaryColor,
          backgroundColor: AppColors.backgroundColor,
          fontFamily: 'OpenSans',
          textTheme: const TextTheme(
          ),
        ),
        home: _defaultHome,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
