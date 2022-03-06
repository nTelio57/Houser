import 'package:flutter/material.dart';

class WGMainDrawer extends StatefulWidget {
  const WGMainDrawer({Key? key}) : super(key: key);

  @override
  _WGMainDrawerState createState() => _WGMainDrawerState();
}

class _WGMainDrawerState extends State<WGMainDrawer> {
  @override
  Widget build(BuildContext context) {
    return body();
  }

  Widget body()
  {
    return Drawer(
      child: Stack(
        children: [
          background(),
          list(),
        ],
      ),
    );
  }

  Widget background()
  {
    return Container(
      color: Theme.of(context).primaryColorDark,
    );
  }

  Widget list()
  {
    return ListView(
      children: [
        drawerHeader(),
        listButton('Profilis', () => null),
        listButton('Mano siūlymai', () => null),
        listButton('Atsijungti', () => null),
      ],
    );
  }

  Widget drawerHeader()
  {
    return DrawerHeader(
      child: const Text('Drawer header'),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor
      ),
    );
  }

  Widget listButton(String title, Function() onTap)
  {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white
        ),
      ),
      onTap: onTap,
    );
  }
}
