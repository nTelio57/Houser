import 'package:flutter/material.dart';
import 'package:houser/resources/app_colors.dart';
import 'package:houser/views/welcome_view.dart';

void main() {
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

        fontFamily: 'OpenSans',
        textTheme: const TextTheme(

        ),



      ),
      home: const WelcomeView(),
    );
  }
}
