import 'dart:io';

import 'package:flutter/material.dart';
import 'package:houser/resources/app_colors.dart';
import 'package:houser/views/welcome_view.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Houser',
      theme: ThemeData(
        primarySwatch: AppColors.primaryPalette,
        primaryColor: AppColors.primaryColor,
        backgroundColor: AppColors.backgroundColor,

        fontFamily: 'OpenSans',
        textTheme: const TextTheme(

        ),



      ),
      home: const WelcomeView(),
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
