import 'package:flutter/material.dart';
import 'package:houser/views/matches%20view/matches_view.dart';
import 'package:houser/views/offer%20view/offer_view.dart';
import 'package:houser/views/profile%20view/profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  int _selectedIndex = 1;

  final _navigationPages = [
    ProfileView(),
    const OfferView(),
    const MatchesView(),
  ];

  @override
  Widget build(BuildContext context) {
    return const OfferView();
  }

  Widget body()
  {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
          bottomNavigationBar: bottomNavBar(),
          body: _navigationPages.elementAt(_selectedIndex)
      ),
    );
  }

  void _onItemTapped(int index)
  {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget bottomNavBar()
  {

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Tasks'
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.view_carousel),//view_agenda view_carousel
            label: 'Workspaces'
        ),
      ],
      currentIndex: _selectedIndex,
      //selectedItemColor: Theme.of(context).primaryColor,
      onTap: _onItemTapped,
    );
  }
}
